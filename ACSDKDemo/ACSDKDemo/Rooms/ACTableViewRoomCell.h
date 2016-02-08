//
//  ACTableViewRoomCell.h
//  ACSDK
//
//  Created by Артур Сагидулин on 29.01.16.
//  Copyright © 2016 Magneta. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACRoomModel;

@interface ACTableViewRoomCell : UITableViewCell

@property (nonatomic, strong) UIImageView *roomAvatar;
@property (nonatomic, strong) UIView *verticalSeparator;

@property (nonatomic, strong) UILabel *timestampLabel;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *lastMessageLabel;

- (void)setupWithModel:(ACRoomModel*)model;

@end
