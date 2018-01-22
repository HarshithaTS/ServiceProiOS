//
//  GSPServiceTasksViewController.h
//  GssServicePro
//
//  Created by Riyas Hassan on 04/06/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSPBaseViewController.h"
#import "Colleagues.h"
#import "ServiceTask.h"

@interface GSPServiceTasksViewController : GSPBaseViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forView:(ScreenType)type withTitle:(NSString*)selectedColleagueName anduName:(NSString*)uName;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forView:(ScreenType)type withTitle:(NSString*)selectedColleagueName andSelectedColleague:(Colleagues *)selected_colleague transferTask:(ServiceTask *)transferTask;
@property (weak, nonatomic) IBOutlet UIImageView *sortCustIcon;
@property (weak, nonatomic) IBOutlet UIImageView *sortEstimatIcon;
@property (weak, nonatomic) IBOutlet UIImageView *sortOrderIcon;
@property (weak, nonatomic) IBOutlet UIImageView *sortContIcon;
@property (weak, nonatomic) IBOutlet UIImageView *sortCustIconPortrait;
@property (weak, nonatomic) IBOutlet UIImageView *sortEstPortrait;
@property (weak, nonatomic) IBOutlet UIImageView *sortDocPortrait;
@property (weak, nonatomic) IBOutlet UIImageView *sortContPortrait;
@property (weak, nonatomic) IBOutlet UIImageView *sortPrioIcon;
@property (weak, nonatomic) IBOutlet UIImageView *sortStatIcon;
@property (weak, nonatomic) IBOutlet UIImageView *sortStartDateIcon;
@property (weak, nonatomic) IBOutlet UIImageView *sortDatePortrait;
@property (weak, nonatomic) IBOutlet UIImageView *sortPrioPortait;
@property (weak, nonatomic) IBOutlet UIImageView *sortStatPortrait;




- (void) getServiceTasksFromStorageAndReloadTableView;
@end
