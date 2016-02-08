//
//  ACMessageModel.h
//  AllychatSDK
//
//  Created by Andrew Kopanev on 12/8/15.
//  Copyright © 2015 Magneta. All rights reserved.
//

#import "ACBaseModel.h"
#import "ACUserModel.h"

typedef NS_ENUM(NSUInteger, ACMessageStatus) {
    ACMessageStatusSending,
    ACMessageStatusSent,
    ACMessageStatusFailed,
};

/*
"last_message": {
    "created_at_millis": 1449264664171,
    "client_id": null,
    "read": true,
    "file": null,
    "is_hidden": false,
    "event": null,
    "room": "56620618d48f54223cd0760b",
    "sender": {
        "alias": null,
        "avatar_url": "https://allychatcdn.blob.core.windows.net/alfaallychatru-dev/040ba2f2-76e1-4db5-a7b7-6e359c33ca04.jpg",
        "id": "55af76764d02f45f4450e5d5",
        "name": "\u041b\u0438\u043b\u0438\u044f"
    },
    "created_at": 1449264664.171076,
    "message": "\u041f\u0440\u0438\u0432\u0435\u0442! \u0417\u0434\u0435\u0441\u044c \u0432\u044b \u043c\u043e\u0436\u0435\u0442\u0435 \u0437\u0430\u0434\u0430\u0442\u044c \u0432\u043e\u043f\u0440\u043e\u0441 \u0438 \u0431\u044b\u0441\u0442\u0440\u043e \u043f\u043e\u043b\u0443\u0447\u0438\u0442\u044c \u043e\u0442\u0432\u0435\u0442 \u043d\u0430 \u043d\u0435\u0433\u043e.",
    "id": "56620618d48f54223cd0760d",
    "issue": "56620618d48f54223cd0760c"
},
*/

@interface ACMessageModel : ACBaseModel <NSCoding>

@property (nonatomic, readonly) NSString        *messageId;
@property (nonatomic, readonly) NSString        *roomId;

@property (nonatomic, readonly) NSDate          *createdAt;
@property (nonatomic, readonly) ACUserModel     *senderModel;

@property (nonatomic, assign, readonly) BOOL                isRead;
@property (nonatomic, assign, readonly) BOOL                isMine;

@property (nonatomic, readonly) ACMessageStatus status;

@end
