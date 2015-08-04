# allychat-ios

## OVERVIEW

This is a full native iPhone app to create realtime chat with AllyChatSDK.
<table>
   <tr>   
        <td>
            <img src="https://cloud.githubusercontent.com/assets/1265098/8768935/3ba36026-2e99-11e5-9baf-734e0d2068b1.png" width ="160" height ="284">
        </td>
        <td>
            <img src="https://cloud.githubusercontent.com/assets/1265098/8768938/3ba62e82-2e99-11e5-9a36-9592976c3697.png" width ="160" height ="284">
        </td>
        <td>
            <img src="https://cloud.githubusercontent.com/assets/1265098/8768939/3ba60e0c-2e99-11e5-98cc-105db54b4dc4.png" width ="160" height ="284">
        </td>
    </tr>
  <tr>
    <td>
        <img src="https://cloud.githubusercontent.com/assets/1265098/8768940/3ba72666-2e99-11e5-94d7-37e4c80007dc.png" width ="160" height ="284">
    </td>
    <td>
        <img src="https://cloud.githubusercontent.com/assets/1265098/8768944/3bc1b904-2e99-11e5-9718-93e82729ac2d.png" width ="160" height ="284">
    </td>
    <td>
        <img src="https://cloud.githubusercontent.com/assets/1265098/8768942/3bbe9b84-2e99-11e5-9a65-a76d22bca6df.png" width ="160" height ="284">
    </td>
  </tr>
 </table>
<br>

## REQUIREMENTS

- Xcode 6
- iOS 7.1
- ARC

## Installation
From [CocoaPods](http://cocoapods.org):
````ruby
# For latest release in cocoapods
pod 'AChat', :git => "https://github.com/allychat/ios-sdk.git"
````

Without CocoaPods:

1. *Why aren't you using CocoaPods?*
2. Drag the `AChat.framework` to your project.
3. Add libicucore.dylib 

### How to Get Started

Check out the included demo project, under the **AChatDemo** directory, which contains an example using different components of the SDK, including the messaging (WebSockets), REST API methods, Push Notification. Since the project's dependencies (specifically JSQMessagesViewController) in the demo project are installed and managed using [CocoaPods](http://cocoapods.org), you will need to open the **allychat.demo.xcworkspace**.


## Getting Started

You need to create ACEngine object to initialize with user's alias and external token. External token should be requested from bank system on the fly.

````objective-c
// import all the things
#import <AChat/AChat.h>   

ACEngine *engine = [[ACEngine alloc] initWithURL:[NSURL URLWithString:@"URL"]
                                           alias:@"ALIAS" name:@"NAME"
                                andApplicationId:@"APP_ID"
                     withExternalTokenCompletion:^NSString *{
    //please return external toke (auth_token)
    return EXTERNAL_TOKEN;
}];
````

#### Create Simple Chat

Get Available Rooms (one support room creates **automatically** when initialized with alias).
````objective-c
[engine roomsWithCompletion:^(NSArray *rooms, NSError *error) {
   
}];
````

In order to receive Messages you should conform to the `AChatDelegate` protocol. 
````objective-c   
- (void)chat:(ACEngine *)engine didReceiveMessage:(ACMessageModel *)message;
````

Received Messages should be marked as `read` with method: 
````objective-c   
- (void)readMessage:(NSString *)messageID 
         completion:(void(^)(NSError *error, bool isComplete))completion;
````

Load last Messages of the Room.
````objective-c   
- (void)lastMessages:(NSNumber *)count
              roomId:(NSString *)roomId
          completion:(void(^)(NSError *, NSArray *))completion;
````

Load first Messages of the Room.
````objective-c  
- (void)firstMessages:(NSNumber *)count
               roomId:(NSString *)roomId
           completion:(void(^)(NSError *, NSArray *))completion;
````

Load earlier Messages (before Last One) of the Room
````objective-c   
- (void)historyForRoomId:(NSString *)roomID
                   limit:(NSNumber*)limit 
           lastMessageID:(NSString *)messageID
                 showNew:(BOOL)show 
              completion:(void(^)(NSError *, NSArray *))completion;
````

#### Send Messages

Simple text message (by using WebSockets).
````objective-c   
- (void)sendTextMessage:(NSString *)text
                 roomId:(NSString *)roomID
             completion:(void(^)(NSError *error, ACMessageModel *message))completion;
````

Image sending contains of 2 inner operation:
- upload image data by REST (progress available);
- get Url of image and send with WebSockets method.

````objective-c   
- (void)sendImageMessage:(UIImage *)image
                   roomId:(NSString *)roomId
               completion:(void(^)(NSError *error, ACMessageModel *message))completion;

- (void)sendImageMessage:(UIImage *)image
                   roomId:(NSString *)roomID
               completion:(void(^)(NSError *error, ACMessageModel *message))completion
                 progress:(void(^)(CGFloat progress))progress;
````

#### Operate With Users

Chat supports 2 type of users: 
 - common users of `ACUserModel`;
 - operators of `ACOperatorModel`.
 
 You can find another user(s) by Id or alias with these methods:
 
````objective-c   
- (void)userWithId:(NSString *)userId
        completion:(void(^)(NSError *error, ACUserModel *user))completion;

- (void)usersWithIDs:(NSArray *)IDs
          completion:(void(^)(NSError *error, NSArray *users))completion;

- (void)userAliasWithID:(NSString *)userID
             completion:(void(^)(NSError *error, NSString *alias))completion;

- (void)userWithAlias:(NSString *)alias
           completion:(void(^)(NSError *error, ACUserModel* user))completion;
```` 

All Messages have `senderId`. If room is `supportRoom` you should use this method in order to load operator info:
````objective-c
- (void)operatorById:(NSString *)operatorId 
      withCompletion:(void(^)(NSError *error, ACOperatorModel *operatorModel))completion;
```` 

#### Operate With Rooms

You can also create room with any other user if his alias exists:
````objective-c
- (void)createRoomWithOpponent:(NSString *)opponentUserId 
                    completion:(void(^)(NSError *error, ACRoomModel *room))completion;
````

If your object conforms to the `AChatDelegate` protocol you can receive the notification about new room invitation:
````objective-c
- (void)chat:(ACEngine *)engine didConnectChatRoom:(ACRoomModel *)room;
````

You can also get rooms from engine by calling:
````objective-c
- (NSArray *)rooms;
````

Room has the count of unread messages:
````objective-c
NSUInteger unreadMessages;
````

#### Push Notifications

First, make your app register for remote notifications by adding the following in your `application:didFinishLaunchingWithOptions:` method (if you haven't already):

````objective-c
UIApplication *sharedApp = [UIApplication sharedApplication];
if ([sharedApp respondsToSelector:@selector(registerUserNotificationSettings:)])
{
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert) categories:nil];
    [sharedApp registerUserNotificationSettings: settings];
}
else
{
    [sharedApp registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
}
````
Then register `deviceToken` once the device is registered for push notifications:
````objective-c
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    [engine setPushNotificationToken:deviceToken withCompletion:^(NSError *error, BOOL isComplete) {
        if (!isComplete) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}
````
