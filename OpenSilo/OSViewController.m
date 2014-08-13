
//
//  OSViewController.m
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/8/14.
//  Copyright (c) 2014 OpenSilo Inc. All rights reserved.
//

#import "OSViewController.h"
#import "OSUIMacro.h"
#import "UIImageView+AFNetworking.h"
#import "OSSession.h"
#import "OSConstant.h"
#import "OSTranscriptTableViewCell.h"
#import "OSDateTimeUtils.h"
#import "OSWebServiceMacro.h"
#import "OSGetRequest.h"
#import "OSUIMacro.h"
#import "OSUserUtils.h"
#import "OSRoomSettingViewController.h"
#import "OSChannelSettingViewController.h"
#import "BoxNavigationController.h"


static NSString * const transcriptCellIdentifier = @"OSTranscriptTableViewCell";
@interface OSViewController()

<<<<<<< HEAD
@property (nonatomic, strong) METransitions *transitions;
=======
@property BOOL inSettingView;
>>>>>>> 224fcec4218ad9f0592fb27dee747f2d01d253bb


@end

@implementation OSViewController

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateCenterViewController:) name:kUpdateCenterViewNotification object:nil];
    
    [self configureSlidingMenu];
    
    UIStoryboard *channelStoryboard = [UIStoryboard storyboardWithName:kChannelTab bundle:[NSBundle mainBundle]];
    self.channelViewController = (OSChannelViewController *)[channelStoryboard instantiateInitialViewController];
    
    [self addChildViewController: self.channelViewController];
    [self.view addSubview:self.channelViewController.view];
    
    self.channelViewController.view.autoresizesSubviews = YES;
    
    _isRoom = false;
    _inSettingView = false;
    
    //customize the navigation bar
    UIView *navView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"nav-left"] forState:UIControlStateNormal];
    [leftBtn setFrame:CGRectMake(10,7,30,30)];
    [leftBtn addTarget:self action:@selector(anchorRight) forControlEvents:UIControlEventTouchUpInside];
    
    _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_titleBtn setFrame:CGRectMake(42,8,180,30)];
    [_titleBtn setTitle:@"Welcome to OpenSilo" forState:UIControlStateNormal];
    [_titleBtn addTarget:self action:@selector(onClickDropDown) forControlEvents:UIControlEventTouchUpInside];

    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:[UIImage imageNamed:@"nav-search"] forState:UIControlStateNormal];
    [searchBtn setFrame:CGRectMake(240,7,30,30)];
    [searchBtn addTarget:self action:@selector(onClickSearch) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"nav-right"] forState:UIControlStateNormal];
    [rightBtn setFrame:CGRectMake(280,7,30,30)];
    [rightBtn addTarget:self action:@selector(anchorLeft) forControlEvents:UIControlEventTouchUpInside];
    
    [navView addSubview:leftBtn];
    [navView addSubview:_titleBtn];
    [navView addSubview:searchBtn];
    [navView addSubview:rightBtn];
    
    SET_NAVIGATION_BAR_BG_COLOR(navView);
    
    [self.navigationController.navigationBar addSubview:navView];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    self.navigationItem.backBarButtonItem = nil;
    
<<<<<<< HEAD
     */
    
    UIStoryboard *channelStoryboard = [UIStoryboard storyboardWithName:kChannelTab bundle:[NSBundle mainBundle]];
    self.channelViewController = (OSChannelViewController *)[channelStoryboard instantiateInitialViewController];
    [self addChildViewController: self.channelViewController];
    [self.view addSubview:self.channelViewController.view];
    self.channelViewController.view.autoresizesSubviews = YES;
=======
>>>>>>> 224fcec4218ad9f0592fb27dee747f2d01d253bb
}

#pragma mark - ECSlidingViewController Delegate
-(void)anchorRight
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

-(void)anchorLeft
{
    [self.slidingViewController anchorTopViewToLeftAnimated:YES];
}

