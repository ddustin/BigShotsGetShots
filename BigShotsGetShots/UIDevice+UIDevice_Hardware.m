//
//  UIDevice+UIDevice_Hardware.m
//  BigShotsGetShots
//
//  Created by Dustin Dettmer on 12/11/12.
//  Copyright (c) 2012 Dusty Technologies. All rights reserved.
//

#import "UIDevice+UIDevice_Hardware.h"
#import <sys/sysctl.h>

@implementation UIDevice (UIDevice_Hardware)
/*
 Platforms
 iPhone1,1 -> iPhone 2G
 iPhone1,2 -> iPhone 3G
 iPhone2,1 -> iPhone 3GS
 iPhone3,1 -> iPhone 4 GSM
 iPhone3,3 -> iPhone 4 CDMA
 iPhone4,1 -> iPhone 4S
 iPod1,1   -> iPod touch 1G
 iPod2,1   -> iPod touch 2G
 iPod3,1   -> iPod touch 3G
 iPad1,1   -> iPad (Wifi or GSM)
 iPad2,1   -> iPad 2 Wifi
 iPad2,2   -> iPad 2 GSM
 iPad2,3   -> iPad 2 CDMA
 */

- (NSString *) platform
{
    static NSString *platform = nil;
    
    if(platform)
        return platform;
    
	size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

- (BOOL)iPhone
{
    return [self.platform hasPrefix:@"iPhone"];
}

- (BOOL)iPod
{
    return [self.platform hasPrefix:@"iPod"];
}

- (BOOL)iPad
{
    return [self.platform hasPrefix:@"iPad"];
}

- (NSString*)hardwareNumbers
{
    if(self.iPhone)
        return [self.platform substringFromIndex:6];
    
    if(self.iPod)
        return [self.platform substringFromIndex:4];
    
    if(self.iPad)
        return [self.platform substringFromIndex:4];
    
    return nil;
}

- (NSInteger)majorHardwareNumber
{
    NSArray *ary = [self.hardwareNumbers componentsSeparatedByString:@","];
    
    if(ary.count)
        return [[ary objectAtIndex:0] integerValue];
    
    return 0;
}

- (NSInteger)minorHardwareNumber
{
    NSArray *ary = [self.hardwareNumbers componentsSeparatedByString:@","];
    
    if(ary.count > 1)
        return [[ary objectAtIndex:1] integerValue];
    
    return 0;
}

- (NSString*)hardwareDescription
{
    if(self.iPhone)
        return [NSString stringWithFormat:@"iPhone%d,%d",
                self.majorHardwareNumber, self.minorHardwareNumber];
    
    if(self.iPod)
        return [NSString stringWithFormat:@"iPod%d,%d",
                self.majorHardwareNumber, self.minorHardwareNumber];
    
    if(self.iPad)
        return [NSString stringWithFormat:@"iPad%d,%d",
                self.majorHardwareNumber, self.minorHardwareNumber];
    
    return [NSString stringWithFormat:@"Hardware Unrecognized: %@, %@",
            self.platform, self.description];
}

- (BOOL)isCrappy
{
    if(self.iPhone) {
        
        if(self.majorHardwareNumber < 4)
            return YES;
        
        return NO;
    }
    
    if(self.iPod) {
        
        if(self.majorHardwareNumber < 3)
            return YES;
        
        return NO;
    }
    
    if(self.iPad) {
        
        if(self.majorHardwareNumber < 2)
            return YES;
        
        return NO;
    }
    
    return NO;
}

@end
