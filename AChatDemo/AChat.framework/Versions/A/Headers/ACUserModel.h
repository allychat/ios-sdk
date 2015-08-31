//
//  ACUserModel.h
//  ACChat
//
//  Created by Alex on 6/18/15.
//  Copyright (c) 2015 Octoberry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACUserModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *senderIdentifier;
@property (nonatomic, strong) NSString *alias;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSString *name;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
