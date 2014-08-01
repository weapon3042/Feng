//
//  OSLoginViewController.m
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/16/14.
//  Copyright (c) 2014 OpenSilo. All rights reserved.
//

#import "OSLoginViewController.h"
#import "OSDataManger.h"
#import "OSWebServiceMacro.h"
#import "LIALinkedInHttpClient.h"
#import "LIALinkedInApplication.h"
#import "OSViewController.h"
#import "OSLeftPanelViewController.h"
#import "OSRightPanelViewController.h"
#import "OSAppDelegate.h"
#import "OSSession.h"
#import "OSRequestUtils.h"
#import "OSToastUtils.h"
#import "OSUIMacro.h"
#import <APToast/UIView+APToast.h>

@interface OSLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernamerTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation OSLoginViewController
{
    LIALinkedInHttpClient *_client;
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
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"LoginBackground"]]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view.
    [self drawView];
}

- (void) drawView
{
    SET_BORDER(_usernamerTextfield);
    SET_BORDER(_passwordTextfield);
    SET_TEXTFIELD_TRANPARENT(_usernamerTextfield);
    SET_TEXTFIELD_TRANPARENT(_passwordTextfield);
}

-(IBAction)onClickLogin:(id)sender {
    [self.view endEditing:YES];
    NSDictionary *parameters = @{@"email": self.usernamerTextfield.text,
                                 @"password": self.passwordTextfield.text};
    OSRequestUtils *loginRequest = [[OSRequestUtils alloc]init];
    [loginRequest httpRequestWithURL:@"api/user/login" andType:@"POST" andAuthHeader:NO andParameters:parameters andResponseBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {

            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if ([[json objectForKey:@"success"] boolValue]) {
                NSDictionary *userInfo = [json objectForKey:@"result"][0];
                [[OSSession getInstance] setToken:[userInfo objectForKey:@"access_token"]];
                
                if (![OSSession getInstance].user) {
                    [[OSSession getInstance] setUser: [[OSUser alloc]init]];
                }
                [[OSSession getInstance].user setUserId:[userInfo objectForKey:@"user_id"]];
                [[OSSession getInstance].user setFirstName:[userInfo objectForKey:@"first_name"]];
                [[OSSession getInstance].user setLastName:[userInfo objectForKey:@"last_name"]];
                [[OSSession getInstance].user setDisplayName:[userInfo objectForKey:@"display_name"]];
                [[OSSession getInstance].user setPicture:[userInfo objectForKey:@"picture"]];
                [[OSSession getInstance].user setCompany:[userInfo objectForKey:@"company"]];
                [[OSSession getInstance].user setAddress:[userInfo objectForKey:@"address"]];
                [[OSSession getInstance].user setRole:[userInfo objectForKey:@"role"]];
                [[OSSession getInstance].user setEmail:[userInfo objectForKey:@"email"]];
                [[OSSession getInstance].user setJobTitle:[userInfo objectForKey:@"knowledge_title"]];
                [[OSSession getInstance].user setStatus:[userInfo objectForKey:@"status"]];
                [[OSSession getInstance].user setLastSeen:[userInfo objectForKey:@"last_seen"]];
                [[OSSession getInstance].user setDepartment:[userInfo objectForKey:@"department"]];
                
//                NSLog(@"%@",[OSSession getInstance].user);
                
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                OSViewController *mainVC = [storyBoard instantiateInitialViewController];
                
                OSAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
                appDelegate.window.rootViewController = mainVC;
                
            }else{
                [self.view ap_makeToastView:[[OSToastUtils getInstance] getToastMessage:@"Invalid credentials" andType:TOAST_FAIL] duration:4.f position:APToastPositionBottom];
            }
        }
    
    }];

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



@end
