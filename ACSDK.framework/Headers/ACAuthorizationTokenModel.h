//
//  ACAuthorizationTokenModel.h
//  ACSDK
//
//  Created by Andrew Kopanev on 12/22/15.
//  Copyright © 2015 Magneta. All rights reserved.
//

#import "ACBaseModel.h"

@interface ACAuthorizationTokenModel : ACBaseModel

@property (nonatomic, readonly) NSString        *token;
@property (nonatomic, readonly) BOOL            isExpired;

// temporary here :) waiting for Pachay's implementation
- (void)markExpired;

@end
