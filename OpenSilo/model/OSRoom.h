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

@property (nonatomic, strong) NSString *roomId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *fireBaseId;
@property (nonatomic, weak) NSString *description;
@property (nonatomic, weak) NSString *snippet;
@property (nonatomic, weak) NSString *status;
@property (nonatomic, weak) NSString *createTime;
@property (nonatomic, weak) NSString *resolvedTime;
@property (nonatomic, weak) NSArray *tags;
@property (nonatomic, weak) NSArray *experts;
@property (nonatomic, weak) NSArray *helpfulExperts;
@property (nonatomic, weak) NSArray *invitedUsers;
@property (nonatomic, weak) NSString *ownerId;
@property (nonatomic, weak) NSArray *files;
@property (nonatomic, weak) NSArray *settings;
@property (nonatomic, assign, getter = isDeleted) BOOL deleted;
@property (nonatomic, assign, getter = isResolved) BOOL resolved;
@property (nonatomic, weak) NSArray *messages;
@property (nonatomic, weak) NSNumber *favoriteCount;

@end
