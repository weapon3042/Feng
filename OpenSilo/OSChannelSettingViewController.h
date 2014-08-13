//
//  OSChannelSettingViewController.h
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 8/4/14.
//  Copyright (c) 2014 OpenSilo Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OSChannelSettingViewController : UIViewController
- (IBAction)emailNotificationsSwitch:(id)sender;
- (IBAction)muteSwitch:(id)sender;

- (IBAction)channelPrivacySwitch:(id)sender;

- (IBAction)leaveChannel:(id)sender;

@end
