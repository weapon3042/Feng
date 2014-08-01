//
//  OSViewController.h
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/8/14.
//  Copyright (c) 2014 OpenSilo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSChannel.h"
#import <Firebase/Firebase.h>
#import "ECSlidingViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "OSSearchViewController.h"
#import "OSAskQuestionViewController.h"
#import "OSCreateChannelViewController.h"
#import "OSInvitePeopleViewController.h"

@interface OSViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ECSlidingViewControllerDelegate>

/*
** @return Firebase API object that will handle data requests
*/

@property (nonatomic, strong) Firebase *firebase;

@property (nonatomic, strong) OSSearchViewController * searchViewController;
@property (nonatomic, strong) OSAskQuestionViewController * askQuestioinViewController;
@property (nonatomic, strong) OSCreateChannelViewController * createChannelViewController;
@property (nonatomic, strong) OSInvitePeopleViewController * invitePeopleViewController;

/*
** @return Array that will hold chat thread
*/

@property (nonatomic, strong) NSMutableArray *array;


/*
** @return Table View resonpsible for displaying chat data
*/

@property (weak, nonatomic) IBOutlet UIView *tableViewContainer;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *roomView;
@property (weak, nonatomic) IBOutlet UILabel *roomTitle;
@property (weak, nonatomic) IBOutlet UILabel *roomDescription;
@property (weak, nonatomic) IBOutlet UILabel *roomSnippet;

/*
** @return Chat Input for user
*/

@property (weak, nonatomic) IBOutlet UITextField *messageInput;


@end
