//
//  OSRoomViewController.h
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev  on 8/2/14.
//  Copyright (c) 2014 OpenSilo Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
#import "ECSlidingViewController.h"
#import "UIViewController+ECSlidingViewController.h"

@interface OSRoomViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,ECSlidingViewControllerDelegate>

@property (nonatomic, strong) Firebase *firebase;
@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *messageInput;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (weak, nonatomic) IBOutlet UILabel *roomTitle;
@property (weak, nonatomic) IBOutlet UILabel *roomDescription;
@property (weak, nonatomic) IBOutlet UILabel *roomSnippet;

@end
