//
//  ChatRoomsViewController.m
//  AChatDemo
//
//  Created by Alexandr Turyev on 15/07/15.
//  Copyright (c) 2015 Octoberry. All rights reserved.
//

#import "ChatRoomsViewController.h"
#import "MessagesViewController.h"
#import "ACRoomTableViewCell.h"


@interface ChatRoomsViewController ()
{
    BOOL _didFinishExecutingBlock;
}

@property (nonatomic, strong) NSMutableArray *rooms;

@end

@implementation ChatRoomsViewController

- (void)reloadRooms {
    
    __block UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.center = self.view.center;
    [self.view addSubview:indicatorView];
    [indicatorView startAnimating];
    
    [AllychatSDK rooms:^(NSArray *rooms) {
        
        [indicatorView stopAnimating];
        [indicatorView removeFromSuperview];
        
        self.rooms = [NSMutableArray arrayWithArray:rooms];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alertView show];
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)viewDidAppear:(BOOL)animated
{
    [self reloadRooms];
    _didFinishExecutingBlock = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addChatRoom:(UIBarButtonItem *)sender {
    
    UIAlertView *newChatForm = [[UIAlertView alloc] initWithTitle:@"Chat with:" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
    newChatForm.alertViewStyle = UIAlertViewStylePlainTextInput;
    [newChatForm show];
}

#pragma mark - UITableView Delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rooms.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ACRoomTableViewCell *cell = (ACRoomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Room" forIndexPath:indexPath];
    if (cell)
    {
        ACRoom *room = self.rooms[indexPath.row];
        cell.room = room;
    }
    return cell;
}


#pragma mark UIAlertView Delegate Methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Continue"])
    {
        //Get the alias of user from input
        UITextField *opponentAlias = [alertView textFieldAtIndex:0];
        NSLog(@"Opponent alias: %@\n", opponentAlias.text);
        
        //Try to get data about the user from this alias
        [AllychatSDK getUserWithAlias:opponentAlias.text success:^(ACUser *user) {
            if (user) {
                [AllychatSDK createRoomWithUserId:user.internalBaseClassIdentifier success:^(ACRoom *newRoom) {
                    [self.rooms addObject:newRoom];
                    [self.tableView reloadData];
                } failure:nil];
            }            
        } failure:nil];
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *inputText = [[alertView textFieldAtIndex:0] text];
    return [inputText length] > 0;
}


#pragma mark - Navigation

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (!_didFinishExecutingBlock) {
        [AllychatSDK connectToChat:^(BOOL isComplete) {
            _didFinishExecutingBlock = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"segueToMessages" sender:sender];
            });
        } failure:nil];
        return NO;
    }
    else
    {
        return YES;
    }
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MessagesViewController *controller = segue.destinationViewController;
    ACRoomTableViewCell *cell = (ACRoomTableViewCell *)sender;
    controller.room = cell.room;
    controller.title = cell.title.text;
}


@end
