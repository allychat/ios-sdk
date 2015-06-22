//
//  ACRoomModel.h
//  ACChat
//
//  Created by Alex on 6/18/15.
//  Copyright (c) 2015 Octoberry. All rights reserved.
//

#import <AChat/ACBaseModel.h>
#import <AChat/ACMessageModel.h>

@interface ACRoomModel : ACBaseModel

@property (nonatomic, strong) NSString *roomID;
@property (nonatomic, strong) NSString *lastReadMessageID;
@property (nonatomic, strong) NSString *firstMessageID;

@property (nonatomic, assign, getter=isSupportRoom) BOOL supportRoom;

@property (nonatomic, strong) ACMessageModel *lastMessage;

@property (nonatomic, strong) NSArray *users;//identifiers

@end
