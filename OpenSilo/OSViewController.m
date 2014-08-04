
//
//  OSViewController.m
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/8/14.
//  Copyright (c) 2014 OpenSilo Inc. All rights reserved.
//

#import "OSViewController.h"
#import "OSUIMacro.h"
#import "UIImageView+AFNetworking.h"
#import "OSSession.h"
#import "OSConstant.h"
#import "OSTranscriptTableViewCell.h"
#import "OSDateTimeUtils.h"
#import "OSWebServiceMacro.h"
#import "OSGetRequest.h"
#import "OSSession.h"
#import "OSUIMacro.h"
#import "METransitions.h"
#import "OSUserUtils.h"
#import "OSSession.h"

static NSString * const transcriptCellIdentifier = @"OSTranscriptTableViewCell";

@interface OSViewController()
@property (nonatomic, strong) METransitions *transitions;

@end

@implementation OSViewController

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateCenterViewController:) name:kUpdateCenterViewNotification object:nil];
     
  
    [self configureSlidingMenu];

    //customize the navigation bar
    UIView *navView=[[UIView alloc] initWithFrame:CGRectMake(0, 0,320, 44)];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"nav-left"] forState:UIControlStateNormal];
    [leftBtn setFrame:CGRectMake(10,7,30,30)];
    [leftBtn addTarget:self action:@selector(anchorRight) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleBtn setFrame:CGRectMake(50,7,80,30)];
#warning title should be dynamic
    [titleBtn setTitle:@"Welcome" forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(onClickDropDown) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *dropBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dropBtn setImage:[UIImage imageNamed:@"nav-drop"] forState:UIControlStateNormal];
    [dropBtn setFrame:CGRectMake(140,10,20,30)];
    [dropBtn addTarget:self action:@selector(anchorRight) forControlEvents:UIControlEventTouchUpInside];

    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:[UIImage imageNamed:@"nav-search"] forState:UIControlStateNormal];
    [searchBtn setFrame:CGRectMake(240,7,30,30)];
    [searchBtn addTarget:self action:@selector(onClickSearch) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"nav-right"] forState:UIControlStateNormal];
    [rightBtn setFrame:CGRectMake(280,7,30,30)];
    [rightBtn addTarget:self action:@selector(anchorLeft) forControlEvents:UIControlEventTouchUpInside];
    
    [navView addSubview:leftBtn];
    [navView addSubview:titleBtn];
    [navView addSubview:dropBtn];
    [navView addSubview:searchBtn];
    [navView addSubview:rightBtn];
    
    SET_NAVIGATION_BAR_BG_COLOR(navView);
    
    [self.navigationController.navigationBar addSubview:navView];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;

    /*
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self registerCustomCellsFromNibs];
    
     */
    
    
    UIStoryboard *channelStoryboard = [UIStoryboard storyboardWithName:kChannelTab bundle:[NSBundle mainBundle]];
    self.channelViewController = (OSChannelViewController *)[channelStoryboard instantiateInitialViewController];
    [self addChildViewController: self.channelViewController];
    [self.view addSubview:self.channelViewController.view];
    self.channelViewController.view.autoresizesSubviews = YES;
}

#pragma mark - ECSlidingViewController Delegate
-(void)anchorRight
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

-(void)anchorLeft
{
    [self.slidingViewController anchorTopViewToLeftAnimated:YES];
}

