//
//  ACMessageTableViewCell.h
//  ACSDK
//
//  Created by Andrew Kopanev on 12/24/15.
//  Copyright © 2015 Magneta. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACMessageModel;

@interface ACMessageTableViewCell : UITableViewCell

@property (nonatomic, readonly) UIView      *container;
@property (nonatomic, readonly) UILabel     *aliasLabel;
@property (nonatomic, readonly) UILabel     *messageLabel;
@property (nonatomic, readonly) UILabel     *statusLabel;
@property (nonatomic, readonly) UIImageView *pictureView;


@property (nonatomic, strong) ACMessageModel *messageModel;

@end
