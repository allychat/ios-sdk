//
//  ACUsers.h
//
//  Created by Александр Турьев on 30/09/15
//  Copyright (c) 2015 ООО "ИнфоТэкРитм". All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ACUsers : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *usersIdentifier;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
