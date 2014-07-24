//
//  OSLeftPanelViewController.h
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/9/14.
//  Copyright (c) 2014 OpenSilo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OSLeftPanelViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


/*
** @return The table view displaying each individual data set
*/

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/*
** @return Segmented Control that switches in between the three data sets
*/

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

/*
** Array sets for data objects
*/

@property (nonatomic, strong) NSMutableArray *channels;
@property (nonatomic, strong) NSMutableArray *rooms;
@property (nonatomic, strong) NSMutableArray *favorites;

/*
** @return The current data set the viewer is using
*/

@property (nonatomic, strong) NSMutableArray *selectedArray;

@end

