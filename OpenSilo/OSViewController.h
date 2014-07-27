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

@interface OSViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

/*
** @return Firebase API object that will handle data requests
*/

@property (nonatomic, strong) Firebase *firebase;


/*
** @return Array that will hold chat thread
*/

@property (nonatomic, strong) NSMutableArray *channelThread;


/*
** @return Table View resonpsible for displaying chat data
*/

@property (nonatomic, weak) IBOutlet UITableView *tableView;

/*
** @return The currently viewed channel
*/

@property (nonatomic, weak) OSChannel *currentChannel;

/*
** @return Chat Input for user
*/

@property (weak, nonatomic) IBOutlet UITextField *messageInput;


@end
