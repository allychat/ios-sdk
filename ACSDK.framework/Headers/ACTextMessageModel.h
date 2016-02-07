//
//  ACTextMessageModel.h
//  AllychatSDK
//
//  Created by Andrew Kopanev on 12/8/15.
//  Copyright © 2015 Magneta. All rights reserved.
//

#import "ACMessageModel.h"
#import "ACRoomModel.h"

@interface ACTextMessageModel : ACMessageModel

@property (nonatomic, readonly) NSString        *text;

// TODO: different interface for message creation?

// return `nil` if text.length == 0
- (instancetype)initWithText:(NSString *)text room:(ACRoomModel *)roomModel;
+ (instancetype)messageWithText:(NSString *)text room:(ACRoomModel *)roomModel;

@end
