//
//  OSGuidUtils.m
//  OpenSilo
//
//  Created by Hshub on 8/14/14.
//  Copyright (c) 2014 IDesign Network Inc. All rights reserved.
//

#import "OSGuidUtils.h"

@implementation OSGuidUtils

+ (OSGuidUtils *)getInstance
{
    static OSGuidUtils *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[OSGuidUtils alloc] init];
        
    });
    return manager;
}

- (NSString *)createGuid
{
    NSUUID  *UUID = [NSUUID UUID];
    return[UUID UUIDString];
}

@end