-(void) configureSlidingMenu
{
    NSDictionary *transitionData = self.transitions.all[2];
    id<ECSlidingViewControllerDelegate> transition = transitionData[@"transition"];
    if (transition == (id)[NSNull null]) {
        self.slidingViewController.delegate = nil;
    } else {
        self.slidingViewController.delegate = transition;
    }
    
    self.transitions.dynamicTransition.slidingViewController = self.slidingViewController;
    self.slidingViewController.underLeftViewController = [[UIStoryboard storyboardWithName:@"leftPanel" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"OSLeftPanelViewController"];
    self.slidingViewController.underRightViewController = [[UIStoryboard storyboardWithName:@"rightPanel" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"OSRightPanelViewController"];
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateCenterViewController: (NSNotification *)notif
{
    NSString *storyboardName = (NSString *)notif.object;
    if ( [storyboardName isEqualToString:kSearchTab]) {//display search view
        UIStoryboard *searchStoryboary = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
        self.searchViewController = (OSSearchViewController *)[searchStoryboary instantiateInitialViewController];
        [self addChildViewController: self.searchViewController];
        [self.view addSubview:self.searchViewController.view];
        self.searchViewController.view.autoresizesSubviews = YES;
        
    }else if ([storyboardName isEqualToString:kAskQuestionTab]){//display ask question view
        UIStoryboard *askQuestionStoryboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
        self.askQuestioinViewController = (OSAskQuestionViewController *)[askQuestionStoryboard instantiateInitialViewController];[self addChildViewController: self.askQuestioinViewController];
        [self.view addSubview:self.askQuestioinViewController.view];
        self.askQuestioinViewController.view.autoresizesSubviews = YES;
    
    }else if ([storyboardName isEqualToString:kCreateChannelTab]){//display create channel view
        UIStoryboard *createChannelStoryboary = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
        self.createChannelViewController = (OSCreateChannelViewController *)[createChannelStoryboary instantiateInitialViewController];
        [self addChildViewController: self.createChannelViewController];
        [self.view addSubview:self.createChannelViewController.view];
        self.createChannelViewController.view.autoresizesSubviews = YES;
        
    }else if ([storyboardName isEqualToString:kInvitePeople]){//display invite view
        UIStoryboard *createChannelStoryboary = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
        self.invitePeopleViewController = (OSInvitePeopleViewController *)[createChannelStoryboary instantiateInitialViewController];
        [self addChildViewController: self.invitePeopleViewController];
        [self.view addSubview:self.invitePeopleViewController.view];
        self.invitePeopleViewController.view.autoresizesSubviews = YES;
        
    }else if ([storyboardName isEqualToString:kChannelTab]){//display channel view
        UIStoryboard *channelStoryboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
        self.channelViewController = (OSChannelViewController *)[channelStoryboard instantiateInitialViewController];
        [self addChildViewController: self.channelViewController];
        [self.view addSubview:self.channelViewController.view];
        self.channelViewController.view.autoresizesSubviews = YES;
        
    }else if ([storyboardName isEqualToString:kRoomTab]){//display room view
        UIStoryboard *roomStoryboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
        self.roomViewController = (OSRoomViewController *)[roomStoryboard instantiateInitialViewController];
        [self addChildViewController: self.roomViewController];
        [self.view addSubview:self.roomViewController.view];
        self.roomViewController.view.autoresizesSubviews = YES;
        
    } else if([storyboardName isEqualToString:kSettingsTab]) {
        UIStoryboard *settingStoryboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
        self.settingViewController = (OSSettingViewController *)[settingStoryboard instantiateInitialViewController];
        [self addChildViewController: self.settingViewController];
        [self.view addSubview:self.settingViewController.view];
        self.settingViewController.view.autoresizesSubviews = YES;

    }
    
    
}

#pragma mark - Properties

- (METransitions *)transitions {
    if (_transitions) return _transitions;
    
    _transitions = [[METransitions alloc] init];
    
    return _transitions;
}

-(void) onClickSearch
{
    UIStoryboard *entrance = [UIStoryboard storyboardWithName:kSearchTab bundle:[NSBundle mainBundle]];
    OSSearchViewController *viewController = [entrance instantiateViewControllerWithIdentifier:@"OSSearchViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) onClickDropDown
{
    UIStoryboard *entrance = [UIStoryboard storyboardWithName:kChannelTab bundle:[NSBundle mainBundle]];
    OSSearchViewController *viewController = [entrance instantiateViewControllerWithIdentifier:@"OSChannelSettingViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
