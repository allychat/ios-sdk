//
//  AllyChatUser.m
//  AChatDemo
//
//  Created by Alexandr Turyev on 17/07/15.
//  Copyright (c) 2015 Octoberry. All rights reserved.
//

#import "AllyChatUser.h"
#import "JSQMessagesCollectionViewFlowLayout.h"

@implementation AllyChatUser

-(void)setUserModel:(id)userModel
{
    if (_userModel != userModel) {
        _userModel = userModel;
        
        if (_userModel)
        {
            //Load Avatar Image
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_userModel valueForKey:@"avatarUrl"]]]];
            if (image) {
                JSQMessagesAvatarImage *wozImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:image diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
                self.avatarImage = wozImage;
            }
            
            //Load Sender Display Name
            if ([_userModel valueForKey:@"name"]) {
                self.senderDisplayName = [_userModel valueForKey:@"name"];
            }
            else if([_userModel valueForKey:@"alias"])
            {
                self.senderDisplayName = [_userModel valueForKey:@"alias"];
            }
            else if([_userModel valueForKey:@"login"])
            {
                self.senderDisplayName = [_userModel valueForKey:@"login"];
            }
            else
                self.senderDisplayName = @"";
        }
    }
}

@end
