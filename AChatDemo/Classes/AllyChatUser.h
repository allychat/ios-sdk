//
//  AllyChatUser.h
//  AChatDemo
//
//  Created by Alexandr Turyev on 17/07/15.
//  Copyright (c) 2015 Octoberry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSQMessagesAvatarImageFactory.h"

@interface AllyChatUser : NSObject

@property(nonatomic, strong) id userModel;

@property(nonatomic, strong) JSQMessagesAvatarImage *avatarImage;

@property(nonatomic, strong) NSString *senderDisplayName;

@end
