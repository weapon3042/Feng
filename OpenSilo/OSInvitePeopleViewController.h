//
//  OSInvitePeopleViewController.h
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/31/14.
//  Copyright (c) 2014 OpenSilo Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OSInvitePeopleViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) NSMutableArray *peopleArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
