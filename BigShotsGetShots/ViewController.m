//
//  DetailViewController.m
//  SVGPad
//
//  Copyright Matt Rajca 2010-2011. All rights reserved.
//

#import "ViewController.h"
#import <objc/message.h>

@interface ViewController ()

- (void)loadResource:(NSString *)name;

@property (weak, nonatomic) IBOutlet UIView *wrapperView;

@property (nonatomic, strong) AVAudioPlayer *sfxPlayer;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, strong) AVAudioPlayer *musicPlayer;

@property (nonatomic, strong) SVGDocument *uiElements;

@property (nonatomic, strong) CALayer *arrow_right;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *forwardBtn;
@property (weak, nonatomic) IBOutlet UIButton *centerBtn;
@property (weak, nonatomic) IBOutlet UILabel *playAgain;

// The number of the page (may contain a letter on the end ie. 5a).
@property (nonatomic, readonly) NSString *pageNumber;

@property (nonatomic, strong) CALayer *draggingLayer;

@property (nonatomic, assign) CGPoint firstPoint;

@property (nonatomic, assign) CGFloat totalDragMovement;

// Keys are the layer names of the items that can be dragged.
// Values are NSValue's holding CGRect's. Once dragged by the user, the named layer's
// frame will be set to to this value.
@property (nonatomic, strong) NSMutableDictionary *draggables;

@property (nonatomic, copy) void (^onAudioComplete)(AVAudioPlayer *player);

@property (nonatomic, copy) void (^onPieceTapped)(NSString *pieceName);

@property (nonatomic, copy) void (^onPiecePickedUp)(NSString *pieceName);
@property (nonatomic, copy) void (^onPlacedPiece)(NSString *pieceName);
@property (nonatomic, copy) void (^onFailedPiecePlacement)(NSString *pieceName);

@property (nonatomic, copy) void (^onCenterBtnTap)();

// When dragging pieces, how much should they be scaled up?
@property (nonatomic, assign) CGFloat dragMultiplier;

@property (weak, nonatomic) IBOutlet UIImageView *splashImage;

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (nonatomic, assign) BOOL didStart;

@end

@implementation ViewController
@synthesize scrollView;
@synthesize toolbar, contentView, detailItem;
@synthesize audioPlayer, musicPlayer;
@synthesize draggingLayer;
@synthesize firstPoint;
@synthesize totalDragMovement;
@synthesize draggables;
@synthesize onAudioComplete;
@synthesize onPieceTapped;
@synthesize arrow_right;
@synthesize onPiecePickedUp, onPlacedPiece, onFailedPiecePlacement, onCenterBtnTap;

- (void)startTheGame {
    
    if(self.didStart)
        return;
    
    self.didStart = YES;
    
    [self playSfx:@"s_pageturn_04" extension:@"m4a"];
    [self playBackground:@"m_musicLoop_02" extension:@"m4a"];
    
    [self bubbleTransitionOn:self.splashImage.layer];
    
    __weak ViewController *bself = self;
    
    bself.detailItem = @"pg1";
    
    [UIView animateWithDuration:1.25f
                          delay:0.5f
                        options:0
                     animations:^{
                         
                         CGRect frame = bself.splashImage.frame;
                         
                         frame.origin.y -= frame.size.height;
                         
                         bself.splashImage.frame = frame;
                         
                     } completion:^(BOOL finished) {
                         
                         [bself.splashImage removeFromSuperview];
                     }];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        
        [self playTrack:@"Pablo The Pufferfish" extension:@"m4a"];
        [self playBackground:@"m_intromusic_01" extension:@"m4a"];
        
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [self beginBubblesOnto:self.splashImage.layer];
        });
    }
    
    return self;
}

- (void)addRightArrowOnSplash {
    
    float arrowFactor = 1.5f;
    
    self.uiElements = [SVGDocument documentNamed:@"UI_pablo-NH-v3"];
    
    CALayer *arrow_rightTmp = [self.uiElements layerWithIdentifier:@"arrow-right-normal"];
    
    arrow_rightTmp.position = CGPointMake(arrow_right.frame.size.width / arrowFactor, arrow_right.frame.size.height / arrowFactor);
    
    arrow_rightTmp.affineTransform = CGAffineTransformMakeScale(1.0f / arrowFactor, 1.0f / arrowFactor);
    
    CGPoint position = self.backBtn.layer.position;
    
    position.y += 15.0f;
    
    position.x += 400.0f;
    
    arrow_rightTmp.position = position;
    
    [self.splashImage.layer addSublayer:arrow_rightTmp];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.uiElements = [SVGDocument documentNamed:@"UI_pablo-NH-v3"];
    
    self.playAgain.font = [UIFont fontWithName:@"Filmotype Brooklyn" size:30.0f];
    self.playAgain.hidden = YES;
    
    float arrowFactor = 1.5f;
    
    CALayer *arrow_left = [self.uiElements layerWithIdentifier:@"arrow-left-normal"];
    
    arrow_left.position = CGPointMake(arrow_left.frame.size.width / arrowFactor, arrow_left.frame.size.height / arrowFactor);
    
    arrow_left.affineTransform = CGAffineTransformMakeScale(1.0f / arrowFactor, 1.0f / arrowFactor);
    
    arrow_left.name = @"LEFT";
    
    CGPoint position = self.backBtn.layer.position;
    
    position.y += 15.0f;
    
    arrow_left.position = position;
    
//    if(![self.pageNumber isEqualToString:@"1"])
//        [self.backBtn.layer.superlayer insertSublayer:arrow_left atIndex:0];
    
    arrow_right = [self.uiElements layerWithIdentifier:@"arrow-right-normal"];
    
    arrow_right.position = CGPointMake(arrow_right.frame.size.width / arrowFactor, arrow_right.frame.size.height / arrowFactor);
    
    arrow_right.affineTransform = CGAffineTransformMakeScale(1.0f / arrowFactor, 1.0f / arrowFactor);
    
    arrow_right.name = @"RIGHT";
    
    position.x += 400.0f;
    
    arrow_right.position = position;
    
    if(![self.pageNumber isEqualToString:@"15"])
        [self.backBtn.layer.superlayer insertSublayer:arrow_right atIndex:0];
    
    CALayer *shell = [self.uiElements layerWithIdentifier:@"Shell-btn-normal"];
    
    shell.affineTransform = CGAffineTransformMakeScale(0.5f, 0.5f);
    
    position.x = shell.frame.size.width / 2;
    position.y = 320 - shell.frame.size.height / 2;
    
    shell.position = position;
    
    [self.wrapperView.layer addSublayer:shell];
    
    [self addRightArrowOnSplash];
}

- (void)move:(int)amount {
    
    [self playSfx:@"s_click_01" extension:@"m4a"];
    
    NSArray *ary = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"ResourceList" withExtension:@"plist"]];
    
    int index = [ary indexOfObject:_name];
    
    index += amount;
    
    if(index >= (int)ary.count)
        index = ary.count - 1;
    
    if(index < 0)
        index = 0;
    
    [self loadResource:[ary objectAtIndex:index]];
}

