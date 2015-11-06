//
//  User.h
//
//  Created by Александр Турьев on 10/07/15
//  Copyright (c) 2015 ООО "ИнфоТэкРитм". All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ACUser : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *internalBaseClassIdentifier;
@property (nonatomic, strong) NSString *alias;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSString *geolocation;

@property (nonatomic, strong) NSString *appVersion;
@property (nonatomic, strong) NSString *login;
@property (nonatomic, assign) double isObserver;
@property (nonatomic, assign) double isOperator;
@property (nonatomic, strong) NSString *deviceType;
@property (nonatomic, assign) double isAdmin;
@property (nonatomic, strong) NSString *osVersion;
@property (nonatomic, strong) NSString *tzoffset;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initAsAnonym;
- (instancetype)initWithAlias:(NSString *)alias;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
