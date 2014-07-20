//
//  OSRightPanelViewController.h
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/9/14.
//  Copyright (c) 2014 OpenSilo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OSRightPanelViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

@property (nonatomic, strong) NSMutableArray *peopleArray;
@property (weak, nonatomic) IBOutlet UITextField *invitePeopleText;
@property (nonatomic, strong) NSMutableArray *fileArray;
@property (weak, nonatomic) IBOutlet UIButton *uploadFileButton;
@property (nonatomic, strong) NSMutableArray *pinArray;
@property (weak, nonatomic) IBOutlet UITextField *pinQuestionsText;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *selectedArray;

@end
