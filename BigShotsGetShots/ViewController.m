//
//  DetailViewController.m
//  SVGPad
//
//  Copyright Matt Rajca 2010-2011. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

- (void)loadResource:(NSString *)name;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *forwardBtn;

// The number of the page (may contain a letter on the end ie. 5a).
@property (nonatomic, readonly) NSString *pageNumber;

@property (nonatomic, strong) CALayer *draggingLayer;

@property (nonatomic, assign) CGPoint firstPoint;

// Keys are the layer names of the items that can be dragged.
// Values are NSValue's holding CGRect's. Once dragged by the user, the named layer's
// frame will be set to to this value.
@property (nonatomic, strong) NSDictionary *draggables;

@end

@implementation ViewController
@synthesize scrollView;
@synthesize toolbar, contentView, detailItem;
@synthesize audioPlayer;
@synthesize draggingLayer;
@synthesize firstPoint;
@synthesize draggables;

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

- (void)animateSea {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    
	animation.duration = 1.0f;
	animation.autoreverses = YES;
	animation.repeatCount = 100000;
	animation.fromValue = @10.0f;
	animation.toValue = @-10.0f;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	[[self.contentView.document layerWithIdentifier:@"SEA"] addAnimation:animation forKey:nil];
}

- (void)page1 {
    
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

- (void)page3 {
    
    SVGView *svgView = self.contentView;
    
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
    
    bubbles.opacity = 0;
    
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

- (void)page4 {
    
    SVGView *svgView = self.contentView;
    
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
    
    bubbles.opacity = 0.0f;
    pabloReflection.opacity = 0.0f;
    
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

- (void)page5 {
    
    SVGView *svgView = self.contentView;
    
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

- (void)page5a {
    
    [self animateSea];
    
    self.draggables =
    @{
    @"BO" : [NSValue valueWithCGRect:[self.contentView.document layerWithIdentifier:@"BO_DEST"].frame],
    @"TUNA_TRIPS" : [NSValue valueWithCGRect:[self.contentView.document layerWithIdentifier:@"TUNA_TRIPS_DEST"].frame],
    @"KAT" : [NSValue valueWithCGRect:[self.contentView.document layerWithIdentifier:@"KAT_DEST"].frame],
    @"SAMMY" : [NSValue valueWithCGRect:[self.contentView.document layerWithIdentifier:@"SAMMY_DEST"].frame],
    @"CHRIS" : [NSValue valueWithCGRect:[self.contentView.document layerWithIdentifier:@"CHRIS_DEST"].frame],
    @"PABLO" : [NSValue valueWithCGRect:[self.contentView.document layerWithIdentifier:@"PABLO_DEST"].frame],
    };
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
    
    self.draggingLayer.affineTransform = CGAffineTransformIdentity;
    
    NSValue *dest = [self.draggables objectForKey:self.draggingLayer.name];
    
    NSParameterAssert(dest);
    
    CGRect rect = [dest CGRectValue];
    
    self.draggingLayer.affineTransform = CGAffineTransformMakeScale(rect.size.width / self.draggingLayer.frame.size.width, rect.size.height / self.draggingLayer.frame.size.height);
    
    self.draggingLayer.frame = rect;
    
    self.draggingLayer = nil;
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

- (void)page6 {
    
    SVGView *svgView = self.contentView;
    
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
    
    [ground setAffineTransform:CGAffineTransformMakeTranslation(0, 500)];
    [uma setAffineTransform:CGAffineTransformMakeTranslation(0, 500)];
    
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

- (void)page7 {
    
    [self animateSea];
}

- (void)page8 {
    
    [self animateSea];
}

- (void)page9 {
    
    SVGView *svgView = self.contentView;
    
    [self animateSea];
    
    CALayer *pablo = [svgView.document layerWithIdentifier:@"PABLO"];
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(-600.0f, 0.0f);
    
    transform = CGAffineTransformScale(transform, 0.1f, 0.1f);
    
    [pablo setAffineTransform:transform];
    
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

- (void)page10 {
    
    SVGView *svgView = self.contentView;
    
    [self animateSea];
    
    CABasicAnimation *animation = nil;
    
    animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    
    animation.duration = 2.0f;
    animation.fromValue = @-440.0f;
    animation.toValue = @0.0f;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [[svgView.document layerWithIdentifier:@"BASEBALL"] addAnimation:animation forKey:nil];
}

- (void)page11 {
    
    SVGView *svgView = self.contentView;
    
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
    
    bubbles.opacity = 0;
    pabloNeedles.opacity = 0;
    [germ setAffineTransform:CGAffineTransformMakeTranslation(600.0f, 0.0f)];
    
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

- (void)page12 {
    
    [self animateSea];
    
    // PABLO
    // FRIENDS
    // GERM
}

- (void)page13 {
    
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

- (void)page14 {
    
    [self animateSea];
    
    // Same as 13 plus
    // UMA
    // GROUND
}

- (void)page15 {
    
    [self animateSea];
    
    // PABLO
}

- (NSString*)pageNumber {
    
    if(!_name.length)
        return nil;
    
    NSMutableString *str = [_name mutableCopy];
    
    [str deleteCharactersInRange:(NSRange){0, 2}];
    
    return [[str componentsSeparatedByString:@"."] objectAtIndex:0];
}

- (void)loadResource:(NSString *)name {
    
    [self.contentView.layer removeAllAnimations];
    
    [self.contentView removeFromSuperview];
    
    self.draggables = nil;
    
	SVGDocument *document = [SVGDocument documentNamed:[name stringByAppendingPathExtension:@"svg"]];
    
	self.contentView = [[SVGView alloc] initWithDocument:document];
	
	_name = [name copy];
    
    [self.scrollView addSubview:self.contentView];
    
    [self.scrollView setContentSize:CGSizeMake(document.width, document.height)];
    self.scrollView.minimumZoomScale = 0.334f;
    self.scrollView.zoomScale = 0.334f;
    
    NSMutableString *str = [name mutableCopy];
    
    [str deleteCharactersInRange:(NSRange){0, 2}];
    
    NSString *number = [self pageNumber];
    
    NSString *resource = [NSString stringWithFormat:@"Page %@", number];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:resource withExtension:@"aif"];
    
    self.audioPlayer.delegate = nil;
    
    [self.audioPlayer stop];
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    self.audioPlayer.delegate = self;
    
    [self.audioPlayer play];
    
    if([number isEqualToString:@"1"])
        [self page1];
    
    if([number isEqualToString:@"3"])
        [self page3];
    
    if([number isEqualToString:@"4"])
        [self page4];
    
    if([number isEqualToString:@"5"])
        [self page5];
    
    if([number isEqualToString:@"5a"])
        [self page5a];
    
    if([number isEqualToString:@"6"])
        [self page6];
    
    if([number isEqualToString:@"7"])
        [self page7];
    
    if([number isEqualToString:@"8"])
        [self page8];
    
    if([number isEqualToString:@"9"])
        [self page9];
    
    if([number isEqualToString:@"10"])
        [self page10];
    
    if([number isEqualToString:@"11"])
        [self page11];
    
    if([number isEqualToString:@"12"])
        [self page12];
    
    if([number isEqualToString:@"13"])
        [self page13];
    
    if([number isEqualToString:@"14"])
        [self page14];
    
    if([number isEqualToString:@"15"])
        [self page15];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    NSString *resource = [NSString stringWithFormat:@"Page %@a", [self pageNumber]];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:resource withExtension:@"aif"];
    
    if(url) {
        
        self.audioPlayer.delegate = nil;
        
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        [self.audioPlayer play];
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
    [super viewDidUnload];
}

@end
