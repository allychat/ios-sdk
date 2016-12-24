//
//  ACPayloadModel.h
//  ACSDK
//
//  Created by Ivan Golikov on 21.12.16.
//  Copyright © 2016 Magneta. All rights reserved.
//

#import "ACBaseModel.h"

@class ACPayloadElement;

@interface ACPayloadModel : ACBaseModel

@property (nonatomic, readonly) NSString                    *templateType;
@property (nonatomic, readonly) NSArray<ACPayloadElement*>  *elements;

@end
