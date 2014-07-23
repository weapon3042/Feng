//
//  OSToastUtils.h
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev  on 7/23/14.
//  Copyright (c) 2014 OpenSilo Co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSToastUtils : NSObject

+ (OSToastUtils *)getInstance;

-(UIView *)getToastMessage:(NSString *) message andType:(NSString *)type;

@end
