//
//  OSTranscriptTableViewCell.h
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/22/14.
//  Copyright (c) 2014 OpenSilo Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OSTranscriptTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *thumbProgressView;
@property (nonatomic, weak) IBOutlet UIImageView *pic;
@property (nonatomic, weak) IBOutlet UIImageView *status;
@property (nonatomic, weak) IBOutlet UILabel *messageTime;
@property (nonatomic, weak) IBOutlet UILabel *message;
@property (nonatomic, weak) IBOutlet UILabel *fullName;

@end
