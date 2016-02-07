//
//  ACBaseModel.h
//  AllychatSDK
//
//  Created by Andrew Kopanev on 12/8/15.
//  Copyright © 2015 Magneta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACBaseModel : NSObject <NSCopying>

// initialization
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;

// parsing
- (void)setDictionaryRepresentation:(NSDictionary *)dictionaryRepresentation;
- (NSMutableDictionary *)dictionaryRepresentation;
- (BOOL)isValidDictionaryRepresentation:(NSDictionary *)dictionaryRepresentation;

@end
