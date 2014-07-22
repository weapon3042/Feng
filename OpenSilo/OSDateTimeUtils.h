//
//  OSDateTimeUtils.h
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/15/14.
//  Copyright (c) 2014 OpenSilo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSDateTimeUtils : NSObject

+ (OSDateTimeUtils *)getInstance;

-(NSString *)dateTimeDifference:(NSString *)dateString;

-(NSString *)convertDateTimeFromUTCtoLocalForDateTime:(long)timestamp;

-(NSString *)convertDateTimeFromUTCtoLocalWithFormat:(NSString *)fromDateTimeFormat toDateTimeFormat:(NSString *)toDateTimeFormat forDateTime:(NSString *)forDateTime;

-(NSString *)convertDateTimeFromLocalToUTCWithFormat:(NSString *)fromDateTimeFormat toDateTimeFormat:(NSString *)toDateTimeFormat forDateTime:(NSString *)forDateTime;
@end
