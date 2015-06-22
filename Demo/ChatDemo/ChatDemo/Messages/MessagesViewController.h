//
//  MessagesViewController.h
//  ACChat
//
//  Created by Alex on 6/18/15.
//  Copyright (c) 2015 Octoberry. All rights reserved.
//

#import "JSQMessagesViewController.h"
#import <AChat/ACRoomModel.h>

@interface MessagesViewController : JSQMessagesViewController
@property (nonatomic, strong) ACRoomModel *room;
@end
