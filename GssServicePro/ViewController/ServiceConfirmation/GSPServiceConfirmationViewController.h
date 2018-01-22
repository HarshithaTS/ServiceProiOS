//
//  GSPServiceConfirmationViewController.h
//  GssServicePro
//
//  Created by Riyas Hassan on 09/09/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSPBaseViewController.h"
#import "ServiceTask.h"

#import "GssMobileConsoleiOS.h"

GssMobileConsoleiOS *objServiceMngtCls;

@interface GSPServiceConfirmationViewController : GSPBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forObject:(ServiceTask*)serviceOrder;

- (IBAction)addNewConfirmationAction:(id)sender;

@property (strong, nonatomic) NSString *tableName;

@end