-(void) configureSlidingMenu
{
    NSDictionary *transitionData = self.transitions.all[2];
    id<ECSlidingViewControllerDelegate> transition = transitionData[@"transition"];
    if (transition == (id)[NSNull null]) {
        self.slidingViewController.delegate = nil;
    } else {
        self.slidingViewController.delegate = transition;
    }
    
    self.transitions.dynamicTransition.slidingViewController = self.slidingViewController;
    self.slidingViewController.underLeftViewController = [[UIStoryboard storyboardWithName:@"leftPanel" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"OSLeftPanelViewController"];
    self.slidingViewController.underRightViewController = [[UIStoryboard storyboardWithName:@"rightPanel" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"OSRightPanelViewController"];
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateCenterViewController: (NSNotification *)notif
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    NSString *storyboardName = (NSString *)notif.object;
    if ( [storyboardName isEqualToString:kSearchTab]) {//display search view
        UIStoryboard *searchStoryboary = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
        self.searchViewController = (OSSearchViewController *)[searchStoryboary instantiateInitialViewController];
        [self addChildViewController: self.searchViewController];
        [self.view addSubview:self.searchViewController.view];
        self.searchViewController.view.autoresizesSubviews = YES;
        
    }else if ([storyboardName isEqualToString:kAskQuestionTab]){//display ask question view
        UIStoryboard *askQuestionStoryboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
        self.askQuestioinViewController = (OSAskQuestionViewController *)[askQuestionStoryboard instantiateInitialViewController];[self addChildViewController: self.askQuestioinViewController];
        [self.view addSubview:self.askQuestioinViewController.view];
        self.askQuestioinViewController.view.autoresizesSubviews = YES;
    
    }else if ([storyboardName isEqualToString:kCreateChannelTab]){//display create channel view
        UIStoryboard *createChannelStoryboary = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
        self.createChannelViewController = (OSCreateChannelViewController *)[createChannelStoryboary instantiateInitialViewController];
        [self addChildViewController: self.createChannelViewController];
        [self.view addSubview:self.createChannelViewController.view];
        self.createChannelViewController.view.autoresizesSubviews = YES;
        
    }else if ([storyboardName isEqualToString:kInvitePeople]){//display invite view
        UIStoryboard *createChannelStoryboary = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
        self.inviteViewController = (OSInviteViewController *)[createChannelStoryboary instantiateInitialViewController];
        [self addChildViewController: self.inviteViewController];
        [self.view addSubview:self.inviteViewController.view];
        self.inviteViewController.view.autoresizesSubviews = YES;
        
    }else if ([storyboardName isEqualToString:kChannelTab]){//display channel view
        UIStoryboard *channelStoryboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
        self.channelViewController = (OSChannelViewController *)[channelStoryboard instantiateInitialViewController];
        [self addChildViewController: self.channelViewController];
        [self.view addSubview:self.channelViewController.view];
        [_titleBtn setTitle:[OSSession getInstance].currentChannel.channelName forState:UIControlStateNormal];
        self.channelViewController.view.autoresizesSubviews = YES;
        _isRoom = false;
        
    }else if ([storyboardName isEqualToString:kRoomTab]){//display room view
        UIStoryboard *roomStoryboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
        self.roomViewController = (OSRoomViewController *)[roomStoryboard instantiateInitialViewController];
        [self addChildViewController: self.roomViewController];
        [self.view addSubview:self.roomViewController.view];
        self.roomViewController.view.autoresizesSubviews = YES;
         [_titleBtn setTitle:[OSSession getInstance].currentRoom.title forState:UIControlStateNormal];
        _isRoom = true;
        
    }else if ([storyboardName isEqualToString:kInboxTab]){//display inbox view
        UIStoryboard *inboxStoryboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
        self.inboxViewController = (OSInboxViewController *)[inboxStoryboard instantiateInitialViewController];
        [self addChildViewController: self.inboxViewController];
        [self.view addSubview:self.inboxViewController.view];
        self.inboxViewController.view.autoresizesSubviews = YES;
        
    } else if([storyboardName isEqualToString:kSettingsTab]) {//display setting view
        UIStoryboard *settingStoryboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
        self.settingViewController = (OSSettingViewController *)[settingStoryboard instantiateInitialViewController];
        [self addChildViewController: self.settingViewController];
        [self.view addSubview:self.settingViewController.view];
        self.settingViewController.view.autoresizesSubviews = YES;

    } else if([storyboardName isEqualToString:kInvitePeople]) {
        UIStoryboard *settingStoryboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
        self.inviteViewController = (OSInviteViewController *)[settingStoryboard instantiateInitialViewController];
        [self addChildViewController: self.inviteViewController];
        [self.view addSubview:self.inviteViewController.view];
        self.inviteViewController.view.autoresizesSubviews = YES;
        
    } else if ([storyboardName isEqualToString:kUploadPhoto]){
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc]init];
        imgPicker.delegate = self;
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
        
    } else if ([storyboardName isEqualToString:kShareViaBox]){
        UIStoryboard *shareBox = [UIStoryboard storyboardWithName:kShareViaBox bundle:[NSBundle mainBundle]];
        self.boxNavigationController = (BoxNavigationController *)[shareBox instantiateInitialViewController];
        [self addChildViewController: self.boxNavigationController];
        [self.view addSubview:self.boxNavigationController.view];
        self.boxNavigationController.view.autoresizesSubviews = YES;
    }
}

