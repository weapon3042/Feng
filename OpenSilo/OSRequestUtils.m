//
//  OSRequestUtils.m
//  OpenSilo
//
//  Created by peng wan on 7/17/14.
//  Copyright (c) 2014 OpenSilo Co. All rights reserved.
//

#import "OSRequestUtils.h"
#import "OSWebServiceMacro.h"

@implementation OSRequestUtils


+(NSMutableURLRequest *)contructHttpRequestWithURL:(NSString *)url andType:(NSString *)methodType andHeaders:(NSDictionary *) headers andParameters:(NSDictionary *)params
{
    
    NSURL * apiURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?",API_HOME,url]];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:apiURL];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [urlRequest setHTTPMethod:methodType];
    if ([methodType isEqualToString:@"GET"]) {
        if (nil!=headers) {
            for (NSString *key in headers.allKeys) {
                [urlRequest addValue:[headers valueForKey:key] forHTTPHeaderField:key];
            }
        }
    }
    if (nil!=params) {
        NSMutableString *requestJson=[[NSMutableString alloc]initWithFormat:@"{"];
        for (NSString *key in params.allKeys) {
            [requestJson appendString:[NSString stringWithFormat:@"\"%@\":\"%@\",",key,[params valueForKey:key]]];
        }
        [requestJson deleteCharactersInRange:NSMakeRange(requestJson.length-1,1)];
        [requestJson appendString:@"}"];
//        NSLog(@"%@", requestJson);
        [urlRequest setHTTPBody:[requestJson dataUsingEncoding:NSUTF8StringEncoding]];
    }
    return urlRequest;
}

@end