- (IBAction)menu:(id)sender {
    
    MenuController *controller = [MenuController new];
    
    controller.delegate = self;
    
    controller.curChapter = self.pageNumber.integerValue;
    
    @try {
        
        [self presentModalViewController:controller animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"Menu failed: %@", exception);
    }
    @finally {
        
    }
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

- (void)beginPage1 {
    
    self.label.text = @"Pablo the Big Shot";
    
    SVGView *svgView = self.contentView;
    CALayer *layer = svgView.layer;
    
    CABasicAnimation *animation = nil;
    
    [self animateSea];
    
	animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    
	animation.duration = 1.5f;
	animation.autoreverses = YES;
	animation.repeatCount = 100000;
	animation.fromValue = @3.0f;
	animation.toValue = @-3.0f;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	[[svgView.document layerWithIdentifier:@"PABLO"] addAnimation:animation forKey:nil];
    
    double delayInSeconds = 4.5f;
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

- (void)preloadPage3 {
    
    SVGView *svgView = self.contentView;
    
    [svgView.document layerWithIdentifier:@"PABLO"].hidden = YES;
    [svgView.document layerWithIdentifier:@"BUBBLES"].opacity = 0;
}

- (void)beginPage3 {
    
    self.label.text = @"A Puff-less Pufferfish";
    
    SVGView *svgView = self.contentView;
    
    [svgView.document layerWithIdentifier:@"PABLO"].hidden = NO;
    
    CABasicAnimation *animation = nil;
    
    [self animateSea];
    
    float enterTime = 10.0f;
    
	animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
	animation.duration = enterTime / 6;
	animation.autoreverses = YES;
	animation.repeatCount = 3;
	animation.fromValue = @0.0f;
	animation.toValue = @(M_PI_4 / 4);
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	[[svgView.document layerWithIdentifier:@"PABLO"] addAnimation:animation forKey:nil];
    
	animation = [CABasicAnimation animationWithKeyPath:@"transform.translation"];
    
	animation.duration = enterTime;
	animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(-1000.0f, -300.0f)];
	animation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.0f, 0.0f)];
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	
	[[svgView.document layerWithIdentifier:@"PABLO"] addAnimation:animation forKey:nil];
    
    CALayer *bubbles = [svgView.document layerWithIdentifier:@"BUBBLES"];
    
    double delayInSeconds = enterTime + 2.0f;
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
        
        animation.duration = 3.0f;
        animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.0f, 0.0f)];
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.0f, -500.0f)];
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        [bubbles addAnimation:animation forKey:nil];
    });
}

- (void)preloadPage4 {
    
    self.label.text = @"A Scary Sight!";
    
    SVGView *svgView = self.contentView;
    
    [svgView.document layerWithIdentifier:@"PABLO"].hidden = YES;
    [svgView.document layerWithIdentifier:@"CLAM"].hidden = YES;
    [svgView.document layerWithIdentifier:@"SAND"].hidden = YES;
    
    [svgView.document layerWithIdentifier:@"PABLOMIRROR"].opacity = 0;
    [svgView.document layerWithIdentifier:@"BUBBLES"].opacity = 0;
}

- (void)beginPage4 {
    
    SVGView *svgView = self.contentView;
    
    [svgView.document layerWithIdentifier:@"PABLO"].hidden = NO;
    [svgView.document layerWithIdentifier:@"CLAM"].hidden = NO;
    [svgView.document layerWithIdentifier:@"SAND"].hidden = NO;
    
    CABasicAnimation *animation = nil;
    
    [self animateSea];
    
	animation = [CABasicAnimation animationWithKeyPath:@"transform.translation"];
    
	animation.duration = 7.0f;
	animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(-600.0f, 0.0f)];
	animation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.0f, 0.0f)];
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	
	[[svgView.document layerWithIdentifier:@"PABLO"] addAnimation:animation forKey:nil];
    
	animation = [CABasicAnimation animationWithKeyPath:@"transform.translation"];
    
	animation.duration = 7.0f;
	animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.0f, 1000.0f)];
	animation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.0f, 0.0f)];
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	
	[[svgView.document layerWithIdentifier:@"CLAM"] addAnimation:animation forKey:nil];
	[[svgView.document layerWithIdentifier:@"SAND"] addAnimation:animation forKey:nil];
    
    CALayer *bubbles = [svgView.document layerWithIdentifier:@"BUBBLES"];
    CALayer *pabloReflection = [svgView.document layerWithIdentifier:@"PABLOMIRROR"];
    
    double delayInSeconds = 7.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        CABasicAnimation *animation = nil;
        
        animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        
        animation.duration = 0.5f;
        animation.fromValue = @0.0f;
        animation.toValue = @1.0f;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        [bubbles addAnimation:animation forKey:nil];
        
        animation = [CABasicAnimation animationWithKeyPath:@"transform.translation"];
        
        animation.duration = 3.0f;
        animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.0f, 0.0f)];
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.0f, -500.0f)];
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        [bubbles addAnimation:animation forKey:nil];
        
        animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        
        animation.duration = 0.5f;
        animation.fromValue = @0.0f;
        animation.toValue = @1.0f;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        [pabloReflection addAnimation:animation forKey:nil];
    });
    
    delayInSeconds = 10.0;
    popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        CABasicAnimation *animation = nil;
        
        animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
        
        animation.duration = 0.25f;
        animation.autoreverses = YES;
        animation.fromValue = @0.0f;
        animation.toValue = @-25.0f;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        [[svgView.document layerWithIdentifier:@"PABLO"] addAnimation:animation forKey:nil];
        
        animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        
        animation.duration = 0.25f;
        animation.autoreverses = YES;
        animation.fromValue = @1.0f;
        animation.toValue = @0.9f;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        [[svgView.document layerWithIdentifier:@"PABLOMIRROR"] addAnimation:animation forKey:nil];
    });
    
    float fallTime = 0.5f;
    
    delayInSeconds = 13.5;
    popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        CABasicAnimation *animation = nil;
        
        animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        
        animation.duration = fallTime;
        animation.fromValue = @0.0f;
        animation.toValue = @190.0f;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        [[svgView.document layerWithIdentifier:@"PABLO"] addAnimation:animation forKey:nil];
        
        animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        
        animation.duration = fallTime;
        animation.fromValue = @0.0f;
        animation.toValue = @50.0f;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        [[svgView.document layerWithIdentifier:@"PABLOMIRROR"] addAnimation:animation forKey:nil];
    });
    
    delayInSeconds += fallTime + 2.5f;
    popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        CABasicAnimation *animation = nil;
        
        animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
        
        animation.duration = 6.0f;
        animation.fromValue = @0.0f;
        animation.toValue = @-190.0f;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        [[svgView.document layerWithIdentifier:@"PABLO"] addAnimation:animation forKey:nil];
        
        animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        
        animation.duration = 6.0f;
        animation.fromValue = @1.0f;
        animation.toValue = @0.75f;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        [[svgView.document layerWithIdentifier:@"PABLOMIRROR"] addAnimation:animation forKey:nil];
    });
}

- (void)addReplayButton {
    
    CALayer *btnLayer = nil;
    
    if(![self.pageNumber isEqualToString:@"15"])
        btnLayer = [[SVGDocument documentNamed:@"UI_pablo-NH-v3"] layerWithIdentifier:@"replay-btn-big-normal"];
    else
        btnLayer = [[SVGDocument documentNamed:@"UI_pablo-NH-v3"] layerWithIdentifier:@"replay-btn-small-normal"];
    
    self.centerBtn.hidden = NO;
    
    if(![self.pageNumber isEqualToString:@"15"])
        self.playAgain.hidden = NO;
    
    btnLayer.opacity = 0.0f;
    btnLayer.opacity = 1.0f;
    
    btnLayer.position = CGPointMake(self.contentView.document.width / 2, self.contentView.document.height / 2);
    
    if([self.pageNumber isEqualToString:@"15"])
        btnLayer.position = CGPointMake(self.contentView.document.width * .9, self.contentView.document.height * .9);
    
    [self.contentView.layer addSublayer:btnLayer];
    
    if(![self.pageNumber isEqualToString:@"15"]) {
        
        __weak ViewController *weakSelf = self;
        
        self.onCenterBtnTap = ^{
            
            __strong ViewController *strongSelf = weakSelf;
            
            strongSelf.onCenterBtnTap = nil;
            
            [strongSelf loadResource:strongSelf->_name];
        };
    }
}

- (IBAction)bottomRightTap:(id)sender {
    
    if([self.pageNumber isEqualToString:@"15"])
        [self loadResource:@"pg1"];
}

