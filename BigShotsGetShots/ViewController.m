//
//  DetailViewController.m
//  SVGPad
//
//  Copyright Matt Rajca 2010-2011. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVAudioPlayer.h>

@interface ViewController ()

- (void)loadResource:(NSString *)name;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, strong) SVGDocument *uiElements;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *forwardBtn;

@end

@implementation ViewController
@synthesize scrollView;
@synthesize toolbar, contentView, detailItem;
@synthesize audioPlayer, uiElements;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        
//        self.uiElements = [SVGDocument documentNamed:@"UI_pablo-NH"];
//        
//        SVGView *view = [[SVGView alloc] initWithDocument:self.uiElements];
//        
//        view.frame = self.backBtn.bounds;
//        
//        [self.view addSubview:view];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)move:(int)amount {
    
    NSArray *ary = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"ResourceList" withExtension:@"plist"]];
    
    int index = [ary indexOfObject:_name];
    
    index += amount;
    
    if(index >= (int)ary.count)
        index = ary.count - 1;
    
    if(index < 0)
        index = 0;
    
    [self loadResource:[ary objectAtIndex:index]];
}

- (IBAction)goForward:(id)sender {
    
    [self move:1];
}

- (IBAction)goBack:(id)sender {
    
    [self move:-1];
}

- (void)setDetailItem:(id)newDetailItem {
    
	if (detailItem != newDetailItem) {
        
		[self loadResource:newDetailItem];
	}
}

- (void)pageOne {
    
    SVGView *svgView = self.contentView;
    CALayer *layer = svgView.layer;
    
    CABasicAnimation *animation = nil;
    
	animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    
	animation.duration = 1.0f;
	animation.autoreverses = YES;
	animation.repeatCount = 100000;
	animation.fromValue = @10.0f;
	animation.toValue = @-10.0f;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	[[svgView.document layerWithIdentifier:@"SEA"] addAnimation:animation forKey:nil];
    
	animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    
	animation.duration = 1.5f;
	animation.autoreverses = YES;
	animation.repeatCount = 100000;
	animation.fromValue = @2.0f;
	animation.toValue = @-2.0f;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	[[svgView.document layerWithIdentifier:@"PABLO"] addAnimation:animation forKey:nil];
    
	animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    
	animation.duration = 1.5f;
	animation.autoreverses = YES;
	animation.repeatCount = 100000;
	animation.fromValue = @2.0f;
	animation.toValue = @-2.0f;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	[[svgView.document layerWithIdentifier:@"KAT"] addAnimation:animation forKey:nil];
    
    int64_t delayInSeconds = 4.5f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        CABasicAnimation *animation = nil;
        
        animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        
        animation.duration = 3.75f;
        animation.fromValue = @1.0f;
        animation.toValue = @3.0f;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        [svgView.document.layerTree addAnimation:animation forKey:nil];
        
        animation = [CABasicAnimation animationWithKeyPath:@"anchorPoint.y"];
        
        animation.duration = 3.75f;
        animation.fromValue = @0.5f;
        animation.toValue = @0.17f;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        [layer addAnimation:animation forKey:nil];
        
        animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
        
        animation.duration = 3.75f;
        animation.fromValue = @0.0f;
        animation.toValue = @-10.0f;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        [[svgView.document layerWithIdentifier:@"FRIENDS_LEFT"] addAnimation:animation forKey:nil];
        
        animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
        
        animation.duration = 3.75f;
        animation.fromValue = @0.0f;
        animation.toValue = @10.0f;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        [[svgView.document layerWithIdentifier:@"FRIENDS_RIGHT"] addAnimation:animation forKey:nil];
    });
}

