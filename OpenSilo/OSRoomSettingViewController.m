//
//  OSRoomSettingViewController.m
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 8/4/14.
//  Copyright (c) 2014 OpenSilo Co. All rights reserved.
//

#import "OSRoomSettingViewController.h"
#import "OSRoom.h"
#import "OSSession.h"
#import "OSUIMacro.h"
#import "OSPostRequest.h"

@implementation OSRoomSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.scrollView.userInteractionEnabled = YES;
    [self.scrollView setContentSize:CGSizeMake(320.0, 776)];
    self.scrollView.scrollEnabled = YES;
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self drawView];
}

- (void) drawView
{
    OSRoom *room = [OSSession getInstance].currentRoom;
    
    _roomTitle.text = room.title;
    _roomDescription.text = room.description;
    _roomSnippet.text = room.snippet;
    
//    NSUInteger index = 0;
//    for (NSString *tag in room.tags) {
//        UIButton *tagButton = [[UIButton alloc]init];
//        [tagButton setFrame:CGRectMake(60 * index + 10, 0, 60, 34)];
//        tagButton.backgroundColor = OS_BLUE_BUTTON;
//        [tagButton setTitle:tag forState:UIControlStateNormal];
//        [tagButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_tagsView addSubview:tagButton];
//        index ++;
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)emailNotificationsSwitch:(id)sender {
    
    OSPostRequest *patchRoom = [[OSPostRequest alloc] init];
    
    NSString *url = [NSString stringWithFormat:@"api/resolutionrooms/%@",[OSSession getInstance].currentRoom.roomId];
    
    //Perform Room Request
    [patchRoom postApiRequest:url params:nil setAuthHeader:YES responseBlock:^(id responseObject, NSError *error) {
        if (!error) {
            
            
            
            
        }
    }];
    
}

- (IBAction)muteSwitch:(id)sender {
    
    OSPostRequest *patchRoom = [[OSPostRequest alloc] init];
    
    NSString *url = [NSString stringWithFormat:@"api/resolutionrooms/%@",[OSSession getInstance].currentRoom.roomId];
    
    //Perform Room Request
    [patchRoom postApiRequest:url params:nil setAuthHeader:YES responseBlock:^(id responseObject, NSError *error) {
        if (!error) {
            
        
            
            
        }
    }];
}

- (IBAction)privacySwitch:(id)sender {
    
    OSPostRequest *patchRoom = [[OSPostRequest alloc] init];
    
    NSString *url = [NSString stringWithFormat:@"api/resolutionrooms/%@",[OSSession getInstance].currentRoom.roomId];
    
    //Perform Room Request
    [patchRoom postApiRequest:url params:nil setAuthHeader:YES responseBlock:^(id responseObject, NSError *error) {
        if (!error) {
            
        
        }
    }];
}

- (IBAction)solveButton:(id)sender {
    OSPostRequest *patchRoom = [[OSPostRequest alloc] init];
    
    NSString *url = [NSString stringWithFormat:@"api/resolutionrooms/%@",[OSSession getInstance].currentRoom.roomId];
    
    //Perform Room Request
    [patchRoom postApiRequest:url params:nil setAuthHeader:YES responseBlock:^(id responseObject, NSError *error) {
        if (!error) {
            
            
            
        }
    }];
    
}



@end
