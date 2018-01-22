//
//  GSPServiceConfCreationViewController.h
//  GssServicePro
//
//  Created by Riyas Hassan on 12/09/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSPBaseViewController.h"

#import "GssMobileConsoleiOS.h"

GssMobileConsoleiOS *objServiceMngtCls;

@interface GSPServiceConfCreationViewController : GSPBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSelectedOrders:(NSMutableArray*)selectedArray;

@property (strong, nonatomic) NSString *tableName;

@property NSInteger increNumExt;

@end
