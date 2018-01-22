//
//  GSPDiagnosePopUpViewController.m
//  GssServicePro
//
//  Created by Harshitha on 3/27/15.
//  Copyright (c) 2015 Harshitha. All rights reserved.
//

#import "GSPDiagnosePopUpViewController.h"
#import <MessageUI/MessageUI.h>
//#import "GSPServiceTasksViewController.h"

@interface GSPDiagnosePopUpViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation GSPDiagnosePopUpViewController

@synthesize diagnoseInfoTextView;
NSMutableArray *diagnoseArray;
NSString *settingsInfo, *screenName;
@synthesize diagPopUpView;
@synthesize disableDiagnosisButton;
int disableDiagButtonStatus;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withDiagnoseInfo:(NSMutableArray*)diagnoseInfoArray andDisableDiagButton:(int)buttonStatus fromScreen:(NSString *)ScreenName
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        diagnoseArray = [NSMutableArray arrayWithArray:(NSMutableArray*)diagnoseInfoArray];
        disableDiagButtonStatus = buttonStatus;
        screenName = [NSString stringWithFormat:@"%@",ScreenName];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setDisableDiagnosisButton];
    
    [self initializeDiagTextView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDisableDiagnosisButton
{
    if (disableDiagButtonStatus == 1) {
        disableDiagnosisButton.hidden = NO;
    }
    else if(disableDiagButtonStatus == 0) {
        disableDiagnosisButton.hidden = YES;
    }
}

- (void)initializeDiagTextView
{
    if ([diagnoseArray count] >  0) {
        
        settingsInfo = @"";
        
        for (NSString *settingsStrng in diagnoseArray) {
            
            settingsInfo =  [NSString stringWithFormat:@"%@  \n%@",settingsInfo, settingsStrng];
        }
        
        diagnoseInfoTextView.text = settingsInfo;
    }
}

- (IBAction)doneButtonClicked:(id)sender {
    
    [self.view removeFromSuperview];
    

    if ([screenName isEqualToString:@"serviceTaskDetailView"]) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
    
    
}

- (IBAction)disableDiagButtonClicked:(id)sender {
    
    NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
    NSString *value = @"OFF";
    [userPreferences setObject:value forKey:@"stateOfSwitch"];
    
    [self.view removeFromSuperview];
    
    if ([screenName isEqualToString:@"serviceTaskDetailView"]) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }
}

- (IBAction)sendDiagnosisInfoMail:(id)sender {
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:MAIL_SUBJECT];
        
        NSArray *toRecipients = [NSArray arrayWithObjects:MAIL_RECIVER, nil];
        [mailer setToRecipients:toRecipients];
        
        NSString *emailBody;
        
        if([settingsInfo length]!=0) {
            
            emailBody = [NSString stringWithFormat:@"API Diagnosis Report:\n%@",settingsInfo];
            
        }
        
        [mailer setMessageBody:emailBody isHTML:NO];
        
        [self presentViewController:mailer animated:YES completion:nil];
        
    }
    else
    {
        [[GSPUtility sharedInstance] showAlertWithTitle:@"Failure" message:@"Your device doesn't support the composer sheet" otherButton:nil tag:0 andDelegate:self];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
