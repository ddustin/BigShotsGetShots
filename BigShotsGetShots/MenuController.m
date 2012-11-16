//
//  MenuController.m
//  BigShotsGetShots
//
//  Created by Dustin Dettmer on 11/15/12.
//  Copyright (c) 2012 Dusty Technologies. All rights reserved.
//

#import "MenuController.h"
#import "SVGKit.h"
#import "CALayerExporter.h"
#import "CALayerCamera.h"

@interface MenuController ()

@property (nonatomic, strong) SVGDocument *uiElements;

@end

@implementation MenuController
@synthesize uiElements;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.uiElements = [SVGDocument documentNamed:@"UI_pablo-NH-v3"];
        
        CALayer *layer = [self.uiElements layerWithIdentifier:@"menu bar"];
        
        layer.affineTransform = CGAffineTransformMakeScale(0.5f, 0.5f);
        
        CGPoint position;
        
        position.x = 480 / 2;
        position.y = 320 - layer.frame.size.height / 2;
        
        layer.position = position;
        
        [self.view.layer insertSublayer:layer atIndex:0];
        
        CALayer *shell = [self.uiElements layerWithIdentifier:@"Shell-btn-normal"];
        
        shell.affineTransform = CGAffineTransformMakeScale(0.5f, 0.5f);
        
        position.x = shell.frame.size.width / 2;
        position.y = 320 - shell.frame.size.height / 2;
        
        shell.position = position;
        
        [self.view.layer addSublayer:shell];
    }
    return self;
}

- (IBAction)menuTap:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
