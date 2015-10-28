//
//  ACMessage.h
//
//  Created by Александр Турьев on 05/10/15
//  Copyright (c) 2015 ООО "ИнфоТэкРитм". All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ACMessageStatus) {
    AC_INCOMING_MSG,
    AC_SENDING,
    AC_DELIVERED,
    AC_FAILED,
    AC_RESENDING
};

@class ACSender;

@interface ACMessage : NSObject <NSCoding, NSCopying>

/*
 Message ID from AllyChat Server
 */
@property (nonatomic, strong) NSString *externalId;

/*
 Unique ID created inside client app
 */
@property (nonatomic, strong) NSString *innerId;

@property (nonatomic, strong) ACSender *sender;

@property (nonatomic, strong) NSString *roomId;

@property (nonatomic, assign) double createdAt;

@property (nonatomic, strong) NSString *file;

@property (nonatomic, assign) BOOL read;

@property (nonatomic, strong) NSString *message;

@property (nonatomic, assign) BOOL isHidden;

@property (nonatomic, assign) id event;

@property (nonatomic, strong) NSString *issue;

@property (nonatomic, assign) ACMessageStatus status;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithText:(NSString *)text
                      roomId:(NSString *)roomId;
- (NSDictionary *)dictionaryRepresentation;

@end
