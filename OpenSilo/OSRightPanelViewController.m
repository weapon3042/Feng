 //
//  OSRightPanelViewController.m
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/9/14.
//  Copyright (c) 2014 OpenSilo Inc. All rights reserved.
//

#import "OSMacro.h"
#import "OSRightPanelViewController.h"
#import "UIImageView+AFNetworking.h"
#import "OSPostRequest.h"
#import "OSGetRequest.h"
#import "OSPeopleTableViewCell.h"
#import "UITableViewCell+NIB.h"
#import "OSUIMacro.h"
#import "OSSession.h"
#import "OSChannel.h"
#import "OSWebServiceMacro.h"
#import "OSInviteViewController.h"
#import "OSInviteVIewController.h"
#import "OSConstant.h"
#import <Firebase/Firebase.h>

static NSString * const peopleCellIdentifier = @"OSPeopleTableViewCell";
static NSString * const fileCellIdentifier = @"OSFileTableViewCell";
static NSString * const pinCellIdentifier = @"OSPinTableViewCell";

@interface OSRightPanelViewController()

@end

@implementation OSRightPanelViewController

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
    
    //Customize the UI
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    [self registerCustomCellsFromNibs];
    [self drawView];
    
}

-(void)drawView
{
    self.invitePeopleButton.hidden = NO;
    self.uploadFileButton.hidden =YES;
    self.pinQuestionsText.hidden = YES;
    _invitePeopleButton.backgroundColor = OS_BLUE_BUTTON;
    _uploadFileButton.backgroundColor = OS_BLUE_BUTTON;
    SET_ROUNDED_CORNER(_invitePeopleButton);
    SET_ROUNDED_CORNER(_uploadFileButton);
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self fetchPeople];
    });
    //hide pin when a room is selected
    NSString *currentSection = [OSSession getInstance].currentSection;
    if ([currentSection isEqualToString:@"room"]) {
        [_segment removeAllSegments];
        [_segment insertSegmentWithTitle:@"Team" atIndex:0 animated:NO];
        [_segment insertSegmentWithTitle:@"Files" atIndex:1 animated:NO];
    }
    if ([currentSection isEqualToString:@"channel"]) {
        [_segment removeAllSegments];
        [_segment insertSegmentWithTitle:@"People" atIndex:0 animated:NO];
        [_segment insertSegmentWithTitle:@"Files" atIndex:1 animated:NO];
        [_segment insertSegmentWithTitle:@"Pinned" atIndex:2 animated:NO];
    }
    [_segment setSelectedSegmentIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.selectedArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.segment.selectedSegmentIndex) {
            
        case 0:
        {
            OSPeopleTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:peopleCellIdentifier forIndexPath:indexPath];
            NSDictionary *dict = [self.selectedArray objectAtIndex:indexPath.row];
            NSDictionary *userInfoDict = dict[@"user_id"];
            cell.fullName.text = [NSString stringWithFormat:@"%@ %@",userInfoDict[@"first_name"],userInfoDict[@"last_name"]];
            cell.jobTitle.text = userInfoDict[@"knowledge_title"];
            NSURL *url = [NSURL URLWithString:[userInfoDict objectForKey:@"picture"]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            UIImage *placeholderImage = [UIImage imageNamed:@"imgPlaceholder"];
            __weak OSPeopleTableViewCell *weakCell = cell;
            [weakCell.thumbProgressView startAnimating];
            [cell.pic setImageWithURLRequest:request
                            placeholderImage:placeholderImage
                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                         weakCell.pic.image = image;
                                         [weakCell.thumbProgressView stopAnimating];
                                     } failure:^(NSURLRequest *request,
                                                 NSHTTPURLResponse *response, NSError *error) {
                                         [weakCell.thumbProgressView stopAnimating];
                                     }];
            cell.thumbProgressView.hidesWhenStopped=YES;
            Firebase *firebase = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/presence/%@",fireBaseUrl,userInfoDict[@"user_id"]]];
//            NSLog(@"userId:%@", userInfoDict[@"user_id"]);
            cell.status.backgroundColor = USER_AWAY;
            [firebase authWithCredential:fireBaseSecret withCompletionBlock:^(NSError* error, id authData) {
                [firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
//                    NSLog(@"status:%@", snapshot.value);
//                    online/offline/idle/away/busy
                    if ([snapshot.value isEqualToString:@"online"]) {
//                        NSLog(@"userId:%@", userInfoDict[@"user_id"]);
                        cell.status.backgroundColor = USER_ONLINE;
                    }
                    if ([snapshot.value isEqualToString:@"busy"]) {
                        cell.status.backgroundColor = USER_BUSY;
                    }
                }];
            } withCancelBlock:^(NSError* error) {
                NSLog(@"error:%@",error);
            }];
