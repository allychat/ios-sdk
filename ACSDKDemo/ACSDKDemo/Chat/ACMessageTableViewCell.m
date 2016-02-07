//
//  ACMessageTableViewCell.m
//  ACSDK
//
//  Created by Andrew Kopanev on 12/24/15.
//  Copyright © 2015 Magneta. All rights reserved.
//

#import "ACMessageTableViewCell.h"
#import <ACSDK/ACSDK.h>
#import <SDWebImage/UIImageView+WebCache.h>

#define RGB(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
const CGFloat xmargin = 12;
const CGFloat ymargin = 8;

@interface ACMessageTableViewCell()
@property (nonatomic) NSLayoutConstraint *leadingContent;
@property (nonatomic) NSLayoutConstraint *trailingContent;
@property (nonatomic, strong) UIView *messageContentView;
@end

@implementation ACMessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubviews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)createSubviews {
    _container = [UIView new];
    _container.layer.borderColor = RGB(228, 228, 228, 1).CGColor;
    [self.contentView addSubview:_container];
    
    _aliasLabel = [UILabel new];
    _aliasLabel.font = [UIFont italicSystemFontOfSize:12];
    _aliasLabel.textColor = [UIColor blackColor];
    _aliasLabel.adjustsFontSizeToFitWidth = YES;
    [_container addSubview:_aliasLabel];
    
    _messageLabel = [UILabel new];
    _messageLabel.numberOfLines=0;
    _messageLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f];
    _messageLabel.textColor = RGB(27, 27, 60, 1);
    _messageLabel.preferredMaxLayoutWidth = 220;
    
    _pictureView = [UIImageView new];
    _pictureView.contentMode = UIViewContentModeScaleAspectFit;
    
    _messageContentView = [UIView new];
    [_container addSubview:_messageContentView];
    
    _statusLabel = [UILabel new];
    _statusLabel.font = [UIFont systemFontOfSize:10];
    _statusLabel.textColor = [UIColor blackColor];
    [_container addSubview:_statusLabel];
    [self setContraints];
}

