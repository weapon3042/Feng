//
//  OSRequestUtils.h
//  OpenSilo
//
//  Created by peng wan on 7/17/14.
//  Copyright (c) 2014 OpenSilo Co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSRequestUtils : NSObject

+(NSMutableURLRequest *)contructHttpRequestWithURL:(NSString *)url andType:(NSString *)methodType andHeaders:(NSDictionary *) headers andParameters:(NSDictionary *)params;

@end
