//
//  OSLeftPanelViewController.h
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/9/14.
//  Copyright (c) 2014 OpenSilo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "UIViewController+ECSlidingViewController.h"

@interface OSLeftPanelViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ECSlidingViewControllerDelegate>{
    int selectedIndex;
}

/*
** @return The table view displaying each individual data set
*/

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/*
** @return Segmented Control that switches in between the three data sets
*/


/*
** Array sets for data objects
*/

@property (nonatomic, strong) NSMutableIndexSet *expandedSections;
@property (nonatomic, strong) NSMutableArray *channels;
@property (nonatomic, strong) NSMutableArray *rooms;
@property (nonatomic, strong) NSMutableArray *favorites;
@property (nonatomic, strong) NSMutableArray *inbox;


/*
** @return The user name label
*/

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *jobTitle;
/*
** @return The user profile imageView
*/
@property (weak, nonatomic) IBOutlet UIImageView *status;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

/**/

@property (nonatomic, strong) NSArray *list;

@end

