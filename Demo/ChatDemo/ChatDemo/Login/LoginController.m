//
//  LoginController.m
//  ChatDemo
//
//  Created by Alex on 6/22/15.
//  Copyright (c) 2015 octoberry. All rights reserved.
//

#import "LoginController.h"
#import "RoomsController.h"

@interface LoginController()
@property (nonatomic, weak) IBOutlet UITextField *loginField;
@end

@implementation LoginController
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return self.loginField.text.length > 0;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    RoomsController *controller = segue.destinationViewController;
    controller.alias = self.loginField.text;
}
@end
