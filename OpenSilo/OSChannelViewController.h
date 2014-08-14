//
//  OSChannelViewController.h
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev  on 8/2/14.
//  Copyright (c) 2014 OpenSilo Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
#import "ECSlidingViewController.h"
#import "UIViewController+ECSlidingViewController.h"

@interface OSChannelViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,ECSlidingViewControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) Firebase *firebase;

@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextField *messageInput;

@end
