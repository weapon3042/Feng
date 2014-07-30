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

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *picture;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, weak) NSString *displayName;
@property (nonatomic, weak) NSString *role;
@property (nonatomic, weak) NSString *timezone;
@property (nonatomic, weak) NSDictionary *permissions;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *jobTitle;
@property (nonatomic, weak) NSString *department;
@property (nonatomic, weak) NSString *address;
@property (nonatomic, weak) NSString *lastSeen;

@property (nonatomic, assign) BOOL seenTutorial;
@property (nonatomic, weak) NSDictionary *skillTags;

@end
