//
//  DetailViewController.h
//  SVGPad
//
//  Copyright Matt Rajca 2010-2011. All rights reserved.
//

#import "SVGKit.h"
#import "CALayerExporter.h"
#import "CALayerCamera.h"
#import <AVFoundation/AVAudioPlayer.h>

@interface ViewController : UIViewController < UIPopoverControllerDelegate, UISplitViewControllerDelegate, UIScrollViewDelegate, AVAudioPlayerDelegate> {
  @private
	NSString *_name;
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet SVGView *contentView;

@property (nonatomic, retain) id detailItem;

@end
