//
//  OSAppDelegate.m
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/8/14.
//  Copyright (c) 2014 OpenSilo Inc. All rights reserved.
//

#import "OSAppDelegate.h"
#import "OSSidePanelController.h"
#import "OSLoginViewController.h"

@implementation OSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setWindow:window];
    
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    OSLoginViewController *loginViewController = [loginStoryboard instantiateInitialViewController];
    
    OSSidePanelController *sidePanelController = [OSSidePanelController sharedSidePanelController];
    
    [sidePanelController setCenterPanel:loginViewController];
    
    
    [[self window] setRootViewController:sidePanelController];

    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark Register Token on server
/*
-(void)registerDevTokenOnServer {
    
    NSDictionary *parameters = @{@"userId": [NSString stringWithFormat:@"%zd",[[TiesUser getInstance] userId]],
                                 @"email": [[TiesUser getInstance] userEmail],
                                 @"targetUserId":[[TiesUser getInstance] deviceToken]};
    
    AFHTTPRequestOperationManager *client = [AFHTTPRequestOperationManager manager];
    client.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [client POST:[NSString stringWithFormat:@"%@user/registerDevice?",API_HOME] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[[responseObject objectForKey:@"ack"] lowercaseString] isEqualToString:@"success"]) {
            
        } else {
            [appDelegateMacro.window makeToast:[responseObject objectForKey:@"error"] backgroundColor:[UIColor redColor]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
 
}
*/

#pragma mark register for remote notification with device token
/*
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
   
     dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
     
     [self registerDevTokenOnServer];
     
     dispatch_async(dispatch_get_main_queue(), ^(void) {
     
     });
     });
}
 

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    for (id key in userInfo) {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
}
 
*/


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
