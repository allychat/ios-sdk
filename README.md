# allychat-ios

SDK для добавления в iOS-приложения функциональности обмена сообщениями в реальном времени.

## Требования

- Xcode 6
- iOS 7.0
- ARC

## Установка

Через СocoaPods. 

````ruby
platform :ios, '7.0'
pod 'ACSDK', :git => "https://github.com/allychat/ios-sdk.git"
````

Без CocoaPods:

1. Добавьте `ACSDK.framework` в ваш проект.
4. Ваше приложение должно быть собрано со следующими подключаемыми библиотеками:
 - libicucore.dylib

### С чего начать

В начале советуем ознакомиться с демо-приложением в папке **ACSDKDemo**, которое содержит примеры использования различных возможностей SDK, таких как прием/отправку сообщений, подписку на Push-уведомления, вызовы методов REST API. Так как демо-проект использует систему управления зависимостями [CocoaPods](http://cocoapods.org), для просмотра необходимо открывать **ACSDKDemo.xcworkspace**.

## Нaчало работы

Для работы с SDK необходимо его проинициализировать, передав Application ID и URL сервера. 

````objective-c
#import <ACSDK/ACSDK.h>

[[ACSDK defaultInstance] setApplicationId:@"app_id" serverURL:[NSURL URLWithString:@"https://example.com"]];
````

#### Регистрация пользователя

````objective-c
//Create new User
ACUserModel *user = [ACUserModel userWithAlias:@"ALIAS"];

//Or you can avoid setting the alias
//ACUserModel *user = [ACUserModel anonymousUser];

//Register (or login) to Allychat server
[[ACSDK defaultInstance] signIn:user completion:^(ACUserModel *userModel, NSError *error) {
    if (error) {
        // handle error
    } else {
        // userModel contains signed in user data
    }
}];
````

После успешной регистрации (авторизации) станет доступен список комнат.

#### Отправка сообщений


````objective-c
// current room
ACRoomModel *room = [ACSDK defaultInstance].supportRoom;

// sending text
ACMessageModel *textMessageModel = [ACTextMessageModel messageWithText:@"text" room:room];
[[ACSDK defaultInstance] sendMessage:textMessageModel];

// sending image
UIImage *image = ...;
ACMessageModel *imageMessageModel = [ACImageMessageModel messageWithImage:image room:room];
[[ACSDK defaultInstance] sendMessage:imageMessageModel];

````

Изменение состояния сообщений при отправке передается с помощью уведомлений `ACSDKDidUpdateMessageStatusNotification` и `ACSDKDidUpdateUploadProgressNotification`, а также через методы делегата:

````objective-c
- (void)allyChatSDK:(ACSDK *)allyChatSDK didUpdateMessageStatus:(ACMessageModel *)messageModel room:(ACRoomModel *)roomModel;
- (void)allyChatSDK:(ACSDK *)allyChatSDK didUpdateUploadProgress:(ACMessageModel *)messageModel room:(ACRoomModel *)roomModel;
````

Подготовка к отправке сообщения с изображением может занять некоторое время, поскольку объект с изображением необходимо сохранить на диск в формате, пригодном для передачи по сети. После завершения сохранения в поле `imageURL` содержится путь до изображения на локальном диске, которое доступно пока происходит загрузка файла на сервер.

Завершение подготовки передается с помощью уведомления `ACSDKDidPrepareMessageNotification`, а также через метод делегата:

````objective-c
- (void)allyChatSDK:(ACSDK *)allyChatSDK didPrepareMessage:(ACMessageModel *)messageModel room:(ACRoomModel *)roomModel;
````

#### Получение сообщений

Новые сообщения доставляются в реальном времени через центр уведомлений (`ACSDKDidReceiveMessageNotification`) и через метод делегата:

````objective-c
- (void)allyChatSDK:(ACSDK *)allyChatSDK didReceiveMessage:(ACMessageModel *)messageModel room:(ACRoomModel *)roomModel;
````

Для получения истории сообщений используются методы SDK:

````objective-c
ACMessageModel *messageModelOrNil = ...;
[[ACSDK defaultInstance] messagesAfterMessage:messageModelOrNil room:room limit:limit completion:^(NSArray *messages, BOOL hasMore, NSError *error) {
    ...
}];

[[ACSDK defaultInstance] messagesBeforeMessage:messageModelOrNil room:room limit:limit completion:^(NSArray *messages, BOOL hasMore, NSError *error) {
    ...
}];
````

В случае передачи `nil` в качестве параметра `messageModel`, в качестве точки отсчета используется сообщение, следующее за последним. То есть `messagesBeforeMessage:nil room:room limit:limit completion:completion` вернет `limit` самых последних сообщений в комнате, а `messagesAfterMessage:nil room:room limit:limit completion:completion` вернет пустой список.

По умолчанию всем полученным сообщениям устанавливается статус 'Прочитано'. Для самостоятельной установки данного статуса необходимо убрать соответствующий флаг и использовать метод SDK

````objective-c
// init
[[ACSDK defaultInstance] setApplicationId:@"app_id" serverURL:[NSURL URLWithString:@"https://example.com"]];
[ACSDK defaultInstance].setReadForAllDeliveredMessages = NO;

// send read status
[[ACSDK defaultInstance] setReadForMessage:messageModel];
````

#### Создание новой комнаты

````objective-c   
ACUserModel *anotherUser = [ACUserModel userWithAlias:@"alias"];
[[ACSDK defaultInstance] createRoomWithUser:anotherUser completion:^(ACRoomModel *roomModel, NSError *error) {
        ...
}];
````

#### Обновление списка комнат

При появлении новой комнаты или изменении существующей происходит отправка уведомления `ACSDKDidUpdateRoomsNotification`, а также вызов метода делегата

````objective-c   
- (void)allyChatSDK:(ACSDK *)allyChatSDK didUpdateRooms:(NSArray *)rooms;
````


#### Push-уведомления

````objective-c
NSData *deviceToken = ...;
[[ACSDK defaultInstance] subscribeToAPNs:deviceToken];

[[ACSDK defaultInstance] unsubscribeFromAPNs];
````

#### Отправка местоположения на сервер

````objective-c
CLLocation *location = ...;
[[ACSDK defaultInstance] sendLocation:location];
````

