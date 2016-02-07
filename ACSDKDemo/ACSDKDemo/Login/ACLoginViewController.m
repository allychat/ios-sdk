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

@property (nonatomic, readonly) UITextField     *textField;
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
    
    self.textField.frame = CGRectMake(hmargin, ceil(self.view.bounds.size.height * 0.33), self.view.bounds.size.width - hmargin * 2.0, h);
    self.signInButton.frame = CGRectMake(hmargin, CGRectGetMaxY(self.textField.frame) + 10.0, self.view.bounds.size.width - hmargin * 2.0, h);
    
    self.activityIndicator.frame = CGRectMake(hmargin, self.view.bounds.size.height * 0.18, self.view.bounds.size.width - hmargin * 2.0, h);
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
    if (self.textField.text.length) {
        self.signInButton.enabled = NO;
        
        [self.textField resignFirstResponder];
        [self.activityIndicator startAnimating];
        
        [[ACSDK defaultInstance] signIn:[ACUserModel userWithAlias:self.textField.text] completion:^(ACUserModel *userModel, NSError *error) {
            [self.activityIndicator stopAnimating];
            self.signInButton.enabled = YES;
            
            if (!error) {
                [[NSUserDefaults standardUserDefaults] setValue:self.textField.text forKey:@"alias"];
                
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
    [textField resignFirstResponder];
    return YES;
}

@end
