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
#import "OSInviteViewController.h"
#import "OSChannelViewController.h"
#import "OSRoomViewController.h"
#import "OSSettingViewController.h"
#import "METransitions.h"
#import "OSInboxViewController.h"
#import "BoxNavigationController.h"
#import <BoxSDK/BoxSDK.h>

@interface OSViewController : UIViewController <ECSlidingViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) OSSearchViewController * searchViewController;
@property (nonatomic, strong) OSAskQuestionViewController * askQuestioinViewController;
@property (nonatomic, strong) OSCreateChannelViewController * createChannelViewController;
@property (nonatomic, strong) OSInviteViewController * inviteViewController;
@property (nonatomic, strong) OSChannelViewController * channelViewController;
@property (nonatomic, strong) OSRoomViewController * roomViewController;
@property (nonatomic, strong) OSInboxViewController * inboxViewController;
@property (nonatomic, strong) OSSettingViewController *settingViewController;
<<<<<<< HEAD
@property (nonatomic, strong) BoxNavigationController *boxNavigationController;
=======
@property (nonatomic, strong) METransitions *transitions;
@property (nonatomic, weak) UIButton *titleBtn;

@property (nonatomic) BOOL isRoom;
>>>>>>> 224fcec4218ad9f0592fb27dee747f2d01d253bb

@end
