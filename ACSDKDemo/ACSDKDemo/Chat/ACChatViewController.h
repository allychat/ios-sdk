//
//  ACChatViewController.h
//  ACSDK
//
//  Created by Andrew Kopanev on 12/23/15.
//  Copyright © 2015 Magneta. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACRoomModel;

@interface ACChatViewController : UIViewController

- (instancetype)initWithRoom:(ACRoomModel *)roomModel;

@end
