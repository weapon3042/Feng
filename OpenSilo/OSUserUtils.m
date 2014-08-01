//
//  OSUserUtils.m
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 8/1/14.
//  Copyright (c) 2014 OpenSilo Co. All rights reserved.
//

#import "OSUserUtils.h"
#import "OSGetRequest.h"
#import "OSSession.h"

@implementation OSUserUtils
+ (OSUserUtils *)getInstance
{
    static OSUserUtils *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[OSUserUtils alloc] init];
        
    });
    return manager;
}

-(void) reloadAllUsers
{
    OSGetRequest *request = [[OSGetRequest alloc]init];
    [request getApiRequest:[NSString stringWithFormat:@"api/users"] params:nil setAuthHeader:YES responseBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSArray *array = responseObject[@"result"];
            NSMutableDictionary *allUsers = [[NSMutableDictionary alloc]init];
            for (NSDictionary *dict in array) {
                [allUsers setObject:dict forKey:dict[@"user_id"]];
            }
            
            [[OSSession getInstance] setAllUsers:allUsers];
            //            NSLog(@"%@",allUsers);
        }
    }];
}
@end
