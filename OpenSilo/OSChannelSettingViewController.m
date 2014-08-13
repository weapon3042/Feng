//
//  OSChannelSettingViewController.m
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 8/4/14.
//  Copyright (c) 2014 OpenSilo Co. All rights reserved.
//

#import "OSChannelSettingViewController.h"
#import "OSPostRequest.h"
#import "OSSession.h"

@interface OSChannelSettingViewController ()

@end

@implementation OSChannelSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)emailNotificationsSwitch:(id)sender {
}

- (IBAction)muteSwitch:(id)sender {
    
    OSPostRequest *patchRoom = [[OSPostRequest alloc] init];
    
    NSString *url = [NSString stringWithFormat:@"api/channels/%@", [OSSession getInstance].currentRoom.roomId];
    
    //Perform Room Request
    [patchRoom postApiRequest:url params:nil setAuthHeader:YES responseBlock:^(id responseObject, NSError *error) {
        if (!error) {
            
            
        }
    }];
}

- (IBAction)channelPrivacySwitch:(id)sender {
    
  
    NSString *privacy;
    
    if(((UISwitch *) sender).isOn) privacy = @"private";
    
    else privacy = @"public";
    
    NSDictionary *params = @{
         @"channel_name": [OSSession getInstance].currentChannel.channelName,
         @"privacy_setting":privacy,
         @"status":@"active"
     };
    
    OSPostRequest *patchRoom = [[OSPostRequest alloc] init];
    
    NSString *url = [NSString stringWithFormat:@"api/channels/%@", [OSSession getInstance].currentRoom.roomId];
    
    //Perform Room Request
    [patchRoom postApiRequest:url params:params setAuthHeader:YES responseBlock:^(id responseObject, NSError *error) {
        if (!error) {
            
            
        }
    }];
}

- (IBAction)leaveChannel:(id)sender {
    
    OSPostRequest *patchRoom = [[OSPostRequest alloc] init];
    
    NSString *url = [NSString stringWithFormat:@"api/channels/%@/users/%@",
                     [OSSession getInstance].currentRoom.roomId,[OSSession getInstance].user.userId];
    
    //Perform Room Request
    [patchRoom postApiRequest:url params:nil setAuthHeader:YES responseBlock:^(id responseObject, NSError *error) {
        if (!error) {
            
            
        }
    }];
    
}

@end
