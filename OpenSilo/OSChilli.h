//
//  OSChilli.h
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/15/14.
//  Copyright (c) 2014 OpenSilo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface OSChilli : MTLModel

@property (nonatomic, weak) NSString *chilliId;
@property (nonatomic, weak) NSString *userId;
@property (nonatomic, assign, getter = isChilli) BOOL chilli;
@property (nonatomic, weak) NSString *timestamp;

@end
