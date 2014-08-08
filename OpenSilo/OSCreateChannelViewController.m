//
//  OSCreateChannelViewController.m
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/31/14.
//  Copyright (c) 2014 OpenSilo Co. All rights reserved.
//

#import "OSCreateChannelViewController.h"
#import "OSPostRequest.h"
#import "OSConstant.h"

@implementation OSCreateChannelViewController

+ (OSCreateChannelViewController *)getInstance {
    static OSCreateChannelViewController *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[OSCreateChannelViewController alloc] init];
    });
    
    return _sharedInstance;
}

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
    
    //First responder for keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    
    //Hide invited members table if no one has been invted
    if(_invitedUsers || _invitedUsers.count) _invitedUsersTable.hidden = YES;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{ return 0; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    return nil;
}


#pragma mark - UI Actions

- (IBAction)inviteMembers:(id)sender {
    
   //Code to bring up inviteMemberView, write to _invitedUsers
   [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateCenterViewNotification object:kInvitePeople];
   [self.slidingViewController resetTopViewAnimated:YES];
    
    
}


- (IBAction)createChannel:(id)sender {
    
    
    OSPostRequest *createChannel = [[OSPostRequest alloc] init];
    
    NSString *privacy;
    
    if(_privacySwitch.isOn) privacy = @"private";
    
    else privacy = @"public";
        
    NSDictionary *params = @{
                             @"channel_name": _channelName.text,
                             @"privacy_setting":privacy,
                             @"status":@"active"
                             };
    
    
    //Perform Channel Creation
    [createChannel postApiRequest:@"api/channels" params:params setAuthHeader:YES responseBlock:^(id responseObject, NSError *error) {
        if (!error) {

            NSDictionary *response =  [NSDictionary dictionaryWithDictionary:responseObject];
                     NSLog(@"%@",response);
            
            
        }
    }];
    
    
    //Check if there any users to invite
    if(_invitedUsers || _invitedUsers.count){
        
        [createChannel postApiRequest:@"api/invited_user_map" params:_invitedUsers setAuthHeader:YES responseBlock:^(id responseObject, NSError *error) {
            if (!error) {
                
                
            }
        }];
    
    }
    
    
}

- (void)dismissKeyboard
{
    [_channelName resignFirstResponder];
    [_channelDescription resignFirstResponder];
}

@end
