//
//  ACRichMessageModel.h
//  ACSDK
//
//  Created by Ivan Golikov on 21.12.16.
//  Copyright © 2016 Magneta. All rights reserved.
//

#import "ACMessageModel.h"
#import "ACRoomModel.h"
#import "ACPayloadModel.h"

@class ACPayloadModel;

@interface ACRichMessageModel : ACMessageModel

@property (nonatomic, readonly) ACPayloadModel  *payload;

@end
