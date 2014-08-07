//
//  OSRoomSettingViewController.m
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 8/4/14.
//  Copyright (c) 2014 OpenSilo Co. All rights reserved.
//

#import "OSRoomSettingViewController.h"
#import "OSRoom.h"
#import "OSSession.h"
#import "OSUIMacro.h"

@interface OSRoomSettingViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UITextView *titleTextView;
@property (nonatomic, weak) IBOutlet UITextView *descriptionTextView;
@property (nonatomic, weak) IBOutlet UITextView *snippetTextView;
@property (nonatomic, weak) IBOutlet UIView *tagsView;

@end

@implementation OSRoomSettingViewController

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
    [self drawView];
}

- (void) drawView
{
    OSRoom *room = [OSSession getInstance].currentRoom;
    _titleTextView.text = room.title;
    _descriptionTextView.text = room.description;
    _snippetTextView.text = room.snippet;
    NSUInteger index = 0;
    for (NSString *tag in room.tags) {
        UIButton *tagButton = [[UIButton alloc]init];
        [tagButton setFrame:CGRectMake(60 * index + 10, 0, 60, 34)];
        tagButton.backgroundColor = OS_BLUE_BUTTON;
        [tagButton setTitle:tag forState:UIControlStateNormal];
        [tagButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_tagsView addSubview:tagButton];
        index ++;
    }
    
    
    [_scrollView setContentSize:CGSizeMake(320,800)];
    
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
