//
//  OSDataManger.m
//  OpenSilo
//
//  Created by Elmir Kouliev on 7/16/14.
//  Copyright (c) 2014 OpenSilo, Inc. All rights reserved
//

#import "OSDataManger.h"
#import "OSWebServiceMacro.h"


@implementation OSDataManger

+ (OSDataManger *)sharedManager
{
    static OSDataManger *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSString *kBaseURLSession = API_HOME;
        manager = [[OSDataManger alloc] initWithBaseURL:[NSURL URLWithString:kBaseURLSession] sessionConfiguration:configuration];

    });
    return manager;
}

@end
