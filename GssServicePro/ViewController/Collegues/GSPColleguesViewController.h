//
//  GSPColleguesViewController.h
//  GssServicePro
//
//  Created by Riyas Hassan on 05/08/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPBaseViewController.h"
#import "ServiceTask.h"

#import "GssMobileConsoleiOS.h"

GssMobileConsoleiOS *objServiceMngtCls;

@interface GSPColleguesViewController : GSPBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forTaskTasnfer:(ServiceTask*)serviceOrder;

-(void) getColleagueTaskListFromSAPForPartner:(NSString*)partnerUName;

@end
