//
//  OSMessage.h
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/15/14.
//  Copyright (c) 2014 OpenSilo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface OSMessage : MTLModel

@property (nonatomic, weak) NSString *messageId;
@property (nonatomic, weak) NSString *userId;
@property (nonatomic, weak) NSString *timestamp;
@property (nonatomic, weak) NSString *text;
@property (nonatomic, weak) NSArray *chillis;

@end
