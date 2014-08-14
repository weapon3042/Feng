//
//  OSRequestUtils.m
//  OpenSilo
//
//  Created by peng wan on 7/17/14.
//  Copyright (c) 2014 OpenSilo Co. All rights reserved.
//

#import "OSRequestUtils.h"
#import "OSWebServiceMacro.h"
#import "OSSession.h"

@implementation OSRequestUtils


-(void)httpRequestWithURL:(NSString *)url andType:(NSString *)methodType andAuthHeader:(BOOL) authHeader andParameters:(NSDictionary *)params andResponseBlock:(OSHttpResponseBlock)responseBlock;
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];

    NSURL * apiURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?",API_HOME,url]];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:apiURL];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [urlRequest setHTTPMethod:methodType];
    if (authHeader) {
        NSString *token = [OSSession getInstance].token;
        [urlRequest addValue:token forHTTPHeaderField:@"Authorization"];
    }
    if (params) {
        NSMutableString *requestJson=[[NSMutableString alloc]initWithFormat:@"{"];
        for (NSString *key in params.allKeys) {
            [requestJson appendString:[NSString stringWithFormat:@"\"%@\":\"%@\",",key,[params valueForKey:key]]];
        }
        [requestJson deleteCharactersInRange:NSMakeRange(requestJson.length-1,1)];
        [requestJson appendString:@"}"];
        //        NSLog(@"%@", requestJson);
        [urlRequest setHTTPBody:[requestJson dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                            if (responseBlock) responseBlock(data, response, nil);
                                                       }];
    [dataTask resume];
}

@end
