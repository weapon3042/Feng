//
//  OSGuidUtils.h
//  OpenSilo
//
//  Created by Hshub on 8/14/14.
//  Copyright (c) 2014 IDesign Network Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSGuidUtils : NSObject

+ (OSGuidUtils *)getInstance;

- (NSString *)createGuid;

@end
