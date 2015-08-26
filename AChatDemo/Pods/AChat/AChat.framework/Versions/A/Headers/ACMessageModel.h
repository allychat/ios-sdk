
//
//  ACMessageModel.h
//  ACChat
//
//  Created by Alex on 6/18/15.
//  Copyright (c) 2015 Octoberry. All rights reserved.
//

#import <AChat/ACBaseModel.h>
#import "ACUserModel.h"

typedef NS_ENUM(NSUInteger, MessageStatus) {
    STATUS_NEW,
    STATUS_SENDING,
    STATUS_RESENDING,
    STATUS_SENT,
    STATUS_FAILED
};

@interface ACMessageModel : ACBaseModel

@property (nonatomic, strong) NSString  *messageID;

@property (nonatomic, strong) NSString *senderID;

@property (nonatomic, strong) ACUserModel *sender;

@property (nonatomic, strong) NSString  *roomID;

@property (nonatomic, strong) NSString  *message;

/*
    Loaded image url
 */
@property (nonatomic, strong) NSString  *fileAttachmentURL;

@property (nonatomic, strong) NSDate    *sentDate;

@property (nonatomic, strong) NSString *issue;

/*
    Signature of message
 */
@property (nonatomic, retain) NSString *client_id;

/*
    Sending status
 */
@property (atomic,assign) MessageStatus status;

/*
 Sending status
 */
@property (atomic,assign) BOOL isOuput;



-(instancetype)initSenderId:(NSString *)userId
                     roomId:(NSString *)roomId
                    message:(NSString *)message
                   clientId:(NSString *)clientId
          fileAttachmentURL:(NSString *)fileAttachmentURL
                andSentDate:(NSDate *)sentDate;



@end
