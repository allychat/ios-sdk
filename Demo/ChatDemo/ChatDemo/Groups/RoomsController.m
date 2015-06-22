//
//  RoomsController.m
//  ChatDemo
//
//  Created by Alex on 6/22/15.
//  Copyright (c) 2015 octoberry. All rights reserved.
//

#import "RoomsController.h"
#import "SharedData.h"
#import "MBProgressHUD.h"
#import "RMUniversalAlert.h"
#import "MessagesViewController.h"

@interface RoomsController()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *rooms;
@end

@implementation RoomsController

- (void)setAlias:(NSString *)alias {
    if (_alias != alias) {
        _alias = alias;
        [SharedData sharedData].engine = [[ACEngine alloc] initWithURL:[NSURL URLWithString:@"https://sense-dev.achat.octoberry.net/"] alias:alias];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[SharedData sharedData].engine roomsWithCompletion:^(NSArray *rooms, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            self.rooms = rooms;
            if (error) {
                [RMUniversalAlert showAlertInViewController:self withTitle:@"Error" message:error.localizedDescription cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:nil];
            } else {
                [self.tableView reloadData];
            }
        }];
    }
}

#pragma mark - TAbleView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rooms.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Room" forIndexPath:indexPath];
    cell.textLabel.text = [self.rooms[indexPath.row] roomID];
    cell.detailTextLabel.text = [self.rooms[indexPath.row] isSupportRoom]?@"support":@"";
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    MessagesViewController *controller = segue.destinationViewController;
    controller.room = self.rooms[indexPath.row];
}
@end
