//
//  OSEntranceViewController.m
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/29/14.
//  Copyright (c) 2014 OpenSilo Co. All rights reserved.
//

#import "OSEntranceViewController.h"
#import "OSSignUpEmailViewController.h"
#import "OSLoginViewController.h"
#import "OSUIMacro.h"
#import "LIALinkedInHttpClient.h"
#import "LIALinkedInApplication.h"
#import "OSWebServiceMacro.h"
#import "OSSession.h"

@interface OSEntranceViewController ()
@property (weak, nonatomic) IBOutlet UIButton *linkedInButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;
@end

@implementation OSEntranceViewController

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
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"LoginBackground"]]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    [self drawView];
}

-(void) drawView
{
    _linkedInButton.backgroundColor = OS_BLUE_BUTTON;
    SET_BORDER(_emailButton);
    SET_BORDER(_logInButton);
    SET_ROUNDED_CORNER(_linkedInButton);
    SET_ROUNDED_CORNER(_emailButton);
    SET_ROUNDED_CORNER(_logInButton);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUpWithEmail:(id)sender {
    UIStoryboard *entrance = [UIStoryboard storyboardWithName:@"Signup" bundle:[NSBundle mainBundle]];
    OSSignUpEmailViewController *viewController = [entrance instantiateViewControllerWithIdentifier:@"OSSignUpEmailViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}
- (IBAction)login:(id)sender {
    UIStoryboard *entrance = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
    OSLoginViewController *viewController = [entrance instantiateViewControllerWithIdentifier:@"OSLoginViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
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
    [self.client GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,pictureUrl,public-profile-url,positions)?oauth2_access_token=%@&format=json", accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
//        NSLog(@"current user %@", result);
        UIStoryboard *entrance = [UIStoryboard storyboardWithName:@"Entrance" bundle:[NSBundle mainBundle]];
        OSSignUpEmailViewController *viewController = [entrance instantiateViewControllerWithIdentifier:@"OSSignUpEmailViewController"];
        [[OSSession getInstance] setUser:[[OSUser alloc]init]];
        [OSSession getInstance].user.firstName= result[@"firstName"];
        [OSSession getInstance].user.lastName = result[@"lastName"];
        [OSSession getInstance].user.email = result[@"emailAddress"];
        
        NSDictionary *positions = result[@"positions"];
        NSArray *arr = positions[@"values"];
        if (arr.count > 0) {
            [OSSession getInstance].user.jobTitle = arr[0][@"title"];
            [OSSession getInstance].user.company = arr[0][@"company"][@"name"];
        }
        [self.navigationController pushViewController:viewController animated:YES];
        
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

@end
