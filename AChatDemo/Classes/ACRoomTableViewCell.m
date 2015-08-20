//
//  ACRoomTableViewCell.m
//  AChatDemo
//
//  Created by Alexandr Turyev on 17/07/15.
//  Copyright (c) 2015 Octoberry. All rights reserved.
//

#import "ACRoomTableViewCell.h"

@implementation ACRoomTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
    _avatarView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setRoom:(ACRoomModel *)room
{
    if (_room != room)
    {
        _room = room;
        
        //Fill Last Message Data
        if (room.lastMessage)
        {
            self.subTitle.text = room.lastMessage.message;
            
            //If last message made by current user - mark it
            if ([room.lastMessage.senderID isEqualToString:[SharedEngine shared].engine.userModel.userID])
            {
                self.subTitle.text = [NSString stringWithFormat:@"You: %@", self.subTitle.text];
            }
            
            // Set Time Elapsed till last message
            NSTimeInterval seconds = [[NSDate date] timeIntervalSinceDate:_room.lastMessage.sentDate];
            self.rightDetail.text = TimeElapsed(seconds);
        }
        else
        {
            self.subTitle.text = self.rightDetail.text = @"";
        }
        
        if (room.isSupportRoom)
        {
            self.title.text = @"Support";
            
            //Load avatar of operator if possible
            if (_room.lastMessage.sender.avatarUrl) {
                self.avatarView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_room.lastMessage.sender.avatarUrl]]];
            }
        }
        else
        {
            //Find Opponent
            [[SharedEngine shared].engine usersWithIDs:room.users completion:^(NSError *error, NSArray *users) {
                if (users) {
                    [users enumerateObjectsUsingBlock:^(ACUserModel *user, NSUInteger idx, BOOL *stop) {
                        if (![user.userID isEqualToString:[SharedEngine shared].engine.userModel.userID]) {
                            self.title.text = user.alias;
                            self.avatarView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.avatarUrl]]];
                            *stop = true;
                        }
                    }];
                }
            }];
        }
    }
}

NSString* TimeElapsed(NSTimeInterval seconds)
{
    NSString *elapsed;
    if (seconds < 60)
    {
        elapsed = @"Just now";
    }
    else if (seconds < 60 * 60)
    {
        int minutes = (int) (seconds / 60);
        elapsed = [NSString stringWithFormat:@"%d %@", minutes, (minutes > 1) ? @"mins" : @"min"];
    }
    else if (seconds < 24 * 60 * 60)
    {
        int hours = (int) (seconds / (60 * 60));
        elapsed = [NSString stringWithFormat:@"%d %@", hours, (hours > 1) ? @"hours" : @"hour"];
    }
    else
    {
        int days = (int) (seconds / (24 * 60 * 60));
        elapsed = [NSString stringWithFormat:@"%d %@", days, (days > 1) ? @"days" : @"day"];
    }
    return elapsed;
}

@end
