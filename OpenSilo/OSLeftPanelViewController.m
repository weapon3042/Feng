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
#import "OSConstant.h"
#import "DTCustomColoredAccessory.h"
#import "UIImageView+AFNetworking.h"
#import <Firebase/Firebase.h>

static NSString * const listCellIdentifier = @"LeftPanelCell";
static NSString * const listCellExpandIdentifier = @"LeftPanelExpandableCell";


@implementation OSLeftPanelViewController



-(void)viewWillAppear:(BOOL)animated {
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self fetchChannels];
            [self fetchRooms];
            [self fetchFavoriteRooms];
    });

}


- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self drawUserInfoView];
    
    [self.navigationController.navigationBar setHidden:NO];
    
    _list = @[kFavoritesTab,kChannelTab,kRoomTab,kInboxTab,kSearchTab,kAskQuestionTab,kCreateChannelTab,kSettingsTab];
    
    //Table view
    [[self tableView] setBackgroundColor:[UIColor clearColor]];
    [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (!_expandedSections)
    {
        _expandedSections = [[NSMutableIndexSet alloc] init];
    }
    
}

-(void) drawUserInfoView{
    NSURL *url = [NSURL URLWithString:[OSSession getInstance].user.picture];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"imgPlaceholder"];
    [_userImage setImageWithURLRequest:request
                      placeholderImage:placeholderImage
                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                               } failure:^(NSURLRequest *request,
                                           NSHTTPURLResponse *response, NSError *error) {
                               }];
    _userName.text = [NSString stringWithFormat:@"%@ %@",[OSSession getInstance].user.firstName, [OSSession getInstance].user.lastName];
    _jobTitle.text = [OSSession getInstance].user.jobTitle;
    _status.backgroundColor = USER_AWAY;
    Firebase *firebase = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/presence/%@",fireBaseUrl,[OSSession getInstance].user.userId]];
    [firebase authWithCredential:fireBaseSecret withCompletionBlock:^(NSError* error, id authData) {
        [firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
            //                    NSLog(@"status:%@", snapshot.value);
            //                    online/offline/idle/away/busy
            if ([snapshot.value isEqualToString:@"online"]) {
                //                        NSLog(@"userId:%@", userInfoDict[@"user_id"]);
                _status.backgroundColor = USER_ONLINE;
            }
            if ([snapshot.value isEqualToString:@"busy"]) {
                _status.backgroundColor = USER_BUSY;
            }
        }];
    } withCancelBlock:^(NSError* error) {
        NSLog(@"error:%@",error);
    }];
    [_userImage.layer setMasksToBounds:YES];
    [_userImage.layer setCornerRadius:22.0];
    [_status.layer setMasksToBounds:YES];
    [_status.layer setCornerRadius:5.0];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Expanding

- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
    if (section<4) return YES;
    
    return NO;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self tableView:tableView canCollapseSection:section])
    {
        if ([_expandedSections containsIndex:section])
        {
            switch (section) {
                case 0:
                    return _rooms.count?_rooms.count:1;
                    break;
                    
                case 1:
                    return _channels.count?_channels.count:1;
                    break;
                    
                case 2:
                    return _favorites.count?_favorites.count:1;
                    break;
                    
                case 3:
                    return _inbox.count?_inbox.count:1;
                    break;
                    
                default:
                    break;
            }
            
        }
        
        return 1; // only top row showing
    }
    
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"leftPanelCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    
    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
        // first row
        if (!indexPath.row)
        {
            switch (indexPath.section) {
                case 0:
                    cell.textLabel.text = @"Rooms"; // only top row showing
                    break;
                    
                case 1:
                    cell.textLabel.text = @"Channels"; // only top row showing
                    break;
                    
                case 2:
                    cell.textLabel.text = @"Favorites"; // only top row showing
                    break;
                
                case 3:
                    cell.textLabel.text = @"Inbox"; // only top row showing
                    break;

                    
                default:
                    break;
            }
            
            
            if ([_expandedSections containsIndex:indexPath.section])
            {
                cell.accessoryView = [DTCustomColoredAccessory accessoryWithColor:[UIColor grayColor] type:DTCustomColoredAccessoryTypeUp];
            }
            else
            {
                cell.accessoryView = [DTCustomColoredAccessory accessoryWithColor:[UIColor grayColor] type:DTCustomColoredAccessoryTypeDown];
            }
        }
        else
        {
            // all other rows
            
            switch (indexPath.section) {
                case 0:
                    cell.textLabel.text = _rooms[indexPath.row][@"title"];
                    break;
                    
                case 1:
                    cell.textLabel.text = _channels[indexPath.row][@"channel_name"];
                    break;
                    
                case 2:
                    cell.textLabel.text = _favorites[indexPath.row][@"title"];
                    break;
                
                case 3:
                    cell.textLabel.text = _inbox[indexPath.row][@"title"];
                    break;
                    
                default:
                    break;
            }
            
           cell.accessoryView = [DTCustomColoredAccessory accessoryWithColor:[UIColor whiteColor] type:DTCustomColoredAccessoryTypeRight];
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14.0f];
        }
    }
    else
    {
        cell.accessoryView = nil;
        cell.textLabel.text = _list[indexPath.row+4];
        
    }
    return cell;
    
}


//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if(selectedIndex == indexPath.row && indexPath.section == 0){
//        return 100;
//    }
//    else return 44;
//    
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.slidingViewController resetTopViewAnimated:YES];
    
    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
        if (!indexPath.row)
        {
            [self.tableView beginUpdates];
            
            // only first row toggles exapand/collapse
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            NSInteger section = indexPath.section;
            BOOL currentlyExpanded = [_expandedSections containsIndex:section];
            NSInteger rows;
            
            NSMutableArray *tmpArray = [NSMutableArray array];
            
            if (currentlyExpanded)
            {
                rows = [self tableView:tableView numberOfRowsInSection:section];
                [_expandedSections removeIndex:section];
                
            }
            else
            {
                [_expandedSections addIndex:section];
                rows = [self tableView:tableView numberOfRowsInSection:section];
            }
            
            for (int i=1; i<rows; i++)
            {
                NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i inSection:section];
                [tmpArray addObject:tmpIndexPath];
            }
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            if (currentlyExpanded)
            {
                [tableView deleteRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
                
                cell.accessoryView = [DTCustomColoredAccessory accessoryWithColor:[UIColor grayColor] type:DTCustomColoredAccessoryTypeDown];
                
            }
            else
            {
                [tableView insertRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
                cell.accessoryView =  [DTCustomColoredAccessory accessoryWithColor:[UIColor grayColor] type:DTCustomColoredAccessoryTypeUp];
                
            }
            
            [self.tableView endUpdates];
        }
    }
    //click to update center view
    if (indexPath.section == 0 && indexPath.row != 0) {
        [self.slidingViewController resetTopViewAnimated:YES];
        [[OSSession getInstance] setCurrentSection:@"room"];
        NSDictionary *dict = [self.rooms objectAtIndex:(NSInteger)indexPath.row];
        if (dict) {
            if (![OSSession getInstance].currentRoom) {
                [[OSSession getInstance] setCurrentRoom: [[OSRoom alloc]init]];
            }
            [[OSSession getInstance].currentRoom setRoomId:dict[@"id"]];
            [[OSSession getInstance].currentRoom setTitle:dict[@"title"]];
            [[OSSession getInstance].currentRoom setFireBaseId:dict[@"firebase_resolutionroom_name"]];
            [[OSSession getInstance].currentRoom setDescription:dict[@"description"]];
            [[OSSession getInstance].currentRoom setSnippet:dict[@"snippet"]];
            [[OSSession getInstance].currentRoom setCreateTime:dict[@"created_on"]];
            [[OSSession getInstance].currentRoom setResolvedTime:dict[@"resolved_on"]];
            [[OSSession getInstance].currentRoom setTags:dict[@"tags"]];
            [[OSSession getInstance].currentRoom setExperts:dict[@"experts"]];
            [[OSSession getInstance].currentRoom setHelpfulExperts:dict[@"helpful_experts"]];
            [[OSSession getInstance].currentRoom setInvitedUsers:dict[@"invited_experts"]];
            [[OSSession getInstance].currentRoom setOwnerId:dict[@"owner_id"]];
            [[OSSession getInstance].currentRoom setFiles:dict[@"files"]];
            [[OSSession getInstance].currentRoom setDeleted:[dict[@"is_deleted"] boolValue]];
            [[OSSession getInstance].currentRoom setResolved:[dict[@"resolved"] boolValue]];
            [[NSNotificationCenter defaultCenter]postNotificationName:kChannelDidSelectNotification object:kRoomTab];
            
        }
    }
    if (indexPath.section == 1 && indexPath.row != 0) {
         [self.slidingViewController resetTopViewAnimated:YES];
        [[OSSession getInstance] setCurrentSection:@"channel"];
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
            [[NSNotificationCenter defaultCenter]postNotificationName:kChannelDidSelectNotification object:kCreateChannelTab];
            
        }

    }
    
    else if(indexPath.section>3){
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateCenterViewNotification object:_list[indexPath.row+4]];

        
    }

}



