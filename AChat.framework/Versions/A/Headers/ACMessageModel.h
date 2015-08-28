
//
//  ACMessageModel.h
//  ACChat
//
//  Created by Alex on 6/18/15.
//  Copyright (c) 2015 Octoberry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACUserModel.h"

typedef NS_ENUM(NSUInteger, MessageStatus) {
    STATUS_NEW,
    STATUS_SENDING,
    STATUS_RESENDING,
    STATUS_SENT,
    STATUS_FAILED
};

@interface ACMessageModel : NSObject<NSCoding, NSCopying>




@property (nonatomic, strong) ACUserModel *sender;
@property (nonatomic, strong) NSString *room;
@property (nonatomic, strong) NSString *internalBaseClassIdentifier;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *file;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) BOOL isHidden;
/*
 Signature of message
 */
@property (nonatomic, strong) NSString *clientId;
@property (nonatomic, strong) NSString *issue;

@property(nonatomic, assign) MessageStatus status;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;



@end