- (void)preloadPage4a {
    
    SVGView *svgView = self.contentView;
    
    UIImage *puzzleImage = [UIImage imageNamed:@"4a_puzzle_4a_cut.png"];
    
    UIImageView *puzzle = [[UIImageView alloc] initWithImage:puzzleImage];
    
    puzzle.layer.name = @"PUZZLE_BACKGROUND";
    
    puzzle.frame = CGRectMake(0.0f, 0.0f, 896.0f, 597.0f);
    
    puzzle.center = CGPointMake(svgView.document.width / 2, svgView.document.height / 2);
    
    [svgView addSubview:puzzle];
}

- (void)beginPage4a {
    
    self.dragMultiplier = 1;
    
    SVGView *svgView = self.contentView;
    
    [self animateSea];
    
    self.draggables = [NSMutableDictionary dictionary];
    
    NSEnumerator *floatingEnumerator = [[self floatPuzzlePositions] objectEnumerator];
    NSEnumerator *puzzleEnumerator = [[self puzzlePositions] objectEnumerator];
    
    for(NSString *name in [self floatingPieceNames]) {
        
        UIImage *image = [UIImage imageNamed:name];
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
        
        imgView.frame = [[floatingEnumerator nextObject] CGRectValue];
        
        [svgView addSubview:imgView];
        
        imgView.layer.name = name;
        
        [self.draggables setObject:[puzzleEnumerator nextObject] forKey:name];
    }
    
    __weak ViewController *bself = self;
    
    void (^playSfx)(NSString*, NSString*) = ^(NSString *track, NSString *extension) {
        [bself playSfx:track extension:extension];
    };
    
    self.onPiecePickedUp = ^(NSString *pieceName) {
        
        playSfx(@"s_click_01", @"m4a");
    };
    
    self.onAudioComplete = ^(AVAudioPlayer *player) {
        
        self.onAudioComplete = nil;
    };
    
    self.onPlacedPiece = ^(NSString *pieceName) {
        
        UIImageView *imgView = (id)[bself viewWithLayer:pieceName startingWith:bself.contentView];
        
        NSString *name = [pieceName stringByDeletingPathExtension];
        
        name = [name stringByAppendingFormat:@"a.%@", [pieceName pathExtension]];
        
        imgView.image = [UIImage imageNamed:name];
        
        playSfx(@"s_pilacecorrectpuzzlepiece_01", @"m4a");
        
        bself.onAudioComplete = ^(AVAudioPlayer *player) {
            
            bself.onAudioComplete = nil;
            
            if(!draggables.count) {
                
                double delayInSeconds = 5.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    
                    [UIView beginAnimations:nil context:nil];
                    
                    for(UIView *subview in svgView.subviews)
                        if(subview)
                            subview.alpha = 0.0f;
                    
                    [UIView commitAnimations];
                    
                    [self addReplayButton];
                });
                
                playSfx(@"s_puzzlecomplete_01", @"m4a");
                
                self.onAudioComplete = ^(AVAudioPlayer *player) {
                    
                    self.onAudioComplete = nil;
                    
                    playSfx(@"You're a bigshot!", @"m4a");
                };
            }
            else {
                
                NSArray *sounds =
                @[@"Jigsaw _Great Job_",
                @"Jigsaw _way to go bigshot_",
                @"Jigsaw _Way to go_",
                @"You're a bigshot!"
                ];
                
                playSfx([sounds objectAtIndex:rand() % sounds.count], @"m4a");
            }
        };
    };
    
    self.onFailedPiecePlacement = ^(NSString *pieceName) {
        
        playSfx(@"Try Again", @"m4a");
    };
    
    [self playTrack:@"Jigsaw _can you put this jigsaw puzzle together_" extension:@"m4a"];
}

- (void)preloadPage5 {
    
    self.label.text = @"Pablo’s Friends";
    
    SVGView *svgView = self.contentView;
    
    float multiplier = 1.5f;
    
    [svgView.document layerWithIdentifier:@"TUNA TRIPS"].affineTransform = CGAffineTransformMakeTranslation(60.0f * multiplier, -20.0f * multiplier);
    
    [svgView.document layerWithIdentifier:@"KAY"].affineTransform = CGAffineTransformMakeTranslation(0.0f * multiplier, 20.0f * multiplier);
    
	[svgView.document layerWithIdentifier:@"SAMMY"].affineTransform = CGAffineTransformMakeTranslation(-20.0f * multiplier, -10.0f * multiplier);
    
	[svgView.document layerWithIdentifier:@"BO"].affineTransform = CGAffineTransformMakeTranslation(-60.0f * multiplier, -20.0f * multiplier);
    
	[svgView.document layerWithIdentifier:@"PABLO"].affineTransform = CGAffineTransformMakeTranslation(-55.0f * multiplier, 0.0f * multiplier);
}

- (void)beginPage5 {
    
    SVGView *svgView = self.contentView;
    
    CABasicAnimation *animation = nil;
    
    [self animateSea];
    
    for(NSString *name in @[ @"TUNA TRIPS", @"KAY", @"SAMMY", @"BO", @"PABLO" ]) {
        
        CALayer *layer = [svgView.document layerWithIdentifier:name];
        
        animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        
        animation.duration = 3.0f;
        animation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        [layer addAnimation:animation forKey:nil];
    }
    
    NSArray *array = @[
    @[ @5.75f, @"TOMMY"],
    @[ @6.45f, @"TINA"],
    @[ @6.9f, @"TED"],
    @[ @8.5f, @"CHRIS"],
    @[ @9.75f, @"BO"],
    @[ @11.0f, @"SAMMY"],
    ];
    
    __block BOOL doneTalking = NO;
    
    double delayInSeconds = 12.0f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        doneTalking = YES;
    });
    
    for(NSArray *items in array) {
        
        double delayInSeconds = [[items objectAtIndex:0] floatValue];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            
            animation.duration = 0.5f;
            animation.fromValue = @1.3f;
            animation.toValue = @1.0f;
            
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            
            CALayer *tmp = [svgView.document layerWithIdentifier:[items objectAtIndex:1]];
            
            [tmp addAnimation:animation forKey:nil];
        });
    }
    
    NSDictionary *audioForPiece =
    @{
    @"BO": @"Beardfish",
    @"CHRIS": @"Crab",
    @"PABLO": @"Pufferfish",
    @"SAMMY": @"Seahorse",
    @"TUNA_TRIPS": @"Tuna",
    };
    
    __block NSMutableArray *friends = [audioForPiece.allKeys mutableCopy];
    
    [friends removeObject:@"PABLO"];
    
    __weak id bself = self;
    
    self.onPieceTapped = ^(NSString *pieceName) {
        
        NSString *track = [audioForPiece objectForKey:pieceName];
        
        if(doneTalking && track) {
            
            [bself playTrack:track extension:@"m4a"];
            
            [friends removeObject:pieceName];
            
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            
            animation.duration = 0.5f;
            animation.fromValue = @1.3f;
            animation.toValue = @1.0f;
            
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            
            [[svgView.document layerWithIdentifier:pieceName] addAnimation:animation forKey:nil];
            
            if(friends && !friends.count) {
                
                friends = nil;
                
                self.onAudioComplete = ^(AVAudioPlayer *player) {
                    
                    self.onAudioComplete = nil;
                    
                    [bself playTrack:@"Job well done you found all of Pablo's friends" extension:@"m4a"];
                };
            }
        }
    };
}

- (IBAction)centerTap:(id)sender {
    
    if(self.onCenterBtnTap)
        self.onCenterBtnTap();
}

- (UIView*)viewWithLayer:(NSString*)name startingWith:(UIView*)firstView {
    
    if([firstView.layer.name isEqualToString:name])
        return firstView;
    
    for(UIView *view in firstView.subviews) {
        
        UIView *result = [self viewWithLayer:name startingWith:view];
        
        if(result)
            return result;
    }
    
    return nil;
}

