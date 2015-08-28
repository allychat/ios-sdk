//
//  ChatRoomsViewController.m
//  AChatDemo
//
//  Created by Alexandr Turyev on 15/07/15.
//  Copyright (c) 2015 Octoberry. All rights reserved.
//

#import "ChatRoomsViewController.h"
#import "MessagesViewController.h"
#import "SharedEngine.h"
#import "ACRoomTableViewCell.h"


@interface ChatRoomsViewController ()
@property (nonatomic, strong) NSArray *rooms;

@end

@implementation ChatRoomsViewController

- (void)reloadRooms {
    
    __block UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.center = self.view.center;
    [self.view addSubview:indicatorView];
    [indicatorView startAnimating];
    
    
    [[SharedEngine shared].engine roomsWithCompletion:^(NSArray *rooms, NSError *error) {
        
        [indicatorView stopAnimating];
        [indicatorView removeFromSuperview];
        
        self.rooms = rooms;
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
            [alertView show];
        }
        else
        {
            [self.tableView reloadData];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //#warning Please input APPLICATION ID and NAME you would like to use
    [SharedEngine shared].engine = [[ACEngine alloc] initWithURL:[NSURL URLWithString:@"https://my-dev.allychat.ru"] alias:self.alias name:@"MY_DEV_TEST_USER" andApplicationId:@"APPLICATION_ID"];
    /*
     Make your app register for remote notifications
     */
    [self registerForPushNotifications];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self reloadRooms];
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
        ACRoomModel *room = self.rooms[indexPath.row];
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
        [[SharedEngine shared].engine userWithAlias:opponentAlias.text completion:^(NSError *error, ACUserModel *user) {
            if (user && error==nil) {
                NSLog(@"Opponent userId: %@\n", user.senderIdentifier);
                
                //Now we have userId and can create a chat(room) with this user
                [[SharedEngine shared].engine createRoomWithOpponent:user.senderIdentifier completion:^(NSError *error, ACRoomModel *room) {
                    if (room && error == nil) {
                        NSLog(@"RoomId: %@\n", room.roomID);
                        
                        self.rooms = [[SharedEngine shared].engine rooms];
                        [self.tableView reloadData];
                    }
                }];
            }
        }];
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *inputText = [[alertView textFieldAtIndex:0] text];
    return [inputText length] > 0;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MessagesViewController *controller = segue.destinationViewController;
    ACRoomTableViewCell *cell = (ACRoomTableViewCell *)sender;
    controller.room = cell.room;
    controller.title = cell.title.text;
}

#pragma mark - Push Notifications

-(void)registerForPushNotifications
{
    UIApplication *sharedApp = [UIApplication sharedApplication];
    if ([sharedApp respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert) categories:nil];
        [sharedApp registerUserNotificationSettings: settings];
    }
    else
    {
        [sharedApp registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
}




@end
