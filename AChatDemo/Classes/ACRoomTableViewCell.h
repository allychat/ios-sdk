//
//  ACRoomTableViewCell.h
//  AChatDemo
//
//  Created by Alexandr Turyev on 17/07/15.
//  Copyright (c) 2015 Octoberry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedEngine.h"

@interface ACRoomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rightDetail;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;

@property(strong, nonatomic) ACRoomModel *room;

@end
