//
//  ACEngine.h
//  ACChat
//
//  Created by Andrew Kopanev on 6/16/15.
//  Copyright (c) 2015 Octoberry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AChat/ACMessageModel.h>
#import <AChat/ACUserModel.h>
#import <AChat/ACRoomModel.h>
#import <AChat/ACOperatorModel.h>

//! Project version number for AChat.
FOUNDATION_EXPORT double AChatVersionNumber;

//! Project version string for AChat.
FOUNDATION_EXPORT const unsigned char AChatVersionString[];


typedef NS_ENUM(NSInteger, AChatStatus) {
    AChatStatusOffline,
    AChatStatusConnecting,
    AChatStatusOnline
};

@class ACEngine;

@protocol AChatDelegate <NSObject>

@optional

- (void)chat:(ACEngine *)engine didUpdateStatusFromStatus:(AChatStatus)oldSstatus toStatus:(AChatStatus)newStatus;

- (void)chat:(ACEngine *)engine didReceiveMessage:(ACMessageModel *)message;

- (void)chat:(ACEngine *)engine didUpdateMessage:(ACMessageModel*)message toStatus:(MessageStatus)newStatus;

- (void)chat:(ACEngine *)engine didConnectChatRoom:(ACRoomModel *)room;

@end

@interface ACEngine : NSObject


@property (nonatomic, readonly) NSURL           *URL;
@property (nonatomic, readonly) NSString        *alias;
@property (nonatomic, readonly) NSString        *applicationId;

@property (nonatomic, readonly) AChatStatus     status;
@property (nonatomic, readonly) ACUserModel     *userModel;

@property (nonatomic, weak) id<AChatDelegate> delegate;

#pragma mark - Inititialization

- (instancetype)initWithURL:(NSURL *)url
                      alias:(NSString *)alias
                       name:(NSString *)name
           andApplicationId:(NSString *)appId
withExternalTokenCompletion:(NSString* (^)(void))externalTokenCompletion;

/*
    Registration without auth_token support
 */
- (instancetype)initWithURL:(NSURL *)url
                      alias:(NSString *)alias
                       name:(NSString *)name
           andApplicationId:(NSString *)appId;

- (void)updateToken:(void (^)(NSError *error, NSString *token))completion;

#pragma mark - Users

- (void)userWithId:(NSString *)userId
        completion:(void(^)(NSError *error, ACUserModel *user))completion;

- (void)usersWithIDs:(NSArray *)IDs
          completion:(void(^)(NSError *error, NSArray *users))completion;

- (void)userAliasWithID:(NSString *)userID
             completion:(void(^)(NSError *error, NSString *alias))completion;

- (void)userWithAlias:(NSString *)alias
           completion:(void(^)(NSError *error, ACUserModel* user))completion;

- (void)updateAvatarWithURLString:(NSString *)urlString
                       completion:(void(^)(NSError *error))completion;

#pragma mark - Rooms
/*
    Get the Room with Support Team
 */
- (void)getSupportRoomWithCompletion:(void(^)(NSError *error, ACRoomModel *room))completion;

/*
    Get current available Rooms
 */
- (NSArray *)rooms;

- (void)roomsWithCompletion:(void(^)(NSArray *rooms, NSError *error))completion;

- (void)createRoomWithOpponent:(NSString *)opponentUserId
                    completion:(void(^)(NSError *error, ACRoomModel *room))completion;

#pragma mark - Messages

- (void)sendImageMessage:(UIImage *)image
                   roomId:(NSString *)roomId
               completion:(void(^)(NSError *error, ACMessageModel *message))completion;

- (void)sendImageMessage:(UIImage *)image
                   roomId:(NSString *)roomID
               completion:(void(^)(NSError *error, ACMessageModel *message))completion
                 progress:(void(^)(CGFloat progress))progress;

- (void)sendTextMessage:(NSString *)text
                 roomId:(NSString *)roomID
             completion:(void(^)(NSError *error, ACMessageModel *message))completion;

- (void)resendMessage:(NSString *)messageId
             completion:(void(^)(NSError *error))completion;

- (void)readMessage:(NSString *)messageID
         completion:(void(^)(NSError *error, bool isComplete))completion;

- (void)lastMessages:(NSNumber *)count
              roomId:(NSString *)roomId
          completion:(void(^)(NSError *, NSArray *))completion;

- (void)firstMessages:(NSNumber *)count
               roomId:(NSString *)roomId
           completion:(void(^)(NSError *, NSArray *))completion;

- (void)unreadMessagesForRoomId:(NSString *)roomId
                     completion:(void(^)(NSError *error, NSArray *unreadMessages))completion;

- (void)failedMessagesForRoomId:(NSString *)roomId
                     completion:(void(^)(NSError *error, NSArray *failedMessages))completion;

/*
    Returns the count of all messages for room by roomId
 */
- (void)countMessagesForRoomId:(NSString *)roomId
                    completion:(void (^)(NSError *error, NSUInteger count))completion;

/*
    Get the array of messages for by roomId with offset and limit
 */
- (void)getMessagesForRoomId:(NSString *)roomId
                      offset:(NSInteger)offset
                       limit:(NSInteger)limit
                  completion:(void(^)(NSError *error, NSArray *messages))completion;

- (void)historyForRoomId:(NSString *)roomID
                   limit:(NSNumber*)limit
           lastMessageID:(NSString *)messageID
                 showNew:(BOOL)show
              completion:(void(^)(NSError *, NSArray *))completion;

#pragma mark - APNS Systems

-(void)setPushNotificationToken:(NSData *)deviceToken
                 withCompletion:(void(^)(NSError *error, BOOL isComplete))completion;


#pragma mark - System Methods

- (void)operatorById:(NSString *)operatorId
      withCompletion:(void(^)(NSError *error, ACOperatorModel *operatorModel))completion;

@end
