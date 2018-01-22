//
//  GSPImagePreviewController.h
//  GssServicePro
//
//  Created by Riyas Hassan on 02/07/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPBaseViewController.h"

@interface GSPImagePreviewController : GSPBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withImage:(UIImage*)image;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withImage:(UIImage*)image withSinaturePath:(NSString*)sigFilePath;

@end
