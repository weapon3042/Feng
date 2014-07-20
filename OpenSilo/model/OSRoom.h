//
//  OSRoom.h
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/15/14.
//  Copyright (c) 2014 OpenSilo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface OSRoom : NSObject

@property (nonatomic, weak) NSString *roomId;
@property (nonatomic, weak) NSString *title;
@property (nonatomic, weak) NSString *description;
@property (nonatomic, weak) NSString *snippet;
@property (nonatomic, weak) NSString *status;
@property (nonatomic, weak) NSArray *tags;
@property (nonatomic, weak) NSArray *experts;
@property (nonatomic, weak) NSArray *helpfulExperts;
@property (nonatomic, weak) NSArray *invitedUsers;
@property (nonatomic, weak) NSString *ownerId;
@property (nonatomic, weak) NSArray *files;
@property (nonatomic, weak) NSArray *settings;
@property (nonatomic, assign, getter = isDeleted) BOOL *deleted;
@property (nonatomic, weak) NSArray *messages;
@property (nonatomic, weak) NSNumber *favoriteCount;

@end
