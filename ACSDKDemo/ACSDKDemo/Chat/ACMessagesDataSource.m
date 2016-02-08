//
//  ACMessagesDataSource.m
//  ACSDKDemo
//
//  Created by Рамис Ямилов on 03.02.16.
//  Copyright © 2016 Magneta. All rights reserved.
//

#import "ACMessagesDataSource.h"
#import "ACMessageTableViewCell.h"
#import <ACSDK/ACSDK.h>

@interface ACMessagesDataSource ()
@property (nonatomic, weak) UITableView                         *tableView;
@property (nonatomic, strong) ACRoomModel                       *roomModel;
@property (nonatomic, strong) NSMutableArray<ACMessageModel*>   *messages;

@property (nonatomic, assign) BOOL hasMoreOldMessages;
@property (nonatomic, assign) BOOL fetchingOldMessages;

@property (nonatomic, strong) dispatch_queue_t dataSourceQueue;
@end

@implementation ACMessagesDataSource

- (instancetype)initWithTableView:(UITableView *)tableView andRoom:(ACRoomModel *)roomModel {
    if (self = [super init]) {
        _hasMoreOldMessages = YES;
        _tableView = tableView;
        _roomModel = roomModel;
        
        NSString *dataSourceQueueLabel = [NSString stringWithFormat:@"com.magneta.ACSDKDemo.dataSourceQueue.%@", _roomModel.roomId];
        _dataSourceQueue = dispatch_queue_create([dataSourceQueueLabel cStringUsingEncoding:NSASCIIStringEncoding], DISPATCH_QUEUE_SERIAL);
        
        _messages = [NSMutableArray array];
        
        _tableView.transform = CGAffineTransformMakeScale(1, -1);
        //_tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        
        if (_roomModel.lastMessageModel) {
            [self.messages addObject:_roomModel.lastMessageModel];
            [[ACSDK defaultInstance] setReadForMessage:_roomModel.lastMessageModel];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMessageNotification:) name:ACSDKDidReceiveMessageNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateRoomsNotification:) name:ACSDKDidUpdateRoomsNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMessageDisplay:) name:ACSDKDidUpdateUploadProgressNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMessageDisplay:) name:ACSDKDidPrepareMessageNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMessageDisplay:) name:ACSDKDidUpdateMessageStatusNotification object:nil];
        
        [self fetchNewMessages];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.messages.count)
        return self.messages[indexPath.row];
    return nil;
}

#pragma mark - Loading indicator

- (void)showLoading {
    UIActivityIndicatorView *footerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    footerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 50);
    [footerView startAnimating];
    self.tableView.tableFooterView = footerView;
}

- (void)hideLoading {
    self.tableView.tableFooterView = nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ACMessageTableViewCell *cell = (ACMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ACMessageTableViewCell" forIndexPath:indexPath];
    cell.transform = CGAffineTransformMakeScale(1, -1);
    cell.messageModel = [self objectAtIndexPath:indexPath];
    if (indexPath.row == self.messages.count - 1)
        [self fetchOldMessages];
    return cell;
}


#pragma mark - chat

- (NSInteger)indexForMessage:(ACMessageModel*)messageModel {
    return [self.messages indexOfObject:messageModel inSortedRange:(NSRange){0, self.messages.count} options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(ACMessageModel *  _Nonnull obj1, ACMessageModel *  _Nonnull obj2) {
        if ([obj1 isEqual:obj2]) return NSOrderedSame;
        return [obj2.createdAt compare:obj1.createdAt];
    }];
}

- (void)addMessages:(NSArray*)messages {
    if (!messages.count)
        return;
    
    dispatch_async(self.dataSourceQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView beginUpdates];
            
            // update existing messages
            NSMutableArray *updatedIndexPaths = [NSMutableArray array];
            for (ACMessageModel *messageModel in messages) {
                NSInteger index = [self indexForMessage:messageModel];
                if (index < self.messages.count && [self.messages[index] isEqual:messageModel]) {
                    [updatedIndexPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
                    self.messages[index] = messageModel;
                }
            }
            [self.tableView reloadRowsAtIndexPaths:updatedIndexPaths withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
            
            [self.tableView beginUpdates];
            
            // insert new messages
            NSMutableArray *insertedIndexPaths = [NSMutableArray array];
            
            for (ACMessageModel *messageModel in messages.reverseObjectEnumerator) {
                NSInteger index = [self indexForMessage:messageModel];
                if (index < self.messages.count && [self.messages[index] isEqual:messageModel]) {
                    // skip update
                } else {
                    [insertedIndexPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
                    [self.messages insertObject:messageModel atIndex:index];
                }
            }
            [self.tableView insertRowsAtIndexPaths:insertedIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
            
            for (ACMessageModel *messageModel in messages) {
                [[ACSDK defaultInstance] setReadForMessage:messageModel];
            }
        });
    });
}

- (void)fetchOldMessages {
    if (!self.hasMoreOldMessages || self.fetchingOldMessages)
        return;
    
    self.fetchingOldMessages = YES;
    [self showLoading];
    [[ACSDK defaultInstance] messagesBeforeMessage:self.messages.lastObject room:self.roomModel limit:20 completion:^(NSArray *messages, BOOL hasMore, NSError *error) {
        self.fetchingOldMessages = NO;
        [self hideLoading];
        self.hasMoreOldMessages = hasMore;
        [self addMessages:messages];
    }];
}

- (void)fetchNewMessages {
    [[ACSDK defaultInstance] messagesAfterMessage:self.messages.firstObject room:self.roomModel limit:20 completion:^(NSArray *messages, BOOL hasMore, NSError *error) {
        [self addMessages:messages];
        if (hasMore)
            [self fetchNewMessages];
    }];
}

#pragma mark * notifications

- (void)didReceiveMessageNotification:(NSNotification *)notification {
    ACRoomModel *roomModel = notification.userInfo[ACRoomKey];
    if ([roomModel isEqual:self.roomModel]) {
        ACMessageModel *messageModel = notification.userInfo[ACMessageKey];
        [self addMessages:@[messageModel]];
    }
}

- (void)didUpdateRoomsNotification:(NSNotification *)notification {
    NSArray *rooms = notification.userInfo[ACRoomsKey];
    for (ACRoomModel *roomModel in rooms) {
        if([roomModel isEqual:self.roomModel]) {
            self.roomModel = roomModel;
            if (![roomModel.lastMessageModel isEqual:self.messages.firstObject])
                [self fetchNewMessages];
        }
    }
}

- (void)updateMessageDisplay:(NSNotification *)notification {
    ACRoomModel *roomModel = notification.userInfo[ACRoomKey];
    if ([roomModel isEqual:self.roomModel]) {
        ACImageMessageModel *messageModel = notification.userInfo[ACMessageKey];
        [self addMessages:@[messageModel]];
    }
}
@end
