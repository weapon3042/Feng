//
//  OSSignUpEmailViewController.m
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 8/6/14.
//  Copyright (c) 2014 OpenSilo Co. All rights reserved.
//

#import "OSSignUpEmailViewController.h"
#import "OSLoginViewController.h"
#import "OSUIMacro.h"

@interface OSSignUpEmailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIButton *signinButton;
@end

@implementation OSSignUpEmailViewController

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

- (void) drawView
{
    SET_BORDER(_emailText);
    SET_TEXTFIELD_TRANPARENT(_emailText);
}

- (IBAction)onClickSignup:(id)sender {
    
}


- (IBAction)onClickSignin:(id)sender {
    UIStoryboard *entrance = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
    OSLoginViewController *viewController = [entrance instantiateViewControllerWithIdentifier:@"OSLoginViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
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
