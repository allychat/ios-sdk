//
//  PHFComposeBarView+Customizing.h
//  ACSDKDemo
//
//  Created by Рамис Ямилов on 03.02.16.
//  Copyright © 2016 Magneta. All rights reserved.
//

#ifndef PHFComposeBarView_Customizing_h
#define PHFComposeBarView_Customizing_h

#import <PHFComposeBarView/PHFComposeBarView.h>

@interface PHFComposeBarView (CustomizableProperties)
@property (nonatomic, strong, readonly) UIButton    *utilityButton;
@property (nonatomic, strong, readonly) UIToolbar   *backgroundView;
@property (nonatomic, strong, readonly) UIView      *topLineView;
@property (nonatomic, strong, readonly) UIButton    *textContainer;
@end

#endif /* PHFComposeBarView_Customizing_h */
