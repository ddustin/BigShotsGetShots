//
//  AppDelegate.m
//  BigShotsGetShots
//
//  Created by Dustin Dettmer on 11/8/12.
//  Copyright (c) 2012 Dusty Technologies. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SVGDocumentView.h"
#import "ViewController.h"
#import "BWQuincyManager.h"
#import <AVFoundation/AVAudioSession.h>

@interface AppDelegate()

@property (nonatomic, strong) ViewController *viewController;

@property (nonatomic, strong) NSMutableArray *detailNames;

@property (nonatomic, assign) NSInteger index;

@end

@implementation AppDelegate
@synthesize window = _window;
@synthesize viewController;
@synthesize detailNames;
@synthesize index;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[BWQuincyManager sharedQuincyManager] setAutoSubmitCrashReport:YES];
    [[BWQuincyManager sharedQuincyManager] setSubmissionURL:@"http://www.agileordering.com/quincy/crash_v200.php"];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    srand(time(0));
    
    self.viewController = [ViewController new];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.rootViewController = self.viewController;
    [self.window addSubview:self.viewController.view];
    
    self.viewController.detailItem = @"pg1";
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
