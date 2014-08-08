//
//  OSCreateChannelViewController.h
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/31/14.
//  Copyright (c) 2014 OpenSilo Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSInviteViewController.h"
#import "ECSlidingViewController.h"
#import "UIViewController+ECSlidingViewController.h"


@interface OSCreateChannelViewController : UIViewController <ECSlidingViewControllerDelegate>

+ (OSCreateChannelViewController *)getInstance;

/*
** @return List of invited persons
*/

@property (nonatomic, strong) NSDictionary *invitedUsers;


/*
** @return The name of the channel
*/

@property (weak, nonatomic) IBOutlet UITextField *channelName;

/*
** @return The description of the channel
*/

@property (weak, nonatomic) IBOutlet UITextField *channelDescription;

/*
** @return The privacy switch for channel
*/

@property (weak, nonatomic) IBOutlet UISwitch *privacySwitch;

/*
** @return The table view for invited users
*/

@property (weak, nonatomic) IBOutlet UITableView *invitedUsersTable;

/*
** @return Action which triggers the invite view
*/

- (IBAction)inviteMembers:(id)sender;


/*
** @return Actions which creates a channel with API request
*/

- (IBAction)createChannel:(id)sender;

@end
