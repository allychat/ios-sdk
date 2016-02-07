//
//  ACSDKConstants.h
//  ACSDK
//
//  Created by Andrew Kopanev on 12/17/15.
//  Copyright © 2015 Magneta. All rights reserved.
//

#ifndef ACSDKConstants_h
#define ACSDKConstants_h

// keys
extern NSString *const ACRoomKey;
extern NSString *const ACRoomsKey;
extern NSString *const ACMessageKey;
extern NSString *const ACStatusKey;

// connection status
typedef NS_ENUM(NSInteger, ACSDKSocketConnectionStatus) {
    ACSDKSocketStatusDisconnected,
    ACSDKSocketStatusConnecting,
    ACSDKSocketStatusConnected
};

// logging
typedef NS_ENUM(NSInteger, ACSDKLogLevel) {
    ACSDKLogNothing,
    ACSDKLogDebug
};

// errors
extern NSString *const ACSDKErrorDomain;

typedef NS_ENUM(NSInteger, ACSDKErrors) {
    ACSDKUnknownError           = 1,
    ACSDKNotJSONError           = 2,
    ACSDKBadAliasError          = 3,

    ACSDKAuthorizationError     = 1002,
    ACSDKUnknownAppIdError      = 1020,
    ACSDKCannotRegisterUser     = 1031
};

#endif /* ACSDKConstants_h */
