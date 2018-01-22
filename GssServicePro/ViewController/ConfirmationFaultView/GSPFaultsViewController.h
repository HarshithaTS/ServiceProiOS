//
//  GSPFaultsViewController.h
//  GssServicePro
//
//  Created by Riyas Hassan on 18/09/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPBaseViewController.h"
#import "ServiceTask.h"

#import "GssMobileConsoleiOS.h"

GssMobileConsoleiOS *objServiceMngtCls;

@interface GSPFaultsViewController : GSPBaseViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withObject:(ServiceTask*)serviceTask;

@property (strong, nonatomic) NSString *tableName;

@end
