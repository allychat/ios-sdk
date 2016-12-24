//
//  ACPayloadElement.h
//  ACSDK
//
//  Created by Ivan Golikov on 21.12.16.
//  Copyright © 2016 Magneta. All rights reserved.
//

#import "ACBaseModel.h"

@class ACPayloadButton;

@interface ACPayloadElement : ACBaseModel

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *subtitle;
@property (nonatomic, readonly) NSString *imageURL;
@property (nonatomic, readonly) NSArray<ACPayloadButton*>  *buttons;

@end
