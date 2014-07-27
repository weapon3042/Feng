//
//  OSViewController.m
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/8/14.
//  Copyright (c) 2014 OpenSilo Inc. All rights reserved.
//

#import "OSViewController.h"
#import "OSUIMacro.h"
#import "UIImageView+AFNetworking.h"
#import "OSSession.h"
#import "OSConstant.h"
#import "OSTranscriptTableViewCell.h"
#import "OSDateTimeUtils.h"
#import "OSWebServiceMacro.h"
#import "OSGetRequest.h"
#import "OSSession.h"
#import "OSUIMacro.h"


static NSString * const transcriptCellIdentifier = @"OSTranscriptTableViewCell";

@interface OSViewController()


@end

@implementation OSViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    self.channelThread = [[NSMutableArray alloc] init];
    
    // Initialize the root of our Firebase namespace.
    NSString *channelId = [OSSession getInstance].currentChannel.fireBaseId ? [OSSession getInstance].currentChannel.fireBaseId : DEFAULT_CHANNEL_ID;
    NSString *url = [NSString stringWithFormat:@"%@channel/%@/messages",fireBaseUrl,channelId];
    self.firebase = [[Firebase alloc] initWithUrl:url];
    [self.firebase authWithCredential:fireBaseSecret withCompletionBlock:^(NSError* error, id authData) {
        
        [self.firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
            // Add the chat message to the array.
            [self.channelThread addObject:snapshot.value];
            // Reload the table view so the new message will show up.
            [self.tableView reloadData];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.channelThread.count -1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }];
        
    } withCancelBlock:^(NSError* error) {
        NSLog(@"Authentication status was cancelled! %@", error);
    }];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(viewWillAppear:) name:kChannelDidSelectNotification object:nil];


    //customize the navigation bar
    UIView *navView=[[UIView alloc] initWithFrame:CGRectMake(0, 0,320, 44)];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"nav-left"] forState:UIControlStateNormal];
    [leftBtn setFrame:CGRectMake(0,0,44,44)];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:[UIImage imageNamed:@"nav-search"] forState:UIControlStateNormal];
    [searchBtn setFrame:CGRectMake(200,0,44,44)];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"nav-right"] forState:UIControlStateNormal];
    [rightBtn setFrame:CGRectMake(260,0,44,44)];
    
    [navView addSubview:leftBtn];
    [navView addSubview:searchBtn];
    [navView addSubview:rightBtn];
    
    navView.backgroundColor=UIColorFromRGB(0x3b95c7);
    [self.navigationController.navigationBar addSubview:navView];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self registerCustomCellsFromNibs];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    // We only have one section in our table view.
    return 1;
}

- (NSInteger)tableView:(UITableView*)table numberOfRowsInSection:(NSInteger)section
{
    // This is the number of chat messages.
    return [self.channelThread count];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell*)tableView:(UITableView*)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OSTranscriptTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:transcriptCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *message = [self.channelThread objectAtIndex:indexPath.row];
    
    NSString *userId = message[@"user_id"];
    NSDictionary *userInfo = [[OSSession getInstance].allUsers objectForKey:userId];
    if([message isKindOfClass:[NSDictionary class]]){
        
        cell.message.text =  @"asbc";
        cell.fullName.text = [NSString stringWithFormat:@"%@ %@", userInfo[@"first_name"], userInfo[@"last_name"]];
    }
    cell.message.text =  message[@"text"];
    NSString *messageTimestamp = message[@"timestamp"];
    NSString *timeDetails = [[OSDateTimeUtils getInstance] convertDateTimeFromUTCtoLocalForDateTime:[messageTimestamp longLongValue]];
    NSArray *foo = [timeDetails componentsSeparatedByString: @"/"];
    NSString *time = [foo objectAtIndex: 0];
    NSString *date = [foo objectAtIndex: 1];
    cell.messageTime.text = time;
    NSURL *url = [NSURL URLWithString:userInfo[@"picture"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"imgPlaceholder"];
    __weak OSTranscriptTableViewCell *weakCell = cell;
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
    [cell.pic.layer setMasksToBounds:YES];
    [cell.pic.layer setCornerRadius:22.0];
    return cell;
}

-(void)registerCustomCellsFromNibs
{
    [self.tableView registerNib:[UINib nibWithNibName:@"OSTranscriptTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OSTranscriptTableViewCell"];
}

#pragma mark - Text Field

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    
    if([textField.text length] > 0){
        
        long timestamp = [[NSDate date] timeIntervalSince1970];
        
        [[self.firebase childByAutoId] setValue:@{
                                                  @"user_id" : @"53c6030e94e4bf19725dd2c6",
                                                  @"text": textField.text,
                                                  @"timestamp" : [NSString stringWithFormat:@"%ld",timestamp]
                                                }];
        
        [textField setText:@""];

        
    }
    
    return NO;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    if ([_messageInput isFirstResponder]) {
        [_messageInput resignFirstResponder];
    }
}

#pragma mark - Animations
-(void)dealloc
{
    // Unsubscribe from keyboard show/hide notifications.
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}

// text field upwards when the keyboard shows, and downwards when it hides.
- (void)keyboardWillShow:(NSNotification*)notification
{
    [self moveView:[notification userInfo] up:YES];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    [self moveView:[notification userInfo] up:NO];
}

- (void)moveView:(NSDictionary*)userInfo up:(BOOL)up
{
    CGRect keyboardEndFrame;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]
     getValue:&keyboardEndFrame];
    
    UIViewAnimationCurve animationCurve;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]
     getValue:&animationCurve];
    
    NSTimeInterval animationDuration;
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]
     getValue:&animationDuration];
    
    // Get the correct keyboard size to we slide the right amount.
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    int y = keyboardFrame.size.height * (up ? -1 : 1);
    self.view.frame = CGRectOffset(self.view.frame, 0, y);
    
    [UIView commitAnimations];
}

/*
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    int selectedTag=tabBar.selectedItem.tag;
//    NSLog(@"%@",[OSSession getInstance].user);
    NSString *url;
    switch (selectedTag) {
        case 0:
            url = [NSString stringWithFormat:@"%@dismissednotifications/%@",fireBaseUrl, [OSSession getInstance].user.userId];
            break;
        case 1:
            url = [NSString stringWithFormat:@"%@lastMessageViewed/%@",fireBaseUrl, [OSSession getInstance].user.userId];
            break;
        default:
            break;
    }
    [self.channelThread removeAllObjects];
    Firebase *notificationsFB = [[Firebase alloc] initWithUrl:url];
    [notificationsFB authWithCredential:fireBaseSecret withCompletionBlock:^(NSError* error, id authData) {
        [notificationsFB observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
            [self.channelThread addObject:snapshot.value];
            [self.tableView reloadData];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.channelThread.count -1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }];
    } withCancelBlock:^(NSError* error) {
        NSLog(@"Authentication status was cancelled! %@", error);
    }];
}
*/
@end
