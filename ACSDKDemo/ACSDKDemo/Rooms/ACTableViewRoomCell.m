//
//  ACTableViewRoomCell.m
//  ACSDK
//
//  Created by Артур Сагидулин on 29.01.16.
//  Copyright © 2016 Magneta. All rights reserved.
//

#import "ACTableViewRoomCell.h"
#import <ACSDK/ACSDK.h>
#import <SDWebImage/UIImageView+WebCache.h>

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface ACTableViewRoomCell ()
@property (nonatomic, strong) UIView *separatorView;
@end;


@implementation ACTableViewRoomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)createSubviews {
    _roomAvatar = [UIImageView new];
    [self.contentView addSubview:_roomAvatar];
    
    _verticalSeparator = [UIView new];
    [self.contentView addSubview:_verticalSeparator];
    
    _nameLabel = [UILabel new];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    _nameLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [self.contentView addSubview:_nameLabel];
    
    _timestampLabel = [UILabel new];
    _timestampLabel.font = [UIFont systemFontOfSize:10];
    _timestampLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_timestampLabel];
    
    _lastMessageLabel = [UILabel new];
    _lastMessageLabel.textColor = [UIColor grayColor];
    _lastMessageLabel.font = [UIFont systemFontOfSize:15];
    _lastMessageLabel.numberOfLines = 0;
    [self.contentView addSubview:_lastMessageLabel];
    
    _separatorView = [UIView new];
    _separatorView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.1];
    [self.contentView addSubview:_separatorView];
    
    [self setConstraints];
}


- (void)setConstraints {
    const CGFloat topPadding = 15.0;
    const CGFloat bottomPadding = 8.0;
    const CGFloat xMargin = 16.0;
    const CGFloat dividerWidth = 12.0;
    
    _roomAvatar.translatesAutoresizingMaskIntoConstraints = NO;
    [_roomAvatar.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
    [_roomAvatar.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
    [_roomAvatar.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
    [_roomAvatar.widthAnchor constraintEqualToAnchor:_roomAvatar.heightAnchor].active = YES;
    
    _verticalSeparator.translatesAutoresizingMaskIntoConstraints = NO;
    [_verticalSeparator.leadingAnchor constraintEqualToAnchor:_roomAvatar.trailingAnchor].active = YES;
    [_verticalSeparator.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
    [_verticalSeparator.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
    [_verticalSeparator.widthAnchor constraintEqualToConstant:dividerWidth].active = YES;
    
    _timestampLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_timestampLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:topPadding].active = YES;
    [_timestampLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-xMargin].active = YES;
    [_timestampLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_nameLabel.centerYAnchor constraintEqualToAnchor:_timestampLabel.centerYAnchor].active = YES;
    [_nameLabel.leadingAnchor constraintEqualToAnchor:_verticalSeparator.trailingAnchor constant:xMargin].active = YES;
    [_nameLabel.trailingAnchor constraintEqualToAnchor:_timestampLabel.leadingAnchor constant:-10].active = YES;
    
    _lastMessageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_lastMessageLabel.leadingAnchor constraintEqualToAnchor:_nameLabel.leadingAnchor].active = YES;
    [_lastMessageLabel.trailingAnchor constraintEqualToAnchor:_timestampLabel.trailingAnchor].active = YES;;
    [_lastMessageLabel.topAnchor constraintEqualToAnchor:_nameLabel.bottomAnchor constant:4].active = YES;
    [self.contentView.bottomAnchor constraintGreaterThanOrEqualToAnchor:_lastMessageLabel.bottomAnchor constant:bottomPadding].active = YES;
    
    _separatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [_separatorView.leadingAnchor constraintEqualToAnchor:_verticalSeparator.trailingAnchor].active = YES;
    [_separatorView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor].active = YES;
    [_separatorView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
    [_separatorView.heightAnchor constraintEqualToConstant:0.5].active = YES;
}

- (void)setupWithModel:(ACRoomModel*)model {
    ACUserModel *sender = model.users.firstObject;
    if ([sender isEqual:[ACSDK defaultInstance].userModel])
        sender = model.users.lastObject;

    if (sender.avatarURL && !model.isSupportRoom) {
        [_roomAvatar sd_setImageWithURL:sender.avatarURL placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    } else {
        _roomAvatar.image = [UIImage imageNamed:@"avatar_placeholder"];
    }
    
    static dispatch_once_t onceToken;
    static NSDateFormatter *dateFormatter = nil;
    static NSArray *colors = nil;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"dd.MM HH:mm";
        colors = @[RGB(31, 200, 176), RGB(202, 173, 171), RGB(191, 101, 192), RGB(233, 106, 178), RGB(252, 207, 108), RGB(251, 220, 145)];
    });
    
    _timestampLabel.text = [dateFormatter stringFromDate:model.lastMessageModel.createdAt];
    _nameLabel.text = model.isSupportRoom ? @"Support Room" : sender.alias;
    
    _verticalSeparator.backgroundColor = colors[[sender.alias hash] % colors.count];
    
    if ([model.lastMessageModel isKindOfClass:[ACTextMessageModel class]]) {
        ACTextMessageModel *textModel = (ACTextMessageModel*)model.lastMessageModel;
        _lastMessageLabel.text = textModel.text;
    } else if ([model.lastMessageModel isKindOfClass:[ACImageMessageModel class]]){
        _lastMessageLabel.text = @"[image]";
    } else {
        _lastMessageLabel.text = nil;
    }
}

//- (void)awakeFromNib {
//    // Initialization code
//}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//}

@end
