//
//  OSPostRequest.h
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 14-7-18.
//  Copyright (c) 2014 OpenSilo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^OSAPIResponseBlock)(id responseObject, NSError *error);

@interface OSPostRequest : NSObject

- (void)postApiRequest:(NSString*)path params:(NSDictionary *)params setAuthHeader:(BOOL)setAuthHeader responseBlock:(OSAPIResponseBlock)responseBlock;


@end