//-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    
//    if(section ==1) return 1.0;
//    
//    return 0;
//}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    if (self.segment.selectedSegmentIndex == 0){
//        NSDictionary *dict = [self.channels objectAtIndex:(NSInteger)indexPath.row];
//        if (dict) {
//            if (![OSSession getInstance].currentChannel) {
//                [[OSSession getInstance] setCurrentChannel: [[OSChannel alloc]init]];
//            }
//            [[OSSession getInstance].currentChannel setChannelId:dict[@"id"]];
//            [[OSSession getInstance].currentChannel setChannelName:dict[@"channel_name"]];
//            [[OSSession getInstance].currentChannel setOwnerId:dict[@"owner_user_id"]];
//            [[OSSession getInstance].currentChannel setStatus:dict[@"status"]];
//            [[OSSession getInstance].currentChannel setBoxFolderId:dict[@"box_folder_id"]];
//            [[OSSession getInstance].currentChannel setPrivacySetting:dict[@"privacy_setting"]];
//            [[OSSession getInstance].currentChannel setFireBaseId:dict[@"firebase_channel_name"]];
//            [[OSSession getInstance].currentChannel setFiles:dict[@"files"]];
//            [[OSSession getInstance].currentChannel setUsers:dict[@"users"]];
//            
//            [[NSNotificationCenter defaultCenter]postNotificationName:kChannelDidSelectNotification object:nil];
//            
//            
//            [[OSSidePanelController sharedSidePanelController] showCenterPanelAnimated:YES];
//            
//        }
//    }
//    
//}


#pragma mark Api Requests

-(void)fetchChannels{
    
    OSGetRequest *channelRequest = [[OSGetRequest alloc]init];
    
    [channelRequest getApiRequest:@"api/channels" params:nil setAuthHeader:YES responseBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSDictionary *response =  [NSDictionary dictionaryWithDictionary:responseObject];
            
            self.channels = [response objectForKey:@"result"];

        }
    }];
    
}


-(void)fetchRooms{
    
    OSGetRequest *roomRequest = [[OSGetRequest alloc]init];
    
    [roomRequest getApiRequest:@"api/resolutionrooms" params:nil setAuthHeader:YES responseBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSDictionary *response =  [NSDictionary dictionaryWithDictionary:responseObject];
            self.rooms = [response objectForKey:@"result"];
//            [self.tableView reloadData];
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
//                [self.tableView reloadData];
            }
        }
    }];
    
}

@end

