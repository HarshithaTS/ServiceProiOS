//
//  GSPDiagnosePopUpViewController.h
//  GssServicePro
//
//  Created by Harshitha on 3/27/15.
//  Copyright (c) 2015 Harshitha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSPDiagnosePopUpViewController : UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withDiagnoseInfo:(NSMutableArray*)diagnoseInfoArray andDisableDiagButton:(int)buttonStatus fromScreen:(NSString *)ScreenName;

@property (strong, nonatomic) IBOutlet UITextView *diagnoseInfoTextView;

- (void)initializeDiagTextView;

- (IBAction)doneButtonClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *disableDiagnosisButton;

- (IBAction)disableDiagButtonClicked:(id)sender;

- (IBAction)sendDiagnosisInfoMail:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *diagPopUpView;

@end
