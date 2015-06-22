//
//  SharedData.h
//  ACChat
//
//  Created by Alex on 6/18/15.
//  Copyright (c) 2015 Octoberry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AChat/AChat.h>

@interface SharedData : NSObject
@property (nonatomic, strong) ACEngine *engine;

+ (instancetype)sharedData;
@end
