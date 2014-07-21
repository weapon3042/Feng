//
//  OSGetRequest.m
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 14-7-18.
//  Copyright (c) 2014年 OpenSilo Inc. All rights reserved.
//

#import "OSGetRequest.h"
#import "OSDataManger.h"
#import "OSWebServiceMacro.h"

@implementation OSGetRequest

- (void)getApiRequest:(NSString*)path params:(NSDictionary *)params setAuthHeader:(BOOL)setAuthHeader responseBlock:(OSAPIResponseBlock)responseBlock
{
    
    OSDataManger *urlSession = [OSDataManger sharedManager];
    [urlSession setRequestSerializer:[AFJSONRequestSerializer new]];
    
    if(setAuthHeader)
        [urlSession.requestSerializer setValue:TestToken forHTTPHeaderField:@"Authorization"];
    
    [urlSession.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    
    [urlSession GET:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (responseBlock) responseBlock(responseObject, nil);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }];

    
    
}


@end