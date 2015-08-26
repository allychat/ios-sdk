//
//  AllyChatMessage.m
//  AChatDemo
//
//  Created by Alexandr Turyev on 17/07/15.
//  Copyright (c) 2015 Octoberry. All rights reserved.
//

#import "AllyChatMessage.h"
#import <AChat/AChat.h>


@implementation AllyChatMessage

+(NSString *)getStatusText:(MessageStatus)status
{
    switch (status) {
        case STATUS_NEW:
            return @"New";
        case STATUS_SENDING:
            return @"Sending...";
        case STATUS_SENT:
            return @"Delivered";
        case STATUS_FAILED:
            return @"Failed!";
        case STATUS_RESENDING:
            return @"Resending...";
        default:
            return @"...";
    }
}

@end
