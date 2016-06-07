//
//  ACChatViewController.m
//  ACSDK
//
//  Created by Andrew Kopanev on 12/23/15.
//  Copyright © 2015 Magneta. All rights reserved.
//

#import "ACChatViewController.h"
#import <ACSDK/ACSDK.h>

#import "ACMessagesDataSource.h"
#import "ACMessageTableViewCell.h"
#import "PHFComposeBarView+CustomizableProperties.h"


const CGFloat controlsHeight = 44.0;
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]




@interface ACChatViewController () <UITextFieldDelegate, UITableViewDelegate, PHFComposeBarViewDelegate,
                                    UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, readonly) ACRoomModel             *roomModel;
@property (nonatomic, readonly) ACMessagesDataSource    *dataSource;

@property (nonatomic, readonly) UITableView             *tableView;
@property (nonatomic, readonly) PHFComposeBarView       *composeBarView;

@property (nonatomic, assign) CGFloat   keyboardHeight;
@end

@implementation ACChatViewController


#pragma mark -

- (instancetype)initWithRoom:(ACRoomModel *)roomModel {
    if (self = [super init]) {
        _roomModel = roomModel;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppearNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappearNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    self.title = self.roomModel.roomId;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [UITableView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    [self.tableView registerClass:[ACMessageTableViewCell class] forCellReuseIdentifier:@"ACMessageTableViewCell"];
    [self.view addSubview:self.tableView];
    
    _composeBarView = [[PHFComposeBarView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - controlsHeight,
                                                                          CGRectGetWidth(self.view.bounds), controlsHeight)];
    _composeBarView.placeholder = @"Message...";
    _composeBarView.utilityButtonImage = [[UIImage imageNamed:@"camera"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _composeBarView.delegate = self;
    _composeBarView.buttonTintColor = RGB(56, 57, 87);
    _composeBarView.utilityButton.tintColor = RGB(150, 147, 159);
    _composeBarView.backgroundView.backgroundColor = RGB(204, 204, 214);
    _composeBarView.textContainer.backgroundColor = [UIColor whiteColor];
    [_composeBarView.button setTitleColor:_composeBarView.utilityButton.tintColor forState:UIControlStateDisabled];
    [self.view addSubview:self.composeBarView];
    
    _dataSource = [[ACMessagesDataSource alloc] initWithTableView:self.tableView andRoom:self.roomModel];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self updateViewFrame];
}

- (void)updateViewFrame {
    self.composeBarView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - controlsHeight - self.keyboardHeight,
                                           CGRectGetWidth(self.view.bounds), controlsHeight);
    
    CGFloat tableViewHeight = CGRectGetMinY(self.composeBarView.frame);
    self.tableView.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, tableViewHeight);
}

#pragma mark - PHFComposeBarViewDelegate

- (void)composeBarViewDidPressButton:(PHFComposeBarView *)composeBarView {
    ACTextMessageModel *messageModel = [ACTextMessageModel messageWithText:composeBarView.text room:self.roomModel];
    [[ACSDK defaultInstance] sendMessage:messageModel];
    composeBarView.text = nil;
}

- (void)composeBarViewDidPressUtilityButton:(PHFComposeBarView *)composeBarView {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)composeBarView:(PHFComposeBarView *)composeBarView didChangeFromFrame:(CGRect)startFrame toFrame:(CGRect)endFrame {
    CGFloat tableViewHeight = CGRectGetMinY(self.composeBarView.frame);
    self.tableView.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, tableViewHeight);
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    ACImageMessageModel *messageModel = [ACImageMessageModel messageWithImage:chosenImage room:self.roomModel];
    
    [[ACSDK defaultInstance] sendMessage:messageModel];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    /* animation shouldn't be displayed at cell reload
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    cell.contentView.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.contentView.layer.shadowOffset = CGSizeMake(10, 10);
    cell.contentView.alpha = 0;
    
    cell.contentView.layer.transform = rotation;
    cell.contentView.layer.anchorPoint = CGPointMake(0, 0.5);

    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.5];
    cell.contentView.layer.transform = CATransform3DIdentity;
    cell.contentView.alpha = 1;
    cell.contentView.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
    */
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static dispatch_once_t onceToken;
    static ACMessageTableViewCell *cell = nil;
    dispatch_once(&onceToken, ^{
        cell = [[ACMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    });
    cell.messageModel = [self.dataSource objectAtIndexPath:indexPath];
    CGSize fittingSize = UILayoutFittingCompressedSize;
    fittingSize.width = tableView.frame.size.width;
    return [cell.contentView systemLayoutSizeFittingSize:fittingSize withHorizontalFittingPriority:UILayoutPriorityRequired verticalFittingPriority:UILayoutPriorityDefaultLow].height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ACMessageModel *message = [self.dataSource objectAtIndexPath:indexPath];
    [self.view endEditing:YES];
    if (message.status == ACMessageStatusFailed) {
        [self.dataSource removeObjectAtIndexPath:indexPath];
        [[ACSDK defaultInstance] resendMessage:message];
    }
}

#pragma mark - notifications

#pragma mark * keyboard

- (void)keyboardWillAppearNotification:(NSNotification *)notification {
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardHeight = keyboardFrame.size.height;
    [self updateViewFrame];
}

- (void)keyboardWillDisappearNotification:(NSNotification *)notification {
    self.keyboardHeight = 0.0;
    [self updateViewFrame];
}

@end
