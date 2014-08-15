//
//  BoxRootViewController.m
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/16/14.
//  Copyright (c) 2014 OpenSilo. All rights reserved.
//

#import <BoxSDK/BoxSDK.h>

#import "BoxFolderViewController.h"
#import "OSUIMacro.h"
#import "OSAppDelegate.h"
#import "BoxNavigationController.h"
#import "OSConstant.h"
#import "OSToastUtils.h"
#import <APToast/UIView+APToast.h>


#define TABLE_CELL_REUSE_IDENTIFIER  @"Cell"
#define isNSNull(value) [value isKindOfClass:[NSNull class]]

#import "OSAppDelegate.h"
#import "BoxNavigationController.h"
#import "OSConstant.h"


#define TABLE_CELL_REUSE_IDENTIFIER  @"Cell"

@interface BoxFolderViewController ()

- (void)drillDownToFolderID:(NSString *)folderID name:(NSString *)name;
- (void)boxTokensDidRefresh:(NSNotification *)notification;
- (void)boxDidGetLoggedOut:(NSNotification *)notification;

@end

@implementation BoxFolderViewController

@synthesize folderItemsArray = _folderItemsArray;
@synthesize totalCount = _totalCount;
@synthesize folderID = _folderID;
@synthesize folderName = _folderName;

+ (instancetype)folderViewFromStoryboardWithFolderID:(NSString *)folderID folderName:(NSString *)folderName;
{

    NSString *storyboardName = kShareViaBox;

    BoxFolderViewController *folderViewController = (BoxFolderViewController *)[[UIStoryboard storyboardWithName:storyboardName bundle:nil] instantiateViewControllerWithIdentifier:@"FolderTableView"];

    folderViewController.folderID = folderID;
    folderViewController.folderName = folderName;

    return folderViewController;
}

- (void)viewDidLoad
{
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(tableViewDidPullToRefresh) forControlEvents:UIControlEventValueChanged];

    // Handle logged in
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(boxTokensDidRefresh:)
                                                name:BoxOAuth2SessionDidBecomeAuthenticatedNotification
                                            object:[BoxSDK sharedSDK].OAuth2Session];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(boxTokensDidRefresh:)
                                                name:BoxOAuth2SessionDidRefreshTokensNotification
                                            object:[BoxSDK sharedSDK].OAuth2Session];
    // Handle logout
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(boxDidGetLoggedOut:)
                                                name:BoxOAuth2SessionDidReceiveAuthenticationErrorNotification
                                            object:[BoxSDK sharedSDK].OAuth2Session];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(boxDidGetLoggedOut:)
                                                name:BoxOAuth2SessionDidReceiveRefreshErrorNotification
                                                object:[BoxSDK sharedSDK].OAuth2Session];

    if (self.folderID == nil)
    {
        self.folderID = BoxAPIFolderIDRoot;
        self.folderName = @"All Files";
    }

    self.navigationItem.title = self.folderName;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)boxTokensDidRefresh:(NSNotification *)notification
{
    BoxOAuth2Session *OAuth2Session = (BoxOAuth2Session *)notification.object;
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"%@,AccessToken: %@, RefreshToken: %@",@"Logout",OAuth2Session.accessToken, OAuth2Session.refreshToken);
    });
}

- (void)boxDidGetLoggedOut:(NSNotification *)notification
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        // clear old folder items
        self.folderItemsArray = [NSMutableArray array];
        [self.tableView reloadData];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self fetchFolderItemsWithFolderID:self.folderID name:self.folderName];
}

#pragma mark - UITableViewController refresh control
- (void)tableViewDidPullToRefresh
{
    [self fetchFolderItemsWithFolderID:self.folderID name:self.folderName];
}

#pragma mark - UITabableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOXAssert([indexPath row] < self.folderItemsArray.count, @"Table cell requested for row greater than number of items in folder");

    BoxItem *item = (BoxItem *)[self.folderItemsArray objectAtIndex:[indexPath row]];

    UITableViewCell *cell = (UITableViewCell  *)[self.tableView dequeueReusableCellWithIdentifier:TABLE_CELL_REUSE_IDENTIFIER];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TABLE_CELL_REUSE_IDENTIFIER];
    }
    [cell.textLabel setText:[NSString stringWithFormat:@"%@ - %@", item.type, item.name]];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![BoxSDK sharedSDK].OAuth2Session.isAuthorized)
    {
        return 0;
    }
    else
    {
        return self.folderItemsArray.count;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSString *IDToDelete = ((BoxModel *)[self.folderItemsArray objectAtIndex:indexPath.row]).modelID;
        NSString *typeToDelete = ((BoxModel *)[self.folderItemsArray objectAtIndex:indexPath.row]).type;

        BoxSuccessfulDeleteBlock success = ^(NSString *deletedID)
        {
            // refresh folder contents
            [self fetchFolderItemsWithFolderID:self.folderID name:self.navigationItem.title];
        };

        if ([typeToDelete isEqualToString:BoxAPIItemTypeFolder])
        {
            [self.refreshControl beginRefreshing];

            BoxFoldersRequestBuilder * builder = [[BoxFoldersRequestBuilder alloc] initWithRecursiveKey:YES];
            [[BoxSDK sharedSDK].foldersManager deleteFolderWithID:IDToDelete requestBuilder:builder success:success failure:nil];
        }
        else if ([typeToDelete isEqualToString:BoxAPIItemTypeFile])
        {
            [self.refreshControl beginRefreshing];
            [[BoxSDK sharedSDK].filesManager deleteFileWithID:IDToDelete requestBuilder:nil success:success failure:nil];
        }

    }
}

- (void)fetchFolderItemsWithFolderID:(NSString *)folderID name:(NSString *)name
{
    BoxCollectionBlock success = ^(BoxCollection *collection)
    {
        self.folderItemsArray = [NSMutableArray array];
        for (NSUInteger i = 0; i < collection.numberOfEntries; i++)
        {
            [self.folderItemsArray addObject:[collection modelAtIndex:i]];
        }
        self.totalCount = [collection.totalCount integerValue];

        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        });
    };
    BoxAPIJSONFailureBlock failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary)
    {
        NSLog(@"folder items error: %@", error);
    };

    [[BoxSDK sharedSDK].foldersManager folderItemsWithID:folderID requestBuilder:nil success:success failure:failure];
}

- (void)drillDownToFolderID:(NSString *)folderID name:(NSString *)name
{
    BoxFolderViewController *drillDownViewController = [BoxFolderViewController folderViewFromStoryboardWithFolderID:folderID folderName:name];

    [self.navigationController pushViewController:drillDownViewController animated:YES];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BoxItem *item = (BoxItem *)[self.folderItemsArray objectAtIndex:[indexPath row]];

    if ([item.type isEqualToString:BoxAPIItemTypeFolder])
    {
        [self drillDownToFolderID:item.modelID name:item.name];
    }
    else if ([item.type isEqualToString:BoxAPIItemTypeFile])
    {
        
        BoxFileBlock success = ^(BoxFile *file)
        {
            if(!isNSNull(file.sharedLink)){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Share" message:file.sharedLink[@"url"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Share link for this file is not available. Plese check the file share setting in your box account." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            if(file.sharedLink){
                
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"This file is no" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        };
        
        BoxAPIJSONFailureBlock failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *JSONDictionary)
        {
            // handle errors
        };
        
        [[BoxSDK sharedSDK].filesManager fileInfoWithID:item.modelID requestBuilder:nil success:success failure:failure];
        };
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
