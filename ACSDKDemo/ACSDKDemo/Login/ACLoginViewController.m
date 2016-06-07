//
//  ACLoginViewController.m
//  ACSDK
//
//  Created by Andrew Kopanev on 12/23/15.
//  Copyright © 2015 Magneta. All rights reserved.
//

#import "ACLoginViewController.h"
#import <ACSDK/ACSDK.h>

#import "ACRoomsViewController.h"

@interface ACLoginViewController () <UITextFieldDelegate>

@property (nonatomic, readonly) UILabel         *textLabel1;
@property (nonatomic, readonly) UILabel         *textLabel2;
@property (nonatomic, readonly) UILabel         *textLabel3;

@property (nonatomic, readonly) UITextField     *textField;
@property (nonatomic, readonly) UITextField     *urlField;
@property (nonatomic, readonly) UITextField     *appIdField;
@property (nonatomic, readonly) UIButton        *signInButton;
@property (nonatomic, readonly) UIActivityIndicatorView *activityIndicator;

@end

@implementation ACLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Sign In";
    //self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor colorWithRed:48/255.0 green:52/255.0 blue:81/255.0 alpha:1];
    
    _textField = [UITextField new];
    self.textField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.placeholder = @"alias";
    self.textField.delegate = self;
    self.textField.textColor = [UIColor whiteColor];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"alias"
                                                              attributes:@{ NSForegroundColorAttributeName: [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] }];
    self.textField.attributedPlaceholder = str;
    [self.view addSubview:self.textField];
    
    _urlField = [UITextField new];
    self.urlField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"server"];
    self.urlField.borderStyle = UITextBorderStyleNone;
    self.urlField.placeholder = @"Server URL";
    self.urlField.delegate = self;
    self.urlField.textColor = [UIColor whiteColor];
    self.urlField.keyboardType = UIKeyboardTypeURL;
    str = [[NSAttributedString alloc] initWithString:self.urlField.placeholder
                                          attributes:@{ NSForegroundColorAttributeName: [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] }];
    self.urlField.attributedPlaceholder = str;
    [self.view addSubview:self.urlField];
    
    _appIdField = [UITextField new];
    self.appIdField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"appId"] ?: @"app";
    self.appIdField.borderStyle = UITextBorderStyleNone;
    self.appIdField.placeholder = @"App ID";
    self.appIdField.delegate = self;
    self.appIdField.textColor = [UIColor whiteColor];
    self.appIdField.keyboardType = UIKeyboardTypeURL;
    str = [[NSAttributedString alloc] initWithString:self.appIdField.placeholder
                                          attributes:@{ NSForegroundColorAttributeName: [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] }];
    self.appIdField.attributedPlaceholder = str;
    [self.view addSubview:self.appIdField];
    
    _textLabel1 = [UILabel new];
    self.textLabel1.text = @"App Id";
    self.textLabel1.textColor = [UIColor colorWithWhite:1 alpha:0.9];
    self.textLabel1.font = [UIFont systemFontOfSize:12.0];
    [self.view addSubview:self.textLabel1];
    
    _textLabel2 = [UILabel new];
    self.textLabel2.text = @"Server URL";
    self.textLabel2.textColor = [UIColor colorWithWhite:1 alpha:0.9];
    self.textLabel2.font = [UIFont systemFontOfSize:12.0];
    [self.view addSubview:self.textLabel2];
    
    _textLabel3 = [UILabel new];
    self.textLabel3.text = @"Alias";
    self.textLabel3.textColor = [UIColor colorWithWhite:1 alpha:0.9];
    self.textLabel3.font = [UIFont systemFontOfSize:12.0];
    [self.view addSubview:self.textLabel3];
    
    
    _signInButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.signInButton addTarget:self action:@selector(signInAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.signInButton setTitle:@"Sign In" forState:UIControlStateNormal];
    [self.signInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.signInButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateDisabled];
    self.signInButton.layer.borderWidth = 1;
    self.signInButton.layer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.15].CGColor;
    self.signInButton.layer.cornerRadius = 16;
    [self.view addSubview:self.signInButton];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:self.activityIndicator];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat hmargin = 20.0;
    CGFloat h = 32.0;
    CGFloat labelHeight = self.textLabel1.font.lineHeight;
    
    self.activityIndicator.frame = CGRectMake(hmargin, 33, self.view.bounds.size.width - hmargin * 2.0, h);
    
    self.textLabel1.frame = CGRectMake(hmargin, 70, self.view.bounds.size.width - hmargin * 2.0, labelHeight);
    self.appIdField.frame = CGRectMake(hmargin, CGRectGetMaxY(self.textLabel1.frame) + 2, self.view.bounds.size.width - hmargin * 2.0, h);
    
    self.textLabel2.frame = CGRectMake(hmargin, CGRectGetMaxY(self.appIdField.frame) + 8, self.view.bounds.size.width - hmargin * 2.0, labelHeight);
    self.urlField.frame = CGRectMake(hmargin, CGRectGetMaxY(self.textLabel2.frame) + 2, self.view.bounds.size.width - hmargin * 2.0, h);
    
    self.textLabel3.frame = CGRectMake(hmargin, CGRectGetMaxY(self.urlField.frame) + 8, self.view.bounds.size.width - hmargin * 2.0, labelHeight);
    self.textField.frame = CGRectMake(hmargin, CGRectGetMaxY(self.textLabel3.frame) + 2, self.view.bounds.size.width - hmargin * 2.0, h);
    
    self.signInButton.frame = CGRectMake(hmargin, CGRectGetMaxY(self.textField.frame) + 10.0, self.view.bounds.size.width - hmargin * 2.0, h);
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textField becomeFirstResponder];
}

#pragma mark - error display

- (void) showErrorAlertWithMessage:(NSString*)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - actions

- (void)signInAction:(id)sender {
    if (self.textField.text.length && self.urlField.text.length && self.appIdField.text.length) {
        self.signInButton.enabled = NO;
        
        [self.textField resignFirstResponder];
        [self.activityIndicator startAnimating];
        
        NSString *serverURL = [@"https://" stringByAppendingString:self.urlField.text];
        [[ACSDK defaultInstance] setApplicationId:self.appIdField.text serverURL:[NSURL URLWithString:serverURL]];
        
        [[ACSDK defaultInstance] signIn:[ACUserModel userWithAlias:self.textField.text] completion:^(ACUserModel *userModel, NSError *error) {
            [self.activityIndicator stopAnimating];
            self.signInButton.enabled = YES;
            
            if (!error) {
                [[NSUserDefaults standardUserDefaults] setValue:self.textField.text forKey:@"alias"];
                [[NSUserDefaults standardUserDefaults] setValue:self.urlField.text forKey:@"server"];
                [[NSUserDefaults standardUserDefaults] setValue:self.appIdField.text forKey:@"appId"];
                
                UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil];
                [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
                [[UIApplication sharedApplication] registerForRemoteNotifications];
                
                [self.navigationController pushViewController:[ACRoomsViewController new] animated:YES];
            } else {
                [self showErrorAlertWithMessage:error.localizedDescription];
            }
        }];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.appIdField) {
        [self.urlField becomeFirstResponder];
    } else if (textField == self.urlField) {
        [self.textField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

@end
