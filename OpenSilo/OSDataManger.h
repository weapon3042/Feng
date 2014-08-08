//
//  OSDataManger.h
//  OpenSilo
//
//  Created by Elmir Kouliev on 7/16/14.
//  Copyright (c) 2014 OpenSilo, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef void(^OSAPIResponseBlock)(id responseObject, NSError *error);

@interface OSDataManger : AFHTTPSessionManager

+ (OSDataManger *)sharedManager;
+ (NSMutableURLRequest *)contructHttpRequestWithURL:(NSString *)url andType:(NSString *)methodType andParameters:(NSDictionary *)params andSetAuthHeader:(BOOL)setAuthHeader;

@end
