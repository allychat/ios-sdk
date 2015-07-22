//
//  ViewController.h
//  AChatDemo
//
//  Created by Alexandr Turyev on 15/07/15.
//  Copyright (c) 2015 Octoberry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQMessagesViewController.h"
#import <AChat/AChat.h>

@interface MessagesViewController : JSQMessagesViewController <UIActionSheetDelegate, AChatDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) ACRoomModel *room;

@end
