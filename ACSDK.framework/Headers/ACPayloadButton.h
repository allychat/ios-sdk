//
//  ACPayloadButton.h
//  ACSDK
//
//  Created by Ivan Golikov on 21.12.16.
//  Copyright © 2016 Magneta. All rights reserved.
//

#import "ACBaseModel.h"

@interface ACPayloadButton : ACBaseModel

@property (nonatomic, readonly) NSString        *title;
@property (nonatomic, readonly) NSString        *url;

@end
