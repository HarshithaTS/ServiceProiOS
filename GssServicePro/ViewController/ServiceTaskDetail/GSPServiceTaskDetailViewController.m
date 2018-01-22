//
//  GSPServiceTaskDetailViewController.m
//  GssServicePro
//
//  Created by Riyas Hassan on 05/06/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPServiceTaskDetailViewController.h"
#import "ServiceTask.h"
#import "GSPPickerController.h"
#import "GSPMapViewController.h"
#import "ContextDataClass.h"
#import "GSPUtility.h"
#import "GSPCommonTableView.h"
#import "GSPTaskLocationMapViewController.h"
#import "GSPColleguesViewController.h"
#import "ServiceOrderClass.h"
#import "GSPImagePreviewController.h"
#import "GalleryViewController.h"
#import "GalleryImage.h"
#import "PDFRenderer.h"
#import <MessageUI/MessageUI.h>
#import "UIDevice+IdentifierAddition.h"
#import "GSPCaptureSignatureViewController.h"
#import "GSPAttachmnetsViewController.h"
#import "GSPOfflineViewConfiguration.h"
#import "GSPTimeZoneSelector.h"
#import "GSPDocViewerViewController.h"
#import "GSPSignatureCaptureView.h"
#import "GSPServiceConfirmationViewController.h"
#import "CheckedNetwork.h"
#import "GSPDiagnosePopUpViewController.h"
#import "GSPAppDelegate.h"
#import "GSPPartnerViewController.h"
#import "GSPOverviewTableViewCell.h"
#import "GSPDetailTableCell.h"
#import "GSPDetailTableViewCell.h"
#import "GSPDatailTableViewCellWithOneLabel.h"
#import "ServerAttachment.h"
#import "Partners.h"
#import "GSPPartnerViewCell.h"

#import "GSPServiceTasksViewController.h"


#import "GSPKeychainStoreManager.h"

#import "UICKeyChainStore.h"

#define kDefaultPageHeight 792
#define kDefaultPageWidth  612
#define kMargin 50

@interface GSPServiceTaskDetailViewController ()<CustomPickerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MFMailComposeViewControllerDelegate,UITextViewDelegate,TimeZoneSelectorDelegate>

{
    GSPPickerController     * pickerController;
    BOOL isSignatureCaputured, isImageAttached, isSignaturePoupVisible;
    NSString *signatureFilePath, *attchmnetImgFilePath;
    UIImage *signatureImage, *attachmentImage;
    
    ServiceOrderClass   * serviceOrderObject;
    ContextDataClass    * contextDataClass;
    
    NSIndexPath * estArrDateIndexPath;
    
    NSMutableArray * multipleTasksArray;
    
    UIPopoverController *popoverController;
    GSPSignatureCaptureView *signatureView;
    
    UIView * errorDisplayView;
    
    GSPAttachmnetsViewController *serverAttachmentsObject;
    int selectedIndex;
    ServerAttachment *selectedAttachment;
    UIDocumentInteractionController *documentInteractionController;
}

@property (nonatomic) int currentlyShownOrderIndex;
@property (nonatomic) int currentlyShownTaskIndex;

@property (strong, nonatomic) NSMutableArray * serviceOrdersArray;
@property (weak, nonatomic) IBOutlet GSPCommonTableView *detailTableView;
//@property (strong, nonatomic) IBOutlet UIView *serviceNoteDetailView;
//@property (weak, nonatomic) IBOutlet UITextView *serviceNoteDetailTextView;
@property (weak, nonatomic) IBOutlet UIToolbar *menuToolBar;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;

@property (strong, nonatomic) NSDictionary * errorDictinory;


//- (IBAction)closeServiceNoteDetailScreen:(id)sender;


@property (nonatomic,strong) ServiceTask * serviceTask;

@property (weak, nonatomic) IBOutlet UITableView *detailTableView1;
@property (weak, nonatomic) IBOutlet UITableView *detailTableView2;
@property (weak, nonatomic) IBOutlet UITableView *detailTableView3;
- (IBAction)mapButtonClicked:(id)sender;
- (IBAction)transferTaskButtonClicked:(id)sender;
- (IBAction)generatePDFButtonClicked:(id)sender;
- (IBAction)confirmationButtonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *serviceNoteDetailView;
@property (weak, nonatomic) IBOutlet UITextView *serviceNoteDetailTextView;
- (IBAction)closeServiceNoteDetailScreen:(id)sender;
- (IBAction)viewAttachedImageButtonClicked:(id)sender;
- (IBAction)attachImageButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *viewImageButton;
@property (weak, nonatomic) IBOutlet UILabel *viewImageLabel;

@property (nonatomic, assign) BOOL serviceNoteExpandButtonClicked, serverAttachmentButtonClicked, additionalPartnersButtonClicked;
@property (strong, nonatomic) NSMutableArray * serverAttachmentsArray, * additionalPartnersArray;
@property (weak, nonatomic) IBOutlet UIImageView *signPreviewImage;
//- (IBAction)tapToSignButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *tapToSignButton;
@property (weak, nonatomic) IBOutlet UIImageView *signUpImage;
@property (weak, nonatomic) IBOutlet UILabel *signHereLabel;
@property (weak, nonatomic) IBOutlet UIImageView *signatureBottomLineImage;

@property (weak, nonatomic) UITextView *notesTextView;
@property (nonatomic, strong) UIPopoverController *popOver;

@property (weak, nonatomic) IBOutlet UITableView *serviceTaskDetailTableView;

@property (weak, nonatomic) IBOutlet UITableView *detailTableView1_Landscape;
@property (weak, nonatomic) IBOutlet UITableView *detailTableView2_Landscape;

@property (weak, nonatomic) IBOutlet UIButton *previousTaskButton;
@property (weak, nonatomic) IBOutlet UIButton *nextTaskButton;
@property (weak, nonatomic) IBOutlet UIImageView *previousTaskArrowImageview;
@property (weak, nonatomic) IBOutlet UIImageView *nextTaskArrowImageView;
- (IBAction)hint_prev:(id)sender;
- (IBAction)hint_next:(id)sender;

-(void)viewPDF;
@end

@implementation GSPServiceTaskDetailViewController



NSMutableArray * diagnoseArray;
@synthesize tableName;
NSString * firstServiceItemStr = @"", * taskStatus = @"", * serviceItemString = @"", * contactNumber = @"";
UIInterfaceOrientation interfaceOrientation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withObject:(ServiceTask*)serviceTaskObj atIndex:(int)index andOrdersArray:(NSMutableArray*)objectsArray
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.serviceTask                = [serviceTaskObj copy];
        self.serviceOrdersArray         = [objectsArray copy];
        self.currentlyShownOrderIndex   = index;
        [self setNavigationTitleWithBrandImage:@"Service Task Detail"];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeVariables];
    
    [self setupView];

    [self getMultipleTasksForServiceOrderAndLoadInView];
    
    [self setUpPreviousAndNextTaskButtons];
    

//    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(wasDragged:)];
    
//    [signatureView.signatureView   addGestureRecognizer:panRecognizer];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
        [[GSPOfflineViewConfiguration sharedInstance] checkReachabilityAndCofigureView:self];

    
    interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
//    if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
//    {
//        //    self.detailTableView1.scrollEnabled = NO;
//        self.detailTableView2.scrollEnabled = NO;
//        //    self.detailTableView3.scrollEnabled = NO;
//        self.detailTableView1.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//        self.detailTableView2.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//        self.detailTableView3.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    }
//    else if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
//    {
        self.detailTableView1_Landscape.scrollEnabled = NO;
    self.serverAttachmentButtonClicked =NO;
   self.additionalPartnersButtonClicked=NO;
        self.detailTableView1_Landscape.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.detailTableView2_Landscape.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  //  }
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation)){
        float X_Co = self.view.frame.size.width - 240;
        float Y_Co = self.view.frame.size.height - 30;
        float X_Co1=self.view.frame.size.width-430;
        self.previousTaskButton.translatesAutoresizingMaskIntoConstraints = YES;
        self.nextTaskButton.translatesAutoresizingMaskIntoConstraints = YES;
//        [self.previousTaskButton setFrame:CGRectMake(X_Co1, Y_Co, 190, 30)];
//        [self.nextTaskButton setFrame:CGRectMake(X_Co, Y_Co, 190, 30)];
    }
    if(UIInterfaceOrientationIsLandscape(interfaceOrientation)){
        float X_Co = self.view.frame.size.width - 320;
        float Y_Co = self.view.frame.size.height - 70;
        float X_Co1=self.view.frame.size.width-570;
        self.previousTaskButton.translatesAutoresizingMaskIntoConstraints = YES;
        self.nextTaskButton.translatesAutoresizingMaskIntoConstraints = YES;

//        [self.previousTaskButton setFrame:CGRectMake(X_Co1, Y_Co, 250, 30)];
//        [self.nextTaskButton setFrame:CGRectMake(X_Co, Y_Co, 250, 30)];
       // [_hintLabel setFrame:CGRectMake(X_Co-20, Y_Co+40, 150, 30)];
    }
    

    [self.detailTableView1_Landscape reloadData];
    [self.detailTableView2_Landscape reloadData];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sapResponseHandlerForServerAttachments:) name:@"DownloadingServerAttachment" object:nil];

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255.0/255 green:143.0/255 blue:30.0/255 alpha:0.0];
    self.navigationController.navigationBar.translucent = NO;
    [signatureView removeFromSuperview];

    [self setUpSignatureViewAndViewServerAttachmentsButton];
    
    
  
    
    
//    [self attachSignatureView];
}


//    *****   Added by Harshitha starts here  *****
-(void)viewWillDisappear:(BOOL)animated
{
    
//    if(self.isMovingToParentViewController|| self.isBeingDismissed){
    
        
        
         [[NSNotificationCenter defaultCenter] removeObserver:self];
        
    }

   


- (void) setUpPreviousAndNextTaskButtons
{
    
     if (multipleTasksArray.count > 1)
  {
//      UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
//      if(UIInterfaceOrientationIsPortrait(interfaceOrientation)){
//          self.previousTaskButton.frame=CGRectMake(379, 900, 200, 30);
//          self.nextTaskButton.frame=CGRectMake(500, 900, 200, 30);
//      }

      
     // UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
      CGSize xAxis2= [[UIScreen mainScreen]bounds].size;
      NSLog(@"frame width %@",NSStringFromCGSize(xAxis2));

     UIDeviceOrientation interfaceOrientation=[[UIDevice currentDevice]orientation];
           if(UIInterfaceOrientationIsPortrait(interfaceOrientation)){
               float X_Co = self.view.frame.size.width - 240;
               float Y_Co = self.view.frame.size.height - 30;
               float X_Co1=self.view.frame.size.width-430;
               self.previousTaskButton.translatesAutoresizingMaskIntoConstraints = YES;
               self.nextTaskButton.translatesAutoresizingMaskIntoConstraints = YES;
//               [self.previousTaskButton setFrame:CGRectMake(X_Co1, Y_Co, 190, 30)];
//               [self.nextTaskButton setFrame:CGRectMake(X_Co, Y_Co, 190, 30)];
               _hintLabel.text=[NSString stringWithFormat:@"Task %d of %d",self.currentlyShownTaskIndex+1,multipleTasksArray.count];
                       }
      if(UIInterfaceOrientationIsLandscape(interfaceOrientation)){
          float X_Co = self.view.frame.size.width - 320;
          float Y_Co = self.view.frame.size.height - 70;
          float X_Co1=self.view.frame.size.width-570;
          self.previousTaskButton.translatesAutoresizingMaskIntoConstraints = YES;
          self.nextTaskButton.translatesAutoresizingMaskIntoConstraints = YES;

//          [self.previousTaskButton setFrame:CGRectMake(X_Co1, Y_Co, 250, 30)];
//          [self.nextTaskButton setFrame:CGRectMake(X_Co, Y_Co, 250, 30)];
          
          
          //[_hintLabel setFrame:CGRectMake(X_Co-20, Y_Co+40, 150, 30)];
          _hintLabel.text=[NSString stringWithFormat:@"Task %d of %d",self.currentlyShownTaskIndex+1,multipleTasksArray.count];

      }


    self.previousTaskButton.hidden = NO;
    self.nextTaskButton.hidden = NO;
      self.hint_prevButton.hidden=NO;
      self.hint_nextButton.hidden=NO;
      
    self.previousTaskArrowImageview.hidden = NO;
    self.nextTaskArrowImageView.hidden = NO;
         _hintLabel.hidden=NO;
   // [self.detailTableView2_Landscape setFrame:CGRectMake(382, 94, 634, 560)];
      
    if (multipleTasksArray.count > 1 && self.currentlyShownTaskIndex != 0)
    {
      
        self.previousTaskButton.enabled = YES;
        self.hint_prevButton.enabled=YES;
        self.previousTaskButton.alpha = 1.0;
        [self.previousTaskButton addTarget:self action:@selector(loadPreviousTask:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        self.previousTaskButton.enabled = NO;
        self.hint_prevButton.enabled=NO;
     
        self.previousTaskButton.alpha = 0.4;
    }
    
    if (multipleTasksArray.count > 1 && self.currentlyShownTaskIndex + 1 < multipleTasksArray.count)
    {
        
        self.nextTaskButton.enabled = YES;
        self.hint_nextButton.enabled=YES;
        self.nextTaskButton.alpha = 1.0;
        [self.nextTaskButton addTarget:self action:@selector(loadNextTask:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        self.nextTaskButton.enabled = NO;
        self.hint_nextButton.enabled=NO;
        _hintNextLabel.hidden=TRUE;
        self.nextTaskButton.alpha = 0.4;
    }
  }
  else
  {
         _hintLabel.hidden=YES;
      self.hint_prevButton.hidden=YES;
      self.hint_nextButton.hidden=YES;
      self.previousTaskButton.hidden = YES;
      self.nextTaskButton.hidden = YES;
      self.previousTaskArrowImageview.hidden = YES;
      self.nextTaskArrowImageView.hidden = YES;
     // [self.detailTableView2_Landscape setFrame:CGRectMake(382, 94, 634, 588)];
  }
}

-(void) setUpSignatureViewAndViewServerAttachmentsButton
{
    [self imageCheckingInDocFolder];
    
    if(!isSignatureCaputured)
    {
        self.signPreviewImage.hidden = YES;
//        
////        if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
////        {
//            self.signHereLabel.hidden = YES;
//            self.signUpImage.hidden = YES;
//            self.tapToSignButton.userInteractionEnabled = NO;
//            self.signatureBottomLineImage.hidden = YES;
//            NSArray *subviewArray   = [[NSBundle mainBundle] loadNibNamed:@"GSPSignatureCaptureView" owner:self options:nil];
//            signatureView           = [subviewArray objectAtIndex:0];
//            signatureView.frame     = CGRectMake(437.0, 785.0, signatureView.frame.size.width, signatureView.frame.size.height);6
//            [self.view addSubview:signatureView];
//            [self.view bringSubviewToFront:signatureView];
//       // }
//        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(wasDragged:)];
        
//        [ addGestureRecognizer:panRecognizer];

         UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
       {
            NSArray *subviewArray   = [[NSBundle mainBundle] loadNibNamed:@"GSPSignatureCaptureView" owner:self options:nil];
            signatureView           = [subviewArray objectAtIndex:0];
           signatureView.frame     = CGRectMake(33.0, 520.0, signatureView.frame.size.width, signatureView.frame.size.height);
            [self.view addSubview:signatureView];
            [self.view bringSubviewToFront:signatureView];
       }
    
        else if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
        {
            NSArray *subviewArray   = [[NSBundle mainBundle] loadNibNamed:@"GSPSignatureCaptureView" owner:self options:nil];
            signatureView           = [subviewArray objectAtIndex:0];
           signatureView.frame     = CGRectMake(33.0, 520.0, signatureView.frame.size.width-70, signatureView.frame.size.height);
            signatureView.userInteractionEnabled=YES;
            [self.view addSubview:signatureView];
            [self.view bringSubviewToFront:signatureView];
            //  }
        }

    }
    
    else if(isSignatureCaputured)
    {
        self.signHereLabel.hidden = YES;
        self.signUpImage.hidden = YES;
        self.tapToSignButton.userInteractionEnabled = NO;
        self.signatureBottomLineImage.hidden = YES;
        self.signPreviewImage.hidden = NO;
        [self.signPreviewImage setImage:signatureImage];
    }
    
//    if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
//    {
//        if (attachmentImage){
//            self.viewImageButton.hidden = NO;
//            self.viewImageLabel.hidden = NO;
//        }
//        else
//        {
//            self.viewImageLabel.hidden = YES;
//            self.viewImageButton.hidden = YES;
//        }
//    }
}

//    *****   Added by Harshitha ends here  *****

- (void)initializeVariables
{
    serviceOrderObject              = [ServiceOrderClass new];
    self.serviceTask.timeZoneFrom   = [[GSPDateUtility sharedInstance] getTimeZoneNameForTimezoneOffset:self.serviceTask.timeZoneFrom];
    
    contextDataClass = [ContextDataClass new];
    
    serverAttachmentsObject = [GSPAttachmnetsViewController new];
    self.serverAttachmentsArray = [[NSMutableArray alloc]init];
    self.additionalPartnersArray = [[NSMutableArray alloc]init];
    self.serviceNoteExpandButtonClicked = NO;
    self.serverAttachmentButtonClicked = NO;
    self.additionalPartnersButtonClicked = NO;
}

- (void)setupView
{
    
    self.bgScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 500);
    
//    [[GSPOfflineViewConfiguration sharedInstance] checkReachabilityAndCofigureView:self];
    
    //[self setLeftNavigationBarButtonWithImage: @"backButton.png"];
    
//    [self setRightNavigationBarButtonItemsWithMenu:YES andOtherBarButtonWithImageNamed:@"Save.png" andSelector:@selector(saveEditedTask)];
    [self setRightNavigationBarButtonItemsWithMenu:NO andOtherBarButtonWithImageNamed:@"SaveIcon.png" andSelector:@selector(saveEditedTask)];
    
/*    [self imageCheckingInDocFolder];
    if (attachmentImage){
        self.viewImageButton.hidden = NO;
        self.viewImageLabel.hidden = NO;
    }
*/
    UIBarButtonItem *barBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClicked)];
    [barBackButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = barBackButton;

    [[GSPUtility sharedInstance] addSwipeGestureRecoganiserForTarget:self withSelctor:@selector(loadNextOrder:) forDirection:UISwipeGestureRecognizerDirectionLeft];
    [[GSPUtility sharedInstance] addSwipeGestureRecoganiserForTarget:self withSelctor:@selector(loadPreviousOrder:) forDirection:UISwipeGestureRecognizerDirectionRight];
    
//    if(!_errorLabel.hidden){
//        self.detailTableView1_Landscape.frame= CGRectMake(8, 120, _detailTableView1_Landscape.frame.size.width, _detailTableView1_Landscape.frame.size.height);
//        self.detailTableView2_Landscape.frame= CGRectMake(379, 120, _detailTableView2_Landscape.frame.size.width, _detailTableView2_Landscape.frame.size.height);
//    }
//    else{
//        self.detailTableView1_Landscape.frame= CGRectMake(8, 100, _detailTableView1_Landscape.frame.size.width, _detailTableView1_Landscape.frame.size.height);
//        self.detailTableView2_Landscape.frame= CGRectMake(379, 100, _detailTableView2_Landscape.frame.size.width, _detailTableView2_Landscape.frame.size.height);
//        
//    }

    
//    
    GSPAppDelegate *appDelegateObj = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];
//    if(appDelegateObj.notificationLaunched){
    
    
    _errorTextView.hidden=YES;
      _warningImage.hidden=YES;
//    _errorBackgroundLabel.hidden = NO;
    
//        appDelegateObj.notificationLaunched=NO;
    
        NSString *notifReferenceID = appDelegateObj.notifObjectID;
        
        NSLog(@"the reference id for notif %@",notifReferenceID);

        NSMutableArray * arrayOfTasksFromKeyChain = [GSPKeychainStoreManager getErrorItemsFromKeyChain];
        NSLog(@"The fetched items from keychain %@",arrayOfTasksFromKeyChain);
        
        
        if(arrayOfTasksFromKeyChain.count >0){
           
                for( NSDictionary *dic in arrayOfTasksFromKeyChain){
                    if([[dic valueForKey:@"referenceID"]isEqualToString:self.serviceTask.serviceOrder]){
                        _errorTextView.hidden=NO;
                        _errorTextView.text=[dic valueForKey:@"errDescription"];
                        _warningImage.hidden=NO;
                        
//                        _errorDisplay.hidden=NO;
//                        _errorDisplay.text = [dic valueForKey:@"errDescription"];
//
                      
//
//                        [_errorDisplay sizeToFit];
                    }
                }
//                    else{
//                        _errorLabel.hidden =YES;
////                    _errorBackgroundLabel.hidden = YES;
////                    _warningImageView.hidden =YES;
//                        
//                        _warningImage.hidden=YES;
//                    
//                }
//        
//            
//        }
        
       
        
        
    }
        else{
            _errorLabel.hidden =YES;
            
            _errorTextView.hidden=YES;            //                    _errorBackgroundLabel.hidden = YES;
//            _warningImageView.hidden =YES;
            
            _warningImage.hidden=YES;
        }
//
    if(!_errorTextView.hidden){
   self.detailTableView1_Landscape.frame= CGRectMake(8, 130, _detailTableView1_Landscape.frame.size.width, _detailTableView1_Landscape.frame.size.height);
    self.detailTableView2_Landscape.frame= CGRectMake(379, 130, _detailTableView2_Landscape.frame.size.width, _detailTableView2_Landscape.frame.size.height);
        
//        [UIView animateWithDuration:3.0f delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
//            _errorLabel.frame = CGRectMake(6, 100, 400,50);
//        } completion:^(BOOL finished)
//         {
//             _errorLabel.frame = CGRectMake(-6, 100, 400, 50);
//         }];
        
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:10];
//        
//        _errorLabel.frame = CGRectMake(-_errorLabel.frame.size.width,_errorLabel.frame.origin.y, _errorLabel.frame.size.width, _errorLabel.frame.size.height);
//        
//        [UIView commitAnimations];
//        NSTimer *errorLabelTimer;
//         errorLabelTimer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(startAnimatingErrorLabel) userInfo:nil repeats:YES];

    }
    else{
        self.detailTableView1_Landscape.frame= CGRectMake(8, 100, _detailTableView1_Landscape.frame.size.width, _detailTableView1_Landscape.frame.size.height);
        self.detailTableView2_Landscape.frame= CGRectMake(379, 100, _detailTableView2_Landscape.frame.size.width, _detailTableView2_Landscape.frame.size.height);
//        CGPoint anchorPoint = _errorLabel.layer.anchorPoint;
//        [UIView animateWithDuration:0.5 animations:^{
//            // grow the label up to 130%, using a animation of 1/2s
//            _errorLabel.transform = CGAffineTransformMakeScale(1.3,1.3);
//        } completion:^(BOOL finished) {
//            // When the "grow" animation is completed, go back to size 100% using another animation of 1/2s
//            _errorLabel.layer.anchorPoint = CGPointMake(anchorPoint.x/1.3, anchorPoint.y/1.3);
//            [UIView animateWithDuration:0.5 animations:^{
//                _errorLabel.transform = CGAffineTransformIdentity;
//                
//                
//            }];
//        }];

    }
}

- (void) getErrorObjectFromErrorTable
{
    CGSize xAxis2= [[UIScreen mainScreen]bounds].size;
    NSLog(@"frame width %@",NSStringFromCGSize(xAxis2));
    
    NSString *sqlQryStr             = [NSString stringWithFormat:@"SELECT * FROM 'TBL_ERRORLIST' WHERE apprefid = '%@'",self.serviceTask.serviceOrder];
    
    NSMutableArray * errorObject    =  [serviceOrderObject getErrorListArray:sqlQryStr];
    
    self.detailTableView.frame = CGRectMake(self.detailTableView.frame.origin.x, 3, self.detailTableView.frame.size.width, self.detailTableView.frame.size.height);
    [errorDisplayView removeFromSuperview];
    
    
    if (errorObject.count > 0)
    {
        self.errorDictinory         = [errorObject objectAtIndex:0];
        errorDisplayView            = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 25)];
        errorDisplayView.backgroundColor = [UIColor grayColor];
        //errorDisplayView.alpha      = 0.5;
        [self.view addSubview:errorDisplayView];
        
        UILabel * errorLabel        = [[UILabel alloc]initWithFrame:CGRectMake(errorDisplayView.frame.origin.x + 30, errorDisplayView.frame.origin.y, errorDisplayView.frame.size.width - 55, errorDisplayView.frame.size.height)];
        
        errorLabel.numberOfLines    = 3;
        
        if (IS_IPHONE)
        {
            errorLabel.font             = [UIFont systemFontOfSize:10];
        }
        else
            errorLabel.font             = [UIFont systemFontOfSize:14];
            
        errorLabel.text             = [self.errorDictinory valueForKey:@"errdesc"];
        errorLabel.textColor        = [UIColor whiteColor];
        [errorDisplayView addSubview:errorLabel];
        
        
        UIImageView * errorImagView = [[UIImageView alloc]initWithFrame:CGRectMake(errorDisplayView.frame.origin.x + 5, errorDisplayView.frame.origin.y + 2.5, 20, 20)];
        errorImagView.image         = [UIImage imageNamed:@"error"];
        
        [errorDisplayView addSubview:errorImagView];
        
        self.detailTableView.frame = CGRectMake(self.detailTableView.frame.origin.x,30, self.detailTableView.frame.size.width, self.detailTableView.frame.size.height);
        
        
    }
 
}

// Original code
/*
- (void)getMultipleTasksForServiceOrderAndLoadInView
{
    multipleTasksArray = nil;
    taskStatus         = self.serviceTask.status;
    
    multipleTasksArray = [serviceOrderObject getMultipleTasksForServiceOrder:self.serviceTask.serviceOrder];
//    taskStatus         = self.serviceTask.status;
    
    self.currentlyShownTaskIndex = 0;
    if (multipleTasksArray.count >= 1)
    {
        
        ServiceTask *task                   = [multipleTasksArray objectAtIndex:0];
        self.serviceTask.serviceItem        = task.serviceItem;
        self.serviceTask.numberExtension    = task.numberExtension;
//        taskStatus                          = task.status;
 
        [self.detailTableView reloadData];
    }
     [self getErrorObjectFromErrorTable];
}
*/

