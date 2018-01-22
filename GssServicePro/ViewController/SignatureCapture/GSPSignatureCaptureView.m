//
//  GSPSignatureCaptureView.m
//  GssServicePro
//
//  Created by Riyas Hassan on 07/08/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPSignatureCaptureView.h"
#import <QuartzCore/QuartzCore.h>


@implementation GSPSignatureCaptureView

@synthesize imageFrame;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(wasDragged:)];
//        
//        [self addGestureRecognizer:panRecognizer];
       

    }
    return self;
}

- (void)awakeFromNib
{
    self.layer.cornerRadius             = 7;
    self.drawImage.layer.cornerRadius   = 7;
    self.layer.borderWidth              = 1.0;
    self.layer.borderColor              = [[UIColor blackColor]CGColor];
    fingerMoved                         = 0;
    
    
//    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(wasDragged:)];
//    
//    [self addGestureRecognizer:panRecognizer];
//    
    
//    self.drawImage.gestureRecognizers = NO ;


    //imageFrame                          = CGRectMake(self.frame.origin.x,self.frame.origin.y +30 ,self.frame.size.width,self.frame.size.height -80);
}
- (void)wasDragged:(UIPanGestureRecognizer *)recognizer {
    
    
    UIView *signImage = (UIView*)recognizer.view;
    //    UIImageView *signImage =(UIImageView*)recognizer.view;
    //    UIImagewView *imageView = (UIImagewView *)recognizer.view;
    CGPoint translation = [recognizer translationInView:signImage];
    
    signImage.center = CGPointMake(signImage.center.x + translation.x, signImage.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:signImage];
    self.drawImage.gestureRecognizers   =NO;

}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    self.signUpImage.hidden = YES;
    self.signHereLabel.hidden = YES;
    
    //did our finger moved yet?
    fingerMoved = NO;
    UITouch *touch = [touches anyObject];
    
    //just clear the image if the user tapped twice on the screen
    if ([touch tapCount] == 2) {
        self.drawImage.image = nil;
        return;
    }
    
    //we need 3 points of contact to make our signature smooth using quadratic bezier curve
   // currentPoint        = [touch locationInView:self.drawImage];
    lastContactPoint1   = [touch previousLocationInView:self.drawImage];
   // lastContactPoint2   = [touch previousLocationInView:self.drawImage];
    
}


//when one or more fingers associated with an event move within a view or window
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //well its obvious that our finger moved on the screen
    fingerMoved = YES;
    UITouch *touch = [touches anyObject];
    
    //save previous contact locations
   // lastContactPoint2 = lastContactPoint1;
    //lastContactPoint1 = [touch previousLocationInView:self.drawImage];
    //save current location
    currentPoint = [touch locationInView:self.drawImage];
    
    //find mid points to be used for quadratic bezier curve
    CGPoint midPoint1 = [self midPoint:lastContactPoint1 withPoint:lastContactPoint2];
    CGPoint midPoint2 = [self midPoint:currentPoint withPoint:lastContactPoint1];
    
    //create a bitmap-based graphics context and makes it the current context
    UIGraphicsBeginImageContext(self.drawImage.frame.size);
    
    //draw the entire image in the specified rectangle frame
    [self.drawImage.image drawInRect:CGRectMake(0, 0, self.drawImage.frame.size.width, self.drawImage.frame.size.height)];
    
    //set line cap, width, stroke color and begin path
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0f);
  //  CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    //CGContextBeginPath(UIGraphicsGetCurrentContext());
    
    //begin a new new subpath at this point
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastContactPoint1.x, lastContactPoint1.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);

    //create quadratic Bézier curve from the current point using a control point and an end point
   // CGContextAddQuadCurveToPoint(UIGraphicsGetCurrentContext(),
                             //    lastContactPoint1.x, lastContactPoint1.y, midPoint2.x, midPoint2.y);
    
    //set the miter limit for the joins of connected lines in a graphics context
   // CGContextSetMiterLimit(UIGraphicsGetCurrentContext(), 2.0);
    
    //paint a line along the current path
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);

    //set the image based on the contents of the current bitmap-based graphics context
    self.drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    
    //remove the current bitmap-based graphics context from the top of the stack
    UIGraphicsEndImageContext();
    
    lastContactPoint1 = currentPoint;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    //just clear the image if the user tapped twice on the screen
    if ([touch tapCount] == 2) {
        self.drawImage.image = nil;
        return;
    }
    
    
    //if the finger never moved draw a point
    if(!fingerMoved) {
        UIGraphicsBeginImageContext(self.drawImage.frame.size);
        [self.drawImage.image drawInRect:CGRectMake(0, 0, self.drawImage.frame.size.width, self.drawImage.frame.size.height)];
        
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0f);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        
        self.drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIGraphicsBeginImageContext(self.drawImage.frame.size);
        // [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
        CGFloat opacity=1.0;
        [self.drawImage.image drawInRect:CGRectMake(0, 0, self.drawImage.frame.size.width, self.drawImage.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity ];
        self.drawImage.image = UIGraphicsGetImageFromCurrentImageContext();

    }
}

//calculate midpoint between two points
- (CGPoint) midPoint:(CGPoint )p0 withPoint: (CGPoint) p1 {
    return (CGPoint) {
        (p0.x + p1.x) / 2.0,
        (p0.y + p1.y) / 2.0
    };
}

//Implement these two methods where you are adding this view as subview

//To save signature
- (IBAction)saveSignature:(id)sender
{

}

//To remove view from superview
- (IBAction)cancelSignature:(id)sender
{
    self.drawImage.image = nil;
}
@end
