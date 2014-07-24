//
//  OSSidePanelController.h
//  OpenSilo
//
//  Created by Elmir Kouliev on 7/22/14.
//  Copyright (c) 2014 IDesign Network Inc. All rights reserved.
//

#import "JASidePanelController.h"

@interface OSSidePanelController : JASidePanelController

+ (instancetype)sharedSidePanelController;

+ (void)setSharedSidePanelController:(OSSidePanelController *)sidePanelController;

@end
