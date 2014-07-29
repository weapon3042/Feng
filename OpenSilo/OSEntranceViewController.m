//
//  OSEntranceViewController.m
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/29/14.
//  Copyright (c) 2014 OpenSilo Co. All rights reserved.
//

#import "OSEntranceViewController.h"
#import "OSSignUpEmailViewController.h"
#import "OSUIMacro.h"

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
    SET_BORDER(_linkedInButton);
    SET_BORDER(_emailButton);
    SET_BORDER(_logInButton);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUpWithEmail:(id)sender {
    UIStoryboard *entrance = [UIStoryboard storyboardWithName:@"Entrance" bundle:[NSBundle mainBundle]];
    OSSignUpEmailViewController *viewController = [entrance instantiateViewControllerWithIdentifier:@"OSSignUpEmailViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}
- (IBAction)login:(id)sender {
    UIStoryboard *entrance = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
    OSSignUpEmailViewController *viewController = [entrance instantiateViewControllerWithIdentifier:@"OSLoginViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
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
