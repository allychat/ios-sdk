//
//  ACRoom.h
//
//  Created by Александр Турьев on 30/09/15
//  Copyright (c) 2015 ООО "ИнфоТэкРитм". All rights reserved.
//

#import <Foundation/Foundation.h>

@class ACMessage;

@interface ACRoom : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *internalBaseClassIdentifier;
@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSString *lastReadMessageId;
@property (nonatomic, strong) ACMessage *lastMessage;
@property (nonatomic, assign) BOOL isSupport;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
