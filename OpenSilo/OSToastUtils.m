//
//  OSToastUtils.m
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev  on 7/23/14.
//  Copyright (c) 2014 OpenSilo Co. All rights reserved.
//

#import "OSToastUtils.h"
#import "OSUIMacro.h"

@implementation OSToastUtils
+ (OSToastUtils *)getInstance
{
    static OSToastUtils *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[OSToastUtils alloc] init];
        
    });
    return manager;
}

-(UIView *)getToastMessage:(NSString *) message andType:(NSString *)type
{
    UIView *customToastView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 280, 44)];
    customToastView.backgroundColor = ([type isEqualToString:TOAST_SUC]?[UIColor colorWithRed:0.0 green:255.0 blue:0.0 alpha:0.8]:[UIColor colorWithRed:255.0 green:0.0 blue:0.0 alpha:0.8]);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 280, 44)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.text = message;
    [customToastView addSubview:label];
    [customToastView.layer setMasksToBounds:YES];
    [customToastView.layer setCornerRadius:5.0];
    return customToastView;
}
@end
