//
//  OSSignUpEmailViewController.m
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/29/14.
//  Copyright (c) 2014 OpenSilo Co. All rights reserved.
//

#import "OSSignUpDetailsViewController.h"
#import "OSUIMacro.h"
#import "OSSession.h"

@interface OSSignUpDetailsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *firstNameText;
@property (weak, nonatomic) IBOutlet UITextField *lastNameText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmText;
@property (weak, nonatomic) IBOutlet UITextField *companyText;
@property (weak, nonatomic) IBOutlet UITextField *teamText;
@property (weak, nonatomic) IBOutlet UITextField *roleText;
@property (weak, nonatomic) IBOutlet UITextField *skillsText;
@property (weak, nonatomic) IBOutlet UIButton *agreenBUtton;
@property (weak, nonatomic) IBOutlet UIButton *createAccountButton;
@property BOOL checkbox;
@end

@implementation OSSignUpDetailsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    if ([OSSession getInstance].user) {
        _firstNameText.text = [OSSession getInstance].user.firstName;
        _lastNameText.text = [OSSession getInstance].user.lastName;
        _emailText.text = [OSSession getInstance].user.email;
        _companyText.text = [OSSession getInstance].user.company;
        _roleText.text = [OSSession getInstance].user.jobTitle;
    }
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
    _checkbox = NO;
    [self drawView];
}

- (void) drawView
{
    SET_BORDER(_firstNameText);
    SET_BORDER(_lastNameText);
    SET_BORDER(_emailText);
    SET_BORDER(_passwordText);
    SET_BORDER(_passwordConfirmText);
    SET_BORDER(_companyText);
    SET_BORDER(_teamText);
    SET_BORDER(_roleText);
    SET_BORDER(_skillsText);
    SET_TEXTFIELD_TRANPARENT(_firstNameText);
    SET_TEXTFIELD_TRANPARENT(_lastNameText);
    SET_TEXTFIELD_TRANPARENT(_emailText);
    SET_TEXTFIELD_TRANPARENT(_passwordText);
    SET_TEXTFIELD_TRANPARENT(_passwordConfirmText);
    SET_TEXTFIELD_TRANPARENT(_companyText);
    SET_TEXTFIELD_TRANPARENT(_teamText);
    SET_TEXTFIELD_TRANPARENT(_roleText);
    SET_TEXTFIELD_TRANPARENT(_skillsText);
    [_agreenBUtton setImage:[UIImage imageNamed:@"checkbox-off.png"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickCreateAccount:(id)sender
{
        
}

- (IBAction)checkbox:(id)sender
{
    if (!_checkbox) {
        [_agreenBUtton setImage:[UIImage imageNamed:@"checkbox-on"] forState:UIControlStateNormal];
        _checkbox = YES;
    }
    
    else if (_checkbox) {
        [_agreenBUtton setImage:[UIImage imageNamed:@"checkbox-off"] forState:UIControlStateNormal];
        _checkbox = NO;
    }
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