// Modified by Harshitha
- (void)getMultipleTasksForServiceOrderAndLoadInView
{
    multipleTasksArray = nil;
    taskStatus         = self.serviceTask.status;
    multipleTasksArray = [serviceOrderObject getMultipleTasksForSO:self.serviceTask.serviceOrder];
    
    self.currentlyShownTaskIndex = 0;
    
    NSMutableArray *searchArray = [[NSMutableArray alloc] init];
    [searchArray addObjectsFromArray:multipleTasksArray];
    
    for (int i=0; i<[multipleTasksArray count]; i++) {
        
        if([[[searchArray objectAtIndex:i] valueForKey:@"firstServiceItem"] length] != 0 && [[[searchArray objectAtIndex:i] valueForKey:@"firstServiceItem"] rangeOfString:self.serviceTask.firstServiceItem options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            self.currentlyShownTaskIndex = i;
            break;
        }
    }
    
    if (multipleTasksArray.count >= 1)
    {
        
        ServiceTask *task                   = [multipleTasksArray objectAtIndex:0];
        self.serviceTask.serviceItem        = task.serviceItem;
//        self.serviceTask.numberExtension    = task.numberExtension;
        
//        [self.detailTableView reloadData];
        
        [self setUpPreviousAndNextTaskButtons];
        
        GSPAppDelegate *appDelegateObj = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];
        //    if(appDelegateObj.notificationLaunched){
        
        _errorLabel.hidden=YES;
        _errorLabel.text=@"JHgd";
        
        _errorTextView.hidden=YES;
        
        _warningImage.hidden=YES;
        //    _errorBackgroundLabel.hidden = NO;
        
        //        appDelegateObj.notificationLaunched=NO;
        
        NSString *notifReferenceID = appDelegateObj.notifObjectID;
        
        NSLog(@"the reference id for notif %@",notifReferenceID);
        
        NSMutableArray * arrayOfTasksFromKeyChain = [GSPKeychainStoreManager getErrorItemsFromKeyChain];
        NSLog(@"The fetched items from keychain %@",arrayOfTasksFromKeyChain);
        
        
        if(arrayOfTasksFromKeyChain.count >0){
            
            for( NSDictionary *dic in arrayOfTasksFromKeyChain){
                if([[dic valueForKey:@"referenceID"]isEqualToString:self.serviceTask.serviceOrder]){
                    _errorLabel.hidden=NO;
                    _errorLabel.text= [dic valueForKey:@"errDescription"];
                    _warningImage.hidden=NO;
                    
                    _errorTextView.hidden=NO;
                    _errorTextView.text = [dic valueForKey:@"errDescription"];
//                    _errorTextView.text = [NSString stringWithFormat:@"User status 'ON HOLD -Cust Delay' must not be set.Exception occured during Status validation"];
                }
            }
            //                    else{
            //                        _errorLabel.hidden =YES;
            ////                    _errorBackgroundLabel.hidden = YES;
            ////                    _warningImageView.hidden =YES;
            //
            //                        _warningImage.hidden=YES;
            //
            //                }
            //
            //
            //        }
            
            
            
            
        }
        else{
            _errorLabel.hidden =YES;
            
            _errorTextView.hidden = YES;
            //                    _errorBackgroundLabel.hidden = YES;
            //            _warningImageView.hidden =YES;
            
            _warningImage.hidden=YES;
        }
        //
//        if(!_errorTextView.hidden){
////            self.detailTableView1_Landscape.frame= CGRectMake(8, 120, _detailTableView1_Landscape.frame.size.width, _detailTableView1_Landscape.frame.size.height);
////            self.detailTableView2_Landscape.frame= CGRectMake(379, 120, _detailTableView2_Landscape.frame.size.width, _detailTableView2_Landscape.frame.size.height);
//            
//            //        [UIView animateWithDuration:3.0f delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
//            //            _errorLabel.frame = CGRectMake(6, 100, 400,50);
//            //        } completion:^(BOOL finished)
//            //         {
//            //             _errorLabel.frame = CGRectMake(-6, 100, 400, 50);
//            //         }];
//            
//            //        [UIView beginAnimations:nil context:NULL];
//            //        [UIView setAnimationDuration:10];
//            //
//            //        _errorLabel.frame = CGRectMake(-_errorLabel.frame.size.width,_errorLabel.frame.origin.y, _errorLabel.frame.size.width, _errorLabel.frame.size.height);
//            //
//            //        [UIView commitAnimations];
//            NSTimer *errorLabelTimer;
//            errorLabelTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(startAnimatingErrorLabel) userInfo:nil repeats:YES];
//            
//        }
//        else{
////            self.detailTableView1_Landscape.frame= CGRectMake(8, 100, _detailTableView1_Landscape.frame.size.width, _detailTableView1_Landscape.frame.size.height);
////            self.detailTableView2_Landscape.frame= CGRectMake(379, 100, _detailTableView2_Landscape.frame.size.width, _detailTableView2_Landscape.frame.size.height);
//            
//        }

        
//        if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
//        {
            [self.detailTableView1_Landscape reloadData];
            [self.detailTableView2_Landscape reloadData];
      //  }
    }
    [self getErrorObjectFromErrorTable];
}

#pragma mark Swipe gesture methods

- (void) loadNextOrder:(id)sender
{
    
//    if ( self.serviceOrdersArray.count == self.currentlyShownOrderIndex + 1 || isSignaturePoupVisible) {
    if ( self.serviceOrdersArray.count == self.currentlyShownOrderIndex + 1) {
        return;
    }
    
    CGFloat xAxis = self.view.frame.size.width;
    
    if ([sender isKindOfClass:[UIButton class]]) {
        xAxis = -self.view.frame.size.width;
    }
    
    self.currentlyShownOrderIndex = self.currentlyShownOrderIndex + 1;
    
    [self startAnimatingViewForSwiprGestureActionFromXaxis:xAxis];
  
    
    
}
- (void) loadPreviousOrder:(id)sender
{
//    if (self.currentlyShownOrderIndex == 0 || isSignaturePoupVisible) {
    if (self.currentlyShownOrderIndex == 0) {
        return;
    }
    self.currentlyShownOrderIndex = self.currentlyShownOrderIndex -1;
    
//    CGFloat xAxis = -self.detailTableView.frame.size.width;
    CGFloat xAxis = -self.view.frame.size.width;
    
    if ([sender isKindOfClass:[UIButton class]]) {
        xAxis = self.view.frame.size.width;
    }
    
    
    [self startAnimatingViewForSwiprGestureActionFromXaxis:xAxis];
}

- (void) startAnimatingViewForSwiprGestureActionFromXaxis:(CGFloat)xAxis
{
//        self.detailTableView.frame = CGRectMake(xAxis, self.detailTableView.frame.origin.y, self.detailTableView.frame.size.width, self.detailTableView.bounds.size.height);
    
//    if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
//    {
//        self.detailTableView1_Landscape.frame = CGRectMake(xAxis, self.detailTableView1_Landscape.frame.origin.y, self.detailTableView1_Landscape.frame.size.width, self.detailTableView1_Landscape.bounds.size.height);
//        
//        self.detailTableView2_Landscape.frame = CGRectMake(xAxis, self.detailTableView2_Landscape.frame.origin.y, self.detailTableView2_Landscape.frame.size.width, self.detailTableView2_Landscape.bounds.size.height);
////    }
    
    [UIView animateWithDuration:0.4f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
//                         self.detailTableView.frame    = CGRectMake(0, self.detailTableView.frame.origin.y, self.detailTableView.bounds.size.width, self.detailTableView.bounds.size.height);
//                         if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
//                         {
//                             self.detailTableView1_Landscape.frame = CGRectMake(0, self.detailTableView1_Landscape.frame.origin.y, self.detailTableView1_Landscape.frame.size.width, self.detailTableView1_Landscape.bounds.size.height);
//                             
//                             self.detailTableView2_Landscape.frame = CGRectMake(382.0 , self.detailTableView2_Landscape.frame.origin.y, self.detailTableView2_Landscape.frame.size.width, self.detailTableView2_Landscape.bounds.size.height);
//                         }
                         
                         if (self.serviceOrdersArray.count > self.currentlyShownOrderIndex && self.currentlyShownOrderIndex >= 0)
                         {
                             self.serviceTask   = [[self.serviceOrdersArray objectAtIndex:self.currentlyShownOrderIndex] copy];
                             self.serviceTask.timeZoneFrom = [[GSPDateUtility sharedInstance] getTimeZoneNameForTimezoneOffset:self.serviceTask.timeZoneFrom];
                         }
                         
                     }
                     completion:^(BOOL finished){
                         
                         [self getMultipleTasksForServiceOrderAndLoadInView];
                         
//                         if (multipleTasksArray.count <= 1)
                         {
                             [signatureView removeFromSuperview];
//                             [self.signPreviewImage removeFromSuperview];
                             
                             [self setUpSignatureViewAndViewServerAttachmentsButton];
                             
                             self.serviceNoteExpandButtonClicked = NO;
                             self.serverAttachmentButtonClicked = NO;
                             self.additionalPartnersButtonClicked = NO;
                             [self.serverAttachmentsArray removeAllObjects];
                             [self.additionalPartnersArray removeAllObjects];

                             [self setUpPreviousAndNextTaskButtons];
                             
//                             if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
//                             {
                                 [self.detailTableView1_Landscape reloadData];
                                 [self.detailTableView2_Landscape reloadData];
                           //  }
                         }
                         
                         
                     }];
    
}

#pragma mark saving the edited service task method

- (void)saveEditedTask
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTaskResponseHandler:) name:@"StartAcitivityIndicator" object:nil];
    
// Added on 12th Aug 2015 by Selvan
    GSPAppDelegate *appDelegateObj = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];
    appDelegateObj.saveChangesFlag = TRUE;
// Added by Selvan ends here
    
    [diagnoseArray removeAllObjects];
    
    NSString * postActionStr = [ contextDataClass getstatusPostSetActionForText:self.serviceTask.statusText ];
    
    if ([postActionStr rangeOfString:@"ASK-FOR-ETA"].location != NSNotFound)
    {
        if (!self.serviceTask.estimatedArrivalDate)
        {
            [[GSPUtility sharedInstance]showAlertWithTitle:@"" message:@"Please enter the estimated arrival date." otherButton:nil tag:0 andDelegate:self];
            return;
        }
        
    }
    else if ([postActionStr rangeOfString:@"ASK-FOR-REJECTION-REASON"].location != NSNotFound)
    {
        if ([self.serviceTask.serviceOrderRejectionReason isEqualToString:@"Other"] && self.serviceTask.rejectionDescription == nil)
        {
            
            [[GSPUtility sharedInstance]showAlertWithTitle:@"" message:@"Please enter the reason for rejection." otherButton:nil tag:0 andDelegate:self];
            return;
        }
        
    }

    [self updateServiceTask];
    
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    Original code
//    if (alertView.tag != 0)
    
//    Modified by Harshitha
    NSString *popUpStatus= [[NSUserDefaults standardUserDefaults] stringForKey:@"stateOfSwitch"];
    
    if (alertView.tag == 1)
    {
        switch (buttonIndex)
        {
            case 0:
                [self generateAndAttachPDFToMail];
   
//    Added by Harshitha
                [self checkPopUpStatusAndCallPopUpView];
                
                if (![popUpStatus isEqual: @"ON"]) {
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                }
                break;
                
            default:
                break;
        }

    }
//    *****   Added by Harshitha   *****
    else if (alertView.tag == 2)
    {
        switch (buttonIndex)
        {
            case 0:
  
                [self checkPopUpStatusAndCallPopUpView];
                if (![popUpStatus isEqual: @"ON"]) {
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                }
                break;
                
            default:
                break;
        }
        
    }
    else if(alertView.tag == 3)
    {
        switch (buttonIndex) {
            case 0:
                [self captureImageAction];
                break;
                
            default:
                break;
        }
    }
//    *****   Added by Harshitha ends   *****
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Tableview delegates , datasources and related methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int numOfRows;
//    
//    if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
//    {
//        if (tableView == self.detailTableView1){
//            numOfRows = 5;
//        }
//        else if (tableView == self.detailTableView2){
//            numOfRows = 7;
//        }
//        else if (tableView == self.detailTableView3){
//            numOfRows = 6;
//            if (self.serverAttachmentButtonClicked)
//                numOfRows += self.serverAttachmentsArray.count;
//            if (self.additionalPartnersButtonClicked)
//                numOfRows += self.additionalPartnersArray.count+1;
//        }
//    }
//    else
//    {
        if (tableView == self.detailTableView1_Landscape){
            numOfRows = 7;
        }
        else if (tableView == self.detailTableView2_Landscape){
            numOfRows = 10;
            if (self.serverAttachmentButtonClicked)
                numOfRows += self.serverAttachmentsArray.count;
            if (self.additionalPartnersButtonClicked)
                numOfRows += self.additionalPartnersArray.count+1;
        }
//    }
    return numOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * statusPostSetAction = [ contextDataClass getstatusPostSetActionForText:self.serviceTask.statusText ];
    
    CGFloat rowHeight = 0.0;
//
//    if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
//  {
//    if (tableView == self.detailTableView1)
//    {
//        switch (indexPath.row)
//        {
//            case 0:
//                if ([self isNullValue:self.serviceTask.serviceLocation] && [self isNullValue:self.serviceTask.locationAddress])
//                {
//                    rowHeight = 0.0;
//                }
//                else
//                {
//                    rowHeight = 105.0;
//                }
//                break;
//                
//            case 1:
//                if ([self isNullValue:self.serviceTask.serviceOrder])
//                {
//                    rowHeight = 0.0;
//                }
//                else
//                {
//                    rowHeight = 60.0;
//                }
//                break;
//                
//            case 2:
//                if ([self isNullValue:self.serviceTask.serviceOrderType])
//                {
//                    rowHeight = 0.0;
//                }
//                else
//                {
//                    rowHeight = 60.0;
//                }
//                break;
//                
//            case 3:
//                if ([self isNullValue:self.serviceTask.serviceOrderDescription])
//                {
//                    rowHeight = 0.0;
//                }
//                else
//                {
//                    rowHeight = 60.0;
//                }
//                break;
//                
//            case 4:
//                if ([self isNullValue:self.serviceTask.priority])
//                {
//                    rowHeight = 0.0;
//                }
//                else
//                {
//                    rowHeight = 60.0;
//                }
//                break;
//                
//            default:
//                break;
//        }
//    }
//    else if (tableView == self.detailTableView2)
//    {
//        switch (indexPath.row)
//        {
//            case 0:
//                if ([self isNullValue:self.serviceTask.contactName] && [self isNullValue:self.serviceTask.telNum] && [self isNullValue:self.serviceTask.altTelNum])
//                {
//                    rowHeight = 0.0;
//                }
//                else if ([self isNullValue:self.serviceTask.altTelNum]){
//                    if (![self isNullValue:self.serviceTask.contactName] || ![self isNullValue:self.serviceTask.telNum])
//                    {
//                        rowHeight = 105.0;
//                    }
//                }
//                else if (![self isNullValue:self.serviceTask.altTelNum] && ![self isNullValue:self.serviceTask.contactName] && ![self isNullValue:self.serviceTask.telNum])
//                {
//                    rowHeight = 105.0;
//                }
//                break;
//            case 1:
//                if (![self isNullValue:self.serviceTask.statusText])
//                {
//                    rowHeight = 60.0;
//                }
//                else if (![self isNullValue:self.serviceTask.status]){
//                    rowHeight = 60.0;
//                }
//                else
//                {
//                    rowHeight = 0.0;
//                }
//                break;
//            case 2:
//                if ([statusPostSetAction rangeOfString:@"ASK-FOR-REJECTION-REASON"].location != NSNotFound && [self.serviceTask.status isEqualToString:@"RJCT"])
//                {
//                    rowHeight = 60.0;
//                }
//                else
//                {
//                    rowHeight = 0.0;
//                }
//                    
//                break;
//            case 3:
//                if ([statusPostSetAction rangeOfString:@"ASK-FOR-REJECTION-REASON"].location != NSNotFound &&  [self.serviceTask.status isEqualToString:@"RJCT"])
//                {
//                    rowHeight = 60.0;
//                }
//                else
//                {
//                    rowHeight = 0.0;
//                }
//                break;
//            case 4:
//                if ([statusPostSetAction rangeOfString:@"ASK-FOR-REJECTION-REASON"].location == NSNotFound || ![self.serviceTask.status isEqualToString:@"RJCT"])
//                {
//                    if ([self isNullValue:self.serviceTask.startDateAndTime])
//                    {
//                        rowHeight = 0.0;
//                    }
//                    else
//                    {
//                        rowHeight = 60.0;
//                    }
//                }
//                break;
//            case 5:
//                if ([statusPostSetAction rangeOfString:@"ASK-FOR-ETA"].location != NSNotFound && [self.serviceTask.status isEqualToString:@"ACPT"])
////                if (![self.serviceTask.status isEqualToString:@"DSCD"])
//                {
//                    estArrDateIndexPath = indexPath;
//                    rowHeight = 60.0;
//                }
////                else
////                {
////                    rowHeight = 0.0;
////                }
//                break;
//            case 6:
//                rowHeight = 60.0;
//                break;
//            default:
//                break;
//        }
//    }
//    else if (tableView == self.detailTableView3)
//    {
//        int serverAttachmentsCount = self.serverAttachmentsArray.count;
//        int additionalPartnersCount = self.additionalPartnersArray.count;
//        
//        if (indexPath.row == 0)
//        {
//                if (![self isNullValue:self.serviceTask.partner])
//                {
//                    rowHeight = 60.0;
//                }
//                else
//                {
//                    rowHeight = 0.0;
//                }
//        }
//        else if (indexPath.row == 1)
//        {
//                if (![self isNullValue:firstServiceItemStr])
//                {
//                    rowHeight = 60.0;
//                }
//                else
//                {
//                    rowHeight = 0.0;
//                }
//        }
//        else if (indexPath.row == 2)
//        {
//                if (![self isNullValue:self.serviceTask.serviceItem])
//                {
//                    rowHeight = 60.0;
//                }
//                else
//                {
//                    rowHeight = 0.0;
//                }
//        }
//        else if (indexPath.row == 3)
//        {
////                rowHeight = [self cellHieghtForMultipleRowCell:self.serviceTask forRow:OtherDetailsRow];
//                if (![self isNullValue:self.serviceTask.serviceNote])
//                {
//                    if (self.serviceNoteExpandButtonClicked)
//                        rowHeight = 60 +((self.serviceTask.serviceNote.length / 110)+1)*21;
//                    else
//                        rowHeight = 60.0;
//                }
//                else
//                {
//                    rowHeight = 0.0;
//                }
//        }
//        else if (indexPath.row == 4)
//        {
//            if ([serviceOrderObject CheckServerAttachments:self.serviceTask.serviceOrder andExtNum:self.serviceTask.firstServiceItem])
//                {
//                    rowHeight = 50.0;
//                }
//                else
//                {
//                    rowHeight = 0.0;
//                }
//        }
//        else if (self.serverAttachmentButtonClicked && indexPath.row > 4 && indexPath.row <= (4+serverAttachmentsCount))
//        {
//            rowHeight = 40.0;
//        }
//        else if (indexPath.row == (5+serverAttachmentsCount))
//        {
//                if ([serviceOrderObject checkAdditionalPartners:self.serviceTask.serviceOrder andFirstServiceItem:self.serviceTask.firstServiceItem])
//                {
//                    rowHeight = 50.0;
//                }
//                else
//                {
//                    rowHeight = 0.0;
//                }
//        }
//        else if (self.additionalPartnersButtonClicked && indexPath.row >= (5+serverAttachmentsCount) && indexPath.row <= (6+additionalPartnersCount+serverAttachmentsCount))
//        {
//            rowHeight =40.0;
//        }
//    }
//  }
//  else
//  {
      if (tableView == self.detailTableView1_Landscape)
      {
          switch (indexPath.row)
          {
              case 0:
                  if ([self isNullValue:self.serviceTask.serviceLocation] && [self isNullValue:self.serviceTask.locationAddress])
                  {
                      rowHeight = 0.0;
                  }
                  else
                  {
                      rowHeight = 60.0;
                  }
                  break;
                  
              case 1:
                  if ([self isNullValue:self.serviceTask.serviceOrder])
                  {
                      rowHeight = 0.0;
                  }
                  else
                  {
                      rowHeight = 55.0;
                  }
                  break;
                  
              case 2:
                  if ([self isNullValue:self.serviceTask.serviceOrderType])
                  {
                      rowHeight = 0.0;
                  }
                  else
                  {
                      rowHeight = 55.0;
                  }
                  break;
                  
              case 3:
                  if ([self isNullValue:self.serviceTask.serviceOrderDescription])
                  {
                      rowHeight = 0.0;
                  }
                  else
                  {
                      rowHeight = 55.0;
                  }
                  break;
                  
              case 4:
                  if ([self isNullValue:self.serviceTask.priority])
                  {
                      rowHeight = 0.0;
                  }
                  else
                  {
                      rowHeight = 55.0;
                  }
                  break;
              case 5:
                  if (![self isNullValue:self.serviceTask.partner])
                  {
                      rowHeight = 55.0;
                  }
                  else
                  {
                      rowHeight = 0.0;
                  }
                  break;
              case 6:
                  if (![self isNullValue:firstServiceItemStr])
                  {
                      rowHeight = 55.0;

                  }
                  else
                  {
                      rowHeight = 0.0;
                  }
                  break;
              default:
                  break;
          }
      }
      else if (tableView == self.detailTableView2_Landscape)
      {
          int serverAttachmentsCount = self.serverAttachmentsArray.count;
          int additionalPartnersCount = self.additionalPartnersArray.count;

          if (indexPath.row == 0)
          {
                  if ([self isNullValue:self.serviceTask.contactName] && [self isNullValue:self.serviceTask.telNum] && [self isNullValue:self.serviceTask.altTelNum])
                  {
                      rowHeight = 0.0;
                  }
                  else if ([self isNullValue:self.serviceTask.altTelNum]){
                      if (![self isNullValue:self.serviceTask.contactName] || ![self isNullValue:self.serviceTask.telNum])
                      {
                          rowHeight = 87.0;
                      }
                  }
                  else if (![self isNullValue:self.serviceTask.altTelNum] && ![self isNullValue:self.serviceTask.contactName] && ![self isNullValue:self.serviceTask.telNum])
                  {
                      rowHeight = 87.0;
                  }
          }
          else if (indexPath.row == 1)
          {
                  if (![self isNullValue:self.serviceTask.statusText])
                  {
                      rowHeight = 55.0;
                  }
                  else if (![self isNullValue:self.serviceTask.status]){
                      rowHeight = 55.0;
                  }
                  else
                  {
                      rowHeight = 0.0;
                  }
          }
          else if (indexPath.row == 2)
          {
                  if ([statusPostSetAction rangeOfString:@"ASK-FOR-REJECTION-REASON"].location != NSNotFound && [self.serviceTask.status isEqualToString:@"RJCT"])
                  {
                      rowHeight = 55.0;
                  }
                  else
                  {
                      rowHeight = 0.0;
                  }
          }
          else if (indexPath.row == 3)
          {
                  if ([statusPostSetAction rangeOfString:@"ASK-FOR-REJECTION-REASON"].location != NSNotFound &&  [self.serviceTask.status isEqualToString:@"RJCT"])
                  {
                      rowHeight = 55.0;
                  }
                  else
                  {
                      rowHeight = 0.0;
                  }
          }
          else if (indexPath.row == 4)
          {
                  if ([statusPostSetAction rangeOfString:@"ASK-FOR-REJECTION-REASON"].location == NSNotFound || ![self.serviceTask.status isEqualToString:@"RJCT"])
                  {
                      if ([self isNullValue:self.serviceTask.startDateAndTime])
                      {
                          rowHeight = 0.0;
                      }
                      else
                      {
                          rowHeight = 55.0;
                      }
                  }
          }
          else if (indexPath.row == 5)
          {
                  if ([statusPostSetAction rangeOfString:@"ASK-FOR-ETA"].location != NSNotFound && [self.serviceTask.status isEqualToString:@"ACPT"])
                      //                if (![self.serviceTask.status isEqualToString:@"DSCD"])
                  {
                      estArrDateIndexPath = indexPath;
                      rowHeight = 55.0;
                  }
                  //                else
                  //                {
                  //                    rowHeight = 0.0;
                  //                }
          }
          else if (indexPath.row == 6)
          {
              rowHeight = 55.0;
          }
          else if (indexPath.row == 7)
          {
//                rowHeight = [self cellHieghtForMultipleRowCell:self.serviceTask forRow:OtherDetailsRow];
                  if (![self isNullValue:self.serviceTask.serviceNote])
                    {
                        if (self.serviceNoteExpandButtonClicked)
                        {
                            UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
                        
                        if(UIInterfaceOrientationIsLandscape(interfaceOrientation))

                            rowHeight = 60 +((self.serviceTask.serviceNote.length / 110)+1)*21;
                        else if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
                            rowHeight=70 +((self.serviceTask.serviceNote.length / 110)+1)*21;
                        }
                        else
                            rowHeight = 55.0;
                    }
                    else
                    {
                        rowHeight = 0.0;
                    }
          }
          
          else if (indexPath.row == 8)
          {
              if ([serviceOrderObject CheckServerAttachments:self.serviceTask.serviceOrder andExtNum:self.serviceTask.firstServiceItem])
              {
                  rowHeight = 55.0;
              }
              else
              {
                  rowHeight = 0.0;
              }
          }
          else if (self.serverAttachmentButtonClicked && indexPath.row > 8 && indexPath.row <= (8+serverAttachmentsCount))
          {
              rowHeight = 55.0;
          }
          else if (indexPath.row == (9+serverAttachmentsCount))
          {
              if ([serviceOrderObject checkAdditionalPartners:self.serviceTask.serviceOrder andFirstServiceItem:self.serviceTask.firstServiceItem])
              {
                  rowHeight = 55.0;
              }
              else
              {
                  rowHeight = 0.0;
              }
          }
          else if (self.additionalPartnersButtonClicked && indexPath.row >= (9+serverAttachmentsCount) && indexPath.row <= (10+additionalPartnersCount+serverAttachmentsCount))
          {
              rowHeight = 55.0;
              
              if (indexPath.row > (10+serverAttachmentsCount) && indexPath.row <= (11+additionalPartnersCount+serverAttachmentsCount))
              {
                  Partners * partners ;
                  partners = [self.additionalPartnersArray objectAtIndex:(indexPath.row-11-self.serverAttachmentsArray.count)];
                  if (![self isNullValue:partners.telNum2] && UIInterfaceOrientationIsLandscape(interfaceOrientation))
                      rowHeight = 68;
              }
          }
//      }
  }
  return rowHeight;
}

/*
- (CGFloat)heightForCellsByCheckingNullValueWithIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0.0;
    
    NSString * statusPostSetAction = [ contextDataClass getstatusPostSetActionForText:self.serviceTask.statusText ];
    
    switch (indexPath.row) {
            
        case ServiceLocationRow:
            if (![self.serviceTask.serviceLocation isEqualToString:@""])
            {
                if (IS_IPAD)
                    rowHeight = 107.0;
                else
                    rowHeight = 96.0;
            }
            break;
            
        case ServiceOrderRow:
            rowHeight = [self setEmptyCellForNullValues:self.serviceTask.serviceOrder];
            break;
            
        case ServiceOrderTypeRow:
            rowHeight = [self setEmptyCellForNullValues:self.serviceTask.serviceOrderTypeDesc];
            break;
            
        case PriorityRow:
            rowHeight = [self setEmptyCellForNullValues:self.serviceTask.priority];
            break;
            
        case StatusRow:
//  Original code
//            rowHeight = [self setEmptyCellForNullValues:self.serviceTask.statusText];
//  Modified by Harshitha
            if (![self.serviceTask.statusText isEqualToString:@""]) {
                rowHeight = [self setEmptyCellForNullValues:self.serviceTask.statusText];
            }
            else {
                rowHeight = [self setEmptyCellForNullValues:self.serviceTask.status];
            }
            break;
            
        case ReasonRow:
            if ([statusPostSetAction rangeOfString:@"ASK-FOR-REJECTION-REASON"].location != NSNotFound && [self.serviceTask.status isEqualToString:@"RJCT"])
                rowHeight = 55.0;
            break;
            
        case EnterReasonRow:
            
            if ([statusPostSetAction rangeOfString:@"ASK-FOR-REJECTION-REASON"].location != NSNotFound &&  [self.serviceTask.status isEqualToString:@"RJCT"])
            {
                if (IS_IPAD)
                    rowHeight = 120.0;
                else
                    rowHeight = 96.0;
            }
            break;
            
        case StartDateRow:
            if ([statusPostSetAction rangeOfString:@"ASK-FOR-REJECTION-REASON"].location == NSNotFound || ![self.serviceTask.status isEqualToString:@"RJCT"])
//                rowHeight = 55.0;
                rowHeight = [self setEmptyCellForNullValues:self.serviceTask.startDateAndTime];
            break;
            
        case EstimatedArrivalDateRow:
            
            if ([statusPostSetAction rangeOfString:@"ASK-FOR-ETA"].location != NSNotFound && [self.serviceTask.status isEqualToString:@"ACPT"])
            {
                estArrDateIndexPath = indexPath;
                rowHeight = 55.0;
            }
            
            break;
//        case TimeZoneRow:

//            rowHeight = [self setEmptyCellForNullValues:self.serviceTask.timeZoneFrom];
//            break;

        case FieldNoteRow:
//            if (![self.serviceTask.fieldNote isEqualToString:@""])
            if (IS_IPAD)
                rowHeight = 107.0;
            else
                rowHeight = 96.0;
            break;
            
        case ContactNameRow:
            rowHeight = [self setEmptyCellForNullValues:self.serviceTask.contactName];
            break;
            
        case TelNumberRow:
            rowHeight = [self setEmptyCellForNullValues:self.serviceTask.telNum];
            break;
        case AltrTeleNumRow:
            if (IS_IPHONE) {
                rowHeight = [self setEmptyCellForNullValues:self.serviceTask.altTelNum];
            }
            else
                rowHeight = 0;
            break;
            
        case ServiceOrdrDescriptionRow:
            rowHeight = [self cellHieghtForMultipleRowCell:self.serviceTask forRow:ServiceOrdrDescriptionRow];
            break;
            
        case OtherDetailsRow:
            rowHeight = [self cellHieghtForMultipleRowCell:self.serviceTask forRow:OtherDetailsRow];
            break;
            
        default:
            break;
    }
    
    
    return rowHeight;
}

- (CGFloat) setEmptyCellForNullValues:(NSString*)serviceOrderTask
{
    if ([serviceOrderTask isEqualToString:@""] || [serviceOrderTask isEqual:[NSNull null]] || serviceOrderTask == nil)
    {
        return 0.0;
    }
    
//    return 55.0;
    else {
        if(IS_IPAD)
            return 55.0;
        else
            return 38.0;
    }
}
*/

- (BOOL) isNullValue:(NSString*)serviceOrderTask
{
    BOOL isNull = NO;
    if ([serviceOrderTask isEqualToString:@""] || [serviceOrderTask isEqual:[NSNull null]] || serviceOrderTask == nil)
    {
        isNull = YES;
    }
    return isNull;
}

- (CGFloat) cellHieghtForMultipleRowCell:(ServiceTask*)serviceTask forRow:(int)row
{
    CGFloat rowHeight = 0.0;
// Added by Harshitha
    if (![self isEmptyValue:serviceTask.firstServiceProduct] && ![self isEmptyValue:serviceTask.firstServiceProductDescription]) {
        firstServiceItemStr = [NSString stringWithFormat:@"%@ %@",serviceTask.firstServiceProduct,serviceTask.firstServiceProductDescription];
    }

    NSString *pattern = [self checkOccuranceOfField:serviceTask.partner servc_firstItem:firstServiceItemStr servc_Item:serviceTask.serviceItem andServc_Note:serviceTask.serviceNote];
// Added by Harshitha ends here

    switch (row)
    {
        case ServiceOrdrDescriptionRow:
            
            if ([serviceTask.serviceOrderDescription isEqualToString:@""] || [serviceTask.serviceOrderDescription isEqual:[NSNull null]] || serviceTask.serviceOrderDescription == nil)
                rowHeight = 0.0;
            else
                rowHeight = 62.0;
            break;
            
       case OtherDetailsRow:
//  Original code
/*            if (([self isEmptyValue:serviceTask.partner])&& ([self isEmptyValue:serviceTask.serviceItem]) && ([self isEmptyValue:serviceTask.serviceNote]))
            {
                rowHeight = 0.0;
            }
            else if (!([self isEmptyValue:serviceTask.partner]) && !([self isEmptyValue:serviceTask.serviceItem]) && !([self isEmptyValue:serviceTask.serviceNote]))
            {
                rowHeight = 180.0;
            }

            else if ((!([self isEmptyValue:serviceTask.partner]) && ([self isEmptyValue:serviceTask.serviceItem]) && ([self isEmptyValue:serviceTask.serviceNote])) || (([self isEmptyValue:serviceTask.partner]) && !([self isEmptyValue:serviceTask.serviceItem]) && ([self isEmptyValue:serviceTask.serviceNote])) || (([self isEmptyValue:serviceTask.partner]) && ([self isEmptyValue:serviceTask.serviceItem]) && !([self isEmptyValue:serviceTask.serviceNote])))
            {
                rowHeight = 62.0;
            }
            
            else if ((!([self isEmptyValue:serviceTask.partner]) && !([self isEmptyValue:serviceTask.serviceItem]) && ([self isEmptyValue:serviceTask.serviceNote])) || (!([self isEmptyValue:serviceTask.partner]) && ([self isEmptyValue:serviceTask.serviceItem]) && !([self isEmptyValue:serviceTask.serviceNote])) || (([self isEmptyValue:serviceTask.partner]) && !([self isEmptyValue:serviceTask.serviceItem]) && !([self isEmptyValue:serviceTask.serviceNote])))
            {
                rowHeight = 125.0;
            }
*/
//  Modified by Harshitha to add FirstServiceItem field
            if ([pattern isEqualToString:@"0000"])
            {
                rowHeight = 0.0;
            }
            else if ([pattern isEqualToString:@"0001"] || [pattern isEqualToString:@"0010"] || [pattern isEqualToString:@"0100"] || [pattern isEqualToString:@"1000"])
            {
                rowHeight = 62.0;
            }
            else if ([pattern isEqualToString:@"0011"] || [pattern isEqualToString:@"0101"] || [pattern isEqualToString:@"1001"] || [pattern isEqualToString:@"0110"] || [pattern isEqualToString:@"1010"] || [pattern isEqualToString:@"1100"])
            {
                rowHeight = 125.0;
            }
            else if ([pattern isEqualToString:@"0111"] || [pattern isEqualToString:@"1011"] || [pattern isEqualToString:@"1110"] || [pattern isEqualToString:@"1101"])
            {
                rowHeight = 180.0;
            }
            else if ([pattern isEqualToString:@"1111"])
            {
                rowHeight = 240.0;
            }

            break;
    }
    return rowHeight;
}

- (BOOL) isEmptyValue: (NSString*)string
{
    if ([string isEqualToString:@""] || [string isEqual:[NSNull null]] || string == nil)
        return YES;
    else
        return NO;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ServiceTask * serviceTask = self.serviceTask;
    
    NSString *CellIdentifier1 = [NSString stringWithFormat: @"GSPTableViewCell%d",(int)indexPath.row];
    NSString *CellIdentifier2 = [NSString stringWithFormat: @"GSPTableViewCellWithOneLabel%d",(int)indexPath.row];
    NSString *CellIdentifier3 = [NSString stringWithFormat: @"GSPMultipleRowTableViewCell%d",(int)indexPath.row];
    
    if (indexPath.row == ServiceLocationRow || indexPath.row == FieldNoteRow || indexPath.row == EnterReasonRow)
    {
        GSPTableViewCell *cell = (GSPTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        
        
        if (cell == nil) {
            
            NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:@"GSPTableViewCell" owner:self options:nil];
            
            if (IS_IPAD) {
                cell            = (GSPTableViewCell *)[nib objectAtIndex:0];
            }
            else
            {
                cell            = (GSPTableViewCell *)[nib objectAtIndex:1];
            }
        }
        
        cell.backgroundView                     = nil;
        cell.backgroundColor                    = [UIColor clearColor];
        cell.noteTextField.layer.cornerRadius   = 3.0;
        cell.noteTextField.layer.borderColor    = [[UIColor lightGrayColor]CGColor];
        cell.noteTextField.layer.borderWidth    = 1.0f;
        cell.showRoute.hidden                   = YES;
        cell.bgView.hidden                      = YES;
        cell.bgView.backgroundColor             = [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
        cell.noteTextField.delegate             = self;
        cell.noteTextField.tag                  = indexPath.row;

        
        [cell.descriptionLabel setLabelsForDetailTableValues];
        [cell.titleLabel boldLabelsForDetailTableTitles];

        
        [cell.showRoute addTarget:self action:@selector(showMapViewWithDirections) forControlEvents:UIControlEventTouchUpInside];
        
        if (indexPath.row == ServiceLocationRow)
        {
            cell.titleLabel.text            = NSLocalizedString(@"SERVICE_LOCATION", nil);
            cell.descriptionLabel.text      = [serviceTask.serviceLocation stringByAppendingString:[NSString stringWithFormat:@", %@", serviceTask.locationAddress]];
            cell.noteTextField.hidden       = YES;
            cell.showRoute.hidden           = NO;
            cell.bgView.hidden              = NO;
        }
        else if (indexPath.row == FieldNoteRow)
        {
            cell.titleLabel.text            = NSLocalizedString(@"FIELD_NOTE", nil);
            cell.noteTextField.text         = serviceTask.fieldNote;
            cell.descriptionLabel.hidden    = YES;
            
        }
        else if (indexPath.row == EnterReasonRow)
        {
            cell.titleLabel.text            = NSLocalizedString(@"ENTER_REASON", nil);
            cell.descriptionLabel.hidden    = YES;
            cell.noteTextField.userInteractionEnabled = NO;
            
            if ([self.serviceTask.serviceOrderRejectionReason isEqualToString:@"Other"]||
                [self.serviceTask.serviceOrderRejectionReason isEqualToString:@""] ||
                [self.serviceTask.serviceOrderRejectionReason isEqual:[NSNull null] ] ||
                self.serviceTask.serviceOrderRejectionReason == nil)
            {
                cell.noteTextField.userInteractionEnabled = YES;
            }
            
        }
        
        return cell;
    }
    
    else if (indexPath.row == ServiceOrdrDescriptionRow || indexPath.row == OtherDetailsRow)
    {
        GSPMultipleRowTableViewCell *cell = (GSPMultipleRowTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
        
        
        if (cell == nil) {
            
            NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:@"GSPMultipleRowTableViewCell" owner:self options:nil];
            cell            = (GSPMultipleRowTableViewCell *)[nib objectAtIndex:0];
            
        }
        

        [cell.rowOneTitle boldLabelsForDetailTableTitles];
        [cell.rowTwoTitle boldLabelsForDetailTableTitles];
        [cell.rowThreeTitle boldLabelsForDetailTableTitles];
        [cell.rowOneDescription setLabelsForDetailTableValues];
        [cell.rowTwoDescription setLabelsForDetailTableValues];
        [cell.rowThreeDescription setLabelsForDetailTableValues];
        [cell.rowFourTitle boldLabelsForDetailTableTitles];
        [cell.rowFourDescription setLabelsForDetailTableValues];
        
        cell.collapseButton.hidden  = YES;
        cell.collapseButton2.hidden = YES;
        
        cell.backgroundView     = nil;
        cell.backgroundColor    = [UIColor clearColor];
        if (indexPath.row == ServiceOrdrDescriptionRow)
        {
            cell.rowOneTitle.text          =  NSLocalizedString(@"SERVICE_ORDER_DESC", nil);
            cell.rowOneDescription.text    = serviceTask.serviceOrderDescription;
            cell.rowTwoTitle.hidden        = YES;
            cell.rowTwoDescription.hidden  = YES;
            
            cell.rowThreeTitle.hidden      = YES;
            cell.rowThreeDescription.hidden  = YES;
            
            cell.rowFourTitle.hidden        = YES;
            cell.rowFourDescription.hidden  = YES;
        }
        else if (indexPath.row == OtherDetailsRow)
        {
            [self configureMultipleRowSectionCell:cell withServiceItem:serviceTask];
        }
        
        
        return cell;
    }

    else
    {
        GSPTableViewCellWithOneLabel *cell  = (GSPTableViewCellWithOneLabel *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        
        if (cell == nil) {
            
            NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:@"GSPTableViewCellWithOneLabel" owner:self options:nil];
            
            if (IS_IPAD) {
                cell            = (GSPTableViewCellWithOneLabel *)[nib objectAtIndex:0];
            }
            else
            {
                cell            = (GSPTableViewCellWithOneLabel *)[nib objectAtIndex:1];
            }
            
            
        }
        
        cell.backgroundView                 = nil;
        cell.backgroundColor                = [UIColor clearColor];
        
        cell.dropBoxSelectionButton.hidden  = YES;
        [cell.dropBoxSelectionButton addTarget:self action:@selector(dropBoxSelectorClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.collapseButton.hidden          = YES;
        
        cell.callButton.hidden              = YES;
        cell.callButton.tag                 = indexPath.row;
        [cell.callButton addTarget:self action:@selector(callButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//  Added by Harshitha
        cell.callButton2.hidden             = YES;
        cell.callButton2.tag                = indexPath.row+1;
        [cell.callButton2 addTarget:self action:@selector(callButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//  Added by Harshitha ends here
        
        //Set The title Labels to bold format
        [cell.titleLabel boldLabelsForDetailTableTitles];
        [cell.descriptionLabel setLabelsForDetailTableValues];
        [cell.descriptionLabel2 setLabelsForDetailTableValues];
        
        switch (indexPath.row) {
                
            case ServiceOrderRow:
                
            {
                cell.titleLabel.text            = NSLocalizedString(@"SERVICE_ORDER", nil);
                
                NSString * serviceOrder         = serviceTask.serviceOrder;
//                if (serviceTask.numberExtension.length > 0)
//                {
//                    serviceOrder   = [serviceOrder stringByAppendingString:[NSString stringWithFormat:@"/%@",serviceTask.numberExtension]];
//                }
 
                if (serviceTask.firstServiceItem.length > 0)
                {
                    serviceOrder   = [serviceOrder stringByAppendingString:[NSString stringWithFormat:@"/%@",serviceTask.firstServiceItem]];
                }
                cell.descriptionLabel.text      = serviceOrder;

            }
                break;
                
            case ServiceOrderTypeRow:
                cell.titleLabel.text            = NSLocalizedString(@"SERVICE_ORDR_TYPE", nil);
                cell.descriptionLabel.text      = serviceTask.serviceOrderTypeDesc;
                break;
                
            case PriorityRow:
                cell.titleLabel.text            = NSLocalizedString(@"PRIORITY_TITLE", nil);
                cell.descriptionLabel.text      = serviceTask.priority;
                break;
                
            case StatusRow:
                cell.titleLabel.text                = NSLocalizedString(@"SERVICE_STATUS", nil);
                cell.dropBoxSelectionButton.hidden  = NO;
                cell.dropBoxSelectionButton.tag     = indexPath.row;
                cell.descriptionLabel.hidden        = YES;
                [cell.dropBoxSelectionButton addTarget:self action:@selector(dropBoxSelectorClicked:) forControlEvents:UIControlEventTouchUpInside];
//    Original code
//                [cell.dropBoxSelectionButton setTitle:serviceTask.statusText forState:UIControlStateNormal];
//    Modified by Harshitha
                if (![serviceTask.statusText isEqualToString:@""]) {
                    [cell.dropBoxSelectionButton setTitle:serviceTask.statusText forState:UIControlStateNormal];
                }
                else {
                    [cell.dropBoxSelectionButton setTitle:[contextDataClass getStatusTextForStatusCode:serviceTask.status] forState:UIControlStateNormal];
                }
                break;
                
            case ReasonRow:
                cell.titleLabel.text                = NSLocalizedString(@"REASON", nil);
                cell.dropBoxSelectionButton.hidden  = NO;
                
                if ([serviceTask.serviceOrderRejectionReason isEqualToString:@""] || [serviceTask.serviceOrderRejectionReason isEqual:[NSNull null]] || serviceTask.serviceOrderRejectionReason == nil)
                {
                    self.serviceTask.serviceOrderRejectionReason = @"Other";
                    [cell.dropBoxSelectionButton setTitle:@"Other" forState:UIControlStateNormal];
                }
                else
                {
                    [cell.dropBoxSelectionButton setTitle:serviceTask.serviceOrderRejectionReason forState:UIControlStateNormal];
                }
                
                cell.dropBoxSelectionButton.tag     = indexPath.row;
                cell.descriptionLabel.hidden        = YES;
                break;
                
            case StartDateRow:
                cell.titleLabel.text                = NSLocalizedString(@"START_TIME", nil);
                cell.dropBoxSelectionButton.hidden  = NO;
                cell.descriptionLabel.hidden        = YES;
//  Original code
//                [cell.dropBoxSelectionButton setTitle:serviceTask.startDate forState:UIControlStateNormal];
//  Modified by Harshitha
                [cell.dropBoxSelectionButton setTitle:[[GSPDateUtility sharedInstance] convertHHMMSStoHHMM:serviceTask.startDateAndTime] forState:UIControlStateNormal];

                [cell.dropBoxSelectionButton setUserInteractionEnabled:NO];
                break;
                
            case EstimatedArrivalDateRow:
                cell.titleLabel.text                = NSLocalizedString(@"EST_ARRIVAL_DATE", nil);
                cell.dropBoxSelectionButton.hidden  = NO;
                cell.descriptionLabel.hidden        = YES;
//  Original code
//                [cell.dropBoxSelectionButton setTitle:serviceTask.estimatedArrivalDate forState:UIControlStateNormal];
//  Modified by Harshitha
                [cell.dropBoxSelectionButton setTitle:[[GSPDateUtility sharedInstance]convertHHMMSStoHHMM:[NSString stringWithFormat:@"%@ %@",serviceTask.estimatedArrivalDate,serviceTask.estimatedArrivalTime]] forState:UIControlStateNormal];
                [cell.dropBoxSelectionButton setUserInteractionEnabled:NO];
                
                break;
                
//            case TimeZoneRow:
//                cell.titleLabel.text                = NSLocalizedString(@"TIME_ZONE", nil);
//                cell.dropBoxSelectionButton.hidden  = NO;
//                cell.descriptionLabel.hidden        = YES;
//                cell.dropBoxSelectionButton.tag     = indexPath.row;
//                [cell.dropBoxSelectionButton setTitle:serviceTask.timeZoneFrom forState:UIControlStateNormal];
//                break;
 
            case ContactNameRow:
                cell.titleLabel.text            = NSLocalizedString(@"CONT_NAME", nil);
                cell.descriptionLabel.text      = serviceTask.contactName;
                break;
                
            case TelNumberRow:
                cell.titleLabel.text            = NSLocalizedString(@"TELEPHONE_NUMBER", nil);
                cell.descriptionLabel.text      = serviceTask.telNum;
                cell.callButton.hidden          = NO;
// Added by Harshitha
                if (IS_IPAD) {
                    cell.descriptionLabel2.text     = serviceTask.altTelNum;
                    if (![serviceTask.altTelNum isEqualToString:@""]) {
                        cell.callButton2.hidden          = NO;
                    }
                }
                break;
            case AltrTeleNumRow:
                if (IS_IPHONE) {
                    cell.titleLabel.text            = NSLocalizedString(@"ALT_TEL_NUMBER", nil);
                    cell.descriptionLabel.text      = serviceTask.altTelNum;
                    cell.callButton.hidden          = NO;
                }
                break;
                
                
            default:v                                                                                                                                                                                  
                break;
        }
        
        return cell;
    }
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceTask * serviceTask = self.serviceTask;
    
    UITableViewCell * tableCell;
    
    static NSString * cellIdentifier2 = @"GSPOverviewTableViewCell";
    static NSString * cellIdentifier4 = @"GSPDetailTableCell";
    static NSString * cellIdentifier6 = @"GSPDetailTableViewCell";
    static NSString * cellIdentifier7 = @"GSPDatailTableViewCellWithOneLabel";

//  if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
//  {
//    if (tableView == self.detailTableView1) {
//        if (indexPath.row == 0)
//        {
//            GSPOverviewTableViewCell *cell = (GSPOverviewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
//            
//            if (cell == nil)
//            {
//                NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:cellIdentifier2 owner:self options:nil];
//                
//                if (IS_IPAD)
//                {
//                    cell            = (GSPOverviewTableViewCell *)[nib objectAtIndex:0];
//                }
//            }
//            
//            cell.backgroundView     = nil;
//            cell.backgroundColor    = [UIColor clearColor];
//            
//            cell.priorityImageView.hidden = YES;
//            cell.priorityLabelText.hidden = YES;
//            cell.mapButton.hidden         = YES;
//            cell.statusLabel2.hidden      = YES;
//            
//            cell.orgNameLabel.text          = serviceTask.serviceLocation;
//            cell.serviceLocationLabel1.text = serviceTask.locationAddress1;
//            cell.serviceLocationLabel2.text = serviceTask.locationAddress2;
//            cell.serviceLocationLabel3.text = serviceTask.locationAddress3;
//            
//            tableCell = cell;
//            return cell;
//        }
//        else if (indexPath.row > 0)
//        {
//            GSPDatailTableViewCellWithOneLabel *cell = (GSPDatailTableViewCellWithOneLabel *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier7];
//            
//            if (cell == nil)
//            {
//                NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:cellIdentifier7 owner:self options:nil];
//                
//                if (IS_IPAD)
//                {
//                    cell            = (GSPDatailTableViewCellWithOneLabel *)[nib objectAtIndex:0];
//                }
//            }
//            
//            cell.backgroundView     = nil;
//            cell.backgroundColor    = [UIColor clearColor];
//            
//            cell.expandArrowButton.hidden = YES;
//            
//            if (indexPath.row == 1){
//                cell.titleLabelName.text             = @"Service Document";
//                
//                if (IS_IPAD)
//                {
////                    cell.descriptionLabel.text       = [NSString stringWithFormat:@"%@",serviceTask.serviceOrder];;
////                    if (serviceTask.firstServiceItem.length != 0) {
////                        cell.descriptionLabel.text   = [NSString stringWithFormat:@"%@/%@",cell.descriptionLabel.text,serviceTask.firstServiceItem];
////                    }
//                    cell.descriptionLabelText.text       = [NSString stringWithFormat:@"%@",serviceTask.serviceOrder];;
//                    if (serviceTask.firstServiceItem.length != 0) {
//                        cell.descriptionLabelText.text   = [NSString stringWithFormat:@"%@/%@",cell.descriptionLabelText.text,serviceTask.firstServiceItem];
//                    }
//                }
//            }
//            else if (indexPath.row == 2){
//                cell.titleLabelName.text          = @"Service Order Type";
//                cell.descriptionLabelText.text   = serviceTask.serviceOrderType;
//            }
//            else if (indexPath.row == 3){
//                cell.titleLabelName.text          = @"Service Description";
//                cell.descriptionLabelText.text   = serviceTask.serviceOrderDescription;
//            }
//            else if (indexPath.row == 4){
//                cell.titleLabelName.text          = @"Priority";
//                cell.descriptionLabelText.text   = serviceTask.priority;
//            }
//            tableCell = cell;
//            return cell;
//        }
//    }
//    else if (tableView == self.detailTableView2) {
//        
//        GSPDetailTableCell *cell = (GSPDetailTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier4];
//        
//        if (cell == nil)
//        {
////            NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:cellIdentifier4 owner:self options:nil];
//            NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:cellIdentifier4 owner:self options:nil];
//            
//            if (IS_IPAD)
//            {
//                cell            = (GSPDetailTableCell *)[nib objectAtIndex:0];
//            }
//        }
//        
//        cell.backgroundView     = nil;
//        cell.backgroundColor    = [UIColor clearColor];
//        
//        cell.pickerButton.hidden = YES;
//        cell.pickerButton.userInteractionEnabled = NO;
//        cell.pickerArrow.hidden = YES;
//        
//        cell.telNumLabel.hidden = YES;
//        cell.telNumButton.userInteractionEnabled = NO;
//        cell.telNumButton.tag = indexPath.row;
//        [cell.telNumButton addTarget:self action:@selector(callButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        
//        cell.altTelNumLabel.hidden = YES;
//        cell.altTelNumButton.userInteractionEnabled = NO;
//        cell.altTelNumButton.tag = indexPath.row + 1;
//        [cell.altTelNumButton addTarget:self action:@selector(callButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        
//        cell.noteTextView.delegate             = self;
//        cell.noteTextView.tag                  = indexPath.row;
//        cell.noteTextView.hidden               = YES;
//
//        cell.notesLabel.hidden = YES;
//        cell.editPencilImage.hidden = YES;
//        
//        if (indexPath.row == 0)
//        {
//            cell.titleTextLabel.text         = @"Contact";
//            cell.descriptionTextLabel.text  = serviceTask.contactName;
//            if (serviceTask.telNum.length > 0) {
//                cell.telNumLabel.hidden = NO;
//                cell.telNumLabel.text       = serviceTask.telNum;
//                cell.telNumButton.userInteractionEnabled = YES;
//            }
//            if (serviceTask.altTelNum.length >0) {
//                cell.altTelNumLabel.hidden = NO;
//                cell.altTelNumLabel.text       = serviceTask.altTelNum;
//                cell.altTelNumButton.userInteractionEnabled = YES;
//            }
//        }
//        else if (indexPath.row == 1)
//        {
//            cell.titleTextLabel.text         = @"Status";
//            cell.pickerButton.hidden  = NO;
//            cell.pickerArrow.hidden   = NO;
//            cell.pickerButton.userInteractionEnabled = YES;
//            cell.pickerButton.tag     = indexPath.row;
//            [cell.pickerButton addTarget:self action:@selector(dropBoxSelectorClicked:) forControlEvents:UIControlEventTouchUpInside];
//            
//            if (![serviceTask.statusText isEqualToString:@""]) {
//                [cell.pickerButton setTitle:serviceTask.statusText forState:UIControlStateNormal];
//            }
//            else {
//                [cell.pickerButton setTitle:[contextDataClass getStatusTextForStatusCode:serviceTask.status] forState:UIControlStateNormal];
//            }
//        }
//        else if (indexPath.row == 2)
//        {
//            cell.titleTextLabel.text    = @"Reason";
//            cell.pickerButton.hidden    = NO;
//            cell.pickerArrow.hidden     = NO;
//            cell.pickerButton.tag     = indexPath.row;
//            [cell.pickerButton addTarget:self action:@selector(dropBoxSelectorClicked:) forControlEvents:UIControlEventTouchUpInside];
//        
//            if ([serviceTask.serviceOrderRejectionReason isEqualToString:@""] || [serviceTask.serviceOrderRejectionReason isEqual:[NSNull null]] || serviceTask.serviceOrderRejectionReason == nil)
//            {
//                self.serviceTask.serviceOrderRejectionReason = @"Other";
//                [cell.pickerButton setTitle:@"Other" forState:UIControlStateNormal];
//            }
//            else
//            {
//                [cell.pickerButton setTitle:serviceTask.serviceOrderRejectionReason forState:UIControlStateNormal];
//            }
//        
//            cell.pickerButton.tag     = indexPath.row;
//        }
//        else if (indexPath.row == 3)
//        {
//            cell.titleTextLabel.text            = @"Enter Reason";
//            cell.noteTextView.hidden            = NO;
//            cell.noteTextView.userInteractionEnabled = NO;
//            
//            if ([self.serviceTask.serviceOrderRejectionReason isEqualToString:@"Other"]||
//                [self.serviceTask.serviceOrderRejectionReason isEqualToString:@""] ||
//                [self.serviceTask.serviceOrderRejectionReason isEqual:[NSNull null] ] ||
//                self.serviceTask.serviceOrderRejectionReason == nil)
//            {
//                cell.noteTextView.userInteractionEnabled = YES;
//            }
//        }
//        else if (indexPath.row == 4)
//        {
//            cell.titleTextLabel.text  = @"Start Time";
//            cell.pickerButton.hidden  = NO;
//            cell.pickerArrow.hidden   = NO;
////            cell.pickerButton.userInteractionEnabled = YES;
//            [cell.pickerButton setTitle:[[GSPDateUtility sharedInstance] convertHHMMSStoHHMM:serviceTask.startDateAndTime] forState:UIControlStateNormal];
////            [cell.pickerButton addTarget:self action:@selector(dropBoxSelectorClicked:) forControlEvents:UIControlEventTouchUpInside];
//        }
//        else if (indexPath.row == 5)
//        {
//            cell.titleTextLabel.text                = @"Estimated Arrival";
//            cell.pickerButton.hidden  = NO;
//            cell.pickerArrow.hidden   = NO;
//        
//            [cell.pickerButton setTitle:[[GSPDateUtility sharedInstance]convertHHMMSStoHHMM:[NSString stringWithFormat:@"%@ %@",serviceTask.estimatedArrivalDate,serviceTask.estimatedArrivalTime]] forState:UIControlStateNormal];
////            [cell.pickerButton setUserInteractionEnabled:YES];
////            [cell.pickerButton addTarget:self action:@selector(dropBoxSelectorClicked:) forControlEvents:UIControlEventTouchUpInside];
//        }
//        else if (indexPath.row == 6)
//        {
//            cell.titleTextLabel.hidden     = YES;
//            cell.noteTextView.hidden       = NO;
//            cell.noteTextView.text         = serviceTask.fieldNote;
//            cell.noteTextView.userInteractionEnabled = YES;
////            cell.notesLabel.hidden = NO;
//            cell.editPencilImage.hidden = NO;
//
//            self.notesTextView = cell.noteTextView;
//        }
//        tableCell = cell;
//        return cell;
//    }
//    else if (tableView == self.detailTableView3) {
//        if (indexPath.row == 4 || (indexPath.row == 5 && !self.serverAttachmentButtonClicked) || (self.serverAttachmentButtonClicked && indexPath.row == (5+self.serverAttachmentsArray.count)))
//        {
//            GSPDetailTableViewCell *cell = (GSPDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier6];
//            
//            if (cell == nil)
//            {
//                NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:cellIdentifier6 owner:self options:nil];
//                
//                if (IS_IPAD)
//                {
//                    cell            = (GSPDetailTableViewCell *)[nib objectAtIndex:0];
//                }
//            }
//            
//            cell.backgroundView     = nil;
//            cell.backgroundColor    = [UIColor clearColor];
//            
//            if (indexPath.row == 4){
//                if (self.serverAttachmentButtonClicked)
//                    [cell.showContentsButton setImage:[UIImage imageNamed:@"CollapseArrow"] forState:UIControlStateNormal];
//                else
//                    [cell.showContentsButton setImage:[UIImage imageNamed:@"ExpandArrow"] forState:UIControlStateNormal];
//                
//                cell.TitleLabelText.text = @"Attachments";
//                cell.showContentsButton.tag = indexPath.row;
//                [cell.showContentsButton addTarget:self action:@selector(showContentsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//            }
//            else if ((indexPath.row == 5 && !self.serverAttachmentButtonClicked) || (self.serverAttachmentButtonClicked && indexPath.row == (5+self.serverAttachmentsArray.count))){
//                
//                if (self.additionalPartnersButtonClicked)
//                    [cell.showContentsButton setImage:[UIImage imageNamed:@"CollapseArrow"] forState:UIControlStateNormal];
//                else
//                    [cell.showContentsButton setImage:[UIImage imageNamed:@"ExpandArrow"] forState:UIControlStateNormal];
//                
////            else if (indexPath.row == (5+self.serverAttachmentsArray.count))
//                cell.TitleLabelText.text = @"Additional Partners";
////                cell.showContentsButton.tag = indexPath.row;
//                cell.showContentsButton.tag = indexPath.row-self.serverAttachmentsArray.count;
//                [cell.showContentsButton addTarget:self action:@selector(showContentsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//            }
//            tableCell = cell;
//            return cell;
//        }
//        
//        if (indexPath.row > 4 && indexPath.row <= (4+self.serverAttachmentsArray.count) && self.serverAttachmentButtonClicked)
//        {
//            static NSString * cellIdentifier = @"CellIdentifier";
//            
//            int nodeCount = [self.serverAttachmentsArray count];
//            
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//            
//            if (cell == nil) {
//                
//                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
//            }
//            cell.backgroundColor = [UIColor clearColor];
//            
//            if (nodeCount == 0 && indexPath.row == 5)
//            {
//                cell.textLabel.text = @"Loading…";
//            }
//            else
//            {
//                ServerAttachment *attachment    = [self.serverAttachmentsArray objectAtIndex:indexPath.row-5];
//                cell.textLabel.text             = attachment.attachmentID;
//                if (attachment.orderTaskNumExtension.length > 0) {
//                    cell.detailTextLabel.text       = [NSString stringWithFormat:@"%@ / %@",attachment.orderId,attachment.orderTaskNumExtension];
//                }
//                [serverAttachmentsObject configurePlaceHolderImageInView:cell.imageView withAttachmentId:attachment.attachmentID];
//            }
//            tableCell = cell;
//            return cell;
//        }
//        
//        if ((self.additionalPartnersButtonClicked && !self.serverAttachmentButtonClicked && indexPath.row > 5 && indexPath.row <=(6+self.additionalPartnersArray.count)) || (self.additionalPartnersButtonClicked && self.serverAttachmentButtonClicked && indexPath.row > (4+self.serverAttachmentsArray.count) && indexPath.row <=(6+self.serverAttachmentsArray.count+self.additionalPartnersArray.count)))
//            {
//                static NSString * cellIdentifier = @"GSPPartnerViewCell";
//                
//                GSPPartnerViewCell *cell = (GSPPartnerViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//                
//                if (cell == nil)
//                {
//                    NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
//                    
//                    if (IS_IPAD)
//                    {
//                        cell            = (GSPPartnerViewCell *)[nib objectAtIndex:0];
//                    }
//                    else
//                    {
//                        cell            = (GSPPartnerViewCell *)[nib objectAtIndex:1];
//                    }
//                    
//                }
//                
//                cell.backgroundView     = nil;
//                cell.backgroundColor    = [UIColor clearColor];
//                
//                cell.callButton1.hidden = YES;
//                cell.callButton2.hidden = YES;
//                cell.callButton2ForLandscape.hidden = YES;
//                cell.partnerTelNumIcon.hidden = YES;
//                cell.partnerAltTelNumIcon.hidden = YES;
//                cell.partnerAltTelNumIconForLandscape.hidden = YES;
//                
//                if (indexPath.row == (6+self.serverAttachmentsArray.count))
//                {
//                    cell.partnerNameLabel.text = @"Partner Name";
//                    cell.partnerNameLabel.textColor = [UIColor colorWithRed:39.0/255 green:119.0/255 blue:255.0/255 alpha:1.0];
//                    cell.partnerTypeLabel.text = @"Partner Type";
//                    cell.partnerTypeLabel.textColor = [UIColor colorWithRed:39.0/255 green:119.0/255 blue:255.0/255 alpha:1.0];
//                    cell.telNum1_label.text = @"Telephone Num";
//                    cell.telNum1_label.textColor = [UIColor colorWithRed:39.0/255 green:119.0/255 blue:255.0/255 alpha:1.0];
//                }
//                else
//                {
//                
////                cell.callButton1.hidden              = YES;
////                cell.callButton1.tag                 = indexPath.row;
//                cell.callButton1.tag                 = indexPath.row-7-self.serverAttachmentsArray.count;
//                [cell.callButton1 addTarget:self action:@selector(partnersCallButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
////                cell.callButton2.hidden              = YES;
////                cell.callButton2.tag                 = indexPath.row + 2000;
//                cell.callButton2.tag                 = indexPath.row-7-self.serverAttachmentsArray.count + 2000;
//                [cell.callButton2 addTarget:self action:@selector(partnersCallButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//                
//                Partners * partners ;
//                
//                partners = [self.additionalPartnersArray objectAtIndex:(indexPath.row-7-self.serverAttachmentsArray.count)];
//                
//                NSString *secondName = @"";
//                if (![self isNullValue:partners.nameTwo])
//                {
//                    secondName = partners.nameTwo;
//                }
//                    
//                cell.partnerTypeLabel.text      = [NSString stringWithFormat:@"%@",partners.parvw];
//                cell.partnerNameLabel.text      = [NSString stringWithFormat:@"%@ %@ (%@)",partners.nameOne,secondName,partners.partnerNum];
//                
//                if (![self isNullValue:partners.telNum1])
//                {
//                    cell.telNum1_label.text     = [NSString stringWithFormat:@"%@",partners.telNum1];
//                    cell.callButton1.hidden     = NO;
//                    cell.partnerTelNumIcon.hidden = NO;
//                }
//                if (![self isNullValue:partners.telNum2])
//                {
//                    cell.telNum2_label.text     = [NSString stringWithFormat:@"%@",partners.telNum2];
//                    cell.callButton2.hidden     = NO;
//                    cell.partnerAltTelNumIcon.hidden = NO;
//                }
//                }
//                tableCell = cell;
//                return cell;
//            }
//        
//        if (indexPath.row >= 0 && indexPath.row <= 3)
//        {
//            GSPDatailTableViewCellWithOneLabel *cell = (GSPDatailTableViewCellWithOneLabel *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier7];
//                
//            if (cell == nil)
//            {
//                NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:cellIdentifier7 owner:self options:nil];
//                    
//                if (IS_IPAD)
//                {
//                    cell            = (GSPDatailTableViewCellWithOneLabel *)[nib objectAtIndex:0];
//                }
//            }
//                
//            cell.backgroundView     = nil;
//            cell.backgroundColor    = [UIColor clearColor];
//            cell.expandArrowButton.hidden = YES;
//            
//            if (indexPath.row == 0)
//            {
//                cell.titleLabelName.text = @"Other Details";
//                cell.descriptionLabelText.text = [NSString stringWithFormat:@"Customer#  %@",serviceTask.partner];
//            }
//            else if (indexPath.row == 1)
//            {
//                cell.titleLabelName.text = @"First Service Item";
//                if (![self isEmptyValue:serviceTask.firstServiceProduct] && ![self isEmptyValue:serviceTask.firstServiceProductDescription]) {
//                    firstServiceItemStr = [NSString stringWithFormat:@"%@ %@",serviceTask.firstServiceProduct,serviceTask.firstServiceProductDescription];
//                }
//                if (![self isEmptyValue:serviceTask.firstServiceItem])
//                {
//                    firstServiceItemStr = [NSString stringWithFormat:@"%@ - %@",serviceTask.firstServiceItem,firstServiceItemStr];
//                }
//                cell.descriptionLabelText.text = firstServiceItemStr;
//            }
//            else if (indexPath.row == 2)
//            {
//                cell.titleLabelName.text = @"Service Item";
//                serviceItemString = @"";
//                if (serviceTask.firstServiceItem)
//                {
//                    serviceItemString = serviceTask.firstServiceItem;
//                }
//                if (serviceTask.serviceItem) {
//                    serviceItemString = [NSString stringWithFormat:@"%@ - %@",serviceItemString,serviceTask.serviceItem];
//                }
//                cell.descriptionLabelText.text = serviceItemString;
//            }
//            
//            else if (indexPath.row == 3)
//            {
//                cell.expandArrowButton.hidden = NO;
//                [cell.expandArrowButton addTarget:self action:@selector(serviceNoteCollapseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//
//                cell.titleLabelName.text = @"Service Note";
//                cell.descriptionLabelText.text = serviceTask.serviceNote;
//            
//                if (self.serviceNoteExpandButtonClicked == NO)
//                {
//                    [cell.expandArrowButton setImage:[UIImage imageNamed:@"ExpandArrow"] forState:UIControlStateNormal];
//                    cell.descriptionLabelText.frame = CGRectMake(13, 36, 660, 21);
//                    cell.descriptionLabelText.numberOfLines = 1;
//                    cell.descriptionLabelText.lineBreakMode = NSLineBreakByTruncatingTail;
//                    [cell.descriptionLabelText setNeedsDisplay];
//                }
//            
//                else if (self.serviceNoteExpandButtonClicked == YES)
//                {
//                    [cell.expandArrowButton setImage:[UIImage imageNamed:@"CollapseArrow"] forState:UIControlStateNormal];
//                    cell.descriptionLabelText.frame = CGRectMake(13, 36, 634, ((self.serviceTask.serviceNote.length / 110)+1)*21);
////                    cell.descriptionLabelText.lineBreakMode = NSLineBreakByWordWrapping;
//                    cell.descriptionLabelText.numberOfLines = 0;
//                    cell.descriptionLabelText.text = serviceTask.serviceNote;
////                        [cell.descriptionLabelText sizeToFit];
//                [cell.descriptionLabelText setNeedsDisplay];
//                }
//            }
//            
//            tableCell = cell;
//            return  cell;
//        }
//    }
//  }
//  else
 // else if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
//     GSPAppDelegate *appDelegateObj = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];
//    //    if(appDelegateObj.notificationLaunched){
//    
//    _errorLabel.hidden=NO;
//    _errorLabel.text=@"JHgd";
//    
//    _warningImageView.hidden=NO;
//    //    _errorBackgroundLabel.hidden = NO;
//    
//    //        appDelegateObj.notificationLaunched=NO;
//    
//    NSString *notifReferenceID = appDelegateObj.notifObjectID;
//    
//    NSLog(@"the reference id for notif %@",notifReferenceID);
//    
//    NSMutableArray * arrayOfTasksFromKeyChain = [GSPKeychainStoreManager getErrorItemsFromKeyChain];
//    NSLog(@"The fetched items from keychain %@",arrayOfTasksFromKeyChain);
//    
//    
//    if(arrayOfTasksFromKeyChain.count >0){
//        
//        for( NSDictionary *dic in arrayOfTasksFromKeyChain){
//            if([[dic valueForKey:@"referenceID"]isEqualToString:self.serviceTask.serviceOrder]){
//                _errorLabel.text= [dic valueForKey:@"errDescription"];
//            }
//            else{
//                _errorLabel.hidden =YES;
//                //                    _errorBackgroundLabel.hidden = YES;
//                _warningImageView.hidden =YES;
//                
//            }
//            
//            
//        }
//        
//        
//        
//        
//    }
//    
    
//    if(!_errorLabel.hidden){
//        self.detailTableView1_Landscape.frame= CGRectMake(8, 120, _detailTableView1_Landscape.frame.size.width, _detailTableView1_Landscape.frame.size.height);
//        self.detailTableView2_Landscape.frame= CGRectMake(379, 120, _detailTableView2_Landscape.frame.size.width, _detailTableView2_Landscape.frame.size.height);
//    }
//    else{
//        self.detailTableView1_Landscape.frame= CGRectMake(8, 100, _detailTableView1_Landscape.frame.size.width, _detailTableView1_Landscape.frame.size.height);
//        self.detailTableView2_Landscape.frame= CGRectMake(379, 100, _detailTableView2_Landscape.frame.size.width, _detailTableView2_Landscape.frame.size.height);
//        
//    }
//
  
      if (tableView == self.detailTableView1_Landscape) {
          if (indexPath.row == 0)
          {
              GSPOverviewTableViewCell *cell = (GSPOverviewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
              
              if (cell == nil)
              {
                  NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:cellIdentifier2 owner:self options:nil];
                  
                  if (IS_IPAD)
                  {
                      cell            = (GSPOverviewTableViewCell *)[nib objectAtIndex:0];
                  }
              }
              
              cell.backgroundView     = nil;
              cell.backgroundColor    = [UIColor clearColor];
              
              cell.priorityImageView.hidden = YES;
              cell.priorityLabelText.hidden = YES;
              cell.mapButton.hidden         = YES;
              cell.statusLabel2.hidden      = YES;
              
              cell.orgNameLabel.text          = serviceTask.serviceLocation;
              cell.serviceLocationLabel1.text = serviceTask.locationAddress1;
              cell.serviceLocationLabel2.text = serviceTask.locationAddress2;
              cell.serviceLocationLabel3.text = serviceTask.locationAddress3;
              
              tableCell = cell;
              return cell;
          }
          else if (indexPath.row > 0 && indexPath.row<= 6)
          {
              GSPDatailTableViewCellWithOneLabel *cell = (GSPDatailTableViewCellWithOneLabel *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier7];
              
              if (cell == nil)
              {
                  NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:cellIdentifier7 owner:self options:nil];
                  
                  if (IS_IPAD)
                  {
                      cell            = (GSPDatailTableViewCellWithOneLabel *)[nib objectAtIndex:0];
                  }
              }
              
              cell.backgroundView     = nil;
              cell.backgroundColor    = [UIColor clearColor];
              
/*             cell.contactNum1Label.hidden = YES;
               cell.contactNum1.userInteractionEnabled = NO;
               cell.contactNum1.tag = indexPath.row;
               
               cell.contactNum2Label.hidden = YES;
               cell.contactNum2.userInteractionEnabled = NO;
               cell.contactNum2.tag = indexPath.row + 1;
*/

              cell.expandArrowButton.hidden = YES;
              
              if (indexPath.row == 1){
                  //                cell.titleText.text             = @"Service Document";
                  cell.titleLabelName.text             = @"Service Document";
                  
                  if (IS_IPAD)
                  {
                      //                    cell.descriptionLabel.text       = [NSString stringWithFormat:@"%@",serviceTask.serviceOrder];;
                      //                    if (serviceTask.firstServiceItem.length != 0) {
                      //                        cell.descriptionLabel.text   = [NSString stringWithFormat:@"%@/%@",cell.descriptionLabel.text,serviceTask.firstServiceItem];
                      //                    }
                      
                      cell.descriptionLabelText.text       = [NSString stringWithFormat:@"%@",serviceTask.serviceOrder];;
                      if (serviceTask.firstServiceItem.length != 0) {
                          cell.descriptionLabelText.text   = [NSString stringWithFormat:@"%@/%@",cell.descriptionLabelText.text,serviceTask.firstServiceItem];
                      }
                  }
              }
              else if (indexPath.row == 2){
                  //                cell.titleText.text          = @"Service Order Type";
                  //                cell.descriptionLabel.text   = serviceTask.serviceOrderType;
                  cell.titleLabelName.text          = @"Service Order Type";
                  cell.descriptionLabelText.text   = serviceTask.serviceOrderType;
              }
              else if (indexPath.row == 3){
                  //                cell.titleText.text          = @"Service Description";
                  //                cell.descriptionLabel.text   = serviceTask.serviceOrderDescription;
                  cell.titleLabelName.text          = @"Service Description";
                  cell.descriptionLabelText.text   = serviceTask.serviceOrderDescription;
              }
              else if (indexPath.row == 4){
                  //                cell.titleText.text          = @"Priority";
                  //                cell.descriptionLabel.text   = serviceTask.priority;
                  cell.titleLabelName.text          = @"Priority";
                  cell.descriptionLabelText.text   = serviceTask.priority;
              }
              else if (indexPath.row == 5)
              {
                  cell.titleLabelName.text = @"Other Details";
                  cell.descriptionLabelText.text = [NSString stringWithFormat:@"Customer#  %@",serviceTask.partner];
              }
              else if (indexPath.row == 6)
              {
                  cell.titleLabelName.text = @"First Service Item";
                  if (![self isEmptyValue:serviceTask.firstServiceProduct] && ![self isEmptyValue:serviceTask.firstServiceProductDescription]) {
                      firstServiceItemStr = [NSString stringWithFormat:@"%@ %@",serviceTask.firstServiceProduct,serviceTask.firstServiceProductDescription];
                  }
                  if (![self isEmptyValue:serviceTask.firstServiceItem])
                  {
                      firstServiceItemStr = [NSString stringWithFormat:@"%@ - %@",serviceTask.firstServiceItem,firstServiceItemStr];
                  }
                // cell.descriptionLabelText.lineBreakMode = NSLineBreakByWordWrapping;
                  cell.descriptionLabelText.numberOfLines = 0;
                   // [cell.descriptionLabelText sizeToFit];
                  cell.descriptionLabelText.text = firstServiceItemStr;
                
              }
              tableCell = cell;
              return cell;
          }
          
      }
      else if (tableView == self.detailTableView2_Landscape) {
          
        if (indexPath.row >= 0 && indexPath.row<= 6)
        {
          
          GSPDetailTableCell *cell = (GSPDetailTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier4];
          
          if (cell == nil)
          {
              //            NSArray *nib    = [[NSBundle mainBu                                                                                   ndle] loadNibNamed:cellIdentifier4 owner:self options:nil];
              NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:cellIdentifier4 owner:self options:nil];
              
              if (IS_IPAD)
              {
                  cell            = (GSPDetailTableCell *)[nib objectAtIndex:1];
              }
          }
          
          cell.backgroundView     = nil;
          cell.backgroundColor    = [UIColor clearColor];
          
          cell.pickerButton.hidden = YES;
          cell.pickerButton.userInteractionEnabled = NO;
          cell.pickerArrow.hidden = YES;
          
          cell.telNumLabel.hidden = YES;
          cell.telNumIcon.hidden   = YES;
          cell.telNumButton.userInteractionEnabled = NO;
          cell.telNumButton.tag = indexPath.row;
          [cell.telNumButton addTarget:self action:@selector(callButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//          cell.telNumIcon.tag = indexPath.row;
//          [cell.telNumIcon addTarget:self action:@selector(callButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
          
          cell.altTelNumLabel.hidden = YES;
          cell.altTelNumIcon.hidden  = YES;
          cell.altTelNumButton.userInteractionEnabled = NO;
          cell.altTelNumButton.tag = indexPath.row + 1;
          [cell.altTelNumButton addTarget:self action:@selector(callButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//          cell.altTelNumIcon.tag = indexPath.row + 1;
//          [cell.altTelNumIcon addTarget:self action:@selector(callButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
          
//          cell.noteTextView.layer.cornerRadius   = 3.0;
//          cell.noteTextView.layer.borderColor    = [[UIColor lightGrayColor]CGColor];
//          cell.noteTextView.layer.borderWidth    = 1.0f;
          cell.noteTextView.delegate             = self;
          cell.noteTextView.tag                  = indexPath.row;
          cell.noteTextView.hidden               = YES;
          
          cell.notesLabel.hidden = YES;
          cell.editPencilImage.hidden = YES;
          
          if (indexPath.row == 0)
          {
              cell.titleTextLabel.text         = @"Contact";
              cell.descriptionTextLabel.text  = serviceTask.contactName;
              if (serviceTask.telNum.length > 0) {
                  cell.telNumLabel.hidden = NO;
                  cell.telNumIcon.hidden  = NO;
                  cell.telNumLabel.text       = serviceTask.telNum;
                  cell.telNumButton.userInteractionEnabled = YES;
//                  cell.telNumIcon.userInteractionEnabled   = YES;
              }
              if (serviceTask.altTelNum.length >0) {
                  cell.altTelNumLabel.hidden = NO;
                  cell.altTelNumIcon.hidden  = NO;
                  cell.altTelNumLabel.text       = serviceTask.altTelNum;
                  cell.altTelNumButton.userInteractionEnabled = YES;
//                  cell.altTelNumIcon.userInteractionEnabled   = YES;
              }
          }
          else if (indexPath.row == 1)
          {
              cell.titleTextLabel.text         = @"Status";
              cell.pickerButton.hidden  = NO;
              cell.pickerArrow.hidden   = NO;
              cell.pickerButton.userInteractionEnabled = YES;
              cell.pickerButton.tag     = indexPath.row;
              [cell.pickerButton addTarget:self action:@selector(dropBoxSelectorClicked:) forControlEvents:UIControlEventTouchUpInside];
              
              if (![serviceTask.statusText isEqualToString:@""]) {
                  [cell.pickerButton setTitle:serviceTask.statusText forState:UIControlStateNormal];
              }
              else {
                  [cell.pickerButton setTitle:[contextDataClass getStatusTextForStatusCode:serviceTask.status] forState:UIControlStateNormal];
              }
          }
          else if (indexPath.row == 2)
          {
              cell.titleTextLabel.text    = @"Reason";
              cell.pickerButton.hidden    = NO;
              cell.pickerArrow.hidden     = NO;
              cell.pickerButton.tag     = indexPath.row;
              [cell.pickerButton addTarget:self action:@selector(dropBoxSelectorClicked:) forControlEvents:UIControlEventTouchUpInside];
              
              if ([serviceTask.serviceOrderRejectionReason isEqualToString:@""] || [serviceTask.serviceOrderRejectionReason isEqual:[NSNull null]] || serviceTask.serviceOrderRejectionReason == nil)
              {
                  self.serviceTask.serviceOrderRejectionReason = @"Other";
                  [cell.pickerButton setTitle:@"Other" forState:UIControlStateNormal];
              }
              else
              {
                  [cell.pickerButton setTitle:serviceTask.serviceOrderRejectionReason forState:UIControlStateNormal];
              }
              
              cell.pickerButton.tag     = indexPath.row;
          }
          else if (indexPath.row == 3)
          {
              cell.titleTextLabel.text            = @"Enter Reason";
              cell.noteTextView.hidden            = NO;
              cell.noteTextView.userInteractionEnabled = NO;
              
              if ([self.serviceTask.serviceOrderRejectionReason isEqualToString:@"Other"]||
                  [self.serviceTask.serviceOrderRejectionReason isEqualToString:@""] ||
                  [self.serviceTask.serviceOrderRejectionReason isEqual:[NSNull null] ] ||
                  self.serviceTask.serviceOrderRejectionReason == nil)
              {
                  cell.noteTextView.userInteractionEnabled = YES;
              }
          }
          else if (indexPath.row == 4)
          {
              cell.titleTextLabel.text  = @"Start Time";
              cell.pickerButton.hidden  = NO;
              cell.pickerArrow.hidden   = NO;
              //            cell.pickerButton.userInteractionEnabled = YES;
              [cell.pickerButton setTitle:[[GSPDateUtility sharedInstance] convertHHMMSStoHHMM:serviceTask.startDateAndTime] forState:UIControlStateNormal];
              
//              [cell.pickerButton setTitle:serviceTask.startDateAndTime forState:UIControlStateNormal];
              NSLog(@"start date %@",serviceTask.startDateAndTime);
              NSLog(@"The start date %@",cell.pickerButton.titleLabel.text);
              //            [cell.pickerButton addTarget:self action:@selector(dropBoxSelectorClicked:) forControlEvents:UIControlEventTouchUpInside];
          }
          else if (indexPath.row == 5)
          {
              cell.titleTextLabel.text  = @"Estimated Arrival";
              cell.pickerButton.hidden  = NO;
              cell.pickerArrow.hidden   = NO;
              
              [cell.pickerButton setTitle:[[GSPDateUtility sharedInstance]convertHHMMSStoHHMM:[NSString stringWithFormat:@"%@ %@",serviceTask.estimatedArrivalDate,serviceTask.estimatedArrivalTime]] forState:UIControlStateNormal];
              //            [cell.pickerButton setUserInteractionEnabled:YES];
              //            [cell.pickerButton addTarget:self action:@selector(dropBoxSelectorClicked:) forControlEvents:UIControlEventTouchUpInside];
          }
          else if (indexPath.row == 6)
          {
              cell.titleTextLabel.text       = @"Field Note";
              cell.noteTextView.hidden       = NO;
              cell.noteTextView.text         = serviceTask.fieldNote;
              cell.noteTextView.userInteractionEnabled = YES;
              //            cell.notesLabel.hidden = NO;
              cell.editPencilImage.hidden = NO;
              
              self.notesTextView = cell.noteTextView;
          }
        tableCell = cell;
        return cell;
      }
      else if (indexPath.row == 7)
      {
              GSPDatailTableViewCellWithOneLabel *cell = (GSPDatailTableViewCellWithOneLabel *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier7];
              
              if (cell == nil)
              {
                  NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:cellIdentifier7 owner:self options:nil];
                  
                  if (IS_IPAD)
                  {
                      cell            = (GSPDatailTableViewCellWithOneLabel *)[nib objectAtIndex:0];
                  }
              }
              
              cell.backgroundView     = nil;
              cell.backgroundColor    = [UIColor clearColor];
              cell.expandArrowButton.hidden             = YES;
              cell.expandArrowButtonForLandscape.hidden = NO;
              [cell.expandArrowButtonForLandscape addTarget:self action:@selector(serviceNoteCollapseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
              
              cell.titleLabelName.text = @"Service Note";
              cell.descriptionLabelText.text = serviceTask.serviceNote;
              cell.descriptionLabelText.textColor = [UIColor blackColor];
          
//          cell.descriptionLabelText.layer.cornerRadius   = 3.0;
//          cell.descriptionLabelText.layer.borderColor    = [[UIColor lightGrayColor]CGColor];
//          cell.descriptionLabelText.layer.borderWidth    = 1.0f;
          
              if (self.serviceNoteExpandButtonClicked == NO)
              {
                  [cell.expandArrowButtonForLandscape setImage:[UIImage imageNamed:@"ExpandArrow"] forState:UIControlStateNormal];
                  cell.descriptionLabelText.frame = CGRectMake(13, 30, 660, 21);
                  cell.descriptionLabelText.numberOfLines = 1;
                  cell.descriptionLabelText.lineBreakMode = NSLineBreakByTruncatingTail;
                  [cell.descriptionLabelText setNeedsDisplay];
              }
              
              else if (self.serviceNoteExpandButtonClicked == YES)
              {
                  [cell.expandArrowButtonForLandscape setImage:[UIImage imageNamed:@"CollapseArrow"] forState:UIControlStateNormal];
//                  cell.descriptionLabelText.frame = CGRectMake(13, 36, 580, 100);
                  UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
                  
                  if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
                  
                  cell.descriptionLabelText.frame = CGRectMake(13, 30, 660, 20+((self.serviceTask.serviceNote.length / 110)+1)*21);
                  else if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
                       cell.descriptionLabelText.frame = CGRectMake(13, 30, 660, 40+((self.serviceTask.serviceNote.length / 110)+1)*21);
//                  cell.descriptionLabelText.frame = CGRectMake(13, 36, 580,300);
//                  cell.descriptionLabelText.lineBreakMode = NSLineBreakByWordWrapping;
                  cell.descriptionLabelText.numberOfLines = 0;
                  cell.descriptionLabelText.text = serviceTask.serviceNote;
//                  [cell.descriptionLabelText sizeToFit];
                  [cell.descriptionLabelText setNeedsDisplay];
                  NSLog(@"text is %@",cell.descriptionLabelText.text);
              }
              tableCell = cell;
              return cell;
        }
      else if (indexPath.row == 8 || (indexPath.row == 9 && !self.serverAttachmentButtonClicked) || (self.serverAttachmentButtonClicked && indexPath.row == (9+self.serverAttachmentsArray.count)))
          {
              GSPDetailTableViewCell *cell = (GSPDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier6];
              
              if (cell == nil)
              {
                  NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:cellIdentifier6 owner:self options:nil];
                  
                  if (IS_IPAD)
                  {
                      cell            = (GSPDetailTableViewCell *)[nib objectAtIndex:0];
                  }
              }
              
              cell.backgroundView     = nil;
              cell.backgroundColor    = [UIColor clearColor];
              
              if (indexPath.row == 8){
                  if (self.serverAttachmentButtonClicked)
                      [cell.showContentsButtonForLandscape setImage:[UIImage imageNamed:@"CollapseArrow"] forState:UIControlStateNormal];
                  else
                      [cell.showContentsButtonForLandscape setImage:[UIImage imageNamed:@"ExpandArrow"] forState:UIControlStateNormal];
                  
                  cell.TitleLabelText.text = @"Attachments";
                  cell.showContentsButtonForLandscape.tag = indexPath.row;
                  [cell.showContentsButtonForLandscape addTarget:self action:@selector(showContentsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
              }
              else if ((indexPath.row == 9 && !self.serverAttachmentButtonClicked) || (self.serverAttachmentButtonClicked && indexPath.row == (9+self.serverAttachmentsArray.count))){
                  if(indexPath.row==9||(indexPath.row==(9+self.serverAttachmentsArray.count))){
                  if (self.additionalPartnersButtonClicked)
                      [cell.showContentsButtonForLandscape setImage:[UIImage imageNamed:@"CollapseArrow"] forState:UIControlStateNormal];
                  else
                      [cell.showContentsButtonForLandscape setImage:[UIImage imageNamed:@"ExpandArrow"] forState:UIControlStateNormal];
                  
                  //            else if (indexPath.row == (9+self.serverAttachmentsArray.count))
                  cell.TitleLabelText.text = @"Additional Partners";
                  //                cell.showContentsButtonForLandscape.tag = indexPath.row;
                      cell.showContentsButtonForLandscape.tag = indexPath.row-self.serverAttachmentsArray.count;
                  [cell.showContentsButtonForLandscape addTarget:self action:@selector(showContentsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
              }
              }
              tableCell = cell;
              return cell;
          }
          
      else if (indexPath.row > 8 && indexPath.row <= (8+self.serverAttachmentsArray.count) && self.serverAttachmentButtonClicked)
          {
              static NSString * cellIdentifier = @"CellIdentifier";
              
              int nodeCount = [self.serverAttachmentsArray count];
              
              UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
              
              if (cell == nil) {
                  
                  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
              }
              cell.backgroundColor = [UIColor clearColor];
              
              //            if(IS_IPHONE) {
              //                cell.textLabel.font = [UIFont boldSystemFontOfSize:12.0];
              //            }
              
              //            if (nodeCount == 0 && indexPath.row == 0)
              if (nodeCount == 0 && indexPath.row == 9)
              {
                  cell.textLabel.text = @"Loading…";
              }
              else
              {
                  //                ServerAttachment *attachment    = [self.serverAttachmentsArray objectAtIndex:indexPath.row];
                  ServerAttachment *attachment    = [self.serverAttachmentsArray objectAtIndex:indexPath.row-9];
                  cell.textLabel.text             = attachment.attachmentID;
                  if (attachment.orderTaskNumExtension.length > 0) {
                      cell.detailTextLabel.text       = [NSString stringWithFormat:@"%@ / %@",attachment.orderId,attachment.orderTaskNumExtension];
                  }
                  [serverAttachmentsObject configurePlaceHolderImageInView:cell.imageView withAttachmentId:attachment.attachmentID];
              }
              tableCell = cell;
              return cell;
          }
          
          if ((self.additionalPartnersButtonClicked && !self.serverAttachmentButtonClicked && indexPath.row > 9 && indexPath.row <=(10+self.additionalPartnersArray.count)) || (self.additionalPartnersButtonClicked && self.serverAttachmentButtonClicked && indexPath.row > (8+self.serverAttachmentsArray.count) && indexPath.row <=(10+self.serverAttachmentsArray.count+self.additionalPartnersArray.count)))
              //        if ((indexPath.row >= 9+self.serverAttachmentsArray.count) && indexPath.row <= (10+self.serverAttachmentsArray.count+self.additionalPartnersArray.count) && self.additionalPartnersButtonClicked)
          {
              static NSString * cellIdentifier = @"GSPPartnerViewCell";
              
              GSPPartnerViewCell *cell = (GSPPartnerViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
              
              if (cell == nil)
              {
                  NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
                  
                  if (IS_IPAD)
                  {
                      cell            = (GSPPartnerViewCell *)[nib objectAtIndex:0];
                  }
                  else
                  {
                      cell            = (GSPPartnerViewCell *)[nib objectAtIndex:1];
                  }
                  
              }
              
              cell.backgroundView     = nil;
              cell.backgroundColor    = [UIColor clearColor];
              
              cell.callButton1.hidden = YES;
              cell.callButton2.hidden = YES;
              cell.callButton2ForLandscape.hidden = YES;
              cell.partnerTelNumIcon.hidden = YES;
              cell.partnerAltTelNumIcon.hidden = YES;
              cell.partnerAltTelNumIconForLandscape.hidden = YES;
              
              if (indexPath.row == (10+self.serverAttachmentsArray.count))
              {
                  cell.partnerNameLabel.text = @"Partner Name";
                  cell.partnerNameLabel.textColor = [UIColor colorWithRed:39.0/255 green:119.0/255 blue:255.0/255 alpha:1.0];
                  cell.partnerTypeLabel.text = @"Partner Type";
                  cell.partnerTypeLabel.textColor = [UIColor colorWithRed:39.0/255 green:119.0/255 blue:255.0/255 alpha:1.0];
                  cell.telNum1_label.text = @"Telephone Num";
                  cell.telNum1_label.textColor = [UIColor colorWithRed:39.0/255 green:119.0/255 blue:255.0/255 alpha:1.0];
              }
              else
              {
                  
                  //                [self setLabelColorsIntableViewCell:cell];
                  
                  //                cell.callButton1.hidden              = YES;
                  //                cell.callButton1.tag                 = indexPath.row;
                  cell.callButton1.tag                 = indexPath.row-11-self.serverAttachmentsArray.count;
                  [cell.callButton1 addTarget:self action:@selector(partnersCallButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                  //                cell.callButton2.hidden              = YES;
                  //                cell.callButton2.tag                 = indexPath.row + 2000;
/*                  cell.callButton2.tag                 = indexPath.row-11-self.serverAttachmentsArray.count + 2000;
                  [cell.callButton2 addTarget:self action:@selector(partnersCallButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
*/
                  cell.callButton2ForLandscape.tag                 = indexPath.row-11-self.serverAttachmentsArray.count + 2000;
                  [cell.callButton2ForLandscape addTarget:self action:@selector(partnersCallButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                  
                  Partners * partners ;
                  
                  //                partners = [self.partnerArray objectAtIndex:indexPath.row];
                  partners = [self.additionalPartnersArray objectAtIndex:(indexPath.row-11-self.serverAttachmentsArray.count)];
                  
                  NSString *secondName = @"";
                  //                if (![self checkforNullValues:partners.nameTwo])
                  if (![self isNullValue:partners.nameTwo])
                  {
                      secondName = partners.nameTwo;
                  }
                  
                  //                if (indexPath.row == (10+self.serverAttachmentsArray.count))
                  //                {
                  //                    cell.partnerNameLabel.text = @"Partner Type";
                  //                    cell.partnerNameLabel.textColor = [UIColor colorWithRed:39.0/255 green:119.0/255 blue:255.0/255 alpha:1.0];
                  //                    cell.partnerTypeLabel.text = @"Partner Name";
                  //                    cell.partnerTypeLabel.textColor = [UIColor colorWithRed:39.0/255 green:119.0/255 blue:255.0/255 alpha:1.0];
                  //                    cell.telNum1_label.text = @"Telephone Num";
                  //                    cell.telNum1_label.textColor = [UIColor colorWithRed:39.0/255 green:119.0/255 blue:255.0/255 alpha:1.0];
                  //                }
                  
                  cell.partnerTypeLabel.text      = [NSString stringWithFormat:@"%@",partners.parvw];
                  cell.partnerNameLabel.text      = [NSString stringWithFormat:@"%@ %@ (%@)",partners.nameOne,secondName,partners.partnerNum];
                  
                  //                if (![self checkforNullValues:partners.telNum1])
                  if (![self isNullValue:partners.telNum1])
                  {
                      cell.telNum1_label.text     = [NSString stringWithFormat:@"%@",partners.telNum1];
                      cell.callButton1.hidden     = NO;
                      cell.partnerTelNumIcon.hidden = NO;
                  }
                  //                if (![self checkforNullValues:partners.telNum2])
                  if (![self isNullValue:partners.telNum2])
                  {
//                      cell.telNum2_label.text     = [NSString stringWithFormat:@"%@",partners.telNum2];
//                      cell.callButton2.hidden     = NO;
                      cell.altTelLabelForLandscape.text     = [NSString stringWithFormat:@"%@",partners.telNum2];
                      cell.callButton2ForLandscape.hidden     = NO;
                      cell.partnerAltTelNumIconForLandscape.hidden = NO;
                  }
              }
              tableCell = cell;
              return cell;
          }
      }
  //}
    return tableCell;
}

- (void) serviceNoteCollapseButtonClicked
{
    if (self.serviceNoteExpandButtonClicked)
        self.serviceNoteExpandButtonClicked = NO;
    else
        self.serviceNoteExpandButtonClicked = YES;
    
//    if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
//        [self.detailTableView3 reloadData];
//    else if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
        [self.detailTableView2_Landscape reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.row == StartDateRow || indexPath.row == EstimatedArrivalDateRow)
    if ((tableView == self.detailTableView2 && (indexPath.row == 4 || indexPath.row == 5)) || (tableView == self.detailTableView2_Landscape && (indexPath.row == 4 || indexPath.row == 5)))
    {
//        if (indexPath.row == 4 || indexPath.row == 5)
//        {
//            UITableViewCell * clickedCell = [self.detailTableView cellForRowAtIndexPath:indexPath];
            
            UITableViewCell * clickedCell;
            
//            UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
            
//            if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
//                clickedCell = [self.detailTableView2 cellForRowAtIndexPath:indexPath];
//            else if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
                clickedCell = [self.detailTableView2_Landscape cellForRowAtIndexPath:indexPath];
            [self showPickerViewInCell:clickedCell WithTag:(int)indexPath.row];

/*            CGRect cellRect = [self.detailTableView2 rectForRowAtIndexPath:indexPath];
            [self showPickerViewInCell:cellRect.origin.x WithTag:(int)indexPath.row];
*/
//        }
    }
//    else if (tableView == self.detailTableView3 || tableView == self.detailTableView2_Landscape)
//    {
        if ((tableView == self.detailTableView3 && indexPath.row > 4 && indexPath.row <= (4+self.serverAttachmentsArray.count) && self.serverAttachmentButtonClicked) || (tableView == self.detailTableView2_Landscape && indexPath.row > 8 && indexPath.row <= (8+self.serverAttachmentsArray.count) && self.serverAttachmentButtonClicked))
        {
            [self loadImageFromSAP:indexPath serverAttachmentArray:self.serverAttachmentsArray];
        }
//    }
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
    [signatureView removeFromSuperview];
    [self setUpSignatureViewAndViewServerAttachmentsButton:toInterfaceOrientation];
    [self setUpPreviousAndNextTaskButtons];

}

-(void) setUpSignatureViewAndViewServerAttachmentsButton:(UIInterfaceOrientation)orientation
{
    [self imageCheckingInDocFolder];
    
    if(!isSignatureCaputured)
    {
        self.signPreviewImage.hidden = YES;
        //
        ////        if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
        ////        {
        //            self.signHereLabel.hidden = YES;
        //            self.signUpImage.hidden = YES;
        //            self.tapToSignButton.userInteractionEnabled = NO;
        //            self.signatureBottomLineImage.hidden = YES;
        //            NSArray *subviewArray   = [[NSBundle mainBundle] loadNibNamed:@"GSPSignatureCaptureView" owner:self options:nil];
        //            signatureView           = [subviewArray objectAtIndex:0];
        //            signatureView.frame     = CGRectMake(437.0, 785.0, signatureView.frame.size.width, signatureView.frame.size.height);
        //            [self.view addSubview:signatureView];
        //            [self.view bringSubviewToFront:signatureView];
        //       // }
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if(UIInterfaceOrientationIsLandscape(orientation))
        {
            NSArray *subviewArray   = [[NSBundle mainBundle] loadNibNamed:@"GSPSignatureCaptureView" owner:self options:nil];
            signatureView           = [subviewArray objectAtIndex:0];
            signatureView.frame     = CGRectMake(33.0, 770.0, signatureView.frame.size.width, signatureView.frame.size.height);
            signatureView.userInteractionEnabled    =YES;
            [self.view addSubview:signatureView];
            [self.view bringSubviewToFront:signatureView];
        }
        
        else if(UIInterfaceOrientationIsPortrait(orientation))
        {
            NSArray *subviewArray   = [[NSBundle mainBundle] loadNibNamed:@"GSPSignatureCaptureView" owner:self options:nil];
            signatureView           = [subviewArray objectAtIndex:0];
            signatureView.frame     = CGRectMake(33.0, 350.0, signatureView.frame.size.width-40, signatureView.frame.size.height);
             signatureView.userInteractionEnabled    =YES;
            [self.view addSubview:signatureView];
            [self.view bringSubviewToFront:signatureView];
            //  }
        }
        
    }
    
    else if(isSignatureCaputured)
    {
        self.signHereLabel.hidden = YES;
        self.signUpImage.hidden = YES;
        self.tapToSignButton.userInteractionEnabled = NO;
        self.signatureBottomLineImage.hidden = YES;
        self.signPreviewImage.hidden = NO;
        [self.signPreviewImage setImage:signatureImage];
    }
    
    //    if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
    //    {
    //        if (attachmentImage){
    //            self.viewImageButton.hidden = NO;
    //            self.viewImageLabel.hidden = NO;
    //        }
    //        else
    //        {
    //            self.viewImageLabel.hidden = YES;
    //            self.viewImageButton.hidden = YES;
    //        }
    //    }
}

- (void)showPickerViewInCell:(UITableViewCell*)cell WithTag:(int)tag
{
    pickerController = [GSPPickerController new];
    pickerController.pickerDelegate = self;
//    [pickerController showDatePickerInView:self.detailTableView fromRectOfView:cell WithPickerTag:tag];
    
//    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
//    
//    if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
//        [pickerController showDatePickerInView:self.detailTableView2 fromRectOfView:cell WithPickerTag:tag];
//    else if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
        [pickerController showDatePickerInView:self.detailTableView2_Landscape fromRectOfView:cell WithPickerTag:tag];
}

- (void) callButtonClicked:(id)sender
{
    UIButton * callbutton = (UIButton*) sender;
    
    switch (callbutton.tag) {
//        case TelNumberRow:
            case 0:
            contactNumber = self.serviceTask.telNum;
            break;
//        case TelNumberRow+1:
            case 1:
            contactNumber = self.serviceTask.altTelNum;
            break;
            
        default:
            break;
    }
    
    UIActionSheet* callActionSheet = [[UIActionSheet alloc]
                                      initWithTitle:NSLocalizedString(@"CHOOSE_ACTION", nil)
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"CANCEL", nil)
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"Facetime",@"Phone call",nil];
    callActionSheet.tag = 4;
    [callActionSheet showInView:self.view];
}

- (void) callActionSheetActionWithIndex:(NSInteger)buttonIndex
{
    NSString *cleanedString = [[contactNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL    *facetimeURL = [NSURL URLWithString:[NSString stringWithFormat:@"facetime://%@", escapedPhoneNumber]];
    
    NSURL    *phoneNumbURL = [NSURL URLWithString:[@"telprompt://" stringByAppendingString:escapedPhoneNumber]];
    
    switch (buttonIndex)
    {
        case 0:
            // Facetime is available or not
            if ([[UIApplication sharedApplication] canOpenURL:facetimeURL])
            {
                [[UIApplication sharedApplication] openURL:facetimeURL];
            }
            else
            {
                [[GSPUtility sharedInstance] showAlertWithTitle:@"Ooops!" message:@"Facetime not available." otherButton:nil tag:0 andDelegate:self];
            }
            break;
        case 1:
            if ([[UIApplication sharedApplication] canOpenURL:phoneNumbURL])
            {
                [[UIApplication sharedApplication] openURL:phoneNumbURL];
            }
            else
            {
                [[GSPUtility sharedInstance] showAlertWithTitle:@"Ooops!" message:@"Cannot make a phone call." otherButton:nil tag:0 andDelegate:self];
            }
            break;
        default:
            break;
    }
}

- (void) partnersCallButtonClicked:(id)sender
{
    UIButton * callbutton = (UIButton*) sender;
    
//    Partners *selectedpartner = [self.partnerArray copy];
    Partners *selectedpartner = [self.additionalPartnersArray copy];
    
    if ((callbutton.tag - 2000) >= 0) {
//        selectedpartner = [self.partnerArray objectAtIndex:(callbutton.tag - 2000)];
        selectedpartner = [self.additionalPartnersArray objectAtIndex:(callbutton.tag - 2000)];
        contactNumber = selectedpartner.telNum2;
        
    }
    else {
//        selectedpartner = [self.partnerArray objectAtIndex:callbutton.tag];
        selectedpartner = [self.additionalPartnersArray objectAtIndex:callbutton.tag];
        contactNumber = selectedpartner.telNum1;
    }
    
    UIActionSheet* callActionSheet = [[UIActionSheet alloc]
                                      initWithTitle:NSLocalizedString(@"CHOOSE_ACTION", nil)
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"CANCEL", nil)
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"Facetime",@"Phone call",nil];
    callActionSheet.tag = 5;
    [callActionSheet showInView:self.view];
}

- (void) callPartnerActionSheetActionWithIndex:(NSInteger) buttonIndex
{
    NSString *cleanedString = [[contactNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL    *facetimeURL = [NSURL URLWithString:[NSString stringWithFormat:@"facetime://%@", escapedPhoneNumber]];

    NSURL    *phoneNumbURL = [NSURL URLWithString:[@"telprompt://" stringByAppendingString:escapedPhoneNumber]];
    
    switch (buttonIndex)
    {
        case 0:
            // Facetime is available or not
            if ([[UIApplication sharedApplication] canOpenURL:facetimeURL])
            {
                [[UIApplication sharedApplication] openURL:facetimeURL];
            }
            else
            {
                [[GSPUtility sharedInstance] showAlertWithTitle:@"Ooops!" message:@"Facetime not available." otherButton:nil tag:0 andDelegate:self];
            }
            break;
        case 1:
            if ([[UIApplication sharedApplication] canOpenURL:phoneNumbURL])
            {
                [[UIApplication sharedApplication] openURL:phoneNumbURL];
            }
            else
            {
                [[GSPUtility sharedInstance] showAlertWithTitle:@"Ooops!" message:@"Cannot make a phone call." otherButton:nil tag:0 andDelegate:self];
            }
            break;
        default:
            break;
    }
}

- (void)showMapViewWithDirections
{
    GSPMapViewController * mapViewController;
    
    if (IS_IPAD)
    {
        mapViewController = [[GSPMapViewController alloc]initWithNibName:@"GSPMapViewController_iPad" bundle:nil withAddress:self.serviceTask.locationAddress];
        mapViewController.modalPresentationStyle = 17;
        [mapViewController setModalTransitionStyle: UIModalTransitionStyleFlipHorizontal];
    }
    else
        mapViewController = [[GSPMapViewController alloc]initWithNibName:@"GSPMapViewController" bundle:nil withAddress:self.serviceTask.locationAddress];
    
    [self presentViewController:mapViewController animated:YES completion:nil];
    
}

- (void) dropBoxSelectorClicked:(id)sender
{
    
    UIButton * btn = (UIButton*)sender;
//    CGPoint center= btn.center;
//    CGPoint rootViewPoint = [btn.superview convertPoint:center toView:self.detailTableView];
//    NSIndexPath *indexPath = [self.detailTableView indexPathForRowAtPoint:rootViewPoint];
//    
//    UITableViewCell * clickedCell = [self.detailTableView cellForRowAtIndexPath:indexPath];
    
//    UIButton * btn = (id)sender;
    CGPoint center= btn.center;
    
    CGPoint rootViewPoint;
    NSIndexPath *indexPath;
    UITableViewCell * clickedCell;

//    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
//    if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
//    {
//        rootViewPoint = [btn.superview convertPoint:center toView:self.detailTableView2];
//        indexPath = [self.detailTableView2 indexPathForRowAtPoint:rootViewPoint];
//        clickedCell = [self.detailTableView2 cellForRowAtIndexPath:indexPath];
//    }
//    else if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
//    {
        rootViewPoint = [btn.superview convertPoint:center toView:self.detailTableView2_Landscape];
        indexPath = [self.detailTableView2_Landscape indexPathForRowAtPoint:rootViewPoint];
        clickedCell = [self.detailTableView2_Landscape cellForRowAtIndexPath:indexPath];
 //   }

    NSMutableArray *pickerContentArray;
    
    contextDataClass = [ContextDataClass new];
    
//    if (btn.tag == StatusRow)
    if (btn.tag == 1)
    {
        
//  *****   Original code  *****
//        pickerContentArray = [contextDataClass getStatusListArray];
        
//  *****   Modified by Harshitha   *****
        ServiceTask * serviceTask = self.serviceTask;
        pickerContentArray = [[NSMutableArray alloc]initWithObjects:@"In Process",@"Completed",@"On hold custome delay", nil];
        
//        pickerContentArray = [contextDataClass getStatusListArrayForPicker:taskStatus andProcessType:serviceTask.serviceOrderType];
//        pickerContentArray = [contextDataClass getStatusListArray];
        
    }
//    else if (btn.tag == ReasonRow)
    else if (btn.tag == 2)
    {
        pickerContentArray = [contextDataClass getTaskReasonArray];
    }
/*    else if (btn.tag == TimeZoneRow)
    {
        [self showTimeZoneSelectionView:clickedCell];
        
        return;
    }
*/
    
    
    pickerController = [GSPPickerController new];
    pickerController.pickerDelegate = self;
//    [pickerController showPickerViewInView:self.detailTableView fromRectOfView:clickedCell withPickerArray:pickerContentArray andPickerTag:(int)btn.tag];
    
//    if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
//        [pickerController showPickerViewInView:self.detailTableView2 fromRectOfView:clickedCell withPickerArray:pickerContentArray andPickerTag:(int)btn.tag];
//    else if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
        [pickerController showPickerViewInView:self.detailTableView2_Landscape fromRectOfView:clickedCell withPickerArray:pickerContentArray andPickerTag:(int)btn.tag];
    
//    [pickerController showPickerViewInView:self.detailTableView2 fromRectOfView:btn withPickerArray:pickerContentArray andPickerTag:(int)btn.tag];
    
}

- (void) showTimeZoneSelectionView:(UITableViewCell*)clickedCell
{
    GSPTimeZoneSelector * timeZoneSelector      = [[GSPTimeZoneSelector alloc]initWithStyle:UITableViewStyleGrouped currentTimeZoneOffset:self.serviceTask.timeZoneFrom];
    timeZoneSelector.timeZoneSelectorDelegate   = self;
    
    if (IS_IPAD) {
        popoverController = [[UIPopoverController alloc] initWithContentViewController:timeZoneSelector];
        
        
        popoverController.popoverContentSize    = CGSizeMake(300, 300);
        
        [popoverController presentPopoverFromRect:clickedCell.frame inView:self.detailTableView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    else
        [self.navigationController pushViewController:timeZoneSelector animated:YES];
}

- (void) showContentsButtonClicked:(id)sender
{
    UIButton * btn = (UIButton*)sender;
    
//    if ((UIInterfaceOrientationIsPortrait(interfaceOrientation) && btn.tag == 4) || (UIInterfaceOrientationIsLandscape(interfaceOrientation) && btn.tag == 8))
    if(btn.tag==8)
    {
//        [self attachBtnServerClicked];
        
        if (self.serverAttachmentButtonClicked)
        {
            self.serverAttachmentButtonClicked = NO;
            [self.serverAttachmentsArray removeAllObjects];
        }
        else
        {
            self.serverAttachmentButtonClicked = YES;
        
            [[NSNotificationCenter defaultCenter] removeObserver:self];

            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sapResponseHandlerForServerAttachments:) name:@"DownloadingServerAttachment" object:nil];
            
            ServerAttachment * serverAttachment = [ServerAttachment new];
            self.serverAttachmentsArray = [serverAttachment getServerAttachmnetsForOrder:self.serviceTask.serviceOrder andExtNum:self.serviceTask.firstServiceItem];
        }
//        if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
//            [self.detailTableView3 reloadData];
//        else if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
            [self.detailTableView2_Landscape reloadData];
    }
//    else if ((UIInterfaceOrientationIsPortrait(interfaceOrientation) && btn.tag == 5) || (UIInterfaceOrientationIsLandscape(interfaceOrientation) && btn.tag == 9))
    if(btn.tag==9)
    {
//        [self partnerIconClicked];
        if (self.additionalPartnersButtonClicked)
        {
            self.additionalPartnersButtonClicked = NO;
            [self.additionalPartnersArray removeAllObjects];
        }
        else
        {
            self.additionalPartnersButtonClicked = YES;
            Partners *partners = [Partners new];
            self.additionalPartnersArray = [partners getPartnersDetails:self.serviceTask.serviceOrder andFirstServiceItem:self.serviceTask.firstServiceItem];
        }
//        if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
//            [self.detailTableView3 reloadData];
//        else if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
            [self.detailTableView2_Landscape reloadData];
    }
}


- (void) showContentsButtonsClicked:(int)btnTag
{
    int  tag = btnTag;
    
    //    if ((UIInterfaceOrientationIsPortrait(interfaceOrientation) && btn.tag == 4) || (UIInterfaceOrientationIsLandscape(interfaceOrientation) && btn.tag == 8))
    if(tag==8)
    {
        //        [self attachBtnServerClicked];
        
        if (self.serverAttachmentButtonClicked)
        {
            self.serverAttachmentButtonClicked = NO;
            [self.serverAttachmentsArray removeAllObjects];
        }
        else
        {
            self.serverAttachmentButtonClicked = YES;
            
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sapResponseHandlerForServerAttachments:) name:@"DownloadingServerAttachment" object:nil];
            
            ServerAttachment * serverAttachment = [ServerAttachment new];
            self.serverAttachmentsArray = [serverAttachment getServerAttachmnetsForOrder:self.serviceTask.serviceOrder andExtNum:self.serviceTask.firstServiceItem];
        }
        //        if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
        //            [self.detailTableView3 reloadData];
        //        else if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
        [self.detailTableView2_Landscape reloadData];
    }
    //    else if ((UIInterfaceOrientationIsPortrait(interfaceOrientation) && btn.tag == 5) || (UIInterfaceOrientationIsLandscape(interfaceOrientation) && btn.tag == 9))
    if(tag==9)
    {
        //        [self partnerIconClicked];
        if (self.additionalPartnersButtonClicked)
        {
            self.additionalPartnersButtonClicked = NO;
            [self.additionalPartnersArray removeAllObjects];
        }
        else
        {
            self.additionalPartnersButtonClicked = YES;
            Partners *partners = [Partners new];
            self.additionalPartnersArray = [partners getPartnersDetails:self.serviceTask.serviceOrder andFirstServiceItem:self.serviceTask.firstServiceItem];
        }
        //        if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
        //            [self.detailTableView3 reloadData];
        //        else if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
        [self.detailTableView2_Landscape reloadData];
    }
}


#pragma mark Time Zone selector delegate

- (void) selectedTimeZoneIs:(id)timezone
{
    NSTimeZone *timeZoneSelected = (NSTimeZone*)timezone;
    
    self.serviceTask.timeZoneFrom = [NSString stringWithFormat:@"%@",timeZoneSelected];
    
    [self.detailTableView reloadData];
    
}

// Added by Harshitha
-(NSString *) checkOccuranceOfField:(NSString *)srvc_partner servc_firstItem:(NSString *)firstServiceItem_Str servc_Item:(NSString *)service_Item andServc_Note:(NSString *)service_Note
{
    NSString * pattern = @"";
    if (![self isEmptyValue:srvc_partner])
        pattern = @"1";
    else
        pattern = @"0";
    
    if (![self isEmptyValue:firstServiceItem_Str])
        pattern = [pattern stringByAppendingString:@"1"];
    else
        pattern = [pattern stringByAppendingString:@"0"];
    
    if (![self isEmptyValue:service_Item])
        pattern = [pattern stringByAppendingString:@"1"];
    else
        pattern = [pattern stringByAppendingString:@"0"];
    
    if (![self isEmptyValue:service_Note])
        pattern = [pattern stringByAppendingString:@"1"];
    else
        pattern = [pattern stringByAppendingString:@"0"];
    
    return pattern;
}
// Added by Harshitha ends here

- (void) moreExpandButtonclick
{
/*    if (self.serviceNoteExpandButtonClicked)
        self.serviceNoteExpandButtonClicked = NO;
    else
        self.serviceNoteExpandButtonClicked = YES;
*/
    float originalY = self.serviceNoteDetailView.frame.origin.y;
    float originalH = self.serviceNoteDetailView.bounds.size.height;
    
    self.serviceNoteDetailView.frame = CGRectMake(self.serviceNoteDetailView.frame.origin.x, (originalY + originalH), self.serviceNoteDetailView.bounds.size.width, self.view.bounds.size.height);
    [self.serviceNoteDetailView setHidden:YES];
    self.serviceNoteDetailTextView.layer.cornerRadius = 10.0;
    [[[UIApplication sharedApplication]keyWindow] addSubview:self.serviceNoteDetailView];
    self.serviceNoteDetailTextView.text = self.serviceTask.serviceNote;
    
    [UIView animateWithDuration:0.7f delay:0.0f options:1 animations:^{
        [self.serviceNoteDetailView setHidden:NO];
        self.serviceNoteDetailView.frame = CGRectMake(0, 0, self.serviceNoteDetailView.bounds.size.width, self.view.bounds.size.height);
    }completion:^(BOOL finished) {
        
    }];
}

- (IBAction)closeServiceNoteDetailScreen:(id)sender
{
    
    self.serviceNoteDetailView.frame = CGRectMake(0, 0, self.serviceNoteDetailView.bounds.size.width, self.view.bounds.size.height);
    [self.serviceNoteDetailView setHidden:YES];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    [keyWindow addSubview:self.serviceNoteDetailView];
    
    [UIView animateWithDuration:0.7f delay:0.0f options:4 animations:^{
        [self.serviceNoteDetailView setHidden:NO];
        self.serviceNoteDetailView.frame = CGRectMake(0, self.view.bounds.size.height, self.serviceNoteDetailView.bounds.size.width, self.view.bounds.size.height);
        
    }completion:^(BOOL finished) {
        
        [self.serviceNoteDetailView removeFromSuperview];
    }];
    
    
}

- (IBAction)viewAttachedImageButtonClicked:(id)sender {
    
    [self imageCheckingInDocFolder];
    
    if (attachmentImage)
    {
        NSMutableArray* assets = [NSMutableArray new];
    
        NSMutableArray *imagesArray = [[GSPUtility sharedInstance] getAttachedImagesFromLocalFolder:self.serviceTask.serviceOrder forPathComponent:@"AttchedImages"];
    
    
        for (NSString *imagesFilePath in imagesArray)
        {
            GalleryImage *myGallery     = [GalleryImage new];
            NSString * folderPath       = [[GSPUtility sharedInstance] getMediaLocalPathForFileName:self.serviceTask.serviceOrder forPathComponent:@"AttchedImages"];
            myGallery.image             = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",folderPath,imagesFilePath]];
            myGallery.imageFilePath     = [NSString stringWithFormat:@"%@/%@",folderPath,imagesFilePath];
            [assets addObject:myGallery];
        }
    
    
//        GalleryViewController* galleryViewController = [[GalleryViewController alloc] init];
        GalleryViewController *galleryViewController = [[GalleryViewController alloc]initWithNibName:nil bundle:nil serviceOrder:self.serviceTask.serviceOrder];
        galleryViewController.assets = assets;
    
        [self.navigationController pushViewController:galleryViewController animated:YES];
    }
    else
    {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"No images attached!" message:@"Do you want to attach an image?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"Cancel", nil];
        alertView.tag           = 3;
        [alertView show];
    }
}

- (IBAction)attachImageButtonClicked:(id)sender {
    UIActionSheet* menuActionSheet = [[UIActionSheet alloc]
                                      initWithTitle:NSLocalizedString(@"CHOOSE_ACTION", nil)
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"CANCEL", nil)
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"Camera",@"Photo Gallery",nil];
    menuActionSheet.tag           = IMAGEPICKER_ACION_SHEET_TAG;
    [menuActionSheet showInView:self.view];
}


#pragma mark Custom Picker Delegate methods

- (void) pickerValueChanged : (NSString *)selectedString forPickerWithTag:(int)tag
{
    NSLog(@"Selected Value is : %@",selectedString);
    
//    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];

    switch (tag) {
//        case 4:
            case 1:
            self.serviceTask.statusText = selectedString;
            
//            self.serviceTask.status     = [contextDataClass getStatusCodeForStatusText:selectedString];
            self.serviceTask.status = @"OHCD";
            
            if ([ [contextDataClass getstatusPostSetActionForText:self.serviceTask.statusText ] rangeOfString:@"ASK-FOR-ETA"].location != NSNotFound)
            {

                if (IS_IPHONE)
                {
                    [pickerController.actionSheetPicker dismissWithClickedButtonIndex:0 animated:NO];
                }
                else
                    [pickerController.popover dismissPopoverAnimated:YES];

                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                    UITableViewCell * clickedCell = [self.detailTableView cellForRowAtIndexPath:estArrDateIndexPath];
                    
                    UITableViewCell * clickedCell;
//                    
//                    if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
//                        clickedCell = [self.detailTableView2 cellForRowAtIndexPath:estArrDateIndexPath];
//                    else if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
                        clickedCell = [self.detailTableView2_Landscape cellForRowAtIndexPath:estArrDateIndexPath];
                    
                    [self showPickerViewInCell:clickedCell WithTag:EstimatedArrivalDateRow];
                });
            }

            break;
//        case 5:
            case 2:
            self.serviceTask.serviceOrderRejectionReason = selectedString;
            break;
        default:
            break;
    }
    
//    [self.detailTableView reloadData];
//    if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
//        [self.detailTableView2 reloadData];
//    else if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
        [self.detailTableView2_Landscape reloadData];
}

- (void) datePickerValueChanged:(NSDate*)selectedDate fordatePickerWithTag:(int)tag
{
//    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    NSDateFormatter *df     = [[NSDateFormatter alloc] init];
    df.dateStyle            = NSDateFormatterMediumStyle;
    [df setDateFormat:@"MMM dd,yyyy"];
    NSString *dateString    = [NSString stringWithFormat:@"%@",[df stringFromDate:selectedDate]];
    [df setDateFormat:@"HH:mm:ss"];
    NSString *timeString    = [NSString stringWithFormat:@"%@",[df stringFromDate:selectedDate]];
   //    if (tag == 7)
    if (tag == 4)
    {
        self.serviceTask.startDate = dateString;
        self.serviceTask.startTime = timeString;
        self.serviceTask.startDateAndTime = [NSString stringWithFormat:@"%@ %@",dateString,timeString];
//        self.serviceTask.startDateAndTime=dateString1;
        NSLog(@"startdate and time %@",self.serviceTask.startDateAndTime);
    }
//    else
    else if (tag == 5)
    {
        self.serviceTask.estimatedArrivalDate = dateString;
// Added by Harshitha
        self.serviceTask.estimatedArrivalTime = timeString;
    }
    
//    [self.detailTableView reloadData];
//    if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
//        [self.detailTableView2 reloadData];
//    else if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
        [self.detailTableView2_Landscape reloadData];
}

#pragma mark Bottom Menu Bar Methods

- (void) setUpBottomMenuBar
{
    UIBarButtonItem *imageSItem     = [self createBarButtonWithImageNamed:@"attachment-1.png" tag:0 selector:@selector(attachBtnServerClicked:)];
    UIBarButtonItem *imageItem      = [self createBarButtonWithImageNamed:@"attachment.png" tag:0 selector:@selector(attachBtnClicked:)];
    UIBarButtonItem *signatureItem  = [self createBarButtonWithImageNamed:@"signature.png" tag:0 selector:@selector(attachSignBtnClicked:)];
    UIBarButtonItem *partnerItem    = [self createBarButtonWithImageNamed:@"partnerIcon" tag:0 selector:@selector(partnerIconClicked:)];
    
    UIBarButtonItem *leftItem       = [UIBarButtonItem new];
    UIBarButtonItem *rightItem      = [UIBarButtonItem new];
    
    
    UIBarButtonItem *fixSpaceItem2  = [UIBarButtonItem new];;
    UIBarButtonItem *fixSpaceItem1  = [UIBarButtonItem new];
    
     if (multipleTasksArray.count > 1 && self.currentlyShownTaskIndex + 1 < multipleTasksArray.count)
    {
        fixSpaceItem2  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        rightItem       = [self createBarButtonWithImageNamed:@"right.png" tag:2 selector:@selector(loadNextTask:)];
    }
     if (multipleTasksArray.count > 1 && self.currentlyShownTaskIndex != 0)
     {
         fixSpaceItem1  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
         leftItem       = [self createBarButtonWithImageNamed:@"left.png" tag:1 selector:@selector(loadPreviousTask:)];
     }

    [self imageCheckingInDocFolder];
    
    
    NSArray *barButtonsArray;
    
    float _screenWidth = self.view.frame.size.width;
    
    
    
    if (IS_IPAD)
        fixSpaceItem1.width  = (_screenWidth - 300);
    else
        fixSpaceItem1.width  = (_screenWidth - 250);
    
    
    fixSpaceItem2.width = 5;
    
    BOOL isServerAttachmentImage;
    
//    isServerAttachmentImage = [serviceOrderObject CheckServerAttachments:self.serviceTask.serviceOrder];
    isServerAttachmentImage = [serviceOrderObject CheckServerAttachments:self.serviceTask.serviceOrder andExtNum:self.serviceTask.firstServiceItem];
    
    BOOL additionalPartner;
    additionalPartner = [serviceOrderObject checkAdditionalPartners:self.serviceTask.serviceOrder andFirstServiceItem:self.serviceTask.firstServiceItem];
    
    if (! additionalPartner) {
    
        if (isSignatureCaputured == YES && attachmentImage == nil && ! isServerAttachmentImage )
        {
            barButtonsArray     = [NSArray arrayWithObjects:signatureItem,fixSpaceItem1,leftItem, fixSpaceItem2,rightItem, nil];
        }
        else if (isSignatureCaputured == YES && attachmentImage != nil && ! isServerAttachmentImage)
        {
            barButtonsArray     = [NSArray arrayWithObjects:imageItem, signatureItem, fixSpaceItem1,leftItem, fixSpaceItem2,rightItem, nil];
        }
        else if (isSignatureCaputured == NO && attachmentImage != nil && !isServerAttachmentImage)
        {
            barButtonsArray    = [NSArray arrayWithObjects:imageItem,fixSpaceItem1,leftItem, fixSpaceItem2,rightItem, nil];
        }
        else if (isSignatureCaputured == YES && attachmentImage == nil && isServerAttachmentImage )
        {
            barButtonsArray     = [NSArray arrayWithObjects:imageSItem, signatureItem,fixSpaceItem1,leftItem, fixSpaceItem2,rightItem, nil];
        }
        else if (isSignatureCaputured == YES && attachmentImage != nil && isServerAttachmentImage)
        {
            barButtonsArray     = [NSArray arrayWithObjects:imageSItem,imageItem, signatureItem,fixSpaceItem1,leftItem, fixSpaceItem2,rightItem, nil];
        }
        else if (isSignatureCaputured == NO && attachmentImage != nil && isServerAttachmentImage)
        {
            barButtonsArray     = [NSArray arrayWithObjects:imageSItem,imageItem,fixSpaceItem1,leftItem, fixSpaceItem2,rightItem, nil];
        }
        else if (isSignatureCaputured == NO && attachmentImage == nil && isServerAttachmentImage)
        {
            barButtonsArray     = [NSArray arrayWithObjects:imageSItem,fixSpaceItem1,leftItem, fixSpaceItem2,rightItem, nil];
        }
        else
        {
            barButtonsArray     = [NSArray arrayWithObjects:fixSpaceItem1,leftItem, fixSpaceItem2,rightItem, nil];
        }
    }
// ***** Added by Harshitha to include additional partners functionality *****
    else if (additionalPartner) {
        
        if (isSignatureCaputured == YES && attachmentImage == nil && ! isServerAttachmentImage )
        {
            barButtonsArray     = [NSArray arrayWithObjects:partnerItem,signatureItem,fixSpaceItem1,leftItem, fixSpaceItem2,rightItem, nil];
        }
        else if (isSignatureCaputured == YES && attachmentImage != nil && ! isServerAttachmentImage)
        {
            barButtonsArray     = [NSArray arrayWithObjects:partnerItem,imageItem, signatureItem, fixSpaceItem1,leftItem, fixSpaceItem2,rightItem, nil];
        }
        else if (isSignatureCaputured == NO && attachmentImage != nil && !isServerAttachmentImage)
        {
            barButtonsArray    = [NSArray arrayWithObjects:partnerItem,imageItem,fixSpaceItem1,leftItem, fixSpaceItem2,rightItem, nil];
        }
        else if (isSignatureCaputured == YES && attachmentImage == nil && isServerAttachmentImage )
        {
            barButtonsArray     = [NSArray arrayWithObjects:partnerItem,imageSItem, signatureItem,fixSpaceItem1,leftItem, fixSpaceItem2,rightItem, nil];
        }
        else if (isSignatureCaputured == YES && attachmentImage != nil && isServerAttachmentImage)
        {
            barButtonsArray     = [NSArray arrayWithObjects:partnerItem,imageSItem,imageItem, signatureItem,fixSpaceItem1,leftItem, fixSpaceItem2,rightItem, nil];
        }
        else if (isSignatureCaputured == NO && attachmentImage != nil && isServerAttachmentImage)
        {
            barButtonsArray     = [NSArray arrayWithObjects:partnerItem,imageSItem,imageItem,fixSpaceItem1,leftItem, fixSpaceItem2,rightItem, nil];
        }
        else if (isSignatureCaputured == NO && attachmentImage == nil && isServerAttachmentImage)
        {
            barButtonsArray     = [NSArray arrayWithObjects:partnerItem,imageSItem,fixSpaceItem1,leftItem, fixSpaceItem2,rightItem, nil];
        }
        else
        {
            barButtonsArray     = [NSArray arrayWithObjects:partnerItem,fixSpaceItem1,leftItem, fixSpaceItem2,rightItem, nil];
        }
    }
// ***** Added by Harshitha ends here *****
    
    [self setBottomMenuBarWithArrayOfBarButtons:barButtonsArray];
    
}

- (UIBarButtonItem*) createBarButtonWithImageNamed:(NSString*)imageName tag:(int)bbTag selector:(SEL)selector
{
    UIImage *buttomBgImage      = [UIImage imageNamed:imageName];
    UIButton *customButton      = [UIButton buttonWithType:UIButtonTypeCustom];
    customButton.frame          = CGRectMake(0.0f, 0.0f, buttomBgImage.size.width, buttomBgImage.size.height);
    customButton.hidden         = NO;
    customButton.tag            = bbTag;
    
    [customButton setImage:buttomBgImage forState:UIControlStateNormal];
    [customButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    
    return barButton;
}

-(void)imageCheckingInDocFolder
{
    
    signatureFilePath   = [[GSPUtility sharedInstance] getSignatureFolderPathForFileName:self.serviceTask.serviceOrder forPathComponent:@"AttachedSignatures"];
    
    signatureImage      = [UIImage imageWithContentsOfFile:signatureFilePath];
    
    if(signatureImage)
        isSignatureCaputured = YES;
    else
        isSignatureCaputured = NO;
    
    
    attachmentImage = nil;
    
    NSMutableArray *imagesArray = [[GSPUtility sharedInstance] getAttachedImagesFromLocalFolder:self.serviceTask.serviceOrder forPathComponent:@"AttchedImages"];
    if (imagesArray.count > 0)
    {
        NSString * folderPath   = [[GSPUtility sharedInstance] getMediaLocalPathForFileName:self.serviceTask.serviceOrder forPathComponent:@"AttchedImages"];
        attachmentImage         = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",folderPath,[imagesArray objectAtIndex:0]]];
    }
    
    if (attachmentImage)
        isImageAttached = YES;
    else
        isImageAttached = NO;
}

#pragma Toolbar button actions

//- (void) attachBtnClicked:(id)sender
- (void) attachBtnClicked
{
    
    NSMutableArray* assets = [NSMutableArray new];
    
    NSMutableArray *imagesArray = [[GSPUtility sharedInstance] getAttachedImagesFromLocalFolder:self.serviceTask.serviceOrder forPathComponent:@"AttchedImages"];
    
    
    for (NSString *imagesFilePath in imagesArray)
    {
        GalleryImage *myGallery     = [GalleryImage new];
        NSString * folderPath       = [[GSPUtility sharedInstance] getMediaLocalPathForFileName:self.serviceTask.serviceOrder forPathComponent:@"AttchedImages"];
        myGallery.image             = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",folderPath,imagesFilePath]];
        myGallery.imageFilePath     = [NSString stringWithFormat:@"%@/%@",folderPath,imagesFilePath];
        [assets addObject:myGallery];
    }
    
    
    GalleryViewController* galleryViewController = [[GalleryViewController alloc] init];
    galleryViewController.assets = assets;
    
    [self.navigationController pushViewController:galleryViewController animated:YES];
    
}

- (void) attachSignBtnClicked: (id)sender
{
    
    GSPImagePreviewController *attachedImageVC ;
    
    if (IS_IPAD) {
        
        attachedImageVC = [[GSPImagePreviewController alloc]initWithNibName:@"GSPImagePreviewController_iPad" bundle:nil withImage:signatureImage withSinaturePath:signatureFilePath];
    }
    else
    {
        attachedImageVC = [[GSPImagePreviewController alloc]initWithNibName:@"GSPImagePreviewController" bundle:nil withImage:signatureImage withSinaturePath:signatureFilePath];
    }
    
    
    attachedImageVC.modalPresentationStyle = UIModalPresentationFormSheet;
    [attachedImageVC setModalTransitionStyle: UIModalTransitionStyleCoverVertical];
    [self.navigationController presentViewController:attachedImageVC animated:YES completion:nil];
    
    
}

- (void)sapResponseHandlerForServerAttachments:(NSNotification*)notification
{
    NSDictionary* userInfo          = notification.userInfo;
    NSString        * message       = [userInfo objectForKey:@"responseMsg"];
    NSMutableArray  * reponseArray  = [userInfo objectForKey:@"FLD_VC"];
    
    NSString * statusMessage;
    
    if ([notification.name isEqualToString:@"DownloadingServerAttachment"]) {
        
        statusMessage = @"Fetching attachment...";
    }
    
    
    if ([message isEqualToString:@"Loading Activity Indicator"])
    {
//        [SVProgressHUD showWithStatus:statusMessage];
        [SVProgressHUD showWithStatus:nil];
    }
    else if ([message isEqualToString:@"Stop Loading Activity Indicator"])
    {
        [self parseServerAttachmentContentData:reponseArray];
        
        [SVProgressHUD dismiss];
    }
    else
    {
        [SVProgressHUD dismiss];
    }
    
}

-(void) loadImageFromSAP:(NSIndexPath *)indexPath serverAttachmentArray:(NSMutableArray *)serverAttachmentArray{
    
//    if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
//    {
//    //     selectedAttachment = [self.dataSourceArray objectAtIndex:indexPath.row];
//        selectedAttachment = [serverAttachmentArray objectAtIndex:indexPath.row-5];
//    
//    //    selectedIndex = indexPath.row;
//        selectedIndex = indexPath.row-5;
//    }
//    else if (UIInterfaceOrientationIsLandscape(interfaceOrientation))
//    {
        selectedAttachment = [serverAttachmentArray objectAtIndex:indexPath.row-9];
        selectedIndex = indexPath.row-9;
   // }
    
    if (selectedAttachment.attachmentContent.length <= 0)
    {
//        [SVProgressHUD showWithStatus:@"Downloading Content..."];
        [SVProgressHUD showWithStatus:nil];
        
        NSMutableArray *_inptArray = [[NSMutableArray alloc] init];
        
        //Creating datatype of service confirmation
        
        NSString *strPar4 = [NSString stringWithFormat:@"%@", @"DATA-TYPE ZGSXCAST_ATTCHMNTKEY01[.]OBJECT_ID[.]OBJECT_TYPE[.]NUMBER_EXT[.]ATTCHMNT_ID"];
        [_inptArray addObject:strPar4];
        
        NSString *strPar5 = [NSString stringWithFormat:@"ZGSXCAST_ATTCHMNTKEY01[.]%@[.]%@[.]%@",selectedAttachment.orderId,selectedAttachment.attachmentObjectType,selectedAttachment.orderTaskNumExtension];
        
        [_inptArray addObject:strPar5];
        
        //If Internet connection is there call do sap updates here
        
        if([CheckedNetwork connectedToNetwork])
        {
            ServerAttachment * serverAttachment = [ServerAttachment new];
            
            [serverAttachment downloadServerAttachmentContentFromSAP:_inptArray];
            
        }
        return;
    }
    
    [self openAttachmentViewWithAttachemnetId:selectedAttachment.attachmentID andContentString:selectedAttachment.attachmentContent];
    
}

- (void) parseServerAttachmentContentData:(NSMutableArray*)contentArray
{
    
    NSString * dataString = @"";
    NSString * extString  = @"";
    
    if (selectedIndex + 3 < contentArray.count ) {
        dataString   = [[contentArray objectAtIndex:selectedIndex + 3] objectAtIndex:6];
        extString    = [[contentArray objectAtIndex:selectedIndex + 3] objectAtIndex:5];
    }
    else
    {
        dataString   = [[contentArray objectAtIndex:3] objectAtIndex:6];
        extString    = [[contentArray objectAtIndex:3] objectAtIndex:5];
        
    }
    
    ServerAttachment *attachment = [ServerAttachment new];
    
    selectedAttachment.attachmentContent = dataString;
    
    [attachment saveDownloadedAttachmentInDbForOrder:selectedAttachment.orderId attachmentId:selectedAttachment.attachmentID andContent:dataString];
    [SVProgressHUD dismiss];
    [self openAttachmentViewWithAttachemnetId:extString andContentString:selectedAttachment.attachmentContent];
    
}

-(void) openAttachmentViewWithAttachemnetId:(NSString*)extString andContentString:(NSString*)dataString
{
    NSData* attachmentData   = [[GSPUtility sharedInstance] decodeBase64StringToData:dataString];
    
    if ([[self checkAttachmentType:extString] isEqualToString:@"pdf"] || [[self checkAttachmentType:extString] isEqualToString:@"PDF"])
    {
        [self showPDF:attachmentData andfileName:extString];
    }
    else if ([[self checkAttachmentType:extString] isEqualToString:@"png"] || [[self checkAttachmentType:extString] isEqualToString:@"BMP"] || [[self checkAttachmentType:extString] isEqualToString:@"tif"] || [[self checkAttachmentType:extString] isEqualToString:@"gif"] || [[self checkAttachmentType:extString] isEqualToString:@"jpg"] || [[self checkAttachmentType:extString] isEqualToString:@"jpeg"])
    {
        UIImage *image      = [UIImage imageWithData:attachmentData];
        [self showImage:image];
    }
    
}


- (NSString*) checkAttachmentType:(NSString*)attchmentExt
{
    NSRange range                   = [attchmentExt rangeOfString:@"."];
    
    NSString * extensionStr;
    
    if (range.length > 0) {
        extensionStr = [attchmentExt substringFromIndex:range.location+1];
    }
    return extensionStr;
}



-(void)showImage:(UIImage*)aImage
{
    GSPImagePreviewController * imagePreviewVC;
    if (IS_IPAD) {
        imagePreviewVC  = [[GSPImagePreviewController alloc]initWithNibName:@"GSPImagePreviewController_iPad" bundle:nil withImage:aImage];
    }
    else {  
        imagePreviewVC  = [[GSPImagePreviewController alloc]initWithNibName:@"GSPImagePreviewController" bundle:nil withImage:aImage];
    }
    [self presentViewController:imagePreviewVC animated:YES completion:nil];
}

- (void)showPDF:(NSData*)pdfData andfileName:(NSString*)fileName
{
    GSPDocViewerViewController * docViewController;
    if (IS_IPAD) {
        docViewController = [[GSPDocViewerViewController alloc]initWithNibName:@"GSPDocViewerViewController_iPad" bundle:nil withData:pdfData andFileName:fileName];
    }
    else {
        docViewController = [[GSPDocViewerViewController alloc]initWithNibName:@"GSPDocViewerViewController" bundle:nil withData:pdfData andFileName:fileName];
        
    }
    [self.navigationController pushViewController:docViewController animated:YES];
}


- (void)loadNextTask:(id)sender
{
    if ( multipleTasksArray.count == self.currentlyShownTaskIndex + 1 ) {
        return;
    }
    
    CGFloat xAxis = self.view.frame.size.width;
    
    if ([sender isKindOfClass:[UIButton class]]) {
        xAxis = -self.view.frame.size.width;
    }
    
    self.currentlyShownTaskIndex = self.currentlyShownTaskIndex + 1;
    
    [self startAnimatingViewForBottomToolBarActionFromXaxis:xAxis];
    _hintLabel.text=[NSString stringWithFormat:@"Task %d of %d",self.currentlyShownTaskIndex+1,multipleTasksArray.count];
    NSLog(@"currently shown task index %d",self.currentlyShownTaskIndex);
}

- (void)loadPreviousTask:(id)sender
{
    if (self.currentlyShownTaskIndex == 0) {
        return;
    }
    self.currentlyShownTaskIndex = self.currentlyShownTaskIndex -1;
    
//    CGFloat xAxis = -self.detailTableView.frame.size.width;
    CGFloat xAxis = -self.view.frame.size.width;
//    
    if ([sender isKindOfClass:[UIButton class]]) {
        xAxis = self.view.frame.size.width;
    }
     _hintLabel.text=[NSString stringWithFormat:@"Task %d of %d",self.currentlyShownTaskIndex+1,multipleTasksArray.count];
     NSLog(@"currently shown task index %d",self.currentlyShownTaskIndex);
    [self startAnimatingViewForBottomToolBarActionFromXaxis:xAxis];
}

- (void) startAnimatingViewForBottomToolBarActionFromXaxis:(CGFloat)xAxis
{
//    self.detailTableView.frame = CGRectMake(xAxis, self.detailTableView.frame.origin.y, self.detailTableView.frame.size.width, self.detailTableView.bounds.size.height);
    
   // if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
  //  {
//        self.detailTableView1_Landscape.frame = CGRectMake(xAxis, self.detailTableView1_Landscape.frame.origin.y, self.detailTableView1_Landscape.frame.size.width, self.detailTableView1_Landscape.bounds.size.height);
//        
//        self.detailTableView2_Landscape.frame = CGRectMake(xAxis, self.detailTableView2_Landscape.frame.origin.y, self.detailTableView2_Landscape.frame.size.width, self.detailTableView2_Landscape.bounds.size.height);
//    }
    
    [UIView animateWithDuration:0.4f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
//                         self.detailTableView.frame    = CGRectMake(0, self.detailTableView.frame.origin.y, self.detailTableView.bounds.size.width, self.detailTableView.bounds.size.height);
                       //  if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
//                       //  {
//                             self.detailTableView1_Landscape.frame = CGRectMake(0, self.detailTableView1_Landscape.frame.origin.y, self.detailTableView1_Landscape.frame.size.width, self.detailTableView1_Landscape.bounds.size.height);
//                             
//                             self.detailTableView2_Landscape.frame = CGRectMake(382.0 , self.detailTableView2_Landscape.frame.origin.y, self.detailTableView2_Landscape.frame.size.width, self.detailTableView2_Landscape.bounds.size.height);
//                     //    }
                         
                         if (multipleTasksArray.count > self.currentlyShownTaskIndex && self.currentlyShownTaskIndex >= 0) {
// Original code
/*                            ServiceTask *task                  = [multipleTasksArray objectAtIndex:self.currentlyShownTaskIndex];
                             
                             self.serviceTask.serviceItem       = task.serviceItem;
                             self.serviceTask.numberExtension   = task.numberExtension;
*/
// Modified by Harshitha
                             self.serviceTask                   = [multipleTasksArray objectAtIndex:self.currentlyShownTaskIndex];
                         }
                         
                     }
                     completion:^(BOOL finished){
                         
                         [signatureView removeFromSuperview];
//                         [self.signPreviewImage removeFromSuperview];
                         
                         [self setUpSignatureViewAndViewServerAttachmentsButton];
                         
                        self.serviceNoteExpandButtonClicked = NO;
                         self.serverAttachmentButtonClicked = NO;
                         self.additionalPartnersButtonClicked = NO;
                         [self.serverAttachmentsArray removeAllObjects];
                         [self.additionalPartnersArray removeAllObjects];

                         [self setUpPreviousAndNextTaskButtons];
                         
                         GSPAppDelegate *appDelegateObj = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];
                         //    if(appDelegateObj.notificationLaunched){
                         
                         _errorLabel.hidden=YES;
                         _errorLabel.text=@"JHgd";
                         
                         _errorTextView.hidden=YES;
                         _warningImage.hidden=YES;
                         //    _errorBackgroundLabel.hidden = NO;
                         
                         //        appDelegateObj.notificationLaunched=NO;
                         
                         NSString *notifReferenceID = appDelegateObj.notifObjectID;
                         
                         NSLog(@"the reference id for notif %@",notifReferenceID);
                         
                         NSMutableArray * arrayOfTasksFromKeyChain = [GSPKeychainStoreManager getErrorItemsFromKeyChain];
                         NSLog(@"The fetched items from keychain %@",arrayOfTasksFromKeyChain);
                         
                         
                         if(arrayOfTasksFromKeyChain.count >0){
                             
                             for( NSDictionary *dic in arrayOfTasksFromKeyChain){
                                 if([[dic valueForKey:@"referenceID"]isEqualToString:self.serviceTask.serviceOrder]){
                                     _errorLabel.hidden=NO;
                                     _errorLabel.text= [dic valueForKey:@"errDescription"];
                                     _warningImage.hidden=NO;
                                     
                                     _errorTextView.hidden =NO;
                                     _errorTextView.text = [dic valueForKey:@"errorDescription"];
                                 }
                             }
                             //                    else{
                             //                        _errorLabel.hidden =YES;
                             ////                    _errorBackgroundLabel.hidden = YES;
                             ////                    _warningImageView.hidden =YES;
                             //
                             //                        _warningImage.hidden=YES;
                             //
                             //                }
                             //
                             //
                             //        }
                             
                             
                             
                             
                         }
                         else{
                             _errorLabel.hidden =YES;
                             
                             _errorTextView.hidden=YES;
                             //                    _errorBackgroundLabel.hidden = YES;
                             //            _warningImageView.hidden =YES;
                             
                             _warningImage.hidden=YES;
                         }
                         //
                         if(!_errorTextView.hidden){
                             self.detailTableView1_Landscape.frame= CGRectMake(8, 130, _detailTableView1_Landscape.frame.size.width, _detailTableView1_Landscape.frame.size.height);
                             self.detailTableView2_Landscape.frame= CGRectMake(379, 130, _detailTableView2_Landscape.frame.size.width, _detailTableView2_Landscape.frame.size.height);
                             
                             //        [UIView animateWithDuration:3.0f delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
                             //            _errorLabel.frame = CGRectMake(6, 100, 400,50);
                             //        } completion:^(BOOL finished)
                             //         {
                             //             _errorLabel.frame = CGRectMake(-6, 100, 400, 50);
                             //         }];
                             
                             //        [UIView beginAnimations:nil context:NULL];
                             //        [UIView setAnimationDuration:10];
                             //        
                             //        _errorLabel.frame = CGRectMake(-_errorLabel.frame.size.width,_errorLabel.frame.origin.y, _errorLabel.frame.size.width, _errorLabel.frame.size.height);
                             //        
                             //        [UIView commitAnimations];
//                             NSTimer *errorLabelTimer;
//                             errorLabelTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(startAnimatingErrorLabel) userInfo:nil repeats:YES];
                             
                         }
                         else{
                             self.detailTableView1_Landscape.frame= CGRectMake(8, 100, _detailTableView1_Landscape.frame.size.width, _detailTableView1_Landscape.frame.size.height);
                             self.detailTableView2_Landscape.frame= CGRectMake(379, 100, _detailTableView2_Landscape.frame.size.width, _detailTableView2_Landscape.frame.size.height);
                             CGPoint anchorPoint = _errorLabel.layer.anchorPoint;
                             [UIView animateWithDuration:0.5 animations:^{
                                 // grow the label up to 130%, using a animation of 1/2s
                                 _errorLabel.transform = CGAffineTransformMakeScale(1.3,1.3);
                             } completion:^(BOOL finished) {
                                 // When the "grow" animation is completed, go back to size 100% using another animation of 1/2s
                                 _errorLabel.layer.anchorPoint = CGPointMake(anchorPoint.x/1.3, anchorPoint.y/1.3);
                                 [UIView animateWithDuration:0.5 animations:^{
                                     _errorLabel.transform = CGAffineTransformIdentity;
                                     
                                     
                                 }];
                             }];
                             
                         }

                         
                       //  if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
                       //  {
                             [self.detailTableView1_Landscape reloadData];
                             [self.detailTableView2_Landscape reloadData];
                         
                         [self setupView];
                       //  }
                     }];
    
}

//- (void) attachBtnServerClicked:(id)sender
- (void) attachBtnServerClicked
{

    GSPAttachmnetsViewController * attachemntsVC;
    
    if (IS_IPAD)
    {
        attachemntsVC = [[GSPAttachmnetsViewController alloc] initWithNibName:@"GSPAttachmnetsViewController_iPad" bundle:nil withServiceOrder:self.serviceTask];
    }
    else
    {
        attachemntsVC = [[GSPAttachmnetsViewController alloc] initWithNibName:@"GSPAttachmnetsViewController" bundle:nil withServiceOrder:self.serviceTask];
    }
    
    [self.navigationController pushViewController:attachemntsVC animated:YES];
    
    
}

// ***** Added by Harshitha to show addittional partners *****
//- (void) partnerIconClicked:(id)sender
- (void) partnerIconClicked
{
    
    GSPPartnerViewController * partnerVC;
    
    if (IS_IPAD)
    {
        partnerVC = [[GSPPartnerViewController alloc] initWithNibName:@"GSPPartnerViewController_iPad" bundle:nil withServiceOrder:self.serviceTask];
    }
    else
    {
        partnerVC = [[GSPPartnerViewController alloc] initWithNibName:@"GSPPartnerViewController" bundle:nil withServiceOrder:self.serviceTask];
    }
    
    [self.navigationController pushViewController:partnerVC animated:YES];
    
}
// ***** Added by Harshitha ends here *****

- (void)menuButtonClick:(id)sender
{
    UIActionSheet* menuActionSheet = [[UIActionSheet alloc]
                                      initWithTitle:NSLocalizedString(@"CHOOSE_ACTION", nil)
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"CANCEL", nil)
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:NSLocalizedString(@"MAP_CUSTOMER", nil),NSLocalizedString(@"TRANSFER_TASK", nil),NSLocalizedString(@"CAPTURE_IMAGE", nil),NSLocalizedString(@"CAPTURE_SIGNATURE", nil),NSLocalizedString(@"SHOW_PDF", nil),NSLocalizedString(@"SERVICE_CONFIRMATION", nil),nil];
    menuActionSheet.tag             = MENU_ACTION_SHEET_TAG;
    [menuActionSheet showInView:self.view];
    
}

#pragma mark Action sheet delegates

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == MENU_ACTION_SHEET_TAG)
    {
        [self menuActionSheetActionWithIndex:buttonIndex];
    }
    else if (actionSheet.tag == IMAGEPICKER_ACION_SHEET_TAG)
    {
        [self ImagePickerActionSheetActionWithIndex:buttonIndex];
    }
    else if (actionSheet.tag == 4)
    {
        [self callActionSheetActionWithIndex:buttonIndex];
    }
    else if (actionSheet.tag == 5)
    {
        [self callPartnerActionSheetActionWithIndex:buttonIndex];
    }
    
}

- (void) menuActionSheetActionWithIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex)
    {
        case 0:
            [self showTaskLocation];
            break;
        case 1:
            [self transferTaskToOtherRepsAction];
            break;
        case 2:
            [self captureImageAction];
            break;
        case 3:
            [self captureSignatureAction];
            break;
        case 4:
            [self showServiceOrderPDF];
            break;
        case 5:
            [self showServiceConfirmation];
            break;

        default:
            break;
    }
    
}

- (void) ImagePickerActionSheetActionWithIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [self imagePickerActionWithOption:CAMERA_SELECTED];
            break;
        case 1:
            [self imagePickerActionWithOption:GALLERY_SELECTED];
            break;
            
        default:
            break;
    }
    
}

- (void)showTaskLocation
{
    GSPTaskLocationMapViewController *taskLocationMapVC;
    
    if (IS_IPAD)
    {
        taskLocationMapVC = [[GSPTaskLocationMapViewController alloc]initWithNibName:@"GSPTaskLocationMapViewController_iPad" bundle:nil withAddress:self.serviceTask.locationAddress];
    }
    else
        taskLocationMapVC = [[GSPTaskLocationMapViewController alloc]initWithNibName:@"GSPTaskLocationMapViewController" bundle:nil withAddress:self.serviceTask.locationAddress];
    
    
    [self.navigationController pushViewController:taskLocationMapVC animated:YES];
    
}

- (void)transferTaskToOtherRepsAction
{
    GSPColleguesViewController * colleguesViewController;
    
    if (IS_IPAD)
    {
        colleguesViewController = [[GSPColleguesViewController alloc]initWithNibName:@"GSPColleguesViewController_iPad" bundle:nil forTaskTasnfer:self.serviceTask];
    }
    else
       colleguesViewController = [[GSPColleguesViewController alloc]initWithNibName:@"GSPColleguesViewController" bundle:nil forTaskTasnfer:self.serviceTask]; 
    
    [self.navigationController pushViewController:colleguesViewController animated:YES];
}


- (void)captureImageAction
{
    UIActionSheet* menuActionSheet = [[UIActionSheet alloc]
                                      initWithTitle:NSLocalizedString(@"CHOOSE_ACTION", nil)
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"CANCEL", nil)
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"Camera",@"Photo Gallery",nil];
    menuActionSheet.tag           = IMAGEPICKER_ACION_SHEET_TAG;
    [menuActionSheet showInView:self.view];
    
}

- (void) showServiceConfirmation
{
    GSPServiceConfirmationViewController * serviceConfirmationVC;
    
    if (IS_IPAD) {
        serviceConfirmationVC = [[GSPServiceConfirmationViewController alloc]initWithNibName:@"GSPServiceConfirmationViewController_iPad" bundle:nil forObject:self.serviceTask];
    }
    else
    {
        serviceConfirmationVC = [[GSPServiceConfirmationViewController alloc]initWithNibName:@"GSPServiceConfirmationViewController" bundle:nil forObject:self.serviceTask];
    }
    
    
    [self.navigationController pushViewController:serviceConfirmationVC animated:YES];
}


#pragma mark Signature Capture Methods
- (void) captureSignatureAction
{
}

//- (void) attachSignatureView
- (IBAction)tapToSignButtonClicked:(id)sender;
{
   /* GSPCaptureSignatureViewController * captureSignatureVC;
  
    if (IS_IPAD)
    {
        captureSignatureVC = [[GSPCaptureSignatureViewController alloc] initWithNibName:@"GSPCaptureSignatureViewController_iPad" bundle:nil withServiceId:self.serviceTask.serviceOrder];
    }
    else
    {
        captureSignatureVC = [[GSPCaptureSignatureViewController alloc] initWithNibName:@"GSPCaptureSignatureViewController" bundle:nil withServiceId:self.serviceTask.serviceOrder];
    }
    
    [self.navigationController pushViewController:captureSignatureVC animated:YES];
    */
    
    NSArray *subviewArray   = [[NSBundle mainBundle] loadNibNamed:@"GSPSignatureCaptureView" owner:self options:nil];
   
    signatureView           = [subviewArray objectAtIndex:0];
    
//    signatureView.frame     = CGRectMake(self.view.bounds.size.width/2 - signatureView.frame.size.width/2, self.view.bounds.size.height - (signatureView.frame.size.height + 65 ), signatureView.frame.size.width, signatureView.frame.size.height);
    signatureView.frame     = CGRectMake(self.view.bounds.size.width/2 - signatureView.frame.size.width/2, 300.0, signatureView.frame.size.width, signatureView.frame.size.height);

//    isSignaturePoupVisible = YES;
    
    [self.view addSubview:signatureView];
    
    [self.view bringSubviewToFront:signatureView];
}

- (IBAction)saveSignature:(id)sender
{
    [signatureView removeFromSuperview];
    
    NSData *imageData                   = [NSData dataWithData:UIImagePNGRepresentation(signatureView.drawImage.image)];
    
    NSString * signatureFolderPath      = [[GSPUtility sharedInstance] getSignatureFolderPathForFileName:self.serviceTask.serviceOrder forPathComponent:@"AttachedSignatures"];
    
    [imageData writeToFile:signatureFolderPath atomically:YES];
    
    
    [self cancelSignature:sender];
    
    [[GSPUtility sharedInstance] showAlertWithTitle:@"" message:@"Signature successfully saved " otherButton:nil tag:0 andDelegate:self];

    self.tapToSignButton.userInteractionEnabled = NO;
    self.signUpImage.hidden = YES;
    self.signHereLabel.hidden = YES;
    self.signatureBottomLineImage.hidden = YES;
    
    [self imageCheckingInDocFolder];
    
    self.signPreviewImage.hidden = NO;
    [self.signPreviewImage setImage:signatureImage];
    NSDate *todayDate = [NSDate date]; // get today date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create
    dateFormatter.locale=[[NSLocale alloc ]initWithLocaleIdentifier:@"en-US" ];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    //This would be in hh:mm a
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    NSString *convertedDateString = [dateFormatter stringFromDate:todayDate];// here convert date
    NSLog(@"Today formatted date is %@",convertedDateString);
    NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
    NSString *value = convertedDateString;
    [userPreferences setObject:value forKey:self.serviceTask.serviceOrder];

}

- (IBAction)cancelSignature:(id)sender
{
/*    isSignaturePoupVisible = NO;
    [signatureView removeFromSuperview];
*/
}

#pragma mark image Picker methods

- (void) imagePickerActionWithOption:(int)selectedOption
{
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    
    if(selectedOption == GALLERY_SELECTED)
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    imagePicker.allowsEditing = YES;
    
    [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
/*    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
    [popover presentPopoverFromRect:CGRectMake(0, 0, 500, 800) inView:self.parentViewController.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    self.popOver = popover;
*/
/*    imagePicker.modalPresentationStyle = 17;
    [imagePicker setModalTransitionStyle: UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:imagePicker animated:YES completion:nil];
*/

//    [self presentModalViewController:imagePicker animated:YES];
}

-(void) saveImage:(UIImage*)image
{
    
    NSData *imageData                   = UIImagePNGRepresentation(image);
    
    NSDateFormatter *dateFormat     = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *tmpImgName                = [NSString stringWithFormat:@"%@_%@_img.png",self.serviceTask.serviceOrder,[dateFormat stringFromDate:[NSDate date]]];
    
    NSString * localFolderPathStr       = [[GSPUtility sharedInstance] getMediaLocalPathForFileName:self.serviceTask.serviceOrder forPathComponent:@"AttchedImages"];
    
    NSString * imagePath                = [localFolderPathStr stringByAppendingPathComponent:tmpImgName];
    
    [imageData writeToFile:imagePath atomically:YES];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSURL *mediaUrl;
    
    UIImage *image;
    
    mediaUrl = (NSURL *)[info valueForKey:UIImagePickerControllerMediaURL];
    
    
    if (mediaUrl == nil)
    {
        image = (UIImage *) [info valueForKey:UIImagePickerControllerEditedImage];
        
        if (image == nil)
        {
            image = (UIImage *) [info valueForKey:UIImagePickerControllerOriginalImage];
            CGSize objCGSize = CGSizeMake(100, 100);
            image = [self scaledImageForImage:image newSize:objCGSize];
            [self saveImage:image];
            
        }
        else
        {
            [self saveImage:image];
        }
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

-(UIImage *)scaledImageForImage:(UIImage*)mimage newSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [mimage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


#pragma mark PDF Generation and sending as mail Methods

-(void) generateAndAttachPDFToMail
{
   // [[PDFRenderer sharedInstance] drawPDFFromTableForServicOrder:self.serviceTask.serviceOrder WithTableViewView:self.detailTableView1_Landscape andAnotheTableView:self.detailTableView2_Landscape withAttacments:[[GSPUtility sharedInstance] getAttachedImagesFromLocalFolder:self.serviceTask.serviceOrder forPathComponent:@"AttchedImages"] andSignature:signatureImage];
 //  [[PDFRenderer sharedInstance] drawPDFFromTableForServicOrder:self.serviceTask.serviceOrder WithTableViewView:self.detailTableView1_Landscape withAttacments:[[GSPUtility sharedInstance] getAttachedImagesFromLocalFolder:self.serviceTask.serviceOrder forPathComponent:@"AttchedImages"] andSignature:signatureImage];
    
    NSString *filePath=[[NSBundle mainBundle]pathForResource:@"default_lang" ofType:@"strings"];
    NSDictionary *translatedDic=[NSDictionary dictionaryWithContentsOfFile:filePath];
    
    [[PDFRenderer sharedInstance] drawPDFofTableForServicOrder:self.serviceTask.serviceOrder withObject :self.serviceTask  WithArray:self.serviceOrdersArray withAttacments:[[GSPUtility sharedInstance] getAttachedImagesFromLocalFolder:self.serviceTask.serviceOrder forPathComponent:@"AttchedImages"]andSignature:signatureImage withTranslatedDictionary:translatedDic];


    [self attachPdfToMailAndSend];
}

-(void)showServiceOrderPDF
{
    
    [[PDFRenderer sharedInstance] drawPDFFromTableForServicOrder:self.serviceTask.serviceOrder WithTableViewView:self.detailTableView withAttacments:[[GSPUtility sharedInstance] getAttachedImagesFromLocalFolder:self.serviceTask.serviceOrder forPathComponent:@"AttchedImages"] andSignature:signatureImage];
   // [[PDFRenderer sharedInstance] drawPDFFromTableForServicOrder:self.serviceTask.serviceOrder WithTableViewView:self.detailTableView1_Landscape andAnotherTableView :self.detailTableView2_Landscape withAttacments:[[GSPUtility sharedInstance] getAttachedImagesFromLocalFolder:self.serviceTask.serviceOrder forPathComponent:@"AttchedImages"] andSignature:signatureImage];


    NSData * pdfData = [NSData dataWithContentsOfFile:[[PDFRenderer sharedInstance] getPdfFileName:self.serviceTask.serviceOrder]];
    
    GSPDocViewerViewController *docViewer  ;
    
    if (IS_IPAD) {
        docViewer   = [[GSPDocViewerViewController alloc]initWithNibName:@"GSPDocViewerViewController_iPad" bundle:nil withData:pdfData andFileName:self.serviceTask.serviceOrder];
    }
    else
        docViewer   = [[GSPDocViewerViewController alloc]initWithNibName:@"GSPDocViewerViewController" bundle:nil withData:pdfData andFileName:self.serviceTask.serviceOrder];
    
    
    [self.navigationController pushViewController:docViewer animated:YES];

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
        
        
        [mailer addAttachmentData:[NSData dataWithContentsOfFile:[[PDFRenderer sharedInstance] getPdfFileName:self.serviceTask.serviceOrder]] mimeType:@"application/pdf" fileName:@"ServiceOrder.PDF"];
        
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
            NSString* pdfFileName = [[PDFRenderer sharedInstance] getPdfFileName:self.serviceTask.serviceOrder];
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

#pragma mark Texview Delegates

- (void)textViewDidBeginEditing:(UITextView *)textView
{
//    [self.detailTableView scrollToRowAtIndexPath:estArrDateIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
//    if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
//        [self.detailTableView2 scrollToRowAtIndexPath:estArrDateIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//    if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
        [self.detailTableView2_Landscape scrollToRowAtIndexPath:estArrDateIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSString * inputString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
	if ([text isEqualToString:@"\n"])
    {
		[textView resignFirstResponder];
		return FALSE;
	}
    
    switch (textView.tag)
    {
//        case EnterReasonRow:
            case 3:
            self.serviceTask.rejectionDescription   = inputString;
            break;
            
//        case FieldNoteRow:
            case 6:
            self.serviceTask.fieldNote              = inputString;
            break;
            
        default:
            break;
    }

    return YES;
}



#pragma mark Update service task methods

- (void)updateTaskResponseHandler:(NSNotification*)notification
{
    NSDictionary* userInfo          = notification.userInfo;
    NSString        * message       = [userInfo objectForKey:@"responseMsg"];
    NSMutableArray  * reponseArray  = [userInfo objectForKey:@"FLD_VC"];
    
    NSString * statusMessage;
    
    if ([notification.name isEqualToString:@"StartAcitivityIndicator"]) {
        
        statusMessage = @"Please wait while processing...";
    }
    
    if ([message isEqualToString:@"Loading Activity Indicator"])
    {
//        [SVProgressHUD showWithStatus:statusMessage];
        [SVProgressHUD showWithStatus:nil];
    }
    else if ([message isEqualToString:@"SAP Response Message"] && [notification.name isEqualToString:@"StartAcitivityIndicator"])
    {
        
//     Added by Harshitha
        if([userInfo objectForKey:@"FLDVC"])
        diagnoseArray  = [userInfo objectForKey:@"FLDVC"];
        
        NSLog(@"RESPONSE ARRAY :%@",reponseArray);
        
//     Added by Harshitha
        dispatch_sync(dispatch_get_main_queue(), ^(void){
            [SVProgressHUD dismiss];
        });
        
        if (reponseArray.count > 3)
        {
            NSString * message = [[reponseArray objectAtIndex:0] objectAtIndex:0];
            
            if ([message isEqualToString:@"E"])
            {
                NSString * errorMessage = [NSString stringWithFormat:@"%@, Do you want to export this task as pdf to your email ?",[[reponseArray objectAtIndex:3] objectAtIndex:0] ];
 
//     Added by Harshitha
                dispatch_sync(dispatch_get_main_queue(), ^(void){
                
                [[GSPUtility sharedInstance]showAlertWithTitle:@"" message:errorMessage otherButton:@"Cancel" tag:1 andDelegate:self];
                });
            }
            else  if ([message isEqualToString:@"S"])
            {
//  Original code....Coomented by Harshitha to avoid explicit deletion of servicetask
            /*  if ([self.serviceTask.status isEqualToString:@"COMP"]) {
                   
                    [serviceOrderObject deleteServiceOrder:self.serviceTask.serviceOrder andFirstServiceItem:self.serviceTask.firstServiceItem];
                }
            */
//    Original Code
//                [[GSPUtility sharedInstance]showAlertWithTitle:@"" message:[[reponseArray objectAtIndex:3] objectAtIndex:0] otherButton:nil tag:0 andDelegate:self];

//    Modified by Harshitha
                dispatch_sync(dispatch_get_main_queue(), ^(void){
                
                    [[GSPUtility sharedInstance]showAlertWithTitle:@"" message:[[reponseArray objectAtIndex:3] objectAtIndex:0] otherButton:nil tag:2 andDelegate:self];
                });
            }
            
            
        }

    }
    else
    {
        [SVProgressHUD dismiss];
    }

}

//    *****   Added by Harshitha    *****
- (void) checkPopUpStatusAndCallPopUpView
{
    
    NSString *popUpStatus= [[NSUserDefaults standardUserDefaults] stringForKey:@"stateOfSwitch"];
    
    if([popUpStatus isEqual: @"ON"]){
        [self diagnoseInfo];
    }
    
}
//    *****   Added by Harshitha ends   *****

- (void) updateServiceTask
{

    NSString *_soUpdateQry = @"";
    NSMutableArray * tableNamesArray = [serviceOrderObject getTaskListRelatedTableNameArray];

    if (![self.serviceTask.estimatedArrivalDate isEqual:[NSNull null]])
    {


        //********DELETE ERROR MESSAGES RELATED TO THIS OBJECT_ID FROM TBL_ERRORLIST TABLE
        NSString *sqlQryStr3 = [NSString stringWithFormat:@"DELETE FROM 'TBL_ERRORLIST' WHERE apprefid = '%@'",self.serviceTask.serviceOrder];

        [serviceOrderObject deleteErrorTable:sqlQryStr3];
        
        //********DELETE ERROR END.



        NSMutableArray *_inptArray = [[NSMutableArray alloc] init];

        //Creating datatype of service confirmation

        NSString *strPar4 = [NSString stringWithFormat:@"%@", @"DATA-TYPE[.]ZGSXSMST_SRVCDCMNT20[.]OBJECT_ID[.]PROCESS_TYPE[.]NUMBER_EXT[.]ZZKEYDATE[.]STATUS[.]STATUS_REASON[.]TIMEZONE_FROM[.]ZZETADATE[.]ZZETATIME[.]ZZFIELDNOTE"];
        [_inptArray addObject:strPar4];
        
        self.serviceTask.timeZoneFrom = @"-18000000";

        //Creating the parameter of SOAP call to pass SAP...
        NSString *strPar5 = @"";

        NSString * postActionStr = [ contextDataClass getstatusPostSetActionForText:self.serviceTask.statusText ];

        if ([postActionStr rangeOfString:@"ASK-FOR-ETA"].location != NSNotFound && [self.serviceTask.status isEqualToString:@"ACPT"]) {

            strPar5 = [NSString stringWithFormat:@"ZGSXSMST_SRVCDCMNT20[.]%@[.]%@[.]%@[.]%@[.]%@[.][.]%@[.]%@[.]%@[.]%@",
                       self.serviceTask.serviceOrder,
                       self.serviceTask.serviceOrderType,
//                       self.serviceTask.numberExtension,
                       self.serviceTask.firstServiceItem,
                       [[GSPDateUtility sharedInstance] convertMMMDDformattoyyyMMdd:self.serviceTask.startDate],
                       self.serviceTask.status,
                       self.serviceTask.timeZoneFrom,
                       [[GSPDateUtility sharedInstance] convertMMMDDformattoyyyMMdd:self.serviceTask.estimatedArrivalDate],
                       self.serviceTask.estimatedArrivalTime,
                       self.serviceTask.fieldNote];


            _soUpdateQry= [NSString stringWithFormat:@"UPDATE '%@' SET ZZKEYDATE='%@', STATUS='%@', ZZETADATE='%@', ZZETATIME='%@',ZZFIELDNOTE = '%@' WHERE OBJECT_ID='%@' AND ZZSERVICEITEM = '%@' ",
                           [tableNamesArray objectAtIndex:0],
                           [[GSPDateUtility sharedInstance] convertMMMDDformattoyyyMMdd:self.serviceTask.startDate],
                           self.serviceTask.status,
                           [[GSPDateUtility sharedInstance] convertMMMDDformattoyyyMMdd:self.serviceTask.estimatedArrivalDate],
                           self.serviceTask.estimatedArrivalTime,
                           self.serviceTask.fieldNote,
                           self.serviceTask.serviceOrder,
                           self.serviceTask.firstServiceItem];
        }
        else if([postActionStr rangeOfString:@"ASK-FOR-REJECTION-REASON"].location != NSNotFound && [self.serviceTask.status isEqualToString:@"RJCT"])
        {
            NSString *rejReason = [NSString stringWithFormat:@"%@ %@",self.serviceTask.serviceOrderRejectionReason,self.serviceTask.rejectionDescription];

            strPar5 = [NSString stringWithFormat:@"ZGSXSMST_SRVCDCMNT20[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@[.][.][.]%@",
                       self.serviceTask.serviceOrder,
                       self.serviceTask.serviceOrderType,
//                       self.serviceTask.numberExtension,
                       self.serviceTask.firstServiceItem,
                       [[GSPDateUtility sharedInstance] convertMMMDDformattoyyyMMdd:self.serviceTask.startDate],
                       self.serviceTask.status,
                       rejReason,
                       self.serviceTask.timeZoneFrom,
                       self.serviceTask.fieldNote];

            _soUpdateQry= [NSString stringWithFormat:@"UPDATE '%@' SET ZZKEYDATE='%@', STATUS='%@', STATUS_REASON='%@' ,ZZFIELDNOTE = '%@' WHERE OBJECT_ID='%@' AND ZZSERVICEITEM = '%@' ",
                           [tableNamesArray objectAtIndex:0],
                           [[GSPDateUtility sharedInstance] convertMMMDDformattoyyyMMdd:self.serviceTask.startDate],
                           self.serviceTask.status,
                           rejReason,
                           self.serviceTask.fieldNote,
                           self.serviceTask.serviceOrder,
                           self.serviceTask.firstServiceItem];
        }
        else
        {
            strPar5 = [NSString stringWithFormat:@"ZGSXSMST_SRVCDCMNT20[.]%@[.]%@[.]%@[.]%@[.]%@[.][.]%@[.][.][.]%@",
                       self.serviceTask.serviceOrder,
                       self.serviceTask.serviceOrderType,
//                       self.serviceTask.numberExtension,
                       self.serviceTask.firstServiceItem,
                       [[GSPDateUtility sharedInstance] convertMMMDDformattoyyyMMdd:self.serviceTask.startDate],
                       self.serviceTask.status,
                       self.serviceTask.timeZoneFrom,
                       self.serviceTask.fieldNote];

            _soUpdateQry= [NSString stringWithFormat:@"UPDATE '%@' SET ZZKEYDATE='%@', STATUS='%@',ZZFIELDNOTE = '%@',STATUS_TXT30= '%@' WHERE OBJECT_ID='%@' AND ZZSERVICEITEM = '%@' ",
                           [tableNamesArray objectAtIndex:0],
                           [[GSPDateUtility sharedInstance] convertMMMDDformattoyyyMMdd:self.serviceTask.startDate],
                           self.serviceTask.status,
                           self.serviceTask.fieldNote,
                           self.serviceTask.statusText,
                           self.serviceTask.serviceOrder,
                           self.serviceTask.firstServiceItem];
            
        }

        [_inptArray addObject:strPar5];


        NSString *strDocumentData;
        NSString *strSignData;
        BOOL _updateStatus = FALSE;

// *****  Added by Harshitha  *****
        
        NSString *strPar6 = [NSString stringWithFormat:@"%@", @"ZGSXCAST_ATTCHMNT01[.]OBJECT_ID[.]OBJECT_TYPE[.]OBJECT_ZZSSRID[.]NUMBER_EXT[.]ATTCHMNT_ID[.]ATTCHMNT_CNTNT"];
        [_inptArray addObject:strPar6];
        
// *****  Added by Harshitha ends here  *****

        //Attach image as a document


        NSMutableArray *imagesArray = [[GSPUtility sharedInstance] getAttachedImagesFromLocalFolder:self.serviceTask.serviceOrder forPathComponent:@"AttchedImages"];

        if (imagesArray.count > 0)
        {
            for (NSString *imagesFilePath in imagesArray)
            {
                NSString    *folderPath     = [[GSPUtility sharedInstance] getMediaLocalPathForFileName:self.serviceTask.serviceOrder forPathComponent:@"AttchedImages"];
// Original code
//                NSData      *imageData      = [UIImagePNGRepresentation([UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",folderPath,imagesFilePath]]) base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
// Modified by Harshitha
                NSData      *imageData      = UIImagePNGRepresentation([UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",folderPath,imagesFilePath]]);

                NSString    *base64ImgString= [imageData base64Encoding];
                
                strDocumentData             = [NSString stringWithFormat:@"ZGSXCAST_ATTCHMNT01[.]%@[.]%@[.][.]%@[.]%@[.]%@",
                                               self.serviceTask.serviceOrder,
                                               self.serviceTask.serviceOrderType,
                                               self.serviceTask.firstServiceItem,
                                               [NSString stringWithFormat:@"%@/%@.png",folderPath,imagesFilePath],
                                               base64ImgString];
                
                [_inptArray addObject:strDocumentData];



            }

        }
        
        //Attach Signature as a document
        signatureFilePath       = [[GSPUtility sharedInstance] getSignatureFolderPathForFileName:self.serviceTask.serviceOrder forPathComponent:@"AttachedSignatures"];
        
        signatureImage          = [UIImage imageWithContentsOfFile:signatureFilePath];
        
        if (signatureImage) {
// Original code
//            NSData      * imageData         = [UIImagePNGRepresentation(signatureImage) base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
// Modified by Harshitha
            NSData *imageData = UIImagePNGRepresentation(signatureImage);
            NSString    * base64ImgString   = [imageData base64Encoding];
        
            strSignData                     = [NSString stringWithFormat:@"ZGSXCAST_ATTCHMNT01[.]%@[.]%@[.][.]%@[.]%@[.]%@",
                                               self.serviceTask.serviceOrder,
                                               self.serviceTask.serviceOrderType,
                                               self.serviceTask.firstServiceItem,
                                               [NSString stringWithFormat:@"%@.png",signatureFilePath],
                                               base64ImgString];
            
            [_inptArray addObject:strSignData];
            
        }

        
// Original code ..... Commented by Harshitha
//        [serviceOrderObject updateServiceOrder:_soUpdateQry];
        NSLog(@"Input array at request %@",_inptArray);
                [serviceOrderObject updateServiceOrderInSAPServerWithInputArray:_inptArray andReferenceID:self.serviceTask.serviceOrder];
       
     
    
// Modified by Harshitha
        GSPAppDelegate *appDelegateObj = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];
        if (![CheckedNetwork connectedToNetwork] && appDelegateObj.updateFailureFlag) {            
            
            [[GSPUtility sharedInstance] showAlertWithTitle:@"No Network Connection!" message:@"Please connect to internet to update" otherButton:nil tag:0 andDelegate:self];
            
        }
        else if(![CheckedNetwork connectedToNetwork] && !appDelegateObj.updateFailureFlag) {
            
            [serviceOrderObject updateServiceOrder:_soUpdateQry];
            [[GSPUtility sharedInstance] showAlertWithTitle:@"No Network Connection" message:@"The process added to queue." otherButton:nil tag:0 andDelegate:self];
        }
        

    }
}

// Added by Harshitha
- (void) diagnoseInfo
{
    
//    dispatch_sync(dispatch_get_main_queue(), ^{
        GSPDiagnosePopUpViewController *diagpopup;
    if (IS_IPAD) {
        diagpopup = [[GSPDiagnosePopUpViewController alloc]initWithNibName:@"GSPDiagnosePopUpViewController" bundle:nil withDiagnoseInfo:diagnoseArray andDisableDiagButton:1 fromScreen:@"serviceTaskDetailView"];
        diagpopup.view.frame = CGRectMake(self.view.bounds.size.width/2 - diagpopup.view.frame.size.width/2, self.view.bounds.size.height - (diagpopup.view.frame.size.height + 400 ), 495, 234);
    }
    else {
        diagpopup = [[GSPDiagnosePopUpViewController alloc]initWithNibName:@"GSPDiagnosePopUpViewController_iPhone" bundle:nil withDiagnoseInfo:diagnoseArray andDisableDiagButton:1 fromScreen:@"serviceTaskDetailView"];
        diagpopup.view.frame = CGRectMake(self.view.bounds.size.width/2 - diagpopup.view.frame.size.width/2, self.view.bounds.size.height - (diagpopup.view.frame.size.height + 200 ), 310, 188);
    }
        diagpopup.view.layer.borderColor = [UIColor blackColor].CGColor;
        diagpopup.view.layer.borderWidth = 1.0f;
        [self.view addSubview:diagpopup.view];
        [self addChildViewController:diagpopup];
        [diagpopup didMoveToParentViewController:self];
//    });
}

- (IBAction)mapButtonClicked:(id)sender {
    GSPMapViewController * mapViewController;
    
    if (IS_IPAD)
    {
        mapViewController = [[GSPMapViewController alloc]initWithNibName:@"GSPMapViewController_iPad" bundle:nil withAddress:self.serviceTask.locationAddress];
        mapViewController.modalPresentationStyle = 17;
        [mapViewController setModalTransitionStyle: UIModalTransitionStyleFlipHorizontal];
    }
    else
        mapViewController = [[GSPMapViewController alloc]initWithNibName:@"GSPMapViewController" bundle:nil withAddress:self.serviceTask.locationAddress];
    
    [self presentViewController:mapViewController animated:YES completion:nil];
}

- (IBAction)transferTaskButtonClicked:(id)sender {
    GSPColleguesViewController * colleguesViewController;
    
    if (IS_IPAD)
    {
        colleguesViewController = [[GSPColleguesViewController alloc]initWithNibName:@"GSPColleguesViewController_iPad" bundle:nil forTaskTasnfer:self.serviceTask];
    }
    else
        colleguesViewController = [[GSPColleguesViewController alloc]initWithNibName:@"GSPColleguesViewController" bundle:nil forTaskTasnfer:self.serviceTask];
    
    [self.navigationController pushViewController:colleguesViewController animated:YES];
}
- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self;
}
- (IBAction)generatePDFButtonClicked:(id)sender {
  //[[PDFRenderer sharedInstance] drawPDFFromTableForServicOrder:self.serviceTask.serviceOrder WithTableViewView:self.detailTableView1_Landscape withAttacments:[[GSPUtility sharedInstance] getAttachedImagesFromLocalFolder:self.serviceTask.serviceOrder forPathComponent:@"AttchedImages"] andSignature:signatureImage];
//    [[PDFRenderer sharedInstance] drawPDFFromTableForServicOrder:self.serviceTask.serviceOrder WithTableViewView:self.detailTableView1_Landscape withAttacments:[[GSPUtility sharedInstance] getAttachedImagesFromLocalFolder:self.serviceTask.serviceOrder forPathComponent:@"AttchedImages"] andSignature:signatureImage];
//    [[PDFRenderer sharedInstance] drawPDFFofTableForServicOrder:self.serviceTask.serviceOrder withObject:self.serviceTask WithArray:self.serviceOrdersArray withAttacments:[[GSPUtility sharedInstance] getAttachedImagesFromLocalFolder:self.serviceTask.serviceOrder forPathComponent:@"AttchedImages"] andSignature:signatureImage];
    
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:@"Select the language"
                                message:nil
                                preferredStyle:UIAlertControllerStyleActionSheet];
    
       UIAlertAction* button1 = [UIAlertAction
                              actionWithTitle:@"French"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  
                                  NSString *filePath=[[NSBundle mainBundle]pathForResource:@"frenchTranslated" ofType:@"strings"];
                                  NSDictionary *translatedDic=[NSDictionary dictionaryWithContentsOfFile:filePath];
                                  
                                  [[PDFRenderer sharedInstance] drawPDFofTableForServicOrder:self.serviceTask.serviceOrder withObject :self.serviceTask  WithArray:self.serviceOrdersArray withAttacments:[[GSPUtility sharedInstance] getAttachedImagesFromLocalFolder:self.serviceTask.serviceOrder forPathComponent:@"AttchedImages"]andSignature:signatureImage withTranslatedDictionary:translatedDic];
                                  
                                  
                                  [self viewPDF];
                                 
                              }];
    
    UIAlertAction* button2 = [UIAlertAction
                              actionWithTitle:@"German"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                 
                                  
                                  NSString *filePath=[[NSBundle mainBundle]pathForResource:@"GermanTranslated" ofType:@"strings"];
                                  NSDictionary *translatedDic=[NSDictionary dictionaryWithContentsOfFile:filePath];
                                  
                                  [[PDFRenderer sharedInstance] drawPDFofTableForServicOrder:self.serviceTask.serviceOrder withObject :self.serviceTask  WithArray:self.serviceOrdersArray withAttacments:[[GSPUtility sharedInstance] getAttachedImagesFromLocalFolder:self.serviceTask.serviceOrder forPathComponent:@"AttchedImages"]andSignature:signatureImage withTranslatedDictionary:translatedDic];
                                  
                                  
                                  [self viewPDF];
                              }];
    
    UIAlertAction* button3 = [UIAlertAction
                              actionWithTitle:@"English"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  
                                  
                                  NSString *filePath=[[NSBundle mainBundle]pathForResource:@"default_lang" ofType:@"strings"];
                                  NSDictionary *translatedDic=[NSDictionary dictionaryWithContentsOfFile:filePath];
                                  
                                  [[PDFRenderer sharedInstance] drawPDFofTableForServicOrder:self.serviceTask.serviceOrder withObject :self.serviceTask  WithArray:self.serviceOrdersArray withAttacments:[[GSPUtility sharedInstance] getAttachedImagesFromLocalFolder:self.serviceTask.serviceOrder forPathComponent:@"AttchedImages"]andSignature:signatureImage withTranslatedDictionary:translatedDic];
                                  
                                  
                                  [self viewPDF];
                              }];
    
    UIAlertAction* button4 = [UIAlertAction
                              actionWithTitle:@"Portuguese"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  
                                  
                                  NSString *filePath=[[NSBundle mainBundle]pathForResource:@"PortugueseTranslated" ofType:@"strings"];
                                  NSDictionary *translatedDic=[NSDictionary dictionaryWithContentsOfFile:filePath];
                                  
                                  [[PDFRenderer sharedInstance] drawPDFofTableForServicOrder:self.serviceTask.serviceOrder withObject :self.serviceTask  WithArray:self.serviceOrdersArray withAttacments:[[GSPUtility sharedInstance] getAttachedImagesFromLocalFolder:self.serviceTask.serviceOrder forPathComponent:@"AttchedImages"]andSignature:signatureImage withTranslatedDictionary:translatedDic];
                                  
                                  
                                  [self viewPDF];
                              }];

    [alert addAction:button3];
    [alert addAction:button1];
    [alert addAction:button2];
    [alert addAction:button4];
    alert.popoverPresentationController.sourceView = self.view;
    alert.popoverPresentationController.sourceRect = [(UIButton *)sender frame];  // this is the center of the screen currently but it can be any point in the view
    
   // self.presentViewController(alertView, animated: true, completion: nil)
 
    [self presentViewController:alert animated:YES completion:nil];
    
    
    }

    
//    if (IS_IPAD) {
//        docViewer   = [[GSPDocViewerViewController alloc]initWithNibName:@"GSPDocViewerViewController_iPad" bundle:nil withData:pdfData andFileName:self.serviceTask.serviceOrder];
//    }
//    else
//        docViewer   = [[GSPDocViewerViewController alloc]initWithNibName:@"GSPDocViewerViewController" bundle:nil withData:pdfData andFileName:self.serviceTask.serviceOrder];
//    
//    
//    [self.navigationController pushViewController:docViewer animated:YES];
    
//    NSData *pdfData = [GSPServiceTaskDetailViewController pdfDataOfScrollView:self.detailTableView1_Landscape];
//       UIGraphicsBeginPDFPage();
//     NSData *pdfData2 = [GSPServiceTaskDetailViewController pdfDataOfScrollView:self.detailTableView2_Landscape];
//
////    NSString *tmpDirectory = NSTemporaryDirectory();
////    NSString *path = [tmpDirectory stringByAppendingPathComponent:@"image.pdf"];
//     NSString * aFileName =  [[PDFRenderer sharedInstance] getPdfFileName:self.serviceTask.serviceOrder];
//    [pdfData writeToFile:aFileName atomically:NO];
//    //UIGraphicsBeginPDFPage();
//    [pdfData2 writeToFile:aFileName atomically:NO];
////
////
//    NSMutableData *pdfData = [NSMutableData data];
//
//        UIView *aView=self.detailTableView1_Landscape;
//    UIView *bView=self.detailTableView2_Landscape;
//    
//            // Points the pdf converter to the mutable data object and to the UIView to be converted
//            UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil);
//    
//            CGContextRef pdfContext1= UIGraphicsGetCurrentContext();
//    
//    
//            // draws rect to the view and thus this is captured by UIGraphicsBeginPDFContextToData
//      UIGraphicsBeginPDFPage();
//           [aView.layer renderInContext:pdfContext1];
//    CGContextRef pdfContext2= UIGraphicsGetCurrentContext();
//
//      UIGraphicsBeginPDFPage();
//     [bView.layer renderInContext:pdfContext2];
//
//    
//            // remove PDF rendering context
//            UIGraphicsEndPDFContext();
//    
//            // Retrieves the document directories from the iOS device
////            NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
//            NSString * aFileName =  [[PDFRenderer sharedInstance] getPdfFileName:self.serviceTask.serviceOrder];
////            NSString* documentDirectory = [documentDirectories objectAtIndex:0];
////            NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:aFilename];
//    
//            // instructs the mutable data object to write its context to a file on disk
    
//    
//    NSMutableData *pdfData = [NSMutableData data];
//    UIView *aView=self.detailTableView1_Landscape;
//    //    UIView *bView=self.detailTableView2_Landscape;
//
//      NSString * aFileName =  [[PDFRenderer sharedInstance] getPdfFileName:self.serviceTask.serviceOrder];
//    // Get Scrollview size
//    CGFloat maxHeight = kDefaultPageHeight - 2 * kMargin;
//    CGFloat maxWidth = kDefaultPageWidth - 2 * kMargin;
//
//    // Set up we the pdf we're going to be generating is
//    CGRect scrollSize =CGRectMake(0.f, 0.f, maxWidth, maxHeight);
//   // CGRect scrollSize = CGRectMake(0,0,aView.width,aView.height);
//    
//    
//    // Points the pdf converter to the mutable data object and to the UIView to be converted
//    UIGraphicsBeginPDFContextToData(pdfData, scrollSize, nil);
//    UIGraphicsBeginPDFPage();
//    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
//    
//    
//    // draws rect to the view and thus this is captured by UIGraphicsBeginPDFContextToData
//    
//    [aView.layer renderInContext:pdfContext];
//    UIGraphicsBeginPDFPage();
//     pdfData = [[PDFRenderer sharedInstance] pdfDataOfScrollView:self.detailTableView2_Landscape ];
    // remove PDF rendering context
//    self.serverAttachmentButtonClicked  =NO;
//    self.additionalPartnersButtonClicked=NO;
//    [self showContentsButtonsClicked:8];
//[self showContentsButtonsClicked:9];
//    NSData *pdfData = [[PDFRenderer sharedInstance] pdfDataOfScrollView:self.serviceTask.serviceOrder andOneTableView :self.detailTableView1_Landscape andTableView:self.detailTableView2_Landscape withAttacments:[[GSPUtility sharedInstance] getAttachedImagesFromLocalFolder:self.serviceTask.serviceOrder forPathComponent:@"AttchedImages"] andSignature:signatureImage];
// 
//    UIGraphicsEndPDFContext();
//
//     NSString * aFileName =  [[PDFRenderer sharedInstance] getPdfFileName:self.serviceTask.serviceOrder];
//
//            [pdfData writeToFile:aFileName atomically:YES];
//            NSLog(@"documentDirectoryFileName: %@",aFileName);
//    GSPDocViewerViewController *docViewer  ;
//    
//    if (IS_IPAD) {
//        docViewer   = [[GSPDocViewerViewController alloc]initWithNibName:@"GSPDocViewerViewController_iPad" bundle:nil withData:pdfData andFileName:self.serviceTask.serviceOrder];
//    }
//    else
//        docViewer   = [[GSPDocViewerViewController alloc]initWithNibName:@"GSPDocViewerViewController" bundle:nil withData:pdfData andFileName:self.serviceTask.serviceOrder];
//    
//    
//    [self.navigationController pushViewController:docViewer animated:YES];

//
//+ (NSMutableData *)pdfDataOfScrollView:(UIScrollView *)scrollView {
//    CGRect origFrame = scrollView.frame;
//    BOOL horizontalScrollIndicator = [scrollView showsHorizontalScrollIndicator];
//    BOOL verticalScrollIndicator = [scrollView showsVerticalScrollIndicator];
//    
//    NSMutableData *pdfFile = [[NSMutableData alloc] init];
//    CGDataConsumerRef pdfConsumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef) pdfFile);
//    CGRect mediaBox = CGRectZero;
//    CGFloat maxHeight = kDefaultPageHeight - 2 * kMargin;
//    CGFloat maxWidth = kDefaultPageWidth - 2 * kMargin;
//    CGFloat height = scrollView.contentSize.height;
//    // Set up we the pdf we're going to be generating is
//    [scrollView setFrame:CGRectMake(0.f, 0.f, maxWidth, maxHeight)];
//    NSInteger pages = (NSInteger) ceil(height / maxHeight);
//    
//    
//    NSMutableData *pdfData = [NSMutableData data];
//  
//    [self prepareForCapture:scrollView];
//    UIGraphicsBeginPDFContextToData(pdfData, CGRectZero, nil);
//    for (int i = 0 ;i < pages ;i++){
//        if (maxHeight * (i + 1) > height){
//            // Check to see if page draws more than the height of the UIWebView
//            CGRect scrollViewFrame = [scrollView frame];
//            scrollViewFrame.size.height -= (((i + 1) * maxHeight) - height);
//            [scrollView setFrame:scrollViewFrame];
//        }
//      UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, kDefaultPageWidth, kDefaultPageHeight), nil);
//        //CGContextRef currentContext1 = UIGraphicsGetCurrentContext();
//        // Specify the size of the pdf page
//      //  UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, kDefaultPageWidth, kDefaultPageHeight), nil);
//        CGContextRef currentContext = UIGraphicsGetCurrentContext();
//     
//        //[self drawPageNumber:(i + 1)];
//        // Move the context for the margins
//  
//        CGContextTranslateCTM(currentContext, kMargin, -(maxHeight * i) + kMargin);
//   
//        [scrollView setContentOffset:CGPointMake(0, maxHeight * i) animated:NO];
//        // draw the layer to the pdf, ignore the "renderInContext not found" warning.
//        [scrollView.layer renderInContext:currentContext];
//        
//
//    }
//    // all done with making the pdf
//    UIGraphicsEndPDFContext();
//    [scrollView setFrame:origFrame];
//    [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
//    [scrollView setShowsHorizontalScrollIndicator:horizontalScrollIndicator];
//    [scrollView setShowsVerticalScrollIndicator:verticalScrollIndicator];
//    return pdfData;
//}
//
//
//+ (void)prepareForCapture:(UIScrollView *)scrollView {
//       [scrollView setContentOffset:CGPointZero animated:NO];
//
//    [scrollView setShowsHorizontalScrollIndicator:NO];
//    [scrollView setShowsVerticalScrollIndicator:NO];
//}




-(void)viewPDF
{
    NSString *path=[[PDFRenderer sharedInstance]getPdfFileName:self.serviceTask.serviceOrder] ;
    
    // NSURL *URL = [[NSBundle mainBundle] URLForResource:self.serviceTask.serviceOrder withExtension:@"pdf"];
    // GSPDocViewerViewController *docViewer  ;
    NSURL *URL=[NSURL fileURLWithPath:path];
    if (URL) {
        // Initialize Document Interaction Controller
        self->documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:URL];
        
        // Configure Document Interaction Controller
        [self->documentInteractionController setDelegate:self];
        
        // Preview PDF
        [self->documentInteractionController presentPreviewAnimated:YES];
    }
    
}
    



- (IBAction)confirmationButtonClicked:(id)sender {
    GSPServiceConfirmationViewController * serviceConfirmationVC;
    
    if (IS_IPAD) {
        serviceConfirmationVC = [[GSPServiceConfirmationViewController alloc]initWithNibName:@"GSPServiceConfirmationViewController_iPad" bundle:nil forObject:self.serviceTask];
    }
    else
    {
        serviceConfirmationVC = [[GSPServiceConfirmationViewController alloc]initWithNibName:@"GSPServiceConfirmationViewController" bundle:nil forObject:self.serviceTask];
    }
    
    
    [self.navigationController pushViewController:serviceConfirmationVC animated:YES];
}
-(void)Hide {
    _hintLabel.hidden = true;
    _hintNextLabel.hidden=true;
    //You can remove timer here.
}

- (IBAction)hint_prev:(id)sender {
    _hintLabel.hidden=false;
    NSTimer *timer;
    NSLog(@"hint button clicked");
    _hintLabel.text =@"service task of the same service order";
    timer = [NSTimer scheduledTimerWithTimeInterval: 5
                                             target: self
                                           selector: @selector(Hide)
                                           userInfo: nil
                                            repeats: NO];
   

    
    //linkTextView.layer.cornerRadius = 5.0;
   }

- (IBAction)hint_next:(id)sender {
    _hintNextLabel.hidden=false;
    NSTimer *timer;
    NSLog(@"hint button clicked");
    _hintNextLabel.text =@"service task of the same service order";
    timer = [NSTimer scheduledTimerWithTimeInterval: 5
                                             target: self
                                           selector: @selector(Hide)
                                           userInfo: nil
                                            repeats: NO];
    
}


- (void)wasDragged:(UIPanGestureRecognizer *)recognizer {
    
    UIView *signImage = (UIView*)recognizer.view;
//    UIImageView *signImage =(UIImageView*)recognizer.view;
    //    UIImagewView *imageView = (UIImagewView *)recognizer.view;
    CGPoint translation = [recognizer translationInView:signImage];
    
    signImage.center = CGPointMake(signImage.center.x + translation.x, signImage.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:signImage];
}
-(void)backButtonClicked{
//    GSPAppDelegate *appDelegateObj = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];
//    if( appDelegateObj.notificationLaunched){
    
        GSPServiceTasksViewController *serviceTasksVC ;
        NSString *selectedColleagueName;
        //    NSString *colleague_uName;
        Colleagues *selectedColleague;
        ServiceTask *transferTask;
        
        if (IS_IPAD)
        {
            //        serviceTasksVC  = [[GSPServiceTasksViewController alloc]initWithNibName:@"GSPServiceTasksViewController_iPad" bundle:nil forView:serviceTaskOverView withTitle:selectedColleagueName anduName:colleague_uName];
            serviceTasksVC  = [[GSPServiceTasksViewController alloc]initWithNibName:@"GSPServiceTasksViewController_iPad" bundle:nil forView:serviceTaskOverView withTitle:selectedColleagueName andSelectedColleague:selectedColleague transferTask:transferTask];
        }
        else
        {
            //        serviceTasksVC  = [[GSPServiceTasksViewController alloc]initWithNibName:@"GSPServiceTasksViewController" bundle:nil forView:serviceTaskOverView withTitle:selectedColleagueName anduName:colleague_uName];
            
            serviceTasksVC  = [[GSPServiceTasksViewController alloc]initWithNibName:@"GSPServiceTasksViewController" bundle:nil forView:serviceTaskOverView withTitle:selectedColleagueName andSelectedColleague:selectedColleague transferTask:transferTask];
            
        }
        
        [self.navigationController pushViewController:serviceTasksVC animated:YES];
        
//    }

    
}

//-(void)startAnimatingErrorLabel{
//    
//    [UIView animateWithDuration:8.0f delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
//        _errorDisplay.frame = CGRectMake(-320,100,_errorDisplay.frame.size.width,_errorDisplay.frame.size.height);
//    } completion:^(BOOL finished)
//     {
//         _errorDisplay.frame = CGRectMake(0,100,_errorDisplay.frame.size.width,_errorDisplay.frame.size.height);
//     }];
//
//

//    CGRect initialFrame = _errorDisplay.frame;
//    
//    // Displace the label so it's hidden outside of the screen before animation starts.
//    CGRect displacedFrame = initialFrame;
//    displacedFrame.origin.x = -100;
//    _errorDisplay.frame = displacedFrame;
//    
//    // Restore label's initial position during animation.
//    [UIView animateWithDuration:0.3 animations:^{
//        _errorDisplay.frame = initialFrame;
//    }];
    
//}
@end
