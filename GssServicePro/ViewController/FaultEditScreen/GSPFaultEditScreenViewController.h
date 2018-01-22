//
//  GSPFaultEditScreenViewController.h
//  GssServicePro
//
//  Created by Riyas Hassan on 07/10/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPBaseViewController.h"
#import "ServiceTask.h"

#import "GssMobileConsoleiOS.h"

GssMobileConsoleiOS *objServiceMngtCls;

@interface GSPFaultEditScreenViewController : GSPBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withServiceObject:(ServiceTask*)serviceTask andFaultObject:(NSMutableDictionary*)faultObj;

@property (strong, nonatomic) NSString *tableName;

@end
