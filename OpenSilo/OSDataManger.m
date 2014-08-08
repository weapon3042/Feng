//
//  OSDataManger.m
//  OpenSilo
//
//  Created by Elmir Kouliev on 7/16/14.
//  Copyright (c) 2014 OpenSilo, Inc. All rights reserved
//

#import "OSDataManger.h"
#import "OSWebServiceMacro.h"
#import "OSSession.h"

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

+(NSMutableURLRequest *)contructHttpRequestWithURL:(NSString *)url andType:(NSString *)methodType andParameters:(NSDictionary *)params andsetAuthHeader:(BOOL)setAuthHeader

{
    
    NSURL * apiURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?",API_HOME,url]];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:apiURL];
    
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    
    if ([methodType isEqualToString:@"GET"]) {
        
        methodType = @"POST";
        
        [urlRequest addValue:[OSSession getInstance].token forHTTPHeaderField:@"Authorization"];
        
    }
    
    [urlRequest setHTTPMethod:methodType];
    
    if (nil!=params) {
        
        NSMutableString *requestJson=[[NSMutableString alloc]initWithFormat:@"{"];
        
        for (NSString *key in params.allKeys) {
            
            [requestJson appendString:[NSString stringWithFormat:@"\"%@\":\"%@\",",key,[params valueForKey:key]]];
            
        }
        
        [requestJson deleteCharactersInRange:NSMakeRange(requestJson.length-1,1)];
        
        [requestJson appendString:@"}"];
        
        NSLog(@"%@", requestJson);
        
        [urlRequest setHTTPBody:[requestJson dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    
    return urlRequest;
    
}

@end
