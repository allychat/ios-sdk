//
//  ACAddRoomViewController.m
//  ACSDK
//
//  Created by Рамис Ямилов on 25.01.16.
//  Copyright © 2016 Magneta. All rights reserved.
//

#import "ACCreateRoomViewController.h"
#import <ACSDK/ACSDK.h>

@interface ACCreateRoomViewController ()

@property (nonatomic, strong) UITextField   *textField;
@property (nonatomic, strong) UIButton      *createButton;
@property (nonatomic, strong) UIButton      *cancelButton;

@end

@implementation ACCreateRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"New room";
    self.view.backgroundColor = [UIColor colorWithRed:48/255.0 green:52/255.0 blue:81/255.0 alpha:1];
    
    self.textField = [UITextField new];
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.placeholder = @"alias";
    self.textField.textColor = [UIColor whiteColor];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"alias"
                                                              attributes:@{ NSForegroundColorAttributeName: [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] }];
    self.textField.attributedPlaceholder = str;
    [self.view addSubview:self.textField];
    
    self.createButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.createButton addTarget:self action:@selector(createRoomAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.createButton setTitle:@"CREATE" forState:UIControlStateNormal];
    [self.createButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.createButton.layer.borderWidth = 1;
    self.createButton.layer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.15].CGColor;
    self.createButton.layer.cornerRadius = 16;
    [self.view addSubview:self.createButton];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton setTitle:@"CANCEL" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.cancelButton.layer.borderWidth = 1;
    self.cancelButton.layer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.15].CGColor;
    self.cancelButton.layer.cornerRadius = 16;
    [self.view addSubview:self.cancelButton];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat hmargin = 20.0;
    CGFloat h = 32.0;
    
    self.textField.frame = CGRectMake(hmargin, ceil(self.view.bounds.size.height * 0.33), self.view.bounds.size.width - hmargin * 2.0, h);
    self.createButton.frame = CGRectMake(hmargin, CGRectGetMaxY(self.textField.frame) + 10.0, self.view.bounds.size.width - hmargin * 2.0, h);
    
    self.cancelButton.frame = CGRectMake(hmargin, CGRectGetMaxY(self.createButton.frame) + 10.0, self.view.bounds.size.width - hmargin * 2.0, h);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)createRoomAction:(UIButton*)sender {
    [self.textField resignFirstResponder];
    sender.enabled = NO;
    
    [[ACSDK defaultInstance] createRoomWithUser:[ACUserModel userWithAlias:self.textField.text] completion:^(ACRoomModel *roomModel, NSError *error) {
        if(error) {
            [self showErrorAlertWithMessage:error.localizedDescription];
            sender.enabled = YES;
        } else {
            [self.delegate didCreateRoom:roomModel];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