- (void)beginPage5a {
    
    self.dragMultiplier = 1.3;
    
    [self animateSea];
    
    [self setDraggablesUsingIdentifiers:
     @{
     @"BO": @"BO_DEST",
     @"TUNA_TRIPS": @"TUNA_TRIPS_DEST",
     @"KAT": @"KAT_DEST",
     @"SAMMY": @"SAMMY_DEST",
     @"PABLO": @"PABLO_DEST",
     }];
    
    __block NSMutableDictionary *trackByIdentifier =
    [@{
    @"BO": @"Can you find the Beardfish",
    @"TUNA_TRIPS": @"Can you find the Tuna fish",
    @"SAMMY": @"Can you find the Seahorse",
    @"KAT": @"Can you find the Catfish",
    @"PABLO": @"Can you find the Pufferfish",
    } mutableCopy];
    
    __weak ViewController *bself = self;
    
    void (^playTrack)(NSString*, NSString*) = ^(NSString *track, NSString *extension) {
        
        [bself playTrack:track extension:extension];
    };
    
    void (^playNextTrack)() = ^{
        
        // Disabling can you find for now.
        return;
        
        if(![trackByIdentifier count])
            return;
        
        NSArray *keys = trackByIdentifier.allKeys;
        
        NSString *track = [trackByIdentifier objectForKey:[keys objectAtIndex:rand() % keys.count]];
        
        playTrack(track, @"m4a");
    };
    
    __block BOOL placedAPiece = NO;
    
    self.onAudioComplete = ^(AVAudioPlayer *player) {
        
        self.onAudioComplete = nil;
        
        double delayInSeconds = 4.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            if(![self.pageNumber isEqualToString:@"5a"])
                return;
            
            if(!placedAPiece)
                playNextTrack();
        });
    };
    
    self.onPlacedPiece = ^(NSString *pieceName) {
        
        placedAPiece = YES;
        
        [trackByIdentifier removeObjectForKey:pieceName];
        
        playTrack(@"s_click_01", @"m4a");
        
        bself.onAudioComplete = ^(AVAudioPlayer *player) {
            
            bself.onAudioComplete = nil;
            
            if(!draggables.count) {
                
                playTrack(@"You're a bigshot!", @"m4a");
                
                double delayInSeconds = 5.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    
                    for(CALayer *layer in [bself.contentView.layer.sublayers.lastObject sublayers]) {
                        
                        if([layer.name isEqualToString:@"CORAL"])
                            continue;
                        
                        if([layer.name isEqualToString:@"SEA"])
                            continue;
                        
                        if([layer.name isEqualToString:@"SEA_BACK"])
                            continue;
                        
                        layer.opacity = 0.0f;
                    }
                    
                    [bself addReplayButton];
                });
            }
            else {
                
                NSArray *sounds =
                @[
                @"Great Job",
                @"Way to go!",
                @"You're a bigshot!"
                ];
                
                playTrack([sounds objectAtIndex:rand() % sounds.count], @"m4a");
                
                self.onAudioComplete = ^(AVAudioPlayer *player) {
                    
                    self.onAudioComplete = nil;
                    
                    playNextTrack();
                };
            }
        };
    };
    
    self.onFailedPiecePlacement = ^(NSString *pieceName) {
        
        if(bself.totalDragMovement > 15000)
            playTrack(@"Try Again", @"m4a");
    };
    
    NSDictionary *audioForPiece =
    @{
    @"BO": @"Beardfish",
    @"CHRIS": @"Crab",
    @"PABLO": @"Pufferfish",
    @"SAMMY": @"Seahorse",
    @"TUNA_TRIPS": @"Tuna",
    @"KAT": @"Catfish"
    };
    
    self.onPieceTapped = ^(NSString *pieceName) {
        
        [bself playTrack:[audioForPiece objectForKey:pieceName] extension:@"m4a"];
    };
    
    playTrack(@"Drag and Drop Pablo's Friends", @"m4a");
}

- (void)preloadPage6 {
    
    SVGView *svgView = self.contentView;
    
    [svgView.document layerWithIdentifier:@"PABLO"].hidden = YES;
    
    CALayer *ground = [svgView.document layerWithIdentifier:@"GROUND"];
    CALayer *uma = [svgView.document layerWithIdentifier:@"UMA"];
    
    [ground setAffineTransform:CGAffineTransformMakeTranslation(0, 500)];
    [uma setAffineTransform:CGAffineTransformMakeTranslation(0, 500)];
}

- (void)beginPage6 {
    
    self.label.text = @"Pablo meets Uma";
    
    SVGView *svgView = self.contentView;
    
    [svgView.document layerWithIdentifier:@"PABLO"].hidden = NO;
    
    CABasicAnimation *animation = nil;
    
	animation = [CABasicAnimation animationWithKeyPath:@"transform.translation"];
    
	animation.duration = 4.5f;
	animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(-600.0f, 0.0f)];
	animation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.0f, 0.0f)];
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	
	[[svgView.document layerWithIdentifier:@"PABLO"] addAnimation:animation forKey:nil];
    
    CALayer *ground = [svgView.document layerWithIdentifier:@"GROUND"];
    CALayer *uma = [svgView.document layerWithIdentifier:@"UMA"];
    
    double delayInSeconds = 13.0f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        
        animation.duration = 7.0f;
        animation.fromValue = @500.0f;
        animation.toValue = @0.0f;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        [ground addAnimation:animation forKey:nil];
        [uma addAnimation:animation forKey:nil];
        
        animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        
        animation.duration = 7.0f;
        animation.fromValue = @0.0f;
        animation.toValue = @70.0f;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        [[svgView.document layerWithIdentifier:@"PABLO"] addAnimation:animation forKey:nil];
        
        animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        
        animation.duration = 7.0f;
        animation.fromValue = @0.0f;
        animation.toValue = @-80.0f;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        [[self.contentView.document layerWithIdentifier:@"SEA"] addAnimation:animation forKey:nil];
    });
}

- (void)beginPage7 {
    
    self.label.text = @"Pablo Couldn’t Look";
    
    [self animateSea];
    
    SVGView *svgView = self.contentView;
    
//    svgView.layer.affineTransform = CGAffineTransformMakeTranslation(600.0f, 0.0f);
//    
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
//    
//    animation.duration = 7.0f;
//    animation.toValue = @0.0f;
//    
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    
//    [svgView.layer addAnimation:animation forKey:nil];
}

- (void)beginPage8 {
    
    self.label.text = @"Uma Says Hello";
    
    [self animateSea];
    
    CALayer *uma = [self.contentView.document layerWithIdentifier:@"UMA"];
    
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    
//	animation.duration = 1.0f;
//	animation.autoreverses = YES;
//	animation.repeatCount = 100000;
//	animation.fromValue = @1.0f;
//	animation.toValue = @1.3f;
//    
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//	
//	[uma addAnimation:animation forKey:nil];
}

- (void)preloadPage9 {
    
    self.label.text = @"Still No Needles for Pablo";
    
    SVGView *svgView = self.contentView;
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(-600.0f, 0.0f);
    
    transform = CGAffineTransformScale(transform, 0.1f, 0.1f);
    
    [[svgView.document layerWithIdentifier:@"PABLO"] setAffineTransform:transform];
}

- (void)beginPage9 {
    
    SVGView *svgView = self.contentView;
    
    [self animateSea];
    
    CALayer *pablo = [svgView.document layerWithIdentifier:@"PABLO"];
    
    double delayInSeconds = 8.5f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        
        CABasicAnimation *animation = nil;
        
        animation = [CABasicAnimation animationWithKeyPath:@"transform.translation"];
        
        animation.duration = 8.5f;
        animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(-600.0f, 0.0f)];
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.0f, 0.0f)];
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        [pablo addAnimation:animation forKey:nil];
        
        animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        
        animation.duration = 8.5f;
        animation.fromValue = @0.1f;
        animation.toValue = @1.0f;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        [pablo addAnimation:animation forKey:nil];
    });
}

