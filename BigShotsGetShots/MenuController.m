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
#import <AVFoundation/AVFoundation.h>

@interface MenuController ()

@property (nonatomic, strong) SVGDocument *uiElements;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *pagesView;

@property (weak, nonatomic) IBOutlet UIImageView *preview;

@property (nonatomic, weak) UIButton *lastButton;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

@property (nonatomic, strong) AVAudioPlayer *player;

@property (weak, nonatomic) IBOutlet UIButton *pagesBtn;
@property (weak, nonatomic) IBOutlet UIButton *aboutBtn;
@property (weak, nonatomic) IBOutlet UIButton *creditBtn;
@property (weak, nonatomic) IBOutlet UIButton *helpBtn;

@end

@implementation MenuController

- (void)clearAllButtons {
    
    UIColor *defaultColor = [UIColor colorWithRed:235.0f / 255.0f green:237.0f / 255.0f blue:243.0f / 255.0f alpha:1.0f];
    
    [self.pagesBtn setTitleColor:defaultColor forState:UIControlStateNormal];
    [self.aboutBtn setTitleColor:defaultColor forState:UIControlStateNormal];
    [self.creditBtn setTitleColor:defaultColor forState:UIControlStateNormal];
    [self.helpBtn setTitleColor:defaultColor forState:UIControlStateNormal];
}

+ (UIColor*)activeColor {
    
    //1c453e
    
    return [UIColor colorWithRed:0x1c / 255.0f green:0x45 / 255.0f blue:0x3e / 255.0f alpha:1.0f];
}

- (IBAction)pages:(id)sender {
    
    [self clearAllButtons];
    [self.pagesBtn setTitleColor:self.class.activeColor forState:UIControlStateNormal];
    
    self.pagesView.hidden = NO;
    self.webView.hidden = YES;
}

- (void)setCurChapter:(int)chapter {
    
    _curChapter = chapter;
    
    self.preview.image = [UIImage imageNamed:[NSString stringWithFormat:@"thumb-%d.png", chapter]];
}

- (void)playTrack:(NSString*)track extension:(NSString*)extension {
    
    if(!track)
        return;
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:track withExtension:extension];
    
    if(!url)
        return;
    
    NSError *error = nil;
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    [self.player play];
}

- (IBAction)chapterTap:(UIButton*)sender {
    
    [self playTrack:@"s_click_01" extension:@"m4a"];
    
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
    
    [self playTrack:@"s_click_01" extension:@"m4a"];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)aboutus:(id)sender {
    
    [self clearAllButtons];
    [self.aboutBtn setTitleColor:self.class.activeColor forState:UIControlStateNormal];
    
    self.pagesView.hidden = YES;
    self.webView.hidden = NO;
    
    NSURL *url = [NSURL URLWithString:@"http://www.3675design.com/Clients/hl/01-bigshots-getshots/about.html"];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (IBAction)credits:(id)sender {
    
    [self clearAllButtons];
    [self.creditBtn setTitleColor:self.class.activeColor forState:UIControlStateNormal];
    
    self.pagesView.hidden = YES;
    self.webView.hidden = NO;
    
    NSURL *url = [NSURL URLWithString:@"http://www.3675design.com/Clients/hl/01-bigshots-getshots/credits.html"];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (IBAction)help:(id)sender {
    
    [self clearAllButtons];
    [self.helpBtn setTitleColor:self.class.activeColor forState:UIControlStateNormal];
    
    self.pagesView.hidden = YES;
    self.webView.hidden = NO;
    
    NSURL *url = [NSURL URLWithString:@"http://www.3675design.com/Clients/hl/01-bigshots-getshots/help.html"];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for(UIButton *btn in self.buttons)
        btn.transform = CGAffineTransformMakeScale(1.25f, 1.25f);
    
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
    
    [self.pagesBtn setTitleColor:self.class.activeColor forState:UIControlStateNormal];
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
    [self setPagesBtn:nil];
    [self setAboutBtn:nil];
    [self setCreditBtn:nil];
    [self setHelpBtn:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

@end
