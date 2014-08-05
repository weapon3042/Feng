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
#import "OSChannelViewController.h"
#import "OSRoomViewController.h"
#import "OSSettingViewController.h"
#import "OSInboxViewController.h"

@interface OSViewController : UIViewController <ECSlidingViewControllerDelegate>

@property (nonatomic, strong) OSSearchViewController * searchViewController;
@property (nonatomic, strong) OSAskQuestionViewController * askQuestioinViewController;
@property (nonatomic, strong) OSCreateChannelViewController * createChannelViewController;
@property (nonatomic, strong) OSInvitePeopleViewController * invitePeopleViewController;
@property (nonatomic, strong) OSChannelViewController * channelViewController;
@property (nonatomic, strong) OSRoomViewController * roomViewController;
@property (nonatomic, strong) OSInboxViewController * inboxViewController;
@property (nonatomic, strong) OSSettingViewController *settingViewController;

@end