- (void)setContraints {

    _container.translatesAutoresizingMaskIntoConstraints = NO;
    [_container.widthAnchor constraintGreaterThanOrEqualToConstant:132].active = YES;
    _container.accessibilityIdentifier = @"Container";
    
    _aliasLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_aliasLabel.leadingAnchor constraintEqualToAnchor:self.container.leadingAnchor constant:xmargin].active = YES;
    [_aliasLabel.topAnchor constraintEqualToAnchor:self.container.topAnchor constant:ymargin].active = YES;
    [_aliasLabel.trailingAnchor constraintEqualToAnchor:self.container.trailingAnchor constant:-xmargin].active = YES;
    [_aliasLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    [_aliasLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_aliasLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    _messageContentView.translatesAutoresizingMaskIntoConstraints = NO;
    _messageContentView.accessibilityIdentifier = @"messageContentView";
    [_messageContentView.topAnchor constraintEqualToAnchor:_aliasLabel.bottomAnchor constant:4].active = YES;
    [_messageContentView.leadingAnchor constraintEqualToAnchor:_container.leadingAnchor constant:xmargin].active = YES;
    [_messageContentView.trailingAnchor constraintEqualToAnchor:_container.trailingAnchor constant:-xmargin].active = YES;
    
    [self setContentPriorities:_messageContentView];
    [self setContentPriorities:_messageLabel];
    [self setContentPriorities:_pictureView];
    
    [_pictureView.widthAnchor constraintLessThanOrEqualToConstant:128].active = YES;
    [_pictureView.heightAnchor constraintLessThanOrEqualToConstant:128].active = YES;
    
    _statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_statusLabel.leadingAnchor constraintEqualToAnchor:_container.leadingAnchor constant:xmargin].active = YES;
    [_statusLabel.trailingAnchor constraintEqualToAnchor:_container.trailingAnchor constant:-xmargin].active = YES;
    [_statusLabel.topAnchor constraintGreaterThanOrEqualToAnchor:_messageContentView.bottomAnchor constant:4].active = YES;
    [_statusLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    [_statusLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_statusLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    [_container.bottomAnchor constraintGreaterThanOrEqualToAnchor:_statusLabel.bottomAnchor constant:ymargin].active = YES;

   
    [self.contentView.topAnchor constraintEqualToAnchor:_container.topAnchor constant:-ymargin].active = YES;
    [self.contentView.bottomAnchor constraintEqualToAnchor:_container.bottomAnchor constant:ymargin].active = YES;
    _leadingContent = [self.contentView.leadingAnchor constraintEqualToAnchor:_container.leadingAnchor constant:-20];
    _trailingContent = [self.contentView.trailingAnchor constraintEqualToAnchor:_container.trailingAnchor constant:20];

}

- (void)setContentPriorities:(UIView*)view {
    [view setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [view setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [view setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [view setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)updateContentViewConstraints:(UIView*)view {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [view.topAnchor constraintEqualToAnchor:_messageContentView.topAnchor].active = YES;
    [view.leadingAnchor constraintEqualToAnchor:_messageContentView.leadingAnchor].active = YES;
    [view.trailingAnchor constraintEqualToAnchor:_messageContentView.trailingAnchor].active = YES;
    [view.bottomAnchor constraintEqualToAnchor:_messageContentView.bottomAnchor].active = YES;
}

- (void)updateConstraints {
    if (self.messageModel.isMine) {
        _leadingContent.active = NO;
        _trailingContent.active = YES;
    } else {
        _trailingContent.active = NO;
        _leadingContent.active = YES;
    }
    [super updateConstraints];
}

- (void)setMessageModel:(ACMessageModel *)messageModel {
    _messageModel = messageModel;
    
    self.aliasLabel.textAlignment = messageModel.isMine ? NSTextAlignmentRight : NSTextAlignmentLeft;
    self.aliasLabel.text = messageModel.senderModel.alias ?: @"Admin";
    self.messageLabel.textAlignment = _aliasLabel.textAlignment;
    self.statusLabel.textAlignment = _aliasLabel.textAlignment;
    
    static dispatch_once_t onceToken;
    static NSDateFormatter *dateFormatter = nil;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"dd.MM HH:mm:ss";
    });
    
    NSString *status = @[@"Sending ", @"Sent ", @"Failed "][messageModel.status];
    self.statusLabel.text = [status stringByAppendingString:[dateFormatter stringFromDate:messageModel.createdAt]];
    
    if ([messageModel isKindOfClass:[ACTextMessageModel class]]) {
        [self setTextContent:[(ACTextMessageModel*)messageModel text]];
    } else if([messageModel isKindOfClass:[ACImageMessageModel class]]) {
        [self setImageContent:[(ACImageMessageModel *)messageModel imageURL]];
    }
    
    _container.backgroundColor = messageModel.isMine ? RGB(233, 233, 243, 1) : [UIColor whiteColor];
    _container.layer.borderWidth = messageModel.isMine ? 0 : 1;
    
    [self setNeedsUpdateConstraints];
}

- (void)setTextContent:(NSString*)text {
    if (!self.messageLabel.superview) {
        [self.pictureView removeFromSuperview];
        [self.messageContentView addSubview:self.messageLabel];
        [self updateContentViewConstraints:self.messageLabel];
    }
    
    self.messageLabel.text = text;
}

- (void)setImageContent:(NSURL*)imageURL {
    if (!self.pictureView.superview) {
        [self.messageLabel removeFromSuperview];
        [self.messageContentView addSubview:self.pictureView];
        [self updateContentViewConstraints:self.pictureView];
    }
    
    //self.pictureView.image = [UIImage imageNamed:@"placeholder"];
    [self.pictureView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"placeholder"]];
}


@end
