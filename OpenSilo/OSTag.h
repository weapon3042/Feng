//
//  OSTag.h
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/15/14.
//  Copyright (c) 2014 OpenSilo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface OSTag : MTLModel

@property (nonatomic, weak) NSString* tagId;
@property (nonatomic, weak) NSString* TagName;

@end
