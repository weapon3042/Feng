//
//  OSLeftPanelViewController.h
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/9/14.
//  Copyright (c) 2014 OpenSilo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "UIViewController+ECSlidingViewController.h"

@interface OSLeftPanelViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,ECSlidingViewControllerDelegate>


@end
