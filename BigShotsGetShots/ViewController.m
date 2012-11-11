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

@end


@implementation ViewController
@synthesize scrollView;
@synthesize toolbar, contentView, detailItem;
@synthesize audioPlayer;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)goBack:(id)sender {
    
    NSArray *ary = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"ResourceList" withExtension:@"plist"]];
    
    NSUInteger index = [ary indexOfObject:_name];
    
    if(index == 0)
        return;
    
    index--;
    
    [self loadResource:[ary objectAtIndex:index]];
}

- (IBAction)goForward:(id)sender {
    
    NSArray *ary = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"ResourceList" withExtension:@"plist"]];
    
    NSUInteger index = [ary indexOfObject:_name];
    
    if(index == ary.count - 1)
        return;
    
    index++;
    
    [self loadResource:[ary objectAtIndex:index]];
}

- (void)setDetailItem:(id)newDetailItem {
	if (detailItem != newDetailItem) {
        
		[self loadResource:newDetailItem];
	}
}

- (void)loadResource:(NSString *)name
{
    [self.contentView removeFromSuperview];
    
	SVGDocument *document = [SVGDocument documentNamed:[name stringByAppendingPathExtension:@"svg"]];
	NSLog(@"[%@] Freshly loaded document (name = %@) has width,height = (%.2f, %.2f)", [self class], name, document.width, document.height );
	self.contentView = [[SVGView alloc] initWithDocument:document];
	
	_name = [name copy];
    
    [self.scrollView addSubview:self.contentView];
    
    [self.scrollView setContentSize:CGSizeMake(document.width, document.height)];
    self.scrollView.minimumZoomScale = 0.33f;
    self.scrollView.zoomScale = 0.33f;
    
    NSMutableString *str = [name mutableCopy];
    
    [str deleteCharactersInRange:(NSRange){0, 2}];
    
    NSString *number = [[str componentsSeparatedByString:@"."] objectAtIndex:0];
    
    NSString *resource = [NSString stringWithFormat:@"Page %@", number];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:resource withExtension:@"aif"];
    
    [self.audioPlayer stop];
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    [self.audioPlayer play];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.contentView;
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [super viewDidUnload];
}

@end
