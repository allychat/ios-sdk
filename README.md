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
- iOS 7.0
- ARC

## Installation

The framework depends on network libraries - [AFNetworking](https://github.com/AFNetworking/AFNetworking) and [SocketRocket](https://github.com/square/SocketRocket). You must install dependencies via [CocoaPods](http://cocoapods.org) or add them manually. 

For latest release in cocoapods. 
````ruby
platform :ios, '7.0'
pod 'AllychatSDK ', :git => "https://github.com/allychat/ios-sdk.git"
````

Without CocoaPods:

1. *Why aren't you using CocoaPods?*
2. Drag the `AllychatSDK.framework` to your project.
3. Add classes from [AFNetworking](https://github.com/AFNetworking/AFNetworking) and [SocketRocket](https://github.com/square/SocketRocket).
4. Your application must be linked against the following frameworks/dylibs:
 - libicucore.dylib
 - CFNetwork.framework
 - Security.framework
 - Foundation.framework

### How to Get Started

Check out the included demo project, under the **AChatDemo** directory, which contains an example using different components of the SDK, including the messaging (WebSockets), REST API methods, Push Notification. Since the project's dependencies (specifically JSQMessagesViewController) in the demo project are installed and managed using [CocoaPods](http://cocoapods.org), you will need to open the **AllychatDemo.xcworkspace**.


## Getting Started

You need to initialize an AllychatSDK singleton-object with appropriate apllication ID and URL. It's recommended to do it in `-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions` method:

````objective-c
// import all the things
#import <AllychatSDK/AllychatSDK.h>

[AllychatSDK initWithAppId:@"APP_ID" andUrl:@"URL"];
````

#### Register User

In order to use REST methods of AllyChat you should register current User. The place is based on your application business logic.

````objective-c
//Create new User Identity
ACUser *usr = [[ACUser alloc] initWithAlias:@"ALIAS"];

//Or you can avoid setting the alias
//ACUser *usr = [[ACUser alloc] initAsAnonym];

//Set it to AllychatSDK instance
[AllychatSDK instance].userIdentity = usr;

//Register (or login) to Allychat server
[AllychatSDK registerUserIdentity:^(ACUser *userModel) {
                //your code
            } failure:^(NSError *error) {
                //your code
            }];
````

To logout you should use (you'll be disconnected from Chat too):
````objective-c
[AllychatSDK signOff];
````

#### Connect to Chat With Support Only
If you need to implement chat with Support Room only just connect with method:
````objective-c
[AllychatSDK connectToChatWithSupport:^(ACRoom *supportRoom) {
            //your code
        } failure:^(NSError *error) {
            //your code
        }];
````

#### Connect to Chat With Many Rooms

You need to get available Rooms (one support room creates **automatically** when initialized with alias). 
````objective-c
[AllychatSDK rooms:^(NSArray *rooms) {
        //your code
    } failure:^(NSError *error) {
        //your code
    }];
````
Or you can create additional one with another user:
````objective-c
[AllychatSDK createRoomWithUserId:(NSString *) success:^(ACRoom *newRoom) {
        //your code
    } failure:^(NSError *error) {
        //your code
    }];    
````
After that you should connect to chat:
````objective-c
[AllychatSDK connectToChat:^(BOOL isComplete) {
            //your code
        } failure:^(NSError *error) {
            //your code
        }];         
````

To disconnect from Chat you should use:
````objective-c
[AllychatSDK disconnectFromChat];
````

#### Receive Messages
In order to receive Messages your should conform to the `AllychatDelegate` protocol (**[AllychatSDK instance].delegate**) and implement: 
````objective-c   
- (void)didReceiveMessage:(ACMessage *)message
                 fromRoom:(ACRoom *)roomObj;
````

To get the status of your own sent messages implement this:
````objective-c   
- (void)didUpdateMessage:(ACMessage *)messageObj
                toStatus:(ACMessageStatus)newStatus;
````

By default all succesfully received messages are set as `read` but you can do it manually:
````objective-c   
[AllychatSDK setReadForMessage:(ACMessage *) failure:^(NSError *error) {
        //your code
    }];
````

#### Send Messages To Support Only
If you want to send text use:
````objective-c   
//The method is the same for Support or any other Room
[AllychatSDK sendTextToSupport:(NSString *) failure:^(NSError *error) {
        //your code
    }];
````
If you want to send images use:
````objective-c   
[AllychatSDK sendImageToSupport:(UIImage *) failure:^(NSError *error) {
        //your code
    }];
    
//With Progress status
[AllychatSDK sendImageToSupport:(UIImage *) withProgress:^(CGFloat progress) {
        //your code
    } failure:^(NSError *error) {
        //your code
    }];
````

#### Send Messages To Any Room
If you want to send text use:
````objective-c   
[AllychatSDK sendText:(NSString *) roomID:(NSString *) failure:^(NSError *error) {
        //your code
    }];
````

If you want to send images use:
````objective-c   
[AllychatSDK sendImage:(UIImage *) roomID:(NSString *) failure:^(NSError *error) {
        //your code
    }];
    
//With Progress status
[AllychatSDK sendImage:(UIImage *) roomID:(NSString *) progress:^(CGFloat progress) {
        //your code
    } failure:^(NSError *error) {
        //your code
    }];
````

When you need to Resend Message use this:
````objective-c   
[AllychatSDK resendMessage:(ACMessage *) failure:^(NSError *error) {
        //your code
    }];
````
#### Load Messages With Offset and Limit For Support Room Only
In order to load history of Support Room you should get the number of messages and then load messages with paging: 
````objective-c   
//Get the number of messages
[AllychatSDK countMessagesWithSupport:^(NSUInteger count) {
            //your code
        } failure:^(NSError *error) {
            //your code
        }];
        
//Load Messages with offset and limit (paging style)
[AllychatSDK messagesWithSupportAndOffset:(NSInteger) limit:(NSInteger) success:^(NSArray *messages) {
            //your code
        } failure:^(NSError *error) {
            //your code
        }];
````

#### Load Messages With Offset and Limit For Any Room
````objective-c   
[AllychatSDK countMessagesInRoom:(NSString *) success:^(NSUInteger count) {
            //your code
        } failure:^(NSError *error) {
            //your code
        }];
        
//Load Messages with offset and limit (paging style)
[AllychatSDK messagesFromRoom:(NSString *) offset:(NSInteger) limit:(NSInteger) success:^(NSArray *messages) {
            //your code
        } failure:^(NSError *error) {
            //your code
        }];
````

#### Load Messages Previous to the Message:
Every ACRoom has a `lastMessage` object of type ACMessage. The method is the same for support and other rooms:
````objective-c   
[AllychatSDK messagesPreviousToMessage:(ACMessage *) limit:(NSInteger) success:^(NSArray *messages) {
            //your code
        } failure:^(NSError *error) {
            //your code
        }];
````

#### Operate With Users 
 You can find another user(s) by Id or alias with these methods: 
````objective-c
[AllychatSDK getUserWithID:(NSString *) success:^(ACUser *user) {
        //your code
    } failure:^(NSError *error) {
        //your code
    }];
    
[AllychatSDK getUsersWithIDs:(NSArray *) success:^(NSArray *users) {
        //your code
    } failure:^(NSError *error) {
        //your code
    }];
    
[AllychatSDK getUserWithAlias:(NSString *) success:^(ACUser *user) {
        //your code
    } failure:^(NSError *error) {
        //your code
    }];
```` 

#### Additional Methods
If your object conforms to the `AllychatDelegate` protocol you can receive the notification about chat status:
````objective-c
- (void)didUpdateChatStatusTo:(AChatStatus)newStatus;
````

#### Push Notifications
You should register deviceToken once the device is registered for push notifications:
````objective-c
[AllychatSDK subscribeToAPNSWithToken:(NSData *) failure:^(NSError *error) {
        //your code
    }];
````
You can also unsubscribe from push notifications:
````objective-c
[AllychatSDK unsubscribeFromAPNS:^(NSError *error) {
        //your code
    }];
````