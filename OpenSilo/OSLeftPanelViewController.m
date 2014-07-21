//
//  OSLeftPanelViewController.m
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/9/14.
//  Copyright (c) 2014 OpenSilo Inc. All rights reserved.
//

#import "OSLeftPanelViewController.h"
#import "OSChannel.h"
#import "OSUIMacro.h"
#import "OSDataManger.h"
#import "OSGetRequest.h"
#import "OSSession.h"

static NSString * const channelCellIdentifier = @"Channel Cell Identifier";
static NSString * const roomcellIdentifier = @"Room Cell Identifier";
@interface OSLeftPanelViewController()
@property (strong,nonatomic) id<ECSlidingViewControllerDelegate> transition;

/*
 ** @return The table view displaying each individual data set
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/*
 ** @return Segmented Control that switches in between the three data sets
 */

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
/*
 ** Array sets for data objects
 */
@property (nonatomic, strong) NSMutableArray *channels;
@property (nonatomic, strong) NSMutableArray *rooms;
@property (nonatomic, strong) NSMutableArray *favorites;

/*
 ** @return The current data set the viewer is using
 */
@property (nonatomic, strong) NSMutableArray *selectedArray;

@end

@implementation OSLeftPanelViewController


-(void)viewWillAppear:(BOOL)animated {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self fetchChannels];
    });
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.selectedArray = self.channels;
    
    [self.navigationController.navigationBar setHidden:NO];
    
    UIColor *backgroundColor = [UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1.0];
    self.tableView.backgroundView = [[UIView alloc]initWithFrame:self.tableView.bounds];
    self.tableView.backgroundView.backgroundColor = backgroundColor;

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.selectedArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.segment.selectedSegmentIndex == 0){
    
        UITableViewCell *channelCell = [tableView dequeueReusableCellWithIdentifier:channelCellIdentifier forIndexPath:indexPath];
        
        channelCell.textLabel.text = [self.selectedArray objectAtIndex:indexPath.row][@"channel_name"];
        
        return channelCell;
    
    }
    else if (self.segment.selectedSegmentIndex == 1){
        
        UITableViewCell *roomCell = [tableView dequeueReusableCellWithIdentifier:roomcellIdentifier forIndexPath:indexPath];
        
        roomCell.textLabel.text =[self.selectedArray objectAtIndex:indexPath.row][@"title"];
        
        return roomCell;
    
    }
    
    else if (self.segment.selectedSegmentIndex == 2){
        
        UITableViewCell *roomCell = [tableView dequeueReusableCellWithIdentifier:roomcellIdentifier forIndexPath:indexPath];
        
        roomCell.textLabel.text = [self.selectedArray objectAtIndex:indexPath.row][@"title"];
        
        return roomCell;
        
    }
   
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.slidingViewController resetTopViewAnimated:YES];

    if (self.segment.selectedSegmentIndex == 0){
        NSDictionary *dict = [self.channels objectAtIndex:(NSInteger)indexPath.row];
        if (dict) {
            if (![OSSession getInstance].currentChannel) {
                [[OSSession getInstance] setCurrentChannel: [[OSChannel alloc]init]];
            }
            [[OSSession getInstance].currentChannel setChannelId:dict[@"id"]];
            [[OSSession getInstance].currentChannel setChannelName:dict[@"channel_name"]];
            [[OSSession getInstance].currentChannel setOwnerId:dict[@"owner_user_id"]];
            [[OSSession getInstance].currentChannel setStatus:dict[@"status"]];
            [[OSSession getInstance].currentChannel setBoxFolderId:dict[@"box_folder_id"]];
            [[OSSession getInstance].currentChannel setPrivacySetting:dict[@"privacy_setting"]];
            [[OSSession getInstance].currentChannel setFireBaseId:dict[@"firebase_channel_name"]];
            [[OSSession getInstance].currentChannel setFiles:dict[@"files"]];
            [[OSSession getInstance].currentChannel setUsers:dict[@"users"]];
            
        }
    }
    
}

#pragma mark - Segmented Switch

- (IBAction)changeSeg:(id)sender {
    
    switch (self.segment.selectedSegmentIndex) {
            
        case 0:{
            [self fetchChannels];
        }
        break;
            
        case 1:{
            [self fetchRooms];
        }
        break;
            
        case 2:{
            [self fetchFavoriteRooms];
        }
        break;
            
    }
    
    [self.tableView reloadData];
    
}

#pragma mark Api Requests

-(void)fetchChannels{
    
    OSGetRequest *channelRequest = [[OSGetRequest alloc]init];
    
    [channelRequest getApiRequest:@"api/channels" params:nil setAuthHeader:YES responseBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSDictionary *response =  [NSDictionary dictionaryWithDictionary:responseObject];
            self.channels = [response objectForKey:@"result"];
            self.selectedArray = self.channels;
            [self.tableView reloadData];
        }
    }];
    
}


-(void)fetchRooms{
    
    OSGetRequest *roomRequest = [[OSGetRequest alloc]init];
    
    [roomRequest getApiRequest:@"api/resolutionrooms" params:nil setAuthHeader:YES responseBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSDictionary *response =  [NSDictionary dictionaryWithDictionary:responseObject];
            self.rooms = [response objectForKey:@"result"];
            self.selectedArray = self.rooms;
            [self.tableView reloadData];
        }
    }];
    
}

-(void)fetchFavoriteRooms{
    
    OSGetRequest *favRequest = [[OSGetRequest alloc]init];
    
    [favRequest getApiRequest:@"api/user/statistics" params:nil setAuthHeader:YES responseBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSDictionary *response =  [NSDictionary dictionaryWithDictionary:responseObject];
            
            NSArray *arr = [response objectForKey:@"result"];
            if ([arr count]>0) {
                self.favorites = [arr[0] objectForKey:@"favorite_rooms"];
                self.selectedArray = self.favorites;
                [self.tableView reloadData];
            }
        }
    }];
    
}

@end