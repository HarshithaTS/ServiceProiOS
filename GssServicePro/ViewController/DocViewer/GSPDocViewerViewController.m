//
//  GSPDocViewerViewController.m
//  GssServicePro
//
//  Created by Riyas Hassan on 22/07/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPDocViewerViewController.h"
#import <MessageUI/MessageUI.h>
#import "UIDevice+IdentifierAddition.h"
#import "PDFRenderer.h"
#import "ServiceTask.h"
#define TAP_AREA_SIZE 48.0f

@interface GSPDocViewerViewController ()<MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *pdfWebView;
@property (strong,nonatomic) NSData * pdfData;
@property (strong,nonatomic)ServiceTask *serviceObj;
@property (strong,nonatomic)UIToolbar *toolbar;

@end

@implementation GSPDocViewerViewController{
    UIPrintInteractionController *printInteraction;
    UIUserInterfaceIdiom *userInterfaceIdiom;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withData:(NSData*)data andFileName:(NSString*)fileName
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = fileName;
        self.pdfData = data;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIToolbar *lotoolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [lotoolbar setTintColor:[UIColor blackColor]];
    UITapGestureRecognizer *singleTapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
	singleTapOne.numberOfTouchesRequired = 1; singleTapOne.numberOfTapsRequired = 1; singleTapOne.delegate = self;
	[self.view addGestureRecognizer:singleTapOne];

//    UIFont *doneButtonFont = [UIFont systemFontOfSize:16.0f];
//    NSString *doneButtonText = NSLocalizedString(@"Done", @"button");
//    CGSize doneButtonSize = [doneButtonText sizeWithFont:doneButtonFont];
//    CGFloat doneButtonWidth = (doneButtonSize.width );
//    
//    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    doneButton.frame = CGRectMake(0, 0, doneButtonWidth, 30);
//    [doneButton setTitleColor:[UIColor colorWithWhite:0.0f alpha:1.0f] forState:UIControlStateNormal];
//    [doneButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:1.0f] forState:UIControlStateHighlighted];
//    [doneButton setTitle:doneButtonText forState:UIControlStateNormal]; doneButton.titleLabel.font = doneButtonFont;
//    [doneButton addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    //[doneButton setBackgroundImage:buttonH forState:UIControlStateHighlighted];
//    //[doneButton setBackgroundImage:buttonN forState:UIControlStateNormal];
//    doneButton.autoresizingMask = UIViewAutoresizingNone;
//    //doneButton.backgroundColor = [UIColor grayColor];
//    doneButton.exclusiveTouch = YES;
    
   // [self.pdfWebView addSubview:doneButton];
    
   // UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap)];
   // [self.view addGestureRecognizer:tap];
    
      UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                  target:nil action:nil];
//    UIBarButtonItem *customItem1 = [[UIBarButtonItem alloc]
//                                    initWithTitle:@"mail" style:UIBarButtonItemStyleDone
//                                    target:self action:@selector(attachPdfToMailAndSend)];
    _toolbar = [[UIToolbar alloc]initWithFrame:
                CGRectMake(0, 0, 770, 50)];
    [_toolbar setBarStyle:UIBarStyleDefault];
    [self.view addSubview:_toolbar];

    UIButton *customItem1=[UIButton buttonWithType:UIButtonTypeCustom];
    customItem1.frame   =CGRectMake(450, 0, 50, 50);
    [customItem1 addTarget:self action:@selector(attachPdfToMailAndSend) forControlEvents:UIControlEventTouchUpInside];
    [customItem1 setImage:[UIImage imageNamed:@"Reader-Email"] forState:UIControlStateNormal];
    [self.view addSubview:customItem1];
   // UIBarButtonItem *customItem2 = [[UIBarButtonItem alloc]
                                  //  initWithTitle:@"Tool2" style:UIBarButtonItemStylePlain
                                 //   target:self action:@selector(printPDF)];
    UIButton *customItem2=[UIButton buttonWithType:UIButtonTypeCustom];
    customItem2.frame=CGRectMake(400, 0, 50, 50);
    [customItem2 addTarget:self action:@selector(printPDF) forControlEvents:UIControlEventTouchUpInside];
    [customItem2 setImage:[UIImage imageNamed:@"Reader-Print"] forState:UIControlStateNormal];
  //  NSArray *toolbarItems = [NSArray arrayWithObjects:
                   //          spaceItem,spaceItem,customItem1,customItem2,spaceItem, nil];
       [self.view addSubview:customItem2];
//    [_toolbar setItems:toolbarItems];
//    
   [self.pdfWebView loadData:self.pdfData MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:nil];
    
//    
//    UIImageView *myImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
//    
//    NSString *imageName = [NSString stringWithFormat:@"%@.png",self.title];
//    myImage.image = [UIImage imageNamed:imageName];
//    
//    [self.pdfWebView addSubview:myImage];
}

