//
//  ACUserModel.h
//  AllychatSDK
//
//  Created by Andrew Kopanev on 12/8/15.
//  Copyright © 2015 Magneta. All rights reserved.
//

#import "ACBaseModel.h"

/*
{
    "geolocation": null,
    "is_operator": false,
    "device_type": "iPhone7,2",
    "is_anonym": true,
    "os_version": "iPhone OS/9.0",
    "tags": [
    
    ],
    "apps": [
    
    ],
    "name": null,
    "alias": "allychat_anonym_client_5C0A28E26EB941C197862769B8A2F3C1",
    "avatar_url": null,
    "is_admin": false,
    "is_observer": false,
    "is_temporary": false,
    "login": null,
    "app_version": "ru.alfabank.AlfaSenseDev.push/1.0.1.0",
    "id": "56620618d48f54223cd0760a",
    "tzoffset": "10800"
}
 */

@interface ACUserModel : ACBaseModel <NSCoding>

@property (nonatomic, readonly) NSString        *userId;
@property (nonatomic, readonly) NSString        *alias;
@property (nonatomic, readonly) NSString        *name;
@property (nonatomic, readonly) NSURL           *avatarURL;

@property (nonatomic, strong)   NSDictionary    *userInfo;

// subclass is better I guess...
@property (nonatomic, readonly) BOOL            isOperator;

- (instancetype)initWithAlias:(NSString *)alias;
+ (instancetype)userWithAlias:(NSString *)alias;

// Возвращает пользователя с анонимным алиасом.
// Алиас будет сгенерирован заново после удаления и повторной установки приложения.
+ (instancetype)anonymousUser;

@end
