//
//  ACSDK.h
//  AllychatSDK
//
//  Created by Andrew Kopanev on 12/8/15.
//  Copyright © 2015 Magneta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACSDKConstants.h"
#import "ACEntities.h"

// notifications
extern NSString *const ACSDKDidChangeSocketConnectionStatusNotification;
extern NSString *const ACSDKDidUpdateRoomsNotification;
extern NSString *const ACSDKDidReceiveMessageNotification;
extern NSString *const ACSDKDidUpdateMessageStatusNotification;
extern NSString *const ACSDKDidUpdateUploadProgressNotification;
extern NSString *const ACSDKDidPrepareMessageNotification;

extern NSString *const ACSDKOauthTokensExpiredNotification;


@class CLLocation;
@class ACSDK;
@protocol ACSDKDelegate <NSObject>

@optional
- (void)allyChatSDK:(ACSDK *)allyChatSDK didReceiveMessage:(ACMessageModel *)messageModel room:(ACRoomModel *)roomModel;
- (void)allyChatSDK:(ACSDK *)allyChatSDK didUpdateMessageStatus:(ACMessageModel *)messageModel room:(ACRoomModel *)roomModel;
- (void)allyChatSDK:(ACSDK *)allyChatSDK didUpdateUploadProgress:(ACMessageModel *)messageModel room:(ACRoomModel *)roomModel;
- (void)allyChatSDK:(ACSDK *)allyChatSDK didPrepareMessage:(ACMessageModel *)messageModel room:(ACRoomModel *)roomModel;

- (void)allyChatSDK:(ACSDK *)allyChatSDK didChangeSocketConnectionStatus:(ACSDKSocketConnectionStatus)connectionStatus;
- (void)allyChatSDK:(ACSDK *)allyChatSDK didUpdateRooms:(NSArray *)rooms;

- (void)allyChatSDKOauthTokensExpired:(ACSDK *)allyChatSDK;

@end

@interface ACSDK : NSObject

// other
@property (nonatomic, readonly) NSString                        *sdkVersion;

// default is ACSDKLogNothing
@property (nonatomic, assign) ACSDKLogLevel                     logLevel;

// settings
@property (nonatomic, copy, readonly) NSString                  *applicationId;
@property (nonatomic, copy, readonly) NSURL                     *serverURL;
@property (nonatomic, assign) BOOL                              setReadForAllDeliveredMessages;

// socket connection status
@property (nonatomic, readonly) ACSDKSocketConnectionStatus     socketConnectionStatus;

// user
@property (nonatomic, copy, readonly) ACUserModel               *userModel; // current user, could be nil

// rooms & users
@property (nonatomic, copy, readonly) NSArray                   *rooms;
@property (nonatomic, copy, readonly) NSArray                   *users;

@property (nonatomic, copy, readonly) ACRoomModel               *supportRoom;

// delegate
@property (nonatomic, weak) id <ACSDKDelegate>                  delegate;

// initalization
+ (instancetype)defaultInstance;
- (void)setApplicationId:(NSString *)applicationId serverURL:(NSURL *)serverURL;

// auth
- (void)signIn:(ACUserModel *)userModel completion:(void(^)(ACUserModel *userModel, NSError *error))completion;
- (void)signInWithCode:(NSString *)code completion:(void(^)(ACUserModel *userModel, NSError *error))completion;
- (void)signOut;

// messages
- (void)sendMessage:(ACMessageModel *)messageModel;

- (void)messagesAfterMessage:(ACMessageModel *)messageModel room:(ACRoomModel *)roomModel limit:(NSInteger)limit completion:(void(^)(NSArray *messages, BOOL hasMore, NSError *error))completion;
- (void)messagesBeforeMessage:(ACMessageModel *)messageModel room:(ACRoomModel *)roomModel limit:(NSInteger)limit completion:(void(^)(NSArray *messages, BOOL hasMore, NSError *error))completion;

- (void)setReadForMessage:(ACMessageModel*)messageModel;

// rooms
- (void)createRoomWithUser:(ACUserModel*)userModel completion:(void(^)(ACRoomModel *roomModel, NSError *error))completion;
- (void)numberOfUnreadMessagesInRoom:(ACRoomModel*)roomModel completion:(void(^)(NSInteger unreadCount, NSError *error))completion;

// APNs
- (void)subscribeToAPNs:(NSData *)deviceToken;
- (void)unsubscribeFromAPNs;

// geolocation
- (void)sendLocation:(CLLocation*)location;

@end
