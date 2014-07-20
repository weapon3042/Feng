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
#import "OSAppDelegate.h"
#import "OSPostRequest.h"

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

    NSDictionary *parameters = @{@"email": self.usernamerTextfield.text,
                                 @"password": self.passwordTextfield.text};

    OSPostRequest *loginRequest = [[OSPostRequest alloc]init];
    
    [loginRequest postApiRequest:@"api/user/login" params:parameters setAuthHeader:NO responseBlock:^(NSData *responseObject, NSError *error) {
        
        if (!error) {
            
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            OSViewController *mainVC = [storyBoard instantiateInitialViewController];
            OSAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            appDelegate.window.rootViewController = mainVC;
            
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
