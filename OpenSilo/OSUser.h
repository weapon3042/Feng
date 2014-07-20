//
//  OSUser.h
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/15/14.
//  Copyright (c) 2014 OpenSilo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface OSUser : MTLModel

@property (nonatomic, weak) NSString *userId;
@property (nonatomic, weak) NSString *email;
@property (nonatomic, weak) NSString *status;
@property (nonatomic, weak) NSString *picture;
@property (nonatomic, weak) NSString *firstName;
@property (nonatomic, weak) NSString *lastName;
@property (nonatomic, weak) NSString *displayName;
@property (nonatomic, weak) NSString *role;
@property (nonatomic, weak) NSString *timezone;
@property (nonatomic, weak) NSDictionary *permissions;
@property (nonatomic, weak) NSString *company;
@property (nonatomic, weak) NSString *jobTitle;
@property (nonatomic, weak) NSString *department;
@property (nonatomic, weak) NSString *address;
@property (nonatomic, weak) NSString *lastSeen;

@property (nonatomic, assign) BOOL seenTutorial;
@property (nonatomic, weak) NSDictionary *skillTags;

@end
