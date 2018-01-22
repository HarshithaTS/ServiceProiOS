//
//  GSPCaptureSignatureViewController.m
//  GssServicePro
//
//  Created by Riyas Hassan on 10/07/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPCaptureSignatureViewController.h"

@interface GSPCaptureSignatureViewController ()
{
    CGPoint         lastPoint;
    UIImageView   * drawImage;
    BOOL            mouseSwiped;
    int             mouseMoved;
    
}

@property (nonatomic, strong)  NSString * serviceOrderId;
@end

@implementation GSPCaptureSignatureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withServiceId:(NSString*)serviceID
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.serviceOrderId = serviceID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpView];
}

- (void) setUpView
{
    
    [self setCustomRightBarButtonItem:@selector(saveSignature:) withImageNamed:@"Save.png"];
    
    self.title                  = @"Write your signature";
    drawImage                   = [[UIImageView alloc] initWithImage:nil];
//    drawImage.frame             =  CGRectMake(self.view.bounds.origin.x + 30, self.view.bounds.origin.y + 100, self.view.bounds.size.width - 60, self.view.bounds.size.height - 300);
    drawImage.backgroundColor   = [UIColor lightGrayColor];
    drawImage.layer.cornerRadius= 7.0;
    drawImage.userInteractionEnabled   =YES;
    [self.view addSubview:drawImage];
    
    mouseMoved = 0;

}

- (void)saveSignature:(id)sender
{
    NSData *imageData                   = [NSData dataWithData:UIImagePNGRepresentation(drawImage.image)];
    
    NSString * signatureFolderPath      = [[GSPUtility sharedInstance] getSignatureFolderPathForFileName:self.serviceOrderId forPathComponent:@"AttachedSignatures"];
    
    [imageData writeToFile:signatureFolderPath atomically:YES];
    
    [[GSPUtility sharedInstance] showAlertWithTitle:@"" message:@"Successfully saved signature " otherButton:nil tag:0 andDelegate:self];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	mouseSwiped = NO;
	UITouch *touch = [touches anyObject];
	
	if ([touch tapCount] == 2) {
		drawImage.image = nil;
		return;
	}
    
	lastPoint = [touch locationInView:drawImage];
	lastPoint.y -= 20;
    
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	mouseSwiped = YES;
	
	UITouch *touch = [touches anyObject];
	CGPoint currentPoint = [touch locationInView:drawImage];
	currentPoint.y -= 20;
	
	
	UIGraphicsBeginImageContext(drawImage.frame.size);
	[drawImage.image drawInRect:CGRectMake(0, 0, drawImage.frame.size.width, drawImage.frame.size.height)];
    
	CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);
	CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
	CGContextBeginPath(UIGraphicsGetCurrentContext());
	CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
	CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
	CGContextStrokePath(UIGraphicsGetCurrentContext());
	drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	lastPoint = currentPoint;
    
	mouseMoved++;
	
	if (mouseMoved == 10) {
		mouseMoved = 0;
	}
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	
	if ([touch tapCount] == 2) {
		drawImage.image = nil;
		return;
	}
	
	
	if(!mouseSwiped) {
		UIGraphicsBeginImageContext(drawImage.frame.size);
		[drawImage.image drawInRect:CGRectMake(0, 0, drawImage.frame.size.width, drawImage.frame.size.height)];
		CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
		CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);
		CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
		CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
		CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
		CGContextStrokePath(UIGraphicsGetCurrentContext());
		CGContextFlush(UIGraphicsGetCurrentContext());
		drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