- (void)didTap
{
    if(_toolbar.hidden==NO)
    _toolbar.hidden=YES;
    else
        _toolbar.hidden=NO;
   
    //Or if you aren't using a nav controller just someToolbar.hidden = YES;
    
}

- (void)attachPdfToMailAndSend
{
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:MAIL_SUBJECT];
        
        NSArray *toRecipients = [NSArray arrayWithObjects:MAIL_RECIVER, nil];
        [mailer setToRecipients:toRecipients];
        
        NSString *path                      = [[NSBundle mainBundle] pathForResource:@"MobileSetup" ofType:@"plist"];
        NSMutableDictionary *dictionary     = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
        
        NSString *emailBody = [NSString stringWithFormat:@"My device information: \n\nBuild Name: %@ \n\nEdition: %@ \n Version: %@ \n GDID: %@ \n Alt.GDID: %@ \n iOS Version: %@ \n Server: %@", [dictionary objectForKey:@"BUILDNAME"],[dictionary objectForKey:@"Edition"], [dictionary objectForKey:@"Version"], [[[UIDevice currentDevice] uniqueDeviceIdentifier] uppercaseString], [[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier] uppercaseString], [[UIDevice currentDevice]systemVersion], @""];
        
        [mailer setMessageBody:emailBody isHTML:NO];
        
        
        [mailer addAttachmentData:[NSData dataWithContentsOfFile:[[PDFRenderer sharedInstance] getPdfFileName:self.title]] mimeType:@"application/pdf" fileName:@"ServiceOrder.PDF"];
        
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
        {
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            NSString* pdfFileName = [[PDFRenderer sharedInstance] getPdfFileName:self.serviceObj.serviceOrder];
            [[GSPUtility sharedInstance] deleteFilesFromDocumentFolders:pdfFileName];
        }
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

-(void)printPDF
    {
        if ([UIPrintInteractionController isPrintingAvailable] == YES)
        {
            //NSURL *fileURL = document.fileURL; // Document file URL
            NSString *fileName=[[PDFRenderer sharedInstance]getPdfFileName:self.title];
            NSURL *aUrl =[[NSURL alloc] initFileURLWithPath:fileName];
            if ([UIPrintInteractionController canPrintURL:aUrl]==YES)
            {
                printInteraction = [UIPrintInteractionController sharedPrintController];
                
                UIPrintInfo *printInfo = [UIPrintInfo printInfo];
                printInfo.duplex = UIPrintInfoDuplexLongEdge;
                printInfo.outputType = UIPrintInfoOutputGeneral;
                printInfo.jobName = fileName;
                
                printInteraction.printInfo = printInfo;
                printInteraction.printingItem = aUrl;
                printInteraction.showsPageRange = YES;
                
                if (userInterfaceIdiom == UIUserInterfaceIdiomPad) // Large device printing
                {
                    [printInteraction presentFromRect:self.view.bounds inView:self.view animated:YES completionHandler:
                     ^(UIPrintInteractionController *pic, BOOL completed, NSError *error)
                     {
#ifdef DEBUG
                         if ((completed == NO) && (error != nil)) NSLog(@"%s %@", __FUNCTION__, error);
#endif
                     }
                     ];
                }
               // else // Handle printing on small device
              //  {
                    [printInteraction presentAnimated:YES completionHandler:
                     ^(UIPrintInteractionController *pic, BOOL completed, NSError *error)
                     {
#ifdef DEBUG
                         if ((completed == NO) && (error != nil)) NSLog(@"%s %@", __FUNCTION__, error);
#endif
                     }
                     ];
             //   }
            }
        }
    }

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
	if (recognizer.state == UIGestureRecognizerStateRecognized)
	{
		CGRect viewRect = recognizer.view.bounds; // View bounds
        
		CGPoint point = [recognizer locationInView:recognizer.view]; // Point
        
		CGRect areaRect = CGRectInset(viewRect, TAP_AREA_SIZE, 0.0f); // Area rect
        
		if (CGRectContainsPoint(areaRect, point) == true) // Single tap is inside area
		{
            [self hideToolbar];
                }
        }
}
- (void)hideToolbar
{
	if (_toolbar.hidden == NO)
	{
		[UIView animateWithDuration:0.25 delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^(void)
         {
             _toolbar.alpha = 0.0f;
         }
                         completion:^(BOOL finished)
         {
            _toolbar.hidden = YES;
            
         }
         ];
	}
}
- (void)showToolbar
{
	if (_toolbar.hidden == YES)
	{
		 // First
        
		[UIView animateWithDuration:0.25 delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^(void)
         {
             _toolbar.hidden = NO;
             _toolbar.alpha = 1.0f;
         }
                         completion:NULL
         ];
	}
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
