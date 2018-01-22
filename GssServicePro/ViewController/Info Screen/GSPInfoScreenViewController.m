//
//  GSPInfoScreenViewController.m
//  GssServicePro
//
//  Created by Riyas Hassan on 30/06/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPInfoScreenViewController.h"
#import "UIDevice+IdentifierAddition.h"
#import <MessageUI/MessageUI.h>
#import "GssMobileConsoleiOS.h"
#import "Diagnose.h"
#import "GSPSettingsView.h"
#import "GSPDiagnosePopUpViewController.h"

@interface GSPInfoScreenViewController ()<MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *deviceIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *altDeviceIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *iOSVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *serverLabel;
@property (weak, nonatomic) IBOutlet UILabel *appEditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *appVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *integratedLabel;

@property (nonatomic, strong) NSString * appBuildName;
@property (nonatomic, strong) NSString * appEdition;
@property (nonatomic, strong) NSString * appVersion;


- (IBAction)sendInformationDetailsMail:(id)sender;

- (IBAction)quickCheckButtonClicked:(id)sender;

- (IBAction)settingsButtonClicked:(id)sender;

@end

@implementation GSPInfoScreenViewController

NSMutableArray *diagnoseArray;
GSPSettingsView *settingsView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GSPAppDelegate *appDelegateObj = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];
    appDelegateObj.activeApp = @"Info";
    
    [self setUpView];
    
    
}

- (void)setUpView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self readPlistFileAndInitializeVariables];
    
    [self initializeViewWithData];
    
    [self setLeftNavigationBarButtonWithImage:@"Icon-Small@2x.png"];
    
    [self initializeDiagnoseWebServiceCall];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPDiagnoseResponseHandler:) name:@"DiagnoseNotification" object:nil];
}

//     *****   Added by Harshitha   *****
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//     *****   Added by Harshitha Ends   *****

-(void) SAPDiagnoseResponseHandler:(NSNotification*)notification
{
    NSDictionary* userInfo          = notification.userInfo;
    
    diagnoseArray  = [userInfo objectForKey:@"FLD_VC"];
    
}

- (void) initializeViewWithData
{
    
    self.appEditionLabel.text   = self.appEdition;
    
    self.appVersionLabel.text   = self.appVersion;
    
    self.iOSVersionLabel.text   = [[UIDevice currentDevice]systemVersion];
    
    self.deviceIDLabel.text     = [[[UIDevice currentDevice] uniqueDeviceIdentifier] uppercaseString];
    
    self.altDeviceIdLabel.text  = [[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier] uppercaseString];
    
}

- (void) initializeDiagnoseWebServiceCall
{
    Diagnose *objDiagnose = [[Diagnose alloc] init];
    [objDiagnose DownloadServiceDataFromSAP];
}

- (void) readPlistFileAndInitializeVariables
{
    NSString *path                      = [[NSBundle mainBundle] pathForResource:@"MobileSetup" ofType:@"plist"];
    NSMutableDictionary *dictionary     = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
   
    self.appBuildName   = [dictionary objectForKey:@"BUILDNAME"];
    self.appEdition     = [dictionary objectForKey:@"Edition"];
    
//    Original Code
//    self.appVersion     = [dictionary objectForKey:@"Version"];
    
//    Added by Harshitha
    self.appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSString * serviceURL = [dictionary objectForKey:@"ServiceURL"];
    NSRange endRange = [serviceURL rangeOfString:@":" options:NSBackwardsSearch];
    NSRange searchRange = NSMakeRange(7, endRange.location-7);
    self.serverLabel.text = [serviceURL substringWithRange:searchRange];
//    Added by Harshitha ends here
}


#pragma mark Mail Composing Methods

- (IBAction)sendInformationDetailsMail:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:MAIL_SUBJECT];
        
        NSArray *toRecipients = [NSArray arrayWithObjects:MAIL_RECIVER, nil];
        [mailer setToRecipients:toRecipients];
        
        
        NSString *emailBody = [NSString stringWithFormat:@"My device information: \n\nBuild Name: %@ \n\nEdition: %@ \n Version: %@ \n GDID: %@ \n Alt.GDID: %@ \n iOS Version: %@ \n Server: %@", self.appBuildName,self.appEdition, self.appVersion, self.deviceIDLabel.text, self.altDeviceIdLabel.text, self.iOSVersionLabel.text, self.serverLabel.text];
       
        [mailer setMessageBody:emailBody isHTML:NO];
        
        [self presentViewController:mailer animated:YES completion:nil];

    }
    else
    {
        [[GSPUtility sharedInstance] showAlertWithTitle:@"Failure" message:@"Your device doesn't support the composer sheet" otherButton:nil tag:0 andDelegate:self];
    }
    
}

//    ****    Added by Harshitha    ****

- (IBAction)quickCheckButtonClicked:(id)sender {
    GSPDiagnosePopUpViewController *diagpopup;
    
    if (IS_IPAD) {
        
        diagpopup = [[GSPDiagnosePopUpViewController alloc]initWithNibName:@"GSPDiagnosePopUpViewController" bundle:nil withDiagnoseInfo:diagnoseArray andDisableDiagButton:0 fromScreen:nil];
        
        diagpopup.view.frame = CGRectMake(135, 475, 495, 234);
    }
// Added by Harshitha
    else {
        
        diagpopup = [[GSPDiagnosePopUpViewController alloc]initWithNibName:@"GSPDiagnosePopUpViewController_iPhone" bundle:nil withDiagnoseInfo:diagnoseArray andDisableDiagButton:0 fromScreen:nil];
        
       diagpopup.view.frame = CGRectMake(5, 225, 310, 188);
    }
    
    diagpopup.view.layer.borderColor = [UIColor blackColor].CGColor;
    diagpopup.view.layer.borderWidth = 1.0f;
    
    [self.view addSubview:diagpopup.view];
    
    [self addChildViewController:diagpopup];
    [diagpopup didMoveToParentViewController:self];
}

- (IBAction)settingsButtonClicked:(id)sender {
   
    if (IS_IPAD) {
        
        NSArray *subviewArray   = [[NSBundle mainBundle] loadNibNamed:@"GSPSettingsView" owner:self options:nil];
    
        settingsView           = [subviewArray objectAtIndex:0];
    
        settingsView.frame     = CGRectMake(135, 475, 501, 201);
    }
//  Added by Harshitha
    else {
        
        NSArray *subviewArray   = [[NSBundle mainBundle] loadNibNamed:@"GSPSettingsView_iPhone" owner:self options:nil];
        
        settingsView           = [subviewArray objectAtIndex:0];
        
        settingsView.frame     = CGRectMake(5, 225, 310, 188);
    }
    
    settingsView.layer.borderColor = [UIColor blackColor].CGColor;
    settingsView.layer.borderWidth = 1.0f;
    
    [self.view addSubview:settingsView];
    
    [self.view bringSubviewToFront:settingsView];
}

//    ****    Added by Harshitha ends    ****


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
    
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
