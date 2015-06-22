//
//  ACBaseModel.h
//  ACChat
//
//  Created by Andrew Kopanev on 6/16/15.
//  Copyright (c) 2015 Octoberry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACBaseModel : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;

- (void)setDictionaryRepresentation:(NSDictionary *)dictionaryRepresentation;

- (BOOL)validateDictionaryRepresentation:(NSDictionary *)dictionaryRepresentation;

@property (nonatomic, readonly) NSMutableDictionary          *mutableDictionaryRepresentation;

@end
