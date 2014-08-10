//
//  OSInviteViewController.h
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/31/14.
//  Copyright (c) 2014 OpenSilo Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OSInviteViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate>

/*
** UI Elements
*/

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)sendInvites:(id)sender;

/*
** Data Sets
*/

@property (nonatomic, strong) NSMutableArray *filteredArray;
@property (nonatomic, strong) NSMutableArray *peopleArray;
@property (nonatomic, strong) NSMutableArray *tableArray;

@property (nonatomic, strong) NSMutableArray *selectedArray;

@end
