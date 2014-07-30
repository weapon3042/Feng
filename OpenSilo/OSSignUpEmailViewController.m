//
//  OSSignUpEmailViewController.m
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/29/14.
//  Copyright (c) 2014 OpenSilo Co. All rights reserved.
//

#import "OSSignUpEmailViewController.h"
#import "OSUIMacro.h"

@interface OSSignUpEmailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmText;
@property (weak, nonatomic) IBOutlet UIButton *agreenBUtton;
@property (weak, nonatomic) IBOutlet UIButton *createAccountButton;
@property BOOL checkbox;
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
    _checkbox = NO;
    
    SET_BORDER(_emailText);
    SET_BORDER(_passwordText);
    SET_BORDER(_passwordConfirmText);
    SET_TEXTFIELD_TRANPARENT(_emailText);
    SET_TEXTFIELD_TRANPARENT(_passwordText);
    SET_TEXTFIELD_TRANPARENT(_passwordConfirmText);
    [_agreenBUtton setImage:[UIImage imageNamed:@"checkbox-off.png"] forState:UIControlStateNormal];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checkbox:(id)sender {
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
