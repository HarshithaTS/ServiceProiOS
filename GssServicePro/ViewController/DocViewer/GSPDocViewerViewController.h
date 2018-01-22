//
//  GSPDocViewerViewController.h
//  GssServicePro
//
//  Created by Riyas Hassan on 22/07/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPBaseViewController.h"

@interface GSPDocViewerViewController : GSPBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withData:(NSData*)data andFileName:(NSString*)fileName;
- (void)attachPdfToMailAndSend;
-(void)printPDF;

@end
