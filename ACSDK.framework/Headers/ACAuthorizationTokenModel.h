//
//  ACAuthorizationTokenModel.h
//  ACSDK
//
//  Created by Andrew Kopanev on 12/22/15.
//  Copyright © 2015 Magneta. All rights reserved.
//

#import "ACBaseModel.h"

typedef NS_ENUM(NSUInteger, AuthorizationTokenModelType)
{
    AuthorizationTokenModelTypeLegacy,
    AuthorizationTokenModelTypeOAuth
};

@interface ACAuthorizationTokenModel : ACBaseModel <NSCoding>

@property (nonatomic, copy) NSString        *token;
@property (nonatomic, copy) NSString        *refreshToken;
@property (nonatomic) BOOL            isExpired;
@property (nonatomic) AuthorizationTokenModelType authorizationType;

// temporary here :) waiting for Pachay's implementation
- (void)markExpired;

@end
