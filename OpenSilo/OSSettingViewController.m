//
//  OSSettingViewController.m
//  OpenSilo
//
//  Created by peng wan on 14-8-4.
//  Copyright (c) 2014 OpenSilo Co. All rights reserved.
//

#import "OSSettingViewController.h"

@interface OSSettingViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation OSSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLayoutSubviews
{
    [self.scrollView setContentSize:CGSizeMake(320.0, 1000)];
    self.scrollView.scrollEnabled = YES;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