- (void)preloadPage10 {
    
    self.label.text = @"Everyone’s Out Playing";
    
    SVGView *svgView = self.contentView;
    
    [svgView.document layerWithIdentifier:@"BASEBALL"].hidden = YES;
}

- (void)beginPage10 {
    
    SVGView *svgView = self.contentView;
    
    [svgView.document layerWithIdentifier:@"BASEBALL"].hidden = NO;
    
    [self animateSea];
    
    CABasicAnimation *animation = nil;
    
    animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    
    animation.duration = 2.0f;
    animation.fromValue = @-440.0f;
    animation.toValue = @0.0f;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [[svgView.document layerWithIdentifier:@"BASEBALL"] addAnimation:animation forKey:nil];
}

- (void)preloadPage11 {
    
    self.label.text = @"Germ Starts Trouble";
    
    SVGView *svgView = self.contentView;
    
    CALayer *bubbles = [svgView.document layerWithIdentifier:@"BUBBLES"];
    CALayer *pabloNeedles = [svgView.document layerWithIdentifier:@"PABLO NEEDLES"];
    CALayer *germ =[svgView.document layerWithIdentifier:@"GERM"];
    
    bubbles.opacity = 0;
    pabloNeedles.opacity = 0;
    [germ setAffineTransform:CGAffineTransformMakeTranslation(600.0f, 0.0f)];
    
    [[svgView.document layerWithIdentifier:@"FRIENDS"] setAffineTransform:CGAffineTransformMakeTranslation(100.0f, 0.0f)];
    [[svgView.document layerWithIdentifier:@"FISH"] setAffineTransform:CGAffineTransformMakeTranslation(200.0f, 0.0f)];
}

- (void)beginPage11 {
    
    SVGView *svgView = self.contentView;
    
    [[svgView.document layerWithIdentifier:@"FRIENDS"] setAffineTransform:CGAffineTransformIdentity];
    [[svgView.document layerWithIdentifier:@"FISH"] setAffineTransform:CGAffineTransformIdentity];
    
    [self animateSea];
    
    CABasicAnimation *animation = nil;
    
    animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    
    animation.duration = 10.0f;
    animation.fromValue = @100.0f;
    animation.toValue = @0.0f;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [[svgView.document layerWithIdentifier:@"FRIENDS"] addAnimation:animation forKey:nil];
    
    animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    
    animation.duration = 10.0f;
    animation.fromValue = @200.0f;
    animation.toValue = @0.0f;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [[svgView.document layerWithIdentifier:@"FISH"] addAnimation:animation forKey:nil];
    
    CALayer *bubbles = [svgView.document layerWithIdentifier:@"BUBBLES"];
    CALayer *pablo = [svgView.document layerWithIdentifier:@"PABLO"];
    CALayer *pabloNeedles = [svgView.document layerWithIdentifier:@"PABLO NEEDLES"];
    CALayer *germ =[svgView.document layerWithIdentifier:@"GERM"];
    
    double delayInSeconds = 10.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        CABasicAnimation *animation = nil;
        
        animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        
        animation.duration = 0.25f;
        animation.fromValue = @0.0f;
        animation.toValue = @1.0f;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        [bubbles addAnimation:animation forKey:nil];
        [pabloNeedles addAnimation:animation forKey:nil];
        
        animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        
        animation.duration = 0.25f;
        animation.fromValue = @1.0f;
        animation.toValue = @0.0f;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        [pablo addAnimation:animation forKey:nil];
        
        animation = [CABasicAnimation animationWithKeyPath:@"transform.translation"];
        
        animation.duration = 3.0f;
        animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.0f, 0.0f)];
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.0f, -500.0f)];
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        [bubbles addAnimation:animation forKey:nil];
    });
        
    delayInSeconds = 7.0;
    popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        CABasicAnimation *animation = nil;
        
        animation = [CABasicAnimation animationWithKeyPath:@"transform.translation"];
        
        animation.duration = 7.0f;
        animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(600.0f, 0.0f)];
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.0f, -0.0f)];
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        [germ addAnimation:animation forKey:nil];
    });
    
    // PABLO
    // PABLO_NEEDLES
    // FRIENDS
    // FISH
    // GERM
}

- (void)beginPage11a {
    
    self.dragMultiplier = 1.3;
    
    [self animateSea];
    
    [self setDraggablesUsingIdentifiers:
     @{
     @"BO": @"BO_DEST",
     @"SAMMY": @"SAMMY_DEST",
     @"PABLO": @"PABLO_DEST",
     }];
    
    __block NSMutableDictionary *trackByIdentifier =
    [@{
     @"BO": @"Can you find the Beardfish",
     @"SAMMY": @"Can you find the Seahorse",
     @"PABLO": @"Can you find the Pufferfish",
     } mutableCopy];
    
    __weak ViewController *bself = self;
    
    void (^playTrack)(NSString*, NSString*) = ^(NSString *track, NSString *extension) {
        
        [bself playTrack:track extension:extension];
    };
    
    void (^playNextTrack)() = ^{
        
        // Disabling can you find for now.
        return;
        
        if(![trackByIdentifier count])
            return;
        
        NSArray *keys = trackByIdentifier.allKeys;
        
        NSString *track = [trackByIdentifier objectForKey:[keys objectAtIndex:rand() % keys.count]];
        
        playTrack(track, @"m4a");
    };
    
    __block BOOL placedAPiece = NO;
    
    self.onAudioComplete = ^(AVAudioPlayer *player) {
        
        self.onAudioComplete = nil;
        
        double delayInSeconds = 4.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            if(![self.pageNumber isEqualToString:@"5a"])
                return;
            
            if(!placedAPiece)
                playNextTrack();
        });
    };
    
    self.onPlacedPiece = ^(NSString *pieceName) {
        
        placedAPiece = YES;
        
        [trackByIdentifier removeObjectForKey:pieceName];
        
        playTrack(@"s_click_01", @"m4a");
        
        bself.onAudioComplete = ^(AVAudioPlayer *player) {
            
            bself.onAudioComplete = nil;
            
            if(!draggables.count) {
                
                playTrack(@"You're a bigshot!", @"m4a");
                
                double delayInSeconds = 5.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    
                    for(CALayer *layer in [bself.contentView.layer.sublayers.lastObject sublayers]) {
                        
                        if([layer.name isEqualToString:@"SEA_BACK"])
                            continue;
                        
                        layer.opacity = 0.0f;
                    }
                    
                    [bself addReplayButton];
                });
            }
            else {
                
                NSArray *sounds =
                @[
                @"Great Job",
                @"Way to go!",
                @"You're a bigshot!"
                ];
                
                playTrack([sounds objectAtIndex:rand() % sounds.count], @"m4a");
                
                self.onAudioComplete = ^(AVAudioPlayer *player) {
                    
                    self.onAudioComplete = nil;
                    
                    playNextTrack();
                };
            }
        };
    };
    
    self.onFailedPiecePlacement = ^(NSString *pieceName) {
        
        if(bself.totalDragMovement > 15000)
            playTrack(@"Try Again", @"m4a");
    };
    
    NSDictionary *audioForPiece =
    @{
    @"BO": @"Beardfish",
    @"CHRIS": @"Crab",
    @"PABLO": @"Pufferfish",
    @"SAMMY": @"Seahorse",
    @"TUNA_TRIPS": @"Tuna",
    @"KAT": @"Catfish"
    };
    
    self.onPieceTapped = ^(NSString *pieceName) {
        
        [bself playTrack:[audioForPiece objectForKey:pieceName] extension:@"m4a"];
    };
    
    playTrack(@"Drag and Drop Pablo's Friends", @"m4a");
}

- (void)beginPage12 {
    
    self.label.text = @"Pablo Saves the Day";
    
    [self animateSea];
    
    // PABLO
    // FRIENDS
    // GERM
}

