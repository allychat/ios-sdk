//
//  ACImageMessageModel.h
//  AllychatSDK
//
//  Created by Andrew Kopanev on 12/8/15.
//  Copyright © 2015 Magneta. All rights reserved.
//

#import "ACMessageModel.h"
#import <UIKit/UIKit.h>

@class ACRoomModel;

@interface ACImageMessageModel : ACMessageModel

@property (nonatomic, readonly) NSURL   *imageURL;


+ (instancetype)messageWithImageURL:(NSURL *)imageURL room:(ACRoomModel *)roomModel;
+ (instancetype)messageWithImage:(UIImage *)image room:(ACRoomModel *)roomModel;

- (instancetype)initWithImageURL:(NSURL *)imageURL room:(ACRoomModel *)roomModel;

@end


@interface ACImageMessageModel (ClientProperties)

@property (nonatomic, assign, readonly) CGFloat uploadProgress;
@property (nonatomic, strong, readonly) UIImage *image;

@end
