//
//  AllyChatMessage.h
//  AChatDemo
//
//  Created by Alexandr Turyev on 17/07/15.
//  Copyright (c) 2015 Octoberry. All rights reserved.
//

#import "JSQMessage.h"
#import <AChat/AChat.h>

@interface AllyChatMessage : JSQMessage

@property(nonatomic, strong)ACMessageModel *model;

@property(nonatomic, strong)NSString *status;

@property(nonatomic, strong)NSString *signature;

@end