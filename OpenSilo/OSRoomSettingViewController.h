//
//  OSRoomSettingViewController.h
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 8/4/14.
//  Copyright (c) 2014 OpenSilo Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OSRoomSettingViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *roomTitle;

@property (weak, nonatomic) IBOutlet UITextView *roomDescription;
@property (weak, nonatomic) IBOutlet UITextView *roomSnippet;

- (IBAction)emailNotificationsSwitch:(id)sender;
- (IBAction)muteSwitch:(id)sender;
- (IBAction)privacySwitch:(id)sender;

- (IBAction)solveButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *leaveRoom;

@end
