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

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, strong) SVGDocument *uiElements;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *forwardBtn;

// The number of the page (may contain a letter on the end ie. 5a).
@property (nonatomic, readonly) NSString *pageNumber;

@property (nonatomic, strong) CALayer *draggingLayer;

@property (nonatomic, assign) CGPoint firstPoint;

// Keys are the layer names of the items that can be dragged.
// Values are NSValue's holding CGRect's. Once dragged by the user, the named layer's
// frame will be set to to this value.
@property (nonatomic, strong) NSMutableDictionary *draggables;

@property (nonatomic, copy) void (^onAudioComplete)(AVAudioPlayer *player);

@property (nonatomic, copy) void (^onPlacedPiece)(NSString *pieceName);
@property (nonatomic, copy) void (^onFailedPiecePlacement)(NSString *pieceName);

@end

@implementation ViewController
@synthesize scrollView;
@synthesize toolbar, contentView, detailItem;
@synthesize audioPlayer;
@synthesize draggingLayer;
@synthesize firstPoint;
@synthesize draggables;
@synthesize onAudioComplete;
@synthesize onPlacedPiece, onFailedPiecePlacement;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.uiElements = [SVGDocument documentNamed:@"UI_pablo-NH"];
    
    CALayer *arrow_left = [self.uiElements layerWithIdentifier:@"arrow-left-normal"];
    
//    [self.view.layer addSublayer:arrow_left];
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

- (BOOL)isPage:(NSString*)pageName beforePage:(NSString*)otherPageName {
    
    NSArray *ary = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"ResourceList" withExtension:@"plist"]];
    
    return [ary indexOfObject:pageName] < [ary indexOfObject:otherPageName];
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

- (void)animateSea {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    
	animation.duration = 1.0f;
	animation.autoreverses = YES;
	animation.repeatCount = 100000;
	animation.fromValue = @0.0f;
	animation.toValue = @-20.0f;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	[[self.contentView.document layerWithIdentifier:@"SEA"] addAnimation:animation forKey:nil];
}

- (void)beginPage1 {
    
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
    
    SVGView *svgView = self.contentView;
    
    [svgView.document layerWithIdentifier:@"PABLO"].hidden = NO;
    
    CABasicAnimation *animation = nil;
    
    [self animateSea];
    
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
    
    double delayInSeconds = 7.0;
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
}

- (void)preloadPage5 {
    
    SVGView *svgView = self.contentView;
    
    [svgView.document layerWithIdentifier:@"PABLO"].hidden = YES;
}

- (void)beginPage5 {
    
    SVGView *svgView = self.contentView;
    
    [svgView.document layerWithIdentifier:@"PABLO"].hidden = NO;
    
    CABasicAnimation *animation = nil;
    
    [self animateSea];
    
	animation = [CABasicAnimation animationWithKeyPath:@"transform.translation"];
    
	animation.duration = 4.5f;
	animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(-600.0f, 0.0f)];
	animation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.0f, 0.0f)];
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	
	[[svgView.document layerWithIdentifier:@"PABLO"] addAnimation:animation forKey:nil];
    
    NSArray *array = @[
    @[ @5.75f, @"TUNA TRIPS"],
    @[ @8.5f, @"CHRIS"],
    @[ @9.75f, @"BO"],
    @[ @11.0f, @"SAMMY"],
    ];
    
    for(NSArray *items in array) {
        
        double delayInSeconds = [[items objectAtIndex:0] floatValue];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            
            animation.duration = 0.5f;
            animation.fromValue = @1.15f;
            animation.toValue = @1.0f;
            
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            
            CALayer *tmp = [svgView.document layerWithIdentifier:[items objectAtIndex:1]];
            
            [tmp addAnimation:animation forKey:nil];
        });
    }
}

- (void)setDraggablesUsingIdentifiers:(NSDictionary*)identifiers {
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    for(id key in identifiers) {
        
        CALayer *layer = [self.contentView.document layerWithIdentifier:[identifiers objectForKey:key]];
        
        [dictionary setObject:[NSValue valueWithCGRect:layer.frame] forKey:key];
    }
    
    self.draggables = dictionary;
}

