//
//  GSPSparesEditViewController.h
//  GssServicePro
//
//  Created by Riyas Hassan on 29/09/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPBaseViewController.h"
#import "ServiceTask.h"

#import "GssMobileConsoleiOS.h"

GssMobileConsoleiOS *objServiceMngtCls;


@interface GSPSparesEditViewController : GSPBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil WithObjectID:(ServiceTask*)servicetask andSpareObject:(NSMutableDictionary*)sparesDict;

@property (strong, nonatomic) NSString *tableName;

@end
