//
//  OSPeopleTableViewCell.h
//  OpenSilo
//
//  Created by Peng Wan on 7/19/14.
//  Copyright (c) 2014 OpenSilo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OSPeopleTableViewCell : UITableViewCell
    
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *thumbProgressView;
@property (nonatomic, weak) IBOutlet UIImageView *pic;
@property (nonatomic, weak) IBOutlet UIImageView *status;
@property (nonatomic, weak) IBOutlet UILabel *jobTitle;
@property (nonatomic, weak) IBOutlet UILabel *fullName;

@end
