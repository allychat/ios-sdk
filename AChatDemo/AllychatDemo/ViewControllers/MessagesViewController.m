//
//  ViewController.m
//  smart-support-ios
//
//  Created by Alexandr Turyev on 11/07/15.
//  Copyright (c) 2015 Octoberry. All rights reserved.
//

#import "MessagesViewController.h"
#import <JSQMessagesViewController/JSQMessages.h>
#import "AllyChatMessage.h"

#define MESSAGES_COUNT 5

@interface MessagesViewController ()

@property (nonatomic, strong) NSMutableArray *messages;

@property (nonatomic, strong) NSMutableDictionary*avatars;

@property (nonatomic, strong) JSQMessagesBubbleImage* outgoingBubbleImageData;
@property (nonatomic, strong) JSQMessagesBubbleImage* incomingBubbleImageData;

@end

@implementation MessagesViewController


#pragma mark AChat Delegate Methods

- (void)didReceiveMessage:(ACMessage *)msgObject
                 fromRoom:(ACRoom *)roomObj
{
    //Check if Message from current Room
    if ([msgObject.roomId isEqualToString:self.room.internalBaseClassIdentifier])
    {
        [self addAllyChatMesage:msgObject];
        [self finishReceivingMessageAnimated:YES];
        
        [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
    }
    else
    {
        //Show Message from another Room
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:roomObj.internalBaseClassIdentifier message:msgObject.message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alertView show];
        [JSQSystemSoundPlayer jsq_playMessageReceivedAlert];
    }
    
}

- (void)didUpdateMessage:(ACMessage *)messageObj
                toStatus:(ACMessageStatus)newStatus
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@ : %d", messageObj.innerId, newStatus);
        
        __block BOOL needToShow = YES;
        [self.messages enumerateObjectsUsingBlock:^(AllyChatMessage *obj, NSUInteger idx, BOOL *stop) {
            if ([obj.messageModel.innerId isEqualToString:messageObj.innerId]) {
                if (newStatus == AC_DELIVERED) {
                    [self.messages removeObject:obj];
                }
                else
                {
                    obj.messageModel.status = newStatus;
                    needToShow = NO;
                }
                *stop = YES;
            }
        }];
        if (needToShow) {
            [JSQSystemSoundPlayer jsq_playMessageSentSound];
            [self addAllyChatMesage:messageObj];
            [self finishSendingMessageAnimated:YES];
        }
        [self.collectionView reloadData];
    });
    
}

- (void)didUpdateChatStatusTo:(AChatStatus)newStatus
{
    NSLog(@"chat status is - > %d", newStatus);
}


#pragma mark - AChat methods

-(void)addAllyChatMesage:(ACMessage *)messageModel
{
    if (messageModel.sender) {
        AllyChatMessage *message = nil;
        NSString *senderDisplayName = messageModel.sender.name ? messageModel.sender.name : messageModel.sender.alias;
        
        if (messageModel.file.length>0)
        {
            JSQPhotoMediaItem *item = [JSQPhotoMediaItem new];
            message = [[AllyChatMessage alloc] initWithSenderId:messageModel.sender.senderIdentifier senderDisplayName:senderDisplayName date:[NSDate dateWithTimeIntervalSince1970:messageModel.createdAt] media:item];
            
            if (messageModel.file.length>0) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:messageModel.file]];
                    item.image = [UIImage imageWithData:data];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.collectionView reloadData];
                    });
                });
            }
        }
        else
        {
            message = [[AllyChatMessage alloc] initWithSenderId:messageModel.sender.senderIdentifier
                                              senderDisplayName:senderDisplayName
                                                           date:[NSDate dateWithTimeIntervalSince1970:messageModel.createdAt]
                                                           text:messageModel.message];
        }
        message.messageModel = messageModel;
        [self.messages addObject:message];
    }
}

/**
 *  Load last Messages of the current Room
 */
-(void)loadLastMessages:(NSUInteger)count
{
    ACMessage *lastMesssageOfTheRoom = self.room.lastMessage;
    
    if (lastMesssageOfTheRoom) {
        
        [self addAllyChatMesage:lastMesssageOfTheRoom];
        [AllychatSDK messagesPreviousToMessage:lastMesssageOfTheRoom limit:MESSAGES_COUNT success:^(NSArray *messages) {
            [messages enumerateObjectsUsingBlock:^(ACMessage *messageModel, NSUInteger idx, BOOL * _Nonnull stop) {
                [self addAllyChatMesage:messageModel];
            }];
            [self.messages sortUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
            [self finishReceivingMessageAnimated:YES];
        } failure:nil];
    }
}

/**
 *  Load earlier Messages (before Last One)
 */
-(void)loadEarlierMessages:(NSUInteger)count forLastMessage:(ACMessage *)messageObj
{
    if (messageObj) {
        [AllychatSDK messagesPreviousToMessage:messageObj limit:MESSAGES_COUNT success:^(NSArray *messages) {
            if (messages.count>0)
            {
                for (ACMessage *messageModel in messages)
                {
                    [self addAllyChatMesage:messageModel];
                }
                [self.messages sortUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
                [self.collectionView reloadData];
            }
        } failure:nil];
    }
}

- (void)messageSend:(NSString *)text
            picture:(UIImage *)picture
{
    if (picture)
    {
        [AllychatSDK sendImage:picture roomID:self.room.internalBaseClassIdentifier progress:^(CGFloat progress) {
            NSLog(@"sending Image To Support %1.2f", progress);
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"CLose" otherButtonTitles:nil, nil];
                [alert show];
            });
        }];
    }
    else
    {
        [AllychatSDK sendText:text roomID:self.room.internalBaseClassIdentifier failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"CLose" otherButtonTitles:nil, nil];
                [alert show];
            });
        }];
    }
}

