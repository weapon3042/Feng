//
//  OSPostRequest.m
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 14-7-18.
//  Copyright (c) 2014 OpenSilo Inc. All rights reserved.
//

#import "OSPostRequest.h"
#import "OSDataManger.h"
#import "OSWebServiceMacro.h"
#import "OSSession.h"

@implementation OSPostRequest

- (void)postApiRequest:(NSString*)path params:(NSDictionary *)params setAuthHeader:(BOOL)setAuthHeader responseBlock:(OSAPIResponseBlock)responseBlock
{
    OSDataManger *urlSession = [OSDataManger sharedManager];
    [urlSession setRequestSerializer:[AFJSONRequestSerializer new]];
    
    if(setAuthHeader)
        [urlSession.requestSerializer setValue:[OSSession getInstance].token forHTTPHeaderField:@"Authorization"];
        [urlSession.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    
        if (params) {
            NSMutableString *requestJson=[[NSMutableString alloc]initWithFormat:@"{"];
            for (NSString *key in params.allKeys) {
                [requestJson appendString:[NSString stringWithFormat:@"\"%@\":\"%@\",",key,[params valueForKey:key]]];
            }
            [requestJson deleteCharactersInRange:NSMakeRange(requestJson.length-1,1)];
            [requestJson appendString:@"}"];
            NSLog(@"%@", requestJson);
        }
    
        [urlSession POST:path parameters:params constructingBodyWithBlock:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        if (responseBlock) responseBlock(responseObject, nil);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

}



@end
