//
//  ACRoomsViewController.m
//  ACSDK
//
//  Created by Andrew Kopanev on 12/23/15.
//  Copyright © 2015 Magneta. All rights reserved.
//

#import "ACRoomsViewController.h"
#import "ACChatViewController.h"
#import "ACCreateRoomViewController.h"
#import "ACTableViewRoomCell.h"
#import <ACSDK/ACSDK.h>

@interface ACRoomsViewController () <UITableViewDataSource, UITableViewDelegate, ACCreateRoomViewControllerDelegate>

@property (nonatomic, readonly) UITableView     *tableView;
@property (nonatomic, strong) NSArray           *rooms;
@property (nonatomic, strong) UIButton *addRoomButton;
@end

@implementation ACRoomsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"CHAT";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateRoomsNotification:) name:ACSDKDidUpdateRoomsNotification object:nil];
    
    _tableView = [UITableView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ACTableViewRoomCell class] forCellReuseIdentifier:@"ACRoomCell"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tableView];
    
    
    _addRoomButton = [UIButton new];
    [_addRoomButton setTitle:@"＋" forState:UIControlStateNormal];
    [_addRoomButton setBackgroundColor:[UIColor colorWithRed:142./255. green:136./255. blue:250/255. alpha:1]];
    [_addRoomButton setClipsToBounds:YES];
    
    [_addRoomButton addTarget:self action:@selector(addRoomAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addRoomButton];
    self.rooms = [ACSDK defaultInstance].rooms;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
    
    CGFloat buttonSide = 50;
    _addRoomButton.layer.cornerRadius = buttonSide/2.f;
    _addRoomButton.frame = CGRectMake(self.view.frame.size.width-buttonSide-buttonSide/2, self.view.frame.size.height-buttonSide-buttonSide/2, buttonSide, buttonSide);
}

- (void)addRoomAction:(id)sender {
    ACCreateRoomViewController *vc = [ACCreateRoomViewController new];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - ACCreateRoomViewControllerDelegate

- (void)didCreateRoom:(ACRoomModel *)roomModel {
    [self.navigationController pushViewController:[[ACChatViewController alloc] initWithRoom:roomModel] animated:YES];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rooms.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ACTableViewRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ACRoomCell"];
    if (!cell) {
        cell = [[ACTableViewRoomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ACRoomCell"];
    }
    ACRoomModel *roomModel = self.rooms[indexPath.row];
    [cell setupWithModel:roomModel];
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BOOL hasUnread = ([(ACRoomModel*)self.rooms[indexPath.row] hasUnreadMessages]);
    
    UIColor *unreadColor = [UIColor colorWithRed:246./255. green:245./255. blue:250/255. alpha:1.];
    UIColor *backgroundColor = hasUnread ? unreadColor : [UIColor whiteColor];
    [cell setBackgroundColor:backgroundColor];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ACRoomModel *roomModel = self.rooms[indexPath.row];
    [self.navigationController pushViewController:[[ACChatViewController alloc] initWithRoom:roomModel] animated:YES];
    
}

#pragma mark - notifications

- (void)didUpdateRoomsNotification:(NSNotification *)notification {
    self.rooms = notification.userInfo[ACRoomsKey];
    [self.tableView reloadData];
}

@end