/*Photo selection*/
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self saveImage:image withName:@"currentImage.png"];
#warning should call box api to upload photo to opensilo box account without login
}

- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPath atomically:NO];
}

-(void) uploadToBox
{
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    BoxFileBlock fileBlock = ^(BoxFile *file)
    {
        // manipulate resulting BoxFile
    };
    
    BoxAPIJSONFailureBlock failureBlock = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary)
    {
        // handle failed upload
    };
    
    BoxAPIMultipartProgressBlock progressBlock = ^(unsigned long long totalBytes, unsigned long long bytesSent)
    {
        // indicate progress of upload
    };
    
    BoxFilesRequestBuilder *builder = [[BoxFilesRequestBuilder alloc] init];
    builder.name = @"icon.png";
    builder.parentID = @"2309297463";

    NSInputStream *inputStream = [NSInputStream inputStreamWithFileAtPath:path];
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    long long contentLength = [[fileAttributes objectForKey:NSFileSize] longLongValue];
    
    [[BoxSDK sharedSDK].filesManager uploadFileWithInputStream:inputStream contentLength:contentLength MIMEType:nil requestBuilder:builder success:fileBlock failure:failureBlock progress:progressBlock];
}

#pragma mark - Properties

- (METransitions *)transitions {
    if (_transitions) return _transitions;
    
    _transitions = [[METransitions alloc] init];
    
    return _transitions;
}

-(void) onClickSearch
{
    UIStoryboard *entrance = [UIStoryboard storyboardWithName:kSearchTab bundle:[NSBundle mainBundle]];
    OSSearchViewController *viewController = [entrance instantiateViewControllerWithIdentifier:@"OSSearchViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) onClickDropDown
{
    
    OSViewController *viewController;
    
    if (_inSettingView==NO) {

        if(_isRoom){
  
        UIStoryboard *roomSetting = [UIStoryboard storyboardWithName:@"RoomSettings" bundle:[NSBundle mainBundle]];
        viewController = [roomSetting instantiateViewControllerWithIdentifier:@"OSRoomSettingViewController"];
        _inSettingView = YES;
        
    } else{
        
        UIStoryboard *roomSetting = [UIStoryboard storyboardWithName:@"ChannelSettings" bundle:[NSBundle mainBundle]];
        viewController = [roomSetting instantiateViewControllerWithIdentifier:@"OSChannelSettingViewController"];
        _inSettingView = YES;
    }
        [self.navigationController pushViewController:viewController animated:NO];

    }else {
        
        [self.navigationController popViewControllerAnimated:NO];
        _inSettingView = NO;
    }
    
}

@end