- (void)beginPage13 {
    
    self.label.text = @"Pablo is a Hero!";
    
    [self animateSea];
    
    // RIBBONS
    // PABLO
    // HERO - his hero necklace
    // KAT
    // CHRIS
    // TINA
    // TOMMY
    // TED
    // SAMMY
}

- (void)beginPage14 {
    
    [self animateSea];
    
    self.label.text = @"Pablo is Proud of Himself";
    
    // Same as 13 plus
    // UMA
    // GROUND
}

- (void)preloadPage14a {
    
    SVGView *svgView = self.contentView;
    
    UIImage *puzzleImage = [UIImage imageNamed:@"14a_puzzle_14a_cut.png"];
    
    UIImageView *puzzle = [[UIImageView alloc] initWithImage:puzzleImage];
    
    puzzle.frame = CGRectMake(0.0f, 0.0f, 896.0f, 597.0f);
    
    puzzle.center = CGPointMake(svgView.document.width / 2, svgView.document.height / 2);
    
    [svgView addSubview:puzzle];
}

- (void)beginPage14a {
    
    self.dragMultiplier = 1;
    
    SVGView *svgView = self.contentView;
    
    [self animateSea];
    
    self.draggables = [NSMutableDictionary dictionary];
    
    NSEnumerator *floatingEnumerator = [[self floatPuzzlePositions] objectEnumerator];
    NSEnumerator *puzzleEnumerator = [[self puzzlePositions] objectEnumerator];
    
    for(NSString *name in [self floatingPieceNames]) {
        
        UIImage *image = [UIImage imageNamed:name];
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
        
        imgView.frame = [[floatingEnumerator nextObject] CGRectValue];
        
        [svgView addSubview:imgView];
        
        imgView.layer.name = name;
        
        [self.draggables setObject:[puzzleEnumerator nextObject] forKey:name];
    }
    
    __weak ViewController *bself = self;
    
    void (^playSfx)(NSString*, NSString*) = ^(NSString *track, NSString *extension) {
        
        [bself playSfx:track extension:extension];
    };
    
    self.onPiecePickedUp = ^(NSString *pieceName) {
        
        playSfx(@"s_click_01", @"m4a");
    };
    
    self.onAudioComplete = ^(AVAudioPlayer *player) {
        
        self.onAudioComplete = nil;
    };
    
    self.onPlacedPiece = ^(NSString *pieceName) {
        
        UIImageView *imgView = (id)[bself viewWithLayer:pieceName startingWith:bself.contentView];
        
        NSString *name = [pieceName stringByDeletingPathExtension];
        
        name = [name stringByAppendingFormat:@"a.%@", [pieceName pathExtension]];
        
        imgView.image = [UIImage imageNamed:name];
        
        playSfx(@"s_pilacecorrectpuzzlepiece_01", @"m4a");
        
        self.onAudioComplete = ^(AVAudioPlayer *player) {
            
            self.onAudioComplete = nil;
            
            if(!draggables.count) {
                
                int64_t delayInSeconds = 5.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    
                    [UIView beginAnimations:nil context:nil];
                    
                    for(UIView *subview in svgView.subviews)
                        if(subview)
                            subview.alpha = 0.0f;
                    
                    [UIView commitAnimations];
                    
                    [bself addReplayButton];
                });
                
                playSfx(@"s_puzzlecomplete_01", @"m4a");
                
                self.onAudioComplete = ^(AVAudioPlayer *player) {
                    
                    self.onAudioComplete = nil;
                    
                    playSfx(@"You're a bigshot!", @"m4a");
                };
            }
            else {
                
                NSArray *sounds =
                @[@"Jigsaw _Great Job_",
                @"Jigsaw _way to go bigshot_",
                @"Jigsaw _Way to go_",
                @"You're a bigshot!"
                ];
                
                playSfx([sounds objectAtIndex:rand() % sounds.count], @"m4a");
            }
        };
    };
    
    self.onFailedPiecePlacement = ^(NSString *pieceName) {
        
        playSfx(@"Try Again", @"m4a");
    };
    
    [self playTrack:@"Jigsaw _can you put this jigsaw puzzle together_" extension:@"m4a"];
}

- (void)beginPage15 {
    
    self.label.text = @"Do you want to be a Big Shot like Pablo?";
    
    [self animateSea];
    
    // PABLO
    
    self.arrow_right.hidden = YES;
    
    [self addReplayButton];
}

- (void)preloadScene {
    
    SEL selector = NSSelectorFromString([@"preloadPage" stringByAppendingString:self.pageNumber]);
    
    if([self respondsToSelector:selector])
        objc_msgSend(self, selector);
}

- (void)bubbleTransitionOn:(CALayer*)layer bubbles:(int)number speed:(float)duration {
    
    SVGDocument *bubbles = [SVGDocument documentNamed:@"bubbles"];
    
    NSArray *origBubbles =
    @[
    @"BUBBLE1",
    @"BUBBLE2",
    @"BUBBLE3",
    @"BUBBLE4",
    @"BUBBLE5",
    @"BUBBLE6",
    @"BUBBLE7",
    @"BUBBLE8",
    @"BUBBLE9",
    @"BUBBLE10",
    @"BUBBLE11"
    ];
    
    NSMutableArray *bubbleIds = [origBubbles mutableCopy];
    
    for(int i = 0; i < number; i++) {
        
        if(!bubbleIds.count) {
            
            bubbles = [SVGDocument documentNamed:@"bubbles"];
            bubbleIds = [origBubbles mutableCopy];
        }
        
        NSString *identifier = [bubbleIds objectAtIndex:rand() % bubbleIds.count];
        
        [bubbleIds removeObject:identifier];
        
        CALayer *bubble = [bubbles layerWithIdentifier:identifier];
        
        bubble.opacity = 0.25f;
        
        int dwidth = (int)layer.frame.size.width;
        int dheight = (int)layer.frame.size.height;
        
        if(!dwidth || !dheight)
            break;
        
        bubble.frame = (CGRect)
        {
            rand() % dwidth,
            dheight + (rand() % dheight),
            bubble.frame.size
        };
        
        [layer addSublayer:bubble];
        
        CABasicAnimation *animation = nil;
        
        animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        
        animation.duration = duration;
        animation.fromValue = @0.0f;
        animation.toValue = @(2 * -dheight);
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        [bubble addAnimation:animation forKey:nil];
    }
}

- (void)bubbleTransitionOn:(CALayer*)layer {
    
    [self bubbleTransitionOn:layer bubbles:70 speed:2.5f];
}

- (void)beginBubblesOnto:(CALayer*)layer {
    
    SVGDocument *bubbles = [SVGDocument documentNamed:@"bubbles"];
    
    NSArray *origBubbles =
    @[
    @"BUBBLE1",
    @"BUBBLE2",
    @"BUBBLE3",
    @"BUBBLE4",
    @"BUBBLE5",
    @"BUBBLE6",
    @"BUBBLE7",
    @"BUBBLE8",
    @"BUBBLE9",
    @"BUBBLE10",
    @"BUBBLE11"
    ];
    
    NSMutableArray *bubbleIds = [origBubbles mutableCopy];
    
    int number = 8 + (rand() % 17);
    
    for(int i = 0; i < number; i++) {
        
        if(!bubbleIds.count) {
            
            bubbles = [SVGDocument documentNamed:@"bubbles"];
            bubbleIds = [origBubbles mutableCopy];
        }
        
        NSString *identifier = [bubbleIds objectAtIndex:rand() % bubbleIds.count];
        
        [bubbleIds removeObject:identifier];
        
        CALayer *bubble = [bubbles layerWithIdentifier:identifier];
        
        bubble.opacity = 0.25f;
        
        int dwidth = (int)layer.frame.size.width;
        int dheight = (int)layer.frame.size.height;
        
        if(!dwidth || !dheight)
            break;
        
        bubble.frame = (CGRect)
        {
            rand() % dwidth,
            dheight + (rand() % dheight),
            bubble.frame.size
        };
        
        [layer addSublayer:bubble];
        
        CABasicAnimation *animation = nil;
        
        animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        
        animation.repeatCount = 10000;
        animation.duration = 10.0f;
        animation.fromValue = @0.0f;
        animation.toValue = @(3 * -dheight);
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        [bubble addAnimation:animation forKey:nil];
    }
}

