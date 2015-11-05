//
//  LoginViewController.m
//  AChatDemo
//
//  Created by Alexandr Turyev on 15/07/15.
//  Copyright (c) 2015 Octoberry. All rights reserved.
//

#import "LoginViewController.h"
#import "ChatRoomsViewController.h"

@interface LoginViewController ()
{
    BOOL _didFinishExecutingBlock;
}
@property (weak, nonatomic) IBOutlet UITextField *loginField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [AllychatSDK signOff];
    _didFinishExecutingBlock = NO;
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Navigation

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if (self.loginField.text.length > 0) {
        if (!_didFinishExecutingBlock) {
            
            [AllychatSDK instance].userIdentity = [[ACUser alloc] initWithAlias:self.loginField.text];
            [AllychatSDK registerUserIdentity:^(ACUser *userModel) {
                if (userModel) {
                    _didFinishExecutingBlock = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self performSegueWithIdentifier:identifier sender:sender];
                    });
                }
            } failure:nil];
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return NO;
}


@end
