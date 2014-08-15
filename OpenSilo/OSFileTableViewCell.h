//
//  OSFileTableViewCell.h
//  OpenSilo
//
//  Created by Hshub on 8/14/14.
//  Copyright (c) 2014 IDesign Network Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OSFileTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *fileIcon;
@property (nonatomic, weak) IBOutlet UILabel *fileName;

@end
