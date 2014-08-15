<<<<<<< HEAD

//  BoxSDKSampleApp
//
//  Created on 2/19/13.
//  Copyright (c) 2013 Box. All rights reserved.

=======
//
//  BoxRootViewController.h
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/16/14.
//  Copyright (c) 2014 OpenSilo. All rights reserved.
//
>>>>>>> 44457b6a0d7a9eb888cb8a548537db849ddd11cf

#import <UIKit/UIKit.h>

#define IS_IPAD() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@interface BoxFolderViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, readwrite, strong) NSMutableArray *folderItemsArray;
@property (nonatomic, readwrite, assign) NSInteger totalCount;
@property (nonatomic, readwrite, strong) NSString *folderID;
@property (nonatomic, readwrite, strong) NSString *folderName;

+ (instancetype)folderViewFromStoryboardWithFolderID:(NSString *)folderID folderName:(NSString *)folderName;

- (void)fetchFolderItemsWithFolderID:(NSString *)folderID name:(NSString *)name;
- (void)tableViewDidPullToRefresh;

@end
