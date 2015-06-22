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
@end

@interface ACEngine : NSObject

@property (nonatomic, readonly) NSURL           *URL;
@property (nonatomic, readonly) NSString        *alias;
@property (nonatomic, readonly) AChatStatus     status;
@property (nonatomic, readonly) ACUserModel     *userModel;

@property (nonatomic, weak) id<AChatDelegate> delegate;

- (instancetype)initWithURL:(NSURL *)url alias:(NSString *)alias NS_DESIGNATED_INITIALIZER;

- (void)roomsWithCompletion:(void(^)(NSArray *rooms, NSError *error))completion;

- (void)sendImageMessage:(UIImage *)image
                    room:(NSString *)roomID
              completion:(void(^)(NSError *error))completion;

- (void)sendTextMessage:(NSString *)text
                   room:(NSString *)roomID
             completion:(void(^)(NSError *error))completion;

- (void)usersWithIDs:(NSArray *)IDs
             completion:(void(^)(NSError *error, NSArray *users))completion;

- (void)updateAvatarWithURLString:(NSString *)urlString
                          completion:(void(^)(NSError *error))completion;

- (void)userAliasWithID:(NSString *)userID
                completion:(void(^)(NSError *error, NSString *alias))completion;

- (void)createRoomWithOpponent:(NSString *)opponentUser
                       completion:(void(^)(NSError *error, NSDictionary *room))completion;

- (void)userWithAlias:(NSString *)alias
              completion:(void(^)(NSError *error, ACUserModel* user))completion;

- (void)readMessage:(NSString *)messageID
            completion:(void(^)(NSError *error))completion;

- (void)lastMessages:(NSNumber *)count
                   room:(NSString *)room
             completion:(void(^)(NSError *, NSArray *))completion;

- (void)firstMessages:(NSNumber *)count
                    room:(NSString *)room
              completion:(void(^)(NSError *, NSArray *))completion;

- (void)historyForRoom:(NSString *)roomID
                    limit:(NSNumber*)limit
            lastMessageID:(NSString *)messageID
                  showNew:(BOOL)show
               completion:(void(^)(NSError *, NSArray *))completion;

@end