//            customize cell's style
            [cell.status.layer setMasksToBounds:YES];
            [cell.status.layer setCornerRadius:5.0];
            [cell.pic.layer setMasksToBounds:YES];
            [cell.pic.layer setCornerRadius:22.0];

            return cell;
        }
            break;
            
        case 1:
        {
            UITableViewCell *fileCell = [self.tableView dequeueReusableCellWithIdentifier:fileCellIdentifier forIndexPath:indexPath];
            NSDictionary *dict = [self.selectedArray objectAtIndex:indexPath.row];
#warning don't know what's the field name.
            fileCell.textLabel.text = dict[@"title"];

            return fileCell;
        }
            break;
        case 2:
        {
            UITableViewCell *pinCell = [self.tableView dequeueReusableCellWithIdentifier:pinCellIdentifier forIndexPath:indexPath];
            NSDictionary *dict = [self.selectedArray objectAtIndex:indexPath.row];
#warning don't know what's the field name.
            pinCell.textLabel.text = dict[@"title"];
            return pinCell;
        }
            break;
    }
    return nil;
}

- (IBAction)changeSeg:(id)sender {
    
    switch (self.segment.selectedSegmentIndex) {
            
        case 0:
        {
            [self fetchPeople];
            self.invitePeopleButton.hidden = NO;
            self.uploadFileButton.hidden = YES;
            self.pinQuestionsText.hidden = YES;
        }
            break;
            
        case 1:
        {
            [self fetchFiles];
            self.invitePeopleButton.hidden = YES;
            self.uploadFileButton.hidden = NO;
            self.pinQuestionsText.hidden = YES;
        }
        break;
            
        case 2:
        {
            [self fetchPinnedQuestions];
            self.invitePeopleButton.hidden = YES;
            self.uploadFileButton.hidden = YES;
            self.pinQuestionsText.hidden = NO;
        }
        break;
            
    }
        
}

- (void) dismissKeyboard
{
    [self.view endEditing:YES];
}



//---------------------------------- People List Section ----------------------------------//

#pragma mark -
#pragma mark Fetch People List from server

-(void)fetchPeople{
    if ([[OSSession getInstance].currentSection isEqualToString:@"room"]) {
        
    }else{
        NSString *currentChannelId = DEFAULT_CHANNEL_ID;
        OSGetRequest *request = [[OSGetRequest alloc]init];
        if ( [OSSession getInstance].currentChannel.channelId) {
            currentChannelId = [OSSession getInstance].currentChannel.channelId;
        }
        [request getApiRequest:[NSString stringWithFormat:@"api/channels/%@/users",currentChannelId] params:nil setAuthHeader:YES responseBlock:^(id responseObject, NSError *error) {
            if (!error) {
                NSDictionary *response =  [NSDictionary dictionaryWithDictionary:responseObject];
                //NSLog(@"json:%@",json);
                self.peopleArray = [response objectForKey:@"result"];
                self.selectedArray = self.peopleArray[0];
                //reload data
                [self.tableView reloadData];
            }
        }];
    }
}

- (IBAction)onClickInvite:(id)sender
{
    [self.slidingViewController resetTopViewAnimated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateCenterViewNotification object:@"InvitePeople"];
}

-(void)registerCustomCellsFromNibs
{
    [self.tableView registerNib:[UINib nibWithNibName:@"OSPeopleTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OSPeopleTableViewCell"];
}

//---------------------------------- File List Section ----------------------------------//
#pragma mark -
#pragma mark Fetch Files from server

-(void)fetchFiles{
    if ([[OSSession getInstance].currentSection isEqualToString:@"room"]) {
        OSRoom *room = [OSSession getInstance].currentRoom;
        if (room) {
            self.fileArray = room.files;
        }
    }else{
        OSChannel *channel = [OSSession getInstance].currentChannel;
        if (channel) {
            self.fileArray = [channel.files mutableCopy];
        }
    }
    self.selectedArray = self.fileArray;
    [self.tableView reloadData];
}

//---------------------------------- Pinned Question List Section ----------------------------------//
#pragma mark -
#pragma mark Fetch Pinned Questions from server

-(void)fetchPinnedQuestions{
    
    OSGetRequest *request = [[OSGetRequest alloc]init];
    OSChannel *channel = [OSSession getInstance].currentChannel;
    if (channel) {
        if (channel.channelId) {
            NSString *currentChannelId = channel.channelId;
            [request getApiRequest:[NSString stringWithFormat:@"api/channels/%@/pinnedquestions", currentChannelId] params:nil setAuthHeader:YES responseBlock:^(id responseObject, NSError *error) {
                if (!error) {
                    NSDictionary *response =  [NSDictionary dictionaryWithDictionary:responseObject];
                    //NSLog(@"json:%@",json);
                    self.pinArray = [response objectForKey:@"result"];
                    self.selectedArray = self.pinArray;
                }
            }];
        }
    }
    //reload data
    [self.tableView reloadData];
}

- (IBAction)onClickUploadFile:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Upload from" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo",@"Box", nil];
    [actionSheet showFromRect:_uploadFileButton.frame inView:self.view animated:YES];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%i",buttonIndex);
    switch (buttonIndex) {
        case 0:
            [self uploadPhoto];
            break;
        case 1:
            [self shareViaBox];
            break;
        default:
            break;
    }
}

-(void)uploadPhoto{
    [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateCenterViewNotification object:kUploadPhoto];
    [self.slidingViewController resetTopViewAnimated:YES];
}

-(void)shareViaBox
{
    [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateCenterViewNotification object:kShareViaBox];
    [self.slidingViewController resetTopViewAnimated:YES];
}

@end