- (void)beginBubbles {
    
    [self beginBubblesOnto:[self.contentView.document layerWithIdentifier:@"SEA"]];
}

- (void)beginScene {
    
    [self beginBubbles];
    
    NSMutableString *str = [_name mutableCopy];
    
    [str deleteCharactersInRange:(NSRange){0, 2}];
    
    NSString *resource = [NSString stringWithFormat:@"Page %@", self.pageNumber];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:resource withExtension:@"m4a"];
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    self.audioPlayer.delegate = self;
    
#if !(TARGET_IPHONE_SIMULATOR)
    [self.audioPlayer play];
#endif
    
    objc_msgSend(self, NSSelectorFromString([@"beginPage" stringByAppendingString:self.pageNumber]));
}

- (void)loadResource:(NSString *)name {
    
    [self dismissModalViewControllerAnimated:YES];
    
    self.arrow_right.hidden = NO;
    self.playAgain.hidden = YES;
    self.centerBtn.hidden = YES;
    
    self.label.hidden = YES;
    self.label.text = @"";
    self.label.font = [UIFont fontWithName:@"Filmotype Brooklyn" size:30.0f];
    
    self.audioPlayer.delegate = nil;
    
    [self.audioPlayer stop];
    
    self.audioPlayer = nil;
    
    [self.contentView.layer removeAllAnimations];
    
    self.draggables = nil;
    self.draggingLayer = nil;
    self.onAudioComplete = nil;
    self.onPlacedPiece = nil;
    self.onPiecePickedUp = nil;
    self.onPieceTapped = nil;
    self.onFailedPiecePlacement = nil;
    
	SVGDocument *document = [SVGDocument documentNamed:[name stringByAppendingPathExtension:@"svg"]];
    
    SVGView *lastContentView = self.contentView;
    SVGView *newContentView = [[SVGView alloc] initWithDocument:document];
    
    NSString *oldName = _name;
	
	_name = [name copy];
    
	self.contentView = newContentView;
    
    [self.scrollView setContentSize:CGSizeMake(document.width, document.height)];
    self.scrollView.minimumZoomScale = 0.334f;
    self.scrollView.zoomScale = 0.334f;
    
    [self preloadScene];
    
    if(lastContentView) {
        
        UIView *containerView = self.wrapperView;
        
        UIViewAnimationOptions transition = 0;
        
        if([self isPage:oldName beforePage:name])
            transition = UIViewAnimationOptionTransitionCurlUp;
        else
            transition = UIViewAnimationOptionTransitionCurlDown;
        
        NSString *newPageNum = [self pageNumberFromName:name];
        NSString *oldPageNum = [self pageNumberFromName:oldName];
        
        if([newPageNum hasSuffix:@"a"] && newPageNum.integerValue == oldPageNum.integerValue)
            transition = UIViewAnimationOptionTransitionCrossDissolve;
        
        if([oldPageNum hasSuffix:@"a"] && newPageNum.integerValue == oldPageNum.integerValue)
            transition = UIViewAnimationOptionTransitionCrossDissolve;
        
        [UIView transitionWithView:containerView
                          duration:1.5f
                           options:transition
                        animations:^{
                            [lastContentView removeFromSuperview];
                            [containerView insertSubview:newContentView atIndex:0];
                        }
                        completion:^(BOOL finished) {
                            
                            [self beginScene];
                            
                            self.label.alpha = 0.0f;
                            self.label.hidden = NO;
                            
                            [UIView beginAnimations:nil context:nil];
                            
                            self.label.alpha = 1.0f;
                            
                            [UIView commitAnimations];
                        }];
    }
    else {
        
        [self.wrapperView insertSubview:newContentView atIndex:0];
        
        [self beginScene];
        
        self.label.alpha = 0.0f;
        self.label.hidden = NO;
        
        [UIView beginAnimations:nil context:nil];
        
        self.label.alpha = 1.0f;
        
        [UIView commitAnimations];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    NSString *resource = [NSString stringWithFormat:@"Page %@a", [self pageNumber]];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:resource withExtension:@"m4a"];
    
    if(url && ![self.pageNumber isEqualToString:@"9"]) {
        
        self.audioPlayer.delegate = nil;
        
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
#if !(TARGET_IPHONE_SIMULATOR)
        [self.audioPlayer play];
#endif
    }
    else {
        
        if(self.onAudioComplete)
            self.onAudioComplete(player);
    }
}

- (CALayer *)layerForTouch:(UITouch *)touch {
    UIView *view = self.view;
    
    CGPoint location = [touch locationInView:view];
    location = [view convertPoint:location toView:nil];
    
    CALayer *hitPresentationLayer = [view.layer.presentationLayer hitTest:location];
    if (hitPresentationLayer) {
        return hitPresentationLayer.modelLayer;
    }
    
    return nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!self.didStart) {
        
        [self startTheGame];
        return;
    }
    
    self.draggingLayer = nil;
    totalDragMovement = 0;
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self.wrapperView];
    
    CALayer *layer = [self.contentView.layer hitTest:point];
    
    point = [self.contentView.layer convertPoint:point fromLayer:self.wrapperView.layer];
    
    NSArray *names = self.draggables.allKeys;
    
    if(self.onPieceTapped)
        for(CALayer *tmp = layer; tmp; tmp = tmp.superlayer)
            if(tmp.name)
                self.onPieceTapped(tmp.name);
    
    while(layer && ![names containsObject:layer.name])
        layer = layer.superlayer;
    
    if(layer) {
        
        self.draggingLayer = layer;
        
        firstPoint = point;
        
        self.draggingLayer.affineTransform = CGAffineTransformMakeScale(self.dragMultiplier, self.dragMultiplier);
        
        CALayer *superLayer = self.draggingLayer.superlayer;
        
        [self.draggingLayer removeFromSuperlayer];
        [superLayer addSublayer:self.draggingLayer];
        
        if(self.onPiecePickedUp)
            self.onPiecePickedUp(layer.name);
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!self.draggingLayer) {
        
        [self touchesBegan:touches withEvent:event];
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self.wrapperView];
    
    point = [self.contentView.layer convertPoint:point fromLayer:self.wrapperView.layer];
    
    totalDragMovement += fabsf(point.x - firstPoint.x) + fabsf(point.y - firstPoint.y);
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(point.x - firstPoint.x, point.y - firstPoint.y);
    
    transform = CGAffineTransformScale(transform, self.dragMultiplier, self.dragMultiplier);
    
//    NSLog(@"%@", NSStringFromCGRect(self.draggingLayer.frame));
    
    self.draggingLayer.affineTransform = transform;
    
    [CATransaction commit];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!self.draggingLayer)
        return;
    
    CGRect dragRect = self.draggingLayer.frame;
    
    self.draggingLayer.affineTransform = CGAffineTransformIdentity;
    
    NSValue *dest = [self.draggables objectForKey:self.draggingLayer.name];
    
    NSParameterAssert(dest);
    
    CGRect rect = [dest CGRectValue];
    
    NSString *pieceName = self.draggingLayer.name;
    
    if(!CGRectIntersectsRect(rect, dragRect)) {
        
        if(self.onFailedPiecePlacement)
            self.onFailedPiecePlacement(pieceName);
        
        return;
    }
    
    self.draggingLayer.affineTransform = CGAffineTransformMakeScale(rect.size.width / self.draggingLayer.frame.size.width, rect.size.height / self.draggingLayer.frame.size.height);
    
    self.draggingLayer.frame = rect;
    
    [self.draggables removeObjectForKey:pieceName];
    
    self.draggingLayer = nil;
    
    if(self.onPlacedPiece)
        self.onPlacedPiece(pieceName);
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!self.draggingLayer)
        return;
    
    self.draggingLayer.affineTransform = CGAffineTransformIdentity;
    
    self.draggingLayer = nil;
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
    [self setWrapperView:nil];
    [self setSplashImage:nil];
    [self setLabel:nil];
    [self setCenterBtn:nil];
    [self setPlayAgain:nil];
    [super viewDidUnload];
}

