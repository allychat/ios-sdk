//
//  ACOperatorModel.h
//
//  Created by Александр Турьев on 18/07/15
//  Copyright (c) 2015 Octoberry. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ACOperatorModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSString *internalBaseClassIdentifier;
@property (nonatomic, assign) double isAdmin;
@property (nonatomic, assign) double isOperator;
@property (nonatomic, assign) double isObserver;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSString *login;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
