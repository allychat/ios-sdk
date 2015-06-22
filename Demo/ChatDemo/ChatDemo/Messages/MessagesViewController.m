//
//  MessagesViewController.m
//  ACChat
//
//  Created by Alex on 6/18/15.
//  Copyright (c) 2015 Octoberry. All rights reserved.
//

#import "MessagesViewController.h"
#import "SharedData.h"
#import "JSQSystemSoundPlayer+JSQMessages.h"
#import "JSQSystemSoundPlayer.h"
#import "JSQMessage.h"
#import "JSQPhotoMediaItem.h"
#import "JSQMessagesTimestampFormatter.h"
#import "JSQMessagesBubbleImageFactory.h"
#import "UIColor+JSQMessages.h"
#import "JSQMessagesAvatarImageFactory.h"
#import "NSObject+MAKeyValue.h"

#import "RMUniversalAlert.h"
#import "MBProgressHUD.h"

@interface MessagesViewController ()<UIActionSheetDelegate, AChatDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSMutableDictionary *avatars;
@property (nonatomic, strong) JSQMessagesBubbleImage* outgoingBubbleImageData;
@property (nonatomic, strong) JSQMessagesBubbleImage* incomingBubbleImageData;
@end

@implementation MessagesViewController

- (void)chat:(ACEngine *)engine didReceiveMessage:(ACMessageModel *)message {
    [self addMessages:@[ message ]];
    [self finishReceivingMessageAnimated:YES];
}

#pragma mark - 

- (void)addMessages:(NSArray *)array {
    for (ACMessageModel *model in array) {
        JSQMessage *message = nil;
        if (model.fileAttachmentURL) {
            JSQPhotoMediaItem *item = [JSQPhotoMediaItem new];
            message = [[JSQMessage alloc] initWithSenderId:model.senderID senderDisplayName:@"" date:model.sentDate media:item];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:model.fileAttachmentURL];
                item.image = [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
            });
        } else {
            message = [[JSQMessage alloc] initWithSenderId:model.senderID senderDisplayName:@"" date:model.sentDate text:model.message];
        }
        [message maSetValue:model forKey:@"model"];
        [self.messages addObject:message];
    }
    [self.messages sortUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES] ]];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.senderId = [SharedData sharedData].engine.userInfoModel.user.userID;
    self.senderDisplayName = @"";
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    
    self.messages = [NSMutableArray array];
    
    [[SharedData sharedData].engine lastMessages:@(50) room:self.room.roomID completion:^(NSError *error, NSArray *array) {
        [self addMessages:array];
        [self finishReceivingMessageAnimated:YES];
    }];
    
    self.avatars = [NSMutableDictionary dictionary];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[SharedData sharedData].engine.userInfoModel.user.avatarURL];
        UIImage *image = [UIImage imageWithData:data];
        if (!image) return;
        
        JSQMessagesAvatarImage *wozImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:image
                                                                                      diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        [self.avatars setValue:wozImage forKey:self.senderId];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    });
    __block NSString *userID = nil;
    [self.room.users enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        if (![obj isEqualToString:self.senderId]) {
            userID = obj;
            *stop = YES;
        }
    }];
    if (userID) {
        [[SharedData sharedData].engine usersWithIDs:@[ userID ] completion:^(NSError *error, NSArray *users) {
            ACUserModel *userModel = users.firstObject;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                
                NSData *data = [NSData dataWithContentsOfURL:userModel.avatarURL];
                UIImage *image = [UIImage imageWithData:data];
                if (!image) return;
                JSQMessagesAvatarImage *wozImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:image
                                                                                              diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
                [self.avatars setValue:wozImage forKey:userID];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
            });
        }];
    }
    
    self.showLoadEarlierMessagesHeader = YES;

    [SharedData sharedData].engine.delegate = self;
}
#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    [[SharedData sharedData].engine sendTextMessage:text room:self.room.roomID completion:nil];
    [self finishSendingMessageAnimated:YES];
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
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        [RMUniversalAlert showAlertInViewController:self withTitle:@"Error" message:@"Current source is not available at this time" cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:nil];
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
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.outgoingBubbleImageData;
    }
    
    return self.incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    return [self.avatars objectForKey:message.senderId];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item % 3 == 0) {
        JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
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
            cell.textView.textColor = [UIColor blackColor];
        }
        else {
            cell.textView.textColor = [UIColor whiteColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    return cell;
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
    /**
     *  iOS7-style sender name labels
     */
    JSQMessage *currentMessage = [self.messages objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSString *msgID = [[self.messages.firstObject maValueForKey:@"model"] messageID];
    [[SharedData sharedData].engine historyForRoom:self.room.roomID limit:@(20) lastMessageID:msgID showNew:NO completion:^(NSError *error, NSArray *array) {
        if (error) {
            [RMUniversalAlert showAlertInViewController:self withTitle:@"Error" message:error.localizedDescription cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:nil];
        } else {
            [self addMessages:array];
//            [self finishReceivingMessageAnimated:NO];
        }
    }];
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
    typeof (self) __weak self_weak = self;
    [self dismissViewControllerAnimated:YES completion:^{
        typeof (self_weak) self = self_weak;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[SharedData sharedData].engine sendImageMessage:image room:self.room.roomID completion:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (error) {
                [RMUniversalAlert showAlertInViewController:self withTitle:@"Error" message:error.localizedDescription cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:nil];
            }
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
