//
//  OSChannel.m
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/15/14.
//  Copyright (c) 2014 OpenSilo Inc. All rights reserved.
//

#import "OSChannel.h"

@implementation OSChannel

+ (NSDictionary *)externalRepresentationKeyPathsByPropertyKey {
    return [super.externalRepresentationKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:@{
        @"channelId": @"id",
        @"channelName" : @"channel_name",
        @"ownerId" : @"owner_user_id",
        @"status" : @"large_path",
        @"boxFolderId" : @"box_folder_id",
        @"privacySetting" : @"privacy_setting",
        @"users" : @"users",
        @"files" : @"files",
        @"fireBaseId" : @"firebase_channel_name"
    }];
}


@end
