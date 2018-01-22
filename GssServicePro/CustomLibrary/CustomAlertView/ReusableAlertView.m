//
//Display the alert when any activity id doing.... and user in waiting state..
///just call the function customAlertAppear with specified parameter... and remove the view from superview when action is done..

#import "ReusableAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import "GCDThreads.h"

@implementation ReusableAlertView

@synthesize alertView, alertLabel;


-(UIView*) customAlertAppear:(NSString*)alertMessage withXaxis:(float)x yAxis:(float)y width:(float)width height:(float)height {
	
         
	alertView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    
    CALayer *viewLayer = alertView.layer;
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.duration = 0.35555555;
    animation.values = [NSArray arrayWithObjects:
                        [NSNumber numberWithFloat:0.6],
                        [NSNumber numberWithFloat:1.1],
                        [NSNumber numberWithFloat:.9],
                        [NSNumber numberWithFloat:1],
                        nil];
    animation.keyTimes = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0.0],
                          [NSNumber numberWithFloat:0.6],
                          [NSNumber numberWithFloat:0.8],
                          [NSNumber numberWithFloat:1.0],
                          nil];
    
    [viewLayer addAnimation:animation forKey:@"transform.scale"];
	
	NSString *alertImage = [[NSBundle mainBundle] pathForResource:@"alert" ofType:@"png"];
	UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 80.0)];
    imgView.layer.cornerRadius = 8.0;
    imgView.layer.borderWidth = 3.0;
    imgView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
	imgView.image = [UIImage imageWithContentsOfFile:alertImage];
	
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	//indicator.center = CGPointMake(alertView.bounds.size.width / 2, alertView.bounds.size.height - 70);
    indicator.center = CGPointMake(25.0, alertView.bounds.size.height - 85);
	[indicator startAnimating];
	
	UILabel *indicatorlabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0, 30.0, 280.0, 20.0)];
	//indicatorlabel.text = alertMessage;
    indicatorlabel.text = alertMessage;// @"Please wait while processing...";
	indicatorlabel.font = [UIFont systemFontOfSize:16.0];
	[indicatorlabel setTextAlignment:NSTextAlignmentCenter];
	indicatorlabel.textColor = [UIColor whiteColor];
	indicatorlabel.backgroundColor = [UIColor clearColor];
    
    
	
	[imgView addSubview:indicatorlabel];
	[imgView addSubview:indicator];
	[alertView addSubview:imgView];
	[self.view addSubview:alertView];
	

	return alertView;
    
}

- (void)removeAlertForView {
    [self.alertView removeFromSuperview];
    self.alertView.alpha = 1.0;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




@end
