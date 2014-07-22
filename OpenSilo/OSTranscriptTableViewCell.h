//
//  OSTranscriptTableViewCell.h
//  OpenSilo
//
//  Created by Kelvin Lam on 7/22/14.
//  Copyright (c) 2014 IDesign Network Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OSTranscriptTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *thumbProgressView;
@property (nonatomic, weak) IBOutlet UIImageView *pic;
@property (nonatomic, weak) IBOutlet UILabel *messageTime;
@property (nonatomic, weak) IBOutlet UILabel *message;
@property (nonatomic, weak) IBOutlet UILabel *fullName;

@end
