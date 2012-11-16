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
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation MenuController
@synthesize uiElements;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        if(!self.webView)
            self.webView = [self.view.subviews objectAtIndex:1];
        
        self.uiElements = [SVGDocument documentNamed:@"UI_pablo-NH-v3"];
        
        CALayer *layer = nil;
        
        layer = [self.uiElements layerWithIdentifier:@"menu bar"];
        
        layer.affineTransform = CGAffineTransformMakeScale(0.5f, 0.5f);
        
        CGPoint position;
        
        position.x = 480 / 2;
        position.y = 320 - layer.frame.size.height / 2;
        
        layer.position = position;
        
        [self.view.layer insertSublayer:layer atIndex:2];
        
        CALayer *shell = [self.uiElements layerWithIdentifier:@"Shell-btn-normal"];
        
        shell.affineTransform = CGAffineTransformMakeScale(0.5f, 0.5f);
        
        position.x = shell.frame.size.width / 2;
        position.y = 320 - shell.frame.size.height / 2;
        
        shell.position = position;
        
        [self.view.layer addSublayer:shell];
    }
    return self;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    NSLog(@"Started loading");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSLog(@"Finished loading");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    NSLog(@"Failed with error: %@", error);
}

- (IBAction)pages:(id)sender {
    
}

- (IBAction)aboutus:(id)sender {
    
    self.webView.hidden = NO;
    
    NSURL *url = [NSURL URLWithString:@"http://www.3675design.com/Clients/hl/01-bigshots-getshots/about.html"];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (IBAction)credits:(id)sender {
    
    self.webView.hidden = NO;
    
    NSURL *url = [NSURL URLWithString:@"http://www.3675design.com/Clients/hl/01-bigshots-getshots/credits.html"];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (IBAction)help:(id)sender {
    
    self.webView.hidden = NO;
    
    NSURL *url = [NSURL URLWithString:@"http://www.3675design.com/Clients/hl/01-bigshots-getshots/help.html"];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
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

- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}

@end
