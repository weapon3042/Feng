//
//  OSSession.h
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/15/14.
//  Copyright (c) 2014 OpenSilo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "OSUser.h"
#import "OSChannel.h"

@interface OSSession : MTLModel

+ (OSSession *)getInstance;

@property (nonatomic, strong) OSUser *user;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSArray *favoriteRooms;
@property (nonatomic, strong) OSChannel *currentChannel;
@end
