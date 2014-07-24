//
//  OSSidePanelController.m
//  OpenSilo
//
//  Created by Elmir Kouliev on 7/22/14.
//  Copyright (c) 2014 IDesign Network Inc. All rights reserved.
//

#import "OSSidePanelController.h"

@implementation OSSidePanelController

#pragma mark - "Singleton"

static OSSidePanelController *sharedSidePanelController = nil;

+ (instancetype)sharedSidePanelController
{
    if (!sharedSidePanelController) {
        sharedSidePanelController = [[OSSidePanelController alloc] init];
    }
    return sharedSidePanelController;
}

+ (void)setSharedSidePanelController:(OSSidePanelController *)sidePanelController
{
    sharedSidePanelController = sidePanelController;
}

#pragma mark - object lifecycle

- (id)init
{
    if (self = [super init]) {
        [super setPanningLimitedToTopViewController:NO];
        [super setPushesSidePanels:YES];
   
        [super setBounceOnCenterPanelChange:NO];
        [super setBounceOnSidePanelClose:NO];
        [super setBounceOnSidePanelOpen:NO];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

}

#pragma mark - style


- (void)styleContainer:(UIView *)container animate:(BOOL)animate duration:(NSTimeInterval)duration {
    //don't call super -- it adds a shadow
}



#pragma mark - rotation

- (BOOL)shouldAutorotate
{
    return [[self centerPanel] shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return [[self centerPanel] supportedInterfaceOrientations];
}

#pragma mark - status bar


- (BOOL)prefersStatusBarHidden
{
    return [[self centerPanel] prefersStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [[self centerPanel] preferredStatusBarStyle];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return [[self centerPanel] preferredStatusBarUpdateAnimation];
}

@end