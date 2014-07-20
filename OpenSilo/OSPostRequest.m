//
//  OSPostRequest.m
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 14-7-18.
//  Copyright (c) 2014年 OpenSilo Inc. All rights reserved.
//

#import "OSPostRequest.h"
#import "OSDataManger.h"
#import "OSWebServiceMacro.h"

@implementation OSPostRequest


- (void)postApiRequest:(NSString*)path params:(NSDictionary *)params setAuthHeader:(BOOL)setAuthHeader responseBlock:(OSAPIResponseBlock)responseBlock
{
    OSDataManger *urlSession = [OSDataManger sharedManager];
    [urlSession setRequestSerializer:[AFJSONRequestSerializer new]];
    
    if(setAuthHeader)
        [urlSession.requestSerializer setValue:TestToken forHTTPHeaderField:@"Authorization"];
    [urlSession.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-type"];

    [urlSession POST:path parameters:params constructingBodyWithBlock:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        if (responseBlock) responseBlock(responseObject, nil);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

}
@end
