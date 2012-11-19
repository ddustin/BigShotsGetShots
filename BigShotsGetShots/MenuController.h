//
//  MenuController.h
//  BigShotsGetShots
//
//  Created by Dustin Dettmer on 11/15/12.
//  Copyright (c) 2012 Dusty Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuControllerDelegate <NSObject>

- (void)loadResource:(NSString*)resource;

@end

@interface MenuController : UIViewController

@property (nonatomic, weak) id<MenuControllerDelegate> delegate;

@property (nonatomic, assign) int curChapter;

@end
