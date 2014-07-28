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
    // Do any additional setup after loading the view.
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


//--------------------------------linkedIn login section-----------------
- (IBAction)onClickLinkedIn:(id)sender {
    [self.client getAuthorizationCode:^(NSString *code) {
        [self.client getAccessToken:code success:^(NSDictionary *accessTokenData) {
            NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
            [self requestMeWithToken:accessToken];
        }failure:^(NSError *error) {
            NSLog(@"Quering accessToken failed %@", error);
        }];
    }                      cancel:^{
        NSLog(@"Authorization was cancelled by user");
    }                     failure:^(NSError *error) {
        NSLog(@"Authorization failed %@", error);
    }];
}

- (void)requestMeWithToken:(NSString *)accessToken {
    [self.client GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,pictureUrl,public-profile-url)?oauth2_access_token=%@&format=json", accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
        NSLog(@"current user %@", result);
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        OSViewController *mainVC = [storyBoard instantiateInitialViewController];
        OSAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        appDelegate.window.rootViewController = mainVC;
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed to fetch current user %@", error);
    }];
    
}

- (LIALinkedInHttpClient *)client {
    LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:API_HOME
                                                                                    clientId:LI_API
                                                                                clientSecret:LI_SECRET
                                                                                       state:@"DCEEFWF45453sdffef424"
                                                                               grantedAccess:@[@"r_fullprofile", @"r_emailaddress"]];//@"r_network",
    return [LIALinkedInHttpClient clientForApplication:application presentingViewController:nil];
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
