//
//  ACAddRoomViewController.h
//  ACSDK
//
//  Created by Рамис Ямилов on 25.01.16.
//  Copyright © 2016 Magneta. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACRoomModel;

@protocol ACCreateRoomViewControllerDelegate <NSObject>
- (void)didCreateRoom:(ACRoomModel*)roomModel;
@end

@interface ACCreateRoomViewController : UIViewController

@property (nonatomic, weak) id<ACCreateRoomViewControllerDelegate> delegate;

@end