-(id<JSQMessageAvatarImageDataSource>)getSenderAvatarImage:(AllyChatMessage *)message
{
    if (self.avatars[message.senderId] == nil)
    {
        //Load Avatar Image
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:message.messageModel.sender.avatarUrl]]];
        if (image) {
            JSQMessagesAvatarImage *wozImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:image diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
            self.avatars[message.senderId] = wozImage;
            return wozImage;
        }
        return nil;
    }
    else return (self.avatars[message.senderId]);
}

#pragma mark -


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.collectionView.collectionViewLayout.springinessEnabled = NO;
    
}

- (void)viewDidLoad
{
    /**
     *  Handle all received messages
     */
    [AllychatSDK instance].delegate = self;
    
    /**
     *  Set properties correspond to determine which messages are incoming or outgoing.
     */
    self.senderId = [AllychatSDK instance].userIdentity.internalBaseClassIdentifier;
    self.senderDisplayName =[AllychatSDK instance].userIdentity.alias;
    
    /**
     *  Remove avatars for output messages
     */
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleBlueColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    
    [super viewDidLoad];
    
    self.messages = [NSMutableArray array];
    
    [self loadLastMessages:MESSAGES_COUNT];
    
    self.showLoadEarlierMessagesHeader = YES;
    
    /**
     *  Register custom menu actions for cells.
     */
    [JSQMessagesCollectionViewCell registerMenuAction:@selector(customAction:)];
    [UIMenuController sharedMenuController].menuItems = @[ [[UIMenuItem alloc] initWithTitle:@"Resend"
                                                                                      action:@selector(customAction:)] ];
}

#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    [self messageSend:text picture:nil];
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Media messages"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Photo library", @"Camera", nil];
    
    [sheet showFromToolbar:self.inputToolbar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    int sourceType;
    if (buttonIndex == 0) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else {
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    if (![UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Current source is not available at this time" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    imagePicker.sourceType = sourceType;
    imagePicker.allowsEditing = NO;
    if (imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        imagePicker.showsCameraControls = YES;
    }
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages objectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self outgoing:self.messages[indexPath.item]])
    {
        return self.outgoingBubbleImageData;
    }
    else return self.incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AllyChatMessage *message = [self.messages objectAtIndex:indexPath.item];
    if ([self incoming:message])
    {
        return [self getSenderAvatarImage:message];
    }
    else
        return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item % 3 == 0)
    {
        JSQMessage *message = self.messages[indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    else return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    AllyChatMessage *message = [self.messages objectAtIndex:indexPath.item];
    if ([self incoming:message])
    {
        if (indexPath.item > 0)
        {
            JSQMessage *previous = self.messages[indexPath.item-1];
            if ([previous.senderId isEqualToString:message.senderId])
            {
                return nil;
            }
        }
        return [[NSAttributedString alloc] initWithString:(message.senderDisplayName)];
    }
    else return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self outgoing:self.messages[indexPath.item]])
    {
        AllyChatMessage *message = [self.messages objectAtIndex:indexPath.item];
        if (message.messageModel.status) {
            return [[NSAttributedString alloc] initWithString:[self getStatusText:message.messageModel.status]];
        }
    }
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    JSQMessage *msg = [self.messages objectAtIndex:indexPath.item];
    if (!msg.isMediaMessage) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor whiteColor];
            
        }
        else {
            cell.textView.textColor = [UIColor blackColor];
        }
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    cell.cellBottomLabel.textInsets = UIEdgeInsetsMake(0.0, -kJSQMessagesCollectionViewAvatarSizeDefault , 0.0, 0.0);
    
    return cell;
}

#pragma mark - UICollectionView Delegate

#pragma mark - Custom menu items

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        return YES;
    }
    
    return [super collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        [self customAction:sender];
        return;
    }
    
    [super collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)customAction:(id)sender
{
    AllyChatMessage *msg = [self.messages objectAtIndex:[self.collectionView indexPathForCell:sender].item];
    ACMessage *msgObject = msg.messageModel;
    [AllychatSDK resendMessage:msgObject withProgress:^(CGFloat progress) {
        NSLog(@"%1.2f", progress);
    } failure:^(NSError *error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = self.messages[indexPath.item];
    if ([self incoming:message])
    {
        if (indexPath.item > 0)
        {
            JSQMessage *previous = self.messages[indexPath.item-1];
            if ([previous.senderId isEqualToString:message.senderId])
            {
                return 0;
            }
        }
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    else return 0;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self outgoing:self.messages[indexPath.item]])
    {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    else return 0;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    AllyChatMessage *theOldestMessage = self.messages.firstObject;
    
    [self loadEarlierMessages:MESSAGES_COUNT forLastMessage:theOldestMessage.messageModel];
}

#pragma mark - ImagePicker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    [self messageSend:nil picture:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper methods

- (BOOL)incoming:(JSQMessage *)message
{
    return ([message.senderId isEqualToString:self.senderId] == NO);
}

- (BOOL)outgoing:(JSQMessage *)message
{
    return ([message.senderId isEqualToString:self.senderId] == YES);
}

-(NSString *)getStatusText:(ACMessageStatus)status
{
    switch (status) {
        case AC_SENDING:
            return @"Sending...";
        case AC_DELIVERED:
            return @"Delivered";
        case AC_FAILED:
            return @"Failed!";
        case AC_RESENDING:
            return @"Resending...";
        default:
            return @"...";
    }
}

@end
