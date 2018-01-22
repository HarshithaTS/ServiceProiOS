//
//  GSPServiceTaskDetailViewController.h
//  GssServicePro
//
//  Created by Riyas Hassan on 05/06/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceTask.h"
#import "GSPBaseViewController.h"

#import "GssMobileConsoleiOS.h"

GssMobileConsoleiOS *objServiceMngtCls;

@interface GSPServiceTaskDetailViewController : GSPBaseViewController <UIDocumentInteractionControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *errorBackgroundLabel;
@property (weak, nonatomic) IBOutlet UIImageView *warningImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withObject:(ServiceTask*)serviceTaskObj atIndex:(int)index andOrdersArray:(NSMutableArray*)objectsArray;

- (void) showServiceConfirmation;

-(void)viewPDF;

@property (strong, nonatomic) NSString *tableName;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

- (IBAction)attachImageButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *hintNextLabel;
@property (weak, nonatomic) IBOutlet UIButton *hint_prevButton;
@property (weak, nonatomic) IBOutlet UIButton *hint_nextButton;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *warningImage;


@property (weak, nonatomic) IBOutlet UITextView *errorTextView;

@end
