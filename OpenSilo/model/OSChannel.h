//
//  OSChannel.h
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/15/14.
//  Copyright (c) 2014 OpenSilo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface OSChannel : MTLModel

@property (nonatomic, strong) NSString *channelId;
@property (nonatomic, strong) NSString *channelName;
@property (nonatomic, weak) NSString *ownerId;
@property (nonatomic, weak) NSString *status;
@property (nonatomic, weak) NSString *boxFolderId;
@property (nonatomic, weak) NSString *privacySetting;
@property (nonatomic, weak) NSArray *users;
@property (nonatomic, weak) NSArray *files;
@property (nonatomic, weak) NSString *fireBaseId;

@end
