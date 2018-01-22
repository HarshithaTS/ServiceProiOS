
#import <UIKit/UIKit.h>


@interface ReusableAlertView : UIViewController {
	UIView *alertView;
	UILabel *alertLabel;
}

@property (nonatomic, retain) UIView *alertView;
@property (nonatomic, retain) UILabel *alertLabel;

-(UIView*) customAlertAppear:(NSString*)alertMessage withXaxis:(float)x yAxis:(float)y width:(float)width height:(float)height;

- (void)removeAlertForView ;

@end