- (void)pageThree {
    
    SVGView *svgView = self.contentView;
//    CALayer *layer = svgView.layer;
    
    CABasicAnimation *animation = nil;
    
	animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    
	animation.duration = 1.0f;
	animation.autoreverses = YES;
	animation.repeatCount = 100000;
	animation.fromValue = @10.0f;
	animation.toValue = @-10.0f;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	[[svgView.document layerWithIdentifier:@"SEA"] addAnimation:animation forKey:nil];
    
	animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
	animation.duration = 1.16666f;
	animation.autoreverses = YES;
	animation.repeatCount = 3;
	animation.fromValue = @0.0f;
	animation.toValue = @(M_PI_4 / 4);
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	[[svgView.document layerWithIdentifier:@"PABLO"] addAnimation:animation forKey:nil];
    
	animation = [CABasicAnimation animationWithKeyPath:@"transform.translation"];
    
	animation.duration = 7.0f;
	animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(-1000.0f, -300.0f)];
	animation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.0f, 0.0f)];
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	
	[[svgView.document layerWithIdentifier:@"PABLO"] addAnimation:animation forKey:nil];
    
    CALayer *bubbles = [svgView.document layerWithIdentifier:@"BUBBLES"];
    
    bubbles.opacity = 0;
    
    int64_t delayInSeconds = 7.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        
        animation.duration = 0.25f;
        animation.fromValue = @0.0f;
        animation.toValue = @1.0f;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        [bubbles addAnimation:animation forKey:nil];
        
        animation = [CABasicAnimation animationWithKeyPath:@"transform.translation"];
        
        animation.duration = 4.0f;
        animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.0f, 0.0f)];
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.0f, -300.0f)];
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        [bubbles addAnimation:animation forKey:nil];
    });
}

- (void)pageFour {
    
    SVGView *svgView = self.contentView;
    //    CALayer *layer = svgView.layer;
    
    CABasicAnimation *animation = nil;
    
	animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    
	animation.duration = 1.0f;
	animation.autoreverses = YES;
	animation.repeatCount = 100000;
	animation.fromValue = @10.0f;
	animation.toValue = @-10.0f;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	[[svgView.document layerWithIdentifier:@"SEA"] addAnimation:animation forKey:nil];
    
	animation = [CABasicAnimation animationWithKeyPath:@"transform.translation"];
    
	animation.duration = 7.0f;
	animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(-1000.0f, -300.0f)];
	animation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.0f, 0.0f)];
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	
	[[svgView.document layerWithIdentifier:@"PABLO"] addAnimation:animation forKey:nil];
    
    CALayer *bubbles = [svgView.document layerWithIdentifier:@"BUBBLES"];
    
    bubbles.opacity = 0;
    
    int64_t delayInSeconds = 7.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        
        animation.duration = 0.25f;
        animation.fromValue = @0.0f;
        animation.toValue = @1.0f;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        [bubbles addAnimation:animation forKey:nil];
    });
}

- (void)loadResource:(NSString *)name {
    
    [self.contentView.layer removeAllAnimations];
    
    [self.contentView removeFromSuperview];
    
	SVGDocument *document = [SVGDocument documentNamed:[name stringByAppendingPathExtension:@"svg"]];
    
	self.contentView = [[SVGView alloc] initWithDocument:document];
	
	_name = [name copy];
    
    [self.scrollView addSubview:self.contentView];
    
    [self.scrollView setContentSize:CGSizeMake(document.width, document.height)];
    self.scrollView.minimumZoomScale = 0.334f;
    self.scrollView.zoomScale = 0.334f;
    
    NSMutableString *str = [name mutableCopy];
    
    [str deleteCharactersInRange:(NSRange){0, 2}];
    
    NSString *number = [[str componentsSeparatedByString:@"."] objectAtIndex:0];
    
    NSString *resource = [NSString stringWithFormat:@"Page %@", number];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:resource withExtension:@"aif"];
    
    [self.audioPlayer stop];
    
    if([number isEqualToString:@"1"])
        [self pageOne];
    
    if([number isEqualToString:@"3"])
        [self pageThree];
    
    if([number isEqualToString:@"4"])
        [self pageFour];
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    [self.audioPlayer play];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return self.contentView;
}

- (void)viewDidUnload {
    
    [self setScrollView:nil];
    
    [self setBackBtn:nil];
    [self setForwardBtn:nil];
    [super viewDidUnload];
}

@end