- (void)beginPage5a {
    
    [self animateSea];
    
    [self setDraggablesUsingIdentifiers:
     @{
     @"BO": @"BO_DEST",
     @"TUNA_TRIPS": @"TUNA_TRIPS_DEST",
     @"KAT": @"KAT_DEST",
     @"SAMMY": @"SAMMY_DEST",
     @"CHRIS": @"CHRIS_DEST",
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
    
    void (^playTrack)(NSString*, NSString*) = ^(NSString *track, NSString *extension) {
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:track withExtension:extension];
        
        [self.audioPlayer stop];
        self.audioPlayer.delegate = nil;
        
        NSError *error = nil;
        
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        
        self.audioPlayer.delegate = self;
        
        [self.audioPlayer play];
    };
    
    void (^playNextTrack)() = ^{
        
        if(![trackByIdentifier count])
            return;
        
        NSArray *keys = trackByIdentifier.allKeys;
        
        NSString *track = [trackByIdentifier objectForKey:[keys objectAtIndex:rand() % keys.count]];
        
        playTrack(track, @"aif");
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
        
        if(!draggables.count) {
            
            playTrack(@"You're a bigshot!", @"aif");
        }
        else {
            
            NSArray *sounds =
            @[@"Great Job",
            @"Way to go!",
            @"You're a bigshot!"
            ];
            
            playTrack([sounds objectAtIndex:rand() % sounds.count], @"aif");
            
            self.onAudioComplete = ^(AVAudioPlayer *player) {
                
                self.onAudioComplete = nil;
                
                playNextTrack();
            };
        }
    };
    
    self.onFailedPiecePlacement = ^(NSString *pieceName) {
        
        playTrack(@"Try Again", @"aif");
    };
    
    playTrack(@"Can you find Pablos friends", @"aif");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:touch.view];
    
    CALayer *layer = [self.contentView.layer hitTest:point];
    
    point = [self.contentView.layer convertPoint:point fromLayer:touch.view.layer];
    
    NSArray *names = self.draggables.allKeys;
    
    while(layer && ![names containsObject:layer.name])
        layer = layer.superlayer;
    
    if(layer) {
        
        self.draggingLayer = layer;
        
        firstPoint = point;
        
        self.draggingLayer.affineTransform = CGAffineTransformMakeScale(2.0f, 2.0f);
        
        CALayer *superLayer = self.draggingLayer.superlayer;
        
        [self.draggingLayer removeFromSuperlayer];
        [superLayer addSublayer:self.draggingLayer];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!self.draggingLayer)
        return;
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:touch.view];
    
    point = [self.contentView.layer convertPoint:point fromLayer:touch.view.layer];
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(point.x - firstPoint.x, point.y - firstPoint.y);
    
    transform = CGAffineTransformScale(transform, 2.0f, 2.0f);
    
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

- (void)preloadPage6 {
    
    SVGView *svgView = self.contentView;
    
    [svgView.document layerWithIdentifier:@"PABLO"].hidden = YES;
    
    CALayer *ground = [svgView.document layerWithIdentifier:@"GROUND"];
    CALayer *uma = [svgView.document layerWithIdentifier:@"UMA"];
    
    [ground setAffineTransform:CGAffineTransformMakeTranslation(0, 500)];
    [uma setAffineTransform:CGAffineTransformMakeTranslation(0, 500)];
}

- (void)beginPage6 {
    
    SVGView *svgView = self.contentView;
    
    [svgView.document layerWithIdentifier:@"PABLO"].hidden = NO;
    
    CABasicAnimation *animation = nil;
    
    [self animateSea];
    
	animation = [CABasicAnimation animationWithKeyPath:@"transform.translation"];
    
	animation.duration = 4.5f;
	animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(-600.0f, 0.0f)];
	animation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.0f, 0.0f)];
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	
	[[svgView.document layerWithIdentifier:@"PABLO"] addAnimation:animation forKey:nil];
    
    CALayer *ground = [svgView.document layerWithIdentifier:@"GROUND"];
    CALayer *uma = [svgView.document layerWithIdentifier:@"UMA"];
    
    [self animateUma];
    
    double delayInSeconds = 11.0f;
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
    });
}

- (void)beginPage7 {
    
    [self animateSea];
}

- (void)beginPage8 {
    
    [self animateSea];
}

- (void)preloadPage9 {
    
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

- (void)beginPage12 {
    
    [self animateSea];
    
    // PABLO
    // FRIENDS
    // GERM
}

- (void)beginPage13 {
    
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
    
    // Same as 13 plus
    // UMA
    // GROUND
}

- (void)beginPage15 {
    
    [self animateSea];
    
    // PABLO
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

- (void)preloadScene {
    
    SEL selector = NSSelectorFromString([@"preloadPage" stringByAppendingString:self.pageNumber]);
    
    if([self respondsToSelector:selector])
        objc_msgSend(self, selector);
}

- (void)beginScene {
    
    NSMutableString *str = [_name mutableCopy];
    
    [str deleteCharactersInRange:(NSRange){0, 2}];
    
    NSString *resource = [NSString stringWithFormat:@"Page %@", self.pageNumber];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:resource withExtension:@"aif"];
    
    self.audioPlayer.delegate = nil;
    
    [self.audioPlayer stop];
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    self.audioPlayer.delegate = self;
    
    [self.audioPlayer play];
    
    objc_msgSend(self, NSSelectorFromString([@"beginPage" stringByAppendingString:self.pageNumber]));
}

- (void)loadResource:(NSString *)name {
    
    [self.contentView.layer removeAllAnimations];
    
    self.draggables = nil;
    self.onAudioComplete = nil;
    self.onPlacedPiece = nil;
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
                          duration:0.75f
                           options:transition
                        animations:^{
                            [lastContentView removeFromSuperview];
                            [containerView insertSubview:newContentView atIndex:0];
                        }
                        completion:^(BOOL finished) {
                            [self beginScene];
                        }];
    }
    else {
        
        [self.wrapperView insertSubview:newContentView atIndex:0];
        
        [self beginScene];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    NSString *resource = [NSString stringWithFormat:@"Page %@a", [self pageNumber]];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:resource withExtension:@"aif"];
    
    if(url) {
        
        self.audioPlayer.delegate = nil;
        
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        [self.audioPlayer play];
    }
    else {
        
        if(self.onAudioComplete)
            self.onAudioComplete(player);
    }
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
    [super viewDidUnload];
}

@end
