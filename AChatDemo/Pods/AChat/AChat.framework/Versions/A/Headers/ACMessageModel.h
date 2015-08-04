
//
//  ACMessageModel.h
//  ACChat
//
//  Created by Alex on 6/18/15.
//  Copyright (c) 2015 Octoberry. All rights reserved.
//

#import <AChat/ACBaseModel.h>

#define STATUS_SENT @"Delivered"
#define STATUS_SENDING @"Sending..."
#define STATUS_ERROR @"Error"

@interface ACMessageModel : ACBaseModel

@property (nonatomic, strong) NSString  *messageID;

@property (nonatomic, strong) NSString  *senderID;

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
@property (nonatomic, strong) NSString *client_id;

/*
    Sending status
 */
@property (nonatomic, strong) NSString *status;


-(instancetype)initSenderId:(NSString *)userId
                     roomId:(NSString *)roomId
                    message:(NSString *)message
                   clientId:(NSString *)clientId
          fileAttachmentURL:(NSString *)fileAttachmentURL
                andSentDate:(NSDate *)sentDate;

@end
