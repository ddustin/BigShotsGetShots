//
//  UIDevice+UIDevice_Hardware.h
//  BigShotsGetShots
//
//  Created by Dustin Dettmer on 12/11/12.
//  Copyright (c) 2012 Dusty Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (UIDevice_Hardware)

- (NSString *) platform;

- (BOOL)iPhone;
- (BOOL)iPod;
- (BOOL)iPad;

- (NSString*)hardwareNumbers;
- (NSString*)hardwareDescription;

- (NSInteger)majorHardwareNumber;
- (NSInteger)minorHardwareNumber;

- (BOOL)isCrappy;

@end