- (NSString*)pageNumberFromName:(NSString*)pageName {
    
    if(!pageName.length)
        return nil;
    
    NSMutableString *str = [pageName mutableCopy];
    
    [str deleteCharactersInRange:(NSRange){0, 2}];
    
    return [[str componentsSeparatedByString:@"."] objectAtIndex:0];
}

- (NSString*)pageNumber {
    
    return [self pageNumberFromName:_name];
}

- (void)animateSea {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    
	animation.duration = 3.0f;
	animation.autoreverses = YES;
	animation.repeatCount = 100000;
	animation.fromValue = @0.0f;
	animation.toValue = @-30.0f;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	[[self.contentView.document layerWithIdentifier:@"SEA"] addAnimation:animation forKey:nil];
}

- (void)playSfx:(NSString*)track extension:(NSString*)extension {
    
    if(!track)
        return;
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:track withExtension:extension];
    
    NSParameterAssert(url);
    
    if(!url)
        return;
    
    [self.sfxPlayer stop];
    self.sfxPlayer.delegate = nil;
    
    NSError *error = nil;
    
    self.sfxPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    self.sfxPlayer.delegate = self;
    
#if !(TARGET_IPHONE_SIMULATOR)
    [self.sfxPlayer play];
#else
    dispatch_async(dispatch_get_current_queue(), ^{
        
        [self audioPlayerDidFinishPlaying:nil successfully:YES];
    });
#endif
}

- (void)playTrack:(NSString*)track extension:(NSString*)extension {
    
    if(!track)
        return;
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:track withExtension:extension];
    
    if(!url)
        return;
    
    [self.audioPlayer stop];
    self.audioPlayer.delegate = nil;
    
    NSError *error = nil;
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    self.audioPlayer.delegate = self;
    
#if !(TARGET_IPHONE_SIMULATOR)
    [self.audioPlayer play];
#else
    dispatch_async(dispatch_get_current_queue(), ^{
        
        [self audioPlayerDidFinishPlaying:nil successfully:YES];
    });
#endif
}

- (void)playBackground:(NSString*)track extension:(NSString*)extension {
    
    if(!track)
        return;
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:track withExtension:extension];
    
    if(!url)
        return;
    
    [self.musicPlayer stop];
    self.musicPlayer.delegate = nil;
    
    NSError *error = nil;
    
    self.musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    self.musicPlayer.numberOfLoops = -1;
    
    self.musicPlayer.volume = 0.5f;
    
#if !(TARGET_IPHONE_SIMULATOR)
    [self.musicPlayer play];
#endif
}

- (void)animateUma {
    
    CALayer *uma = [self.contentView.document layerWithIdentifier:@"UMA"];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
	animation.duration = 2.33f;
	animation.autoreverses = YES;
	animation.repeatCount = 100000;
	animation.fromValue = @1.0f;
	animation.toValue = @1.05f;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	[uma addAnimation:animation forKey:nil];
}

- (void)setDraggablesUsingIdentifiers:(NSDictionary*)identifiers {
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    for(id key in identifiers) {
        
        CALayer *layer = [self.contentView.document layerWithIdentifier:[identifiers objectForKey:key]];
        
        [dictionary setObject:[NSValue valueWithCGRect:layer.frame] forKey:key];
    }
    
    self.draggables = dictionary;
}

- (BOOL)isPage:(NSString*)pageName beforePage:(NSString*)otherPageName {
    
    NSArray *ary = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"ResourceList" withExtension:@"plist"]];
    
    return [ary indexOfObject:pageName] < [ary indexOfObject:otherPageName];
}

- (NSArray*)floatingPieceNames {
    
    NSMutableArray *array = [NSMutableArray array];
    
    for(NSString *basename in @[ @"piece1", @"piece2", @"piece3", @"piece4", @"piece5", @"piece6" ])
        [array addObject:[NSString stringWithFormat:@"%@_%@.png", self.pageNumber, basename]];
    
    return array;
}

- (NSArray*)pieceNames {
    
    NSMutableArray *array = [NSMutableArray array];
    
    for(NSString *basename in @[ @"piece1", @"piece2", @"piece3", @"piece4", @"piece5", @"piece6" ])
        [array addObject:[NSString stringWithFormat:@"%@_%@a.png", self.pageNumber, basename]];
    
    return array;
}

- (NSArray*)floatPuzzlePositions {
    
    NSMutableArray *ret = [NSMutableArray array];
    
    if([self.pageNumber isEqualToString:@"4a"]) {
        
        [ret addObject:[NSValue valueWithCGRect:CGRectMake(400, -100, 312, 226)]];
        [ret addObject:[NSValue valueWithCGRect:CGRectMake(770, -100, 232, 335)]];
        
        [ret addObject:[NSValue valueWithCGRect:CGRectMake(-70, 250, 318, 237)]];
        [ret addObject:[NSValue valueWithCGRect:CGRectMake(-70, 540, 319, 237)]];
        
        [ret addObject:[NSValue valueWithCGRect:CGRectMake(1200, 200, 232, 319)]];
        [ret addObject:[NSValue valueWithCGRect:CGRectMake(1200, 560, 316, 226)]];
    }
    else {
        
        [ret addObject:[NSValue valueWithCGRect:CGRectMake(400, -100, 226, 312)]];
        [ret addObject:[NSValue valueWithCGRect:CGRectMake(770, -100, 335, 232)]];
        
        [ret addObject:[NSValue valueWithCGRect:CGRectMake(-70, 250, 318, 237)]];
        [ret addObject:[NSValue valueWithCGRect:CGRectMake(-70, 540, 319, 237)]];
        
        [ret addObject:[NSValue valueWithCGRect:CGRectMake(1200, 200, 232, 319)]];
        [ret addObject:[NSValue valueWithCGRect:CGRectMake(1200, 560, 316, 226)]];
    }
    
    return ret;
}

- (NSArray*)puzzlePositions {
    
    NSMutableArray *ret = [NSMutableArray array];
    
    if([self.pageNumber isEqualToString:@"4a"]) {
        
        [ret addObject:[NSValue valueWithCGRect:CGRectMake(281, 487, 417, 284)]];
        [ret addObject:[NSValue valueWithCGRect:CGRectMake(281, 193, 300, 442)]];
        
        [ret addObject:[NSValue valueWithCGRect:CGRectMake(446, 193, 420, 300)]];
        [ret addObject:[NSValue valueWithCGRect:CGRectMake(734, 193, 425, 300)]];
        
        [ret addObject:[NSValue valueWithCGRect:CGRectMake(862, 350, 296, 420)]];
        [ret addObject:[NSValue valueWithCGRect:CGRectMake(568, 487, 429, 284)]];
    }
    else {
        
        [ret addObject:[NSValue valueWithCGRect:CGRectMake(281, 487, 417, 284)]];
        [ret addObject:[NSValue valueWithCGRect:CGRectMake(281, 193, 300, 442)]];
        
        [ret addObject:[NSValue valueWithCGRect:CGRectMake(446, 193, 420, 300)]];
        [ret addObject:[NSValue valueWithCGRect:CGRectMake(734, 193, 425, 300)]];
        
        [ret addObject:[NSValue valueWithCGRect:CGRectMake(862, 350, 296, 420)]];
        [ret addObject:[NSValue valueWithCGRect:CGRectMake(568, 487, 429, 284)]];
    }
    
    return ret;
}

@end
