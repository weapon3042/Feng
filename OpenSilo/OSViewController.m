//
//  OSViewController.m
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/8/14.
//  Copyright (c) 2014 OpenSilo Inc. All rights reserved.
//

#import "OSViewController.h"
#import "OSUIMacro.h"
#import "UIViewController+ECSlidingViewController.h"


@implementation OSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.channelThread = [[NSMutableArray alloc] init];

    // Initialize the root of our Firebase namespace.
    self.firebase = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@channel/-JR_TRvFMfvqfSQD4twU/messages",fireBaseUrl]];
    
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

    
    self.slidingViewController.underLeftViewController = [[UIStoryboard storyboardWithName:@"leftPanel" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"OSLeftPanelViewController"];
    self.slidingViewController.underRightViewController = [[UIStoryboard storyboardWithName:@"rightPanel" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"OSRightPanelViewController"];
    //customize the navigation bar
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"icon"] forState:UIControlStateNormal];
    [backBtn setFrame:CGRectMake(0,0,25,20)];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:backBtn]];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // enable swiping on the top view
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];

}

- (void)anchorRight {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (void)anchorLeft {
    [self.slidingViewController anchorTopViewToLeftAnimated:YES];
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

- (UITableViewCell*)tableView:(UITableView*)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *message = [self.channelThread objectAtIndex:indexPath.row];
    
    
    if([message isKindOfClass:[NSDictionary class]]){
    
    cell.textLabel.text = message[@"text"];
    cell.detailTextLabel.text = message[@"user_id"];
        
    }
    
    return cell;
}

#pragma mark - Text Field

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    
    if([textField.text length] > 0){
        
        [[self.firebase childByAutoId] setValue:@{
                                                  @"user_id" : @"53c6030e94e4bf19725dd2c6",
                                                  @"text": textField.text,
                                                  @"timestamp" : @"1405790066"
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


// Subscribe to keyboard show/hide notifications.
- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification object:nil];
}

// Unsubscribe from keyboard show/hide notifications.
- (void)viewWillDisappear:(BOOL)animated
{
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




@end
