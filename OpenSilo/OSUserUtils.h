//
//  OSUserUtils.h
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 8/1/14.
//  Copyright (c) 2014 OpenSilo Co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSUserUtils : NSObject
+ (OSUserUtils *)getInstance;
-(void) reloadAllUsers;
@end
