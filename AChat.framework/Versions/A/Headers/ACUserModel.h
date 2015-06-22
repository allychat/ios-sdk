//
//  ACUserModel.h
//  ACChat
//
//  Created by Alex on 6/18/15.
//  Copyright (c) 2015 Octoberry. All rights reserved.
//

#import <AChat/ACBaseModel.h>

@interface ACUserModel : ACBaseModel

@property (nonatomic, strong) NSString  *userID;
@property (nonatomic, strong) NSString  *name;//does not supported yet
@property (nonatomic, strong) NSURL     *avatarURL;

@property (nonatomic, strong) NSString  *alias;

@end
