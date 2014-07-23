//
//  OSRequestUtils.h
//  OpenSilo
//
//  Created by peng wan on 7/17/14.
//  Copyright (c) 2014 OpenSilo Co. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^OSHttpResponseBlock)(NSData *data, NSURLResponse *response, NSError *error);

@interface OSRequestUtils : NSObject

-(void)httpRequestWithURL:(NSString *)url andType:(NSString *)methodType andAuthHeader:(BOOL) authHeader andParameters:(NSDictionary *) params andResponseBlock:(OSHttpResponseBlock)responseBlock;

@end
