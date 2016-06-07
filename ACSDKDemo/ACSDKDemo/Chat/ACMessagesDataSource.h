//
//  ACMessagesDataSource.h
//  ACSDKDemo
//
//  Created by Рамис Ямилов on 03.02.16.
//  Copyright © 2016 Magneta. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACRoomModel;

@interface ACMessagesDataSource : NSObject <UITableViewDataSource>

- (instancetype)initWithTableView:(UITableView*)tableView andRoom:(ACRoomModel*)roomModel;
- (id)objectAtIndexPath:(NSIndexPath*)indexPath;
- (void)removeObjectAtIndexPath:(NSIndexPath*)indexPath;

@end
