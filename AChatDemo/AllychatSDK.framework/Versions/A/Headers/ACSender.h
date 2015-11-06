//
//  ACSender.h
//
//  Created by Александр Турьев on 30/09/15
//  Copyright (c) 2015 ООО "ИнфоТэкРитм". All rights reserved.
//

#import <Foundation/Foundation.h>

@class ACUser;


@interface ACSender : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *senderIdentifier;
@property (nonatomic, strong) NSString *alias;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSString *name;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithUser:(ACUser *)user;
- (NSDictionary *)dictionaryRepresentation;

@end
