//
//  OSSession.m
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/15/14.
//  Copyright (c) 2014 OpenSilo Inc. All rights reserved.
//

#import "OSSession.h"

@implementation OSSession

+ (OSSession *)getInstance {
    static OSSession *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[OSSession alloc] init];
    });
    
    return _sharedInstance;
}

@end
