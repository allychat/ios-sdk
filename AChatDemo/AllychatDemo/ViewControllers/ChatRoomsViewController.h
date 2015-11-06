//
//  ChatRoomsViewController.h
//  AChatDemo
//
//  Created by Alexandr Turyev on 15/07/15.
//  Copyright (c) 2015 Octoberry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatRoomsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
