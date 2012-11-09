//
//  DetailViewController.m
//  SVGPad
//
//  Copyright Matt Rajca 2010-2011. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

- (void)loadResource:(NSString *)name;

@end


@implementation ViewController
@synthesize scrollView;
@synthesize toolbar, contentView, detailItem;

- (void)viewDidLoad
{
    [super viewDidLoad];
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
}

- (IBAction)tapEvent:(id)sender {
    
    NSArray *ary = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"ResourceList" withExtension:@"plist"]];
    
    NSUInteger index = [ary indexOfObject:_name];
    
    index++;
    
    if(index >= ary.count)
        return;
    
    [self loadResource:[ary objectAtIndex:index]];
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
