//
//  AllychatSDK.h
//  AllychatSDK
//
//  Created by Alexandr Turyev on 10/07/15.
//  Copyright (c) 2015 Octoberry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DataModels.h"


typedef NS_ENUM(NSInteger, AChatStatus) {
    AC_OFFLINE,
    AC_CONNECTING,
    AC_ONLINE
};

@protocol AllychatDelegate <NSObject>

#pragma mark - Responds Delegate Methods

@optional

- (void)didReceiveMessage:(ACMessage *)message
                 fromRoom:(ACRoom *)roomObj;

- (void)didUpdateMessage:(ACMessage *)messageObj
                toStatus:(ACMessageStatus)newStatus;

- (void)didUpdateChatStatusTo:(AChatStatus)newStatus;

-(NSString *)getExternalToken;

@end

@interface AllychatSDK : NSObject

@property (nonatomic, strong) ACUser *userIdentity;
@property (nonatomic, readonly) ACRoom *supportRoom;
@property (nonatomic, strong) NSString *applicationId;
@property (nonatomic, strong) NSString *url;

@property (nonatomic, weak) id<AllychatDelegate> delegate;

+ (instancetype)instance;

+ (void)initWithAppId:(NSString *)applicationId
               andUrl:(NSString *)serverUrl;

+ (void)registerUserIdentity:(void(^)(ACUser *userModel))success
                     failure:(void (^)(NSError *error))failure;

+ (void)signOff;

+ (void)connectToChatWithSupport:(void(^)(ACRoom *supportRoom))success
                         failure:(void (^)(NSError *error))failure;

+ (void)connectToChat:(void(^)(BOOL isComplete))success
              failure:(void (^)(NSError *error))failure;

+ (void)disconnectFromChat;

#pragma mark - User

+ (void)updateAvatarURL:(NSURL *)URL
                failure:(void(^)(NSError *))failure;

#pragma mark - History For Any Room

+ (void)countMessagesInRoom:(NSString *)roomID
                    success:(void(^)(NSUInteger count))success
                    failure:(void (^)(NSError *error))failure;

+ (void)messagesFromRoom:(NSString *)roomID
                  offset:(NSInteger)offset
                   limit:(NSInteger)limit
                 success:(void(^)(NSArray *messages))success
                 failure:(void (^)(NSError *error))failure;

+ (void)messagesPreviousToMessage:(ACMessage *)lastMessage
                            limit:(NSInteger)limit
                          success:(void(^)(NSArray *messages))success
                          failure:(void (^)(NSError *error))failure;


#pragma mark - History With Support

+ (void)countMessagesWithSupport:(void(^)(NSUInteger count))success
                         failure:(void(^)(NSError *error))failure;

+ (void)messagesWithSupportAndOffset:(NSInteger)offset
                               limit:(NSInteger)limit
                             success:(void(^)(NSArray *messages))success
                             failure:(void (^)(NSError *error))failure;

#pragma mark - Optional Methods

+ (void)unreadMessagesForRoom:(ACRoom *)room
                      success:(void(^)(NSArray *messages))success
                      failure:(void (^)(NSError *error))failure;

+ (void)failedMessagesForRoom:(ACRoom *)room
                      success:(void(^)(NSArray *failedMessages))success
                      failure:(void (^)(NSError *error))failure;


#pragma mark - Sending Messages To Support


+ (void)sendTextToSupport:(NSString *)text
                  failure:(void (^)(NSError *error))failure;

+ (void)sendImageToSupport:(UIImage *)image
                   failure:(void (^)(NSError *error))failure;

+ (void)sendImageToSupport:(UIImage *)image
              withProgress:(void(^)(CGFloat progress))progress
                   failure:(void (^)(NSError *error))failure;

#pragma mark - Sending Messages 

+ (void)sendText:(NSString *)text
          roomID:(NSString *)roomID
         failure:(void (^)(NSError *error))failure;

+ (void)sendImage:(UIImage *)image
           roomID:(NSString *)roomID
          failure:(void (^)(NSError *error))failure;

+ (void)sendImage:(UIImage *)image
           roomID:(NSString *)roomID
         progress:(void(^)(CGFloat progress))progress
          failure:(void (^)(NSError *error))failure;

#pragma mark - Common Sending Methods

+ (void)resendMessage:(ACMessage *)message
              failure:(void (^)(NSError *error))failure;

+ (void)resendMessage:(ACMessage *)messageObj
         withProgress:(void(^)(CGFloat progress))progress
              failure:(void (^)(NSError *error))failure;

+ (void)setReadForMessage:(ACMessage *)message
                  failure:(void (^)(NSError *error))failure;



#pragma mark - Rooms Operations

+ (void)rooms:(void(^)(NSArray *rooms))success
      failure:(void (^)(NSError *error))failure;

+ (void)createRoomWithUserId:(NSString *)userId
                    success:(void(^)(ACRoom *newRoom))success
                    failure:(void (^)(NSError *error))failure;

+ (void)getUserWithID:(NSString *)userId
              success:(void(^)(ACUser *user))success
              failure:(void (^)(NSError *error))failure;

+ (void)getUsersWithIDs:(NSArray *)usersIds
              success:(void(^)(NSArray *users))success
              failure:(void (^)(NSError *error))failure;

+ (void)getUserWithAlias:(NSString *)userAlias
                 success:(void(^)(ACUser *user))success
                 failure:(void (^)(NSError *error))failure;

#pragma mark - APNS Systems

+(void)subscribeToAPNSWithToken:(NSData *)deviceToken
                        failure:(void (^)(NSError *error))failure;

+(void)unsubscribeFromAPNS:(void (^)(NSError *error))failure;





@end
