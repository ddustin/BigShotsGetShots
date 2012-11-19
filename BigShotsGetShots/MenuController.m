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
#import <QuartzCore/QuartzCore.h>

@interface MenuController ()

@property (nonatomic, strong) SVGDocument *uiElements;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *pagesView;

@property (weak, nonatomic) IBOutlet UIImageView *preview;

@property (nonatomic, weak) UIButton *lastButton;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

@end

@implementation MenuController

- (IBAction)pages:(id)sender {
    
    self.pagesView.hidden = NO;
    self.webView.hidden = YES;
}

- (void)setCurChapter:(int)chapter {
    
    _curChapter = chapter;
    
    self.preview.image = [UIImage imageNamed:[NSString stringWithFormat:@"thumb-%d.png", chapter]];
}

- (IBAction)chapterTap:(UIButton*)sender {
    
    int num = sender.tag;
    
    if(self.curChapter == num) {
        
        [self.delegate loadResource:[NSString stringWithFormat:@"pg%d", sender.tag]];
        return;
    }
    
    self.curChapter = num;
    
    self.lastButton.selected = NO;
    
    sender.selected = YES;
    
    self.lastButton = sender;
}

- (IBAction)goToCurChapter:(id)sender {
    
    [self.delegate loadResource:[NSString stringWithFormat:@"pg%d", self.curChapter]];
}

- (IBAction)menuBtnTap:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)aboutus:(id)sender {
    
    self.pagesView.hidden = YES;
    self.webView.hidden = NO;
    
    NSURL *url = [NSURL URLWithString:@"http://www.3675design.com/Clients/hl/01-bigshots-getshots/about.html"];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (IBAction)credits:(id)sender {
    
    self.pagesView.hidden = YES;
    self.webView.hidden = NO;
    
    NSURL *url = [NSURL URLWithString:@"http://www.3675design.com/Clients/hl/01-bigshots-getshots/credits.html"];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (IBAction)help:(id)sender {
    
    self.pagesView.hidden = YES;
    self.webView.hidden = NO;
    
    NSURL *url = [NSURL URLWithString:@"http://www.3675design.com/Clients/hl/01-bigshots-getshots/help.html"];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    if(self.curChapter) {
        
        self.preview.image = [UIImage imageNamed:[NSString stringWithFormat:@"thumb-%d.png", self.curChapter]];
        
        for(UIButton *btn in self.buttons) {
            
            if(btn.tag == self.curChapter) {
                
                btn.selected = YES;
                self.lastButton = btn;
            }
        }
    }
    
    self.preview.layer.masksToBounds = YES;
    self.preview.layer.cornerRadius = 5;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [self setPagesView:nil];
    [self setPreview:nil];
    [self setButtons:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

@end
