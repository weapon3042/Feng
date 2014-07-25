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


static NSString * const transcriptCellIdentifier = @"OSTranscriptTableViewCell";

@implementation OSViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    self.channelThread = [[NSMutableArray alloc] init];
    
    // Initialize the root of our Firebase namespace.
    if (![OSSession getInstance].currentChannel.fireBaseId) {
        self.firebase = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@channel/%@/messages",fireBaseUrl,DEFAULT_CHANNEL_ID]];
    } else {
        self.firebase = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@channel/%@/messages",fireBaseUrl,[OSSession getInstance].currentChannel.fireBaseId]];
        self.navigationItem.title = [OSSession getInstance].currentChannel.channelName;
    }
    
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
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"icon"] forState:UIControlStateNormal];
    [backBtn setFrame:CGRectMake(0,0,25,20)];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:backBtn]];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
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
    
    
    if([message isKindOfClass:[NSDictionary class]]){
        
        cell.message.text =  @"asbc";
        cell.fullName.text = message[@"user_id"];
        
    }
    cell.message.text =  message[@"text"];
    cell.fullName.text = message[@"user_id"];
    NSString *messageTimestamp = message[@"timestamp"];
    cell.messageTime.text = [[OSDateTimeUtils getInstance] convertDateTimeFromUTCtoLocalForDateTime:[messageTimestamp longLongValue]];
#warning pic url should be dynamic
    NSURL *url = [NSURL URLWithString:@"http://google.com"];
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

@end
