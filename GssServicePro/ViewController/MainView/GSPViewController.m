//
//  GSPViewController.m
//  GssServicePro
//
//  Created by Riyas Hassan on 04/06/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "GSPViewController.h"
#import "GSPServiceTasksViewController.h"
#import "GSPInfoScreenViewController.h"
#import "GssMobileConsoleiOS.h"
#import "ServiceOrderClass.h"
#import "ServiceTask.h"
#import "ContextDataClass.h"
#import "GSPDiagnosePopUpViewController.h"
#import "GSPOfflineViewConfiguration.h"
#import "CheckedNetwork.h"
#import "GSPKeychainStoreManager.h"

@interface GSPViewController ()<CLLocationManagerDelegate>{
    ContextDataClass    *objContextDataClass;
}

@property (weak, nonatomic) IBOutlet UIButton *totalServiceTaskButton;
//@property (weak, nonatomic) IBOutlet UIButton *completedTaskButton;
@property (weak, nonatomic) IBOutlet UIButton *vanStockButton;
@property (weak, nonatomic) IBOutlet UIButton *utilisationButton;
//@property (weak, nonatomic) IBOutlet UIButton *absenceReqButton;
@property (weak, nonatomic) IBOutlet UIButton *activitiesButton;
@property (weak, nonatomic) IBOutlet UIButton *contatcsButton;
@property (weak, nonatomic) IBOutlet UIButton *billableButton;

- (IBAction)totalServiceTasksButtonClick:(id)sender;
- (IBAction)taskForTheDayButtonClicked:(id)sender;
- (IBAction)vanStockButtonClicked:(id)sender;
- (IBAction)utilizationButtonClicked:(id)sender;
- (IBAction)contactsButtonClicked:(id)sender;
- (IBAction)billableButtonClicked:(id)sender;
- (IBAction)activitiesButtonClicked:(id)sender;

-(void) refreshBtnClicked;
-(void)initializeServiceTasksApiCall;

@property (weak, nonatomic) IBOutlet UILabel *nextServiceOrgName;
@property (weak, nonatomic) IBOutlet UILabel *nextServiceLocation1;
@property (weak, nonatomic) IBOutlet UILabel *nextServiceLocation2;
@property (weak, nonatomic) IBOutlet UILabel *nextServiceLocation3;
@property (weak, nonatomic) IBOutlet UILabel *contactName;
@property (weak, nonatomic) IBOutlet UIButton *contactNum1Button;
@property (weak, nonatomic) IBOutlet UIButton *contactNum2Button;
@property (weak, nonatomic) IBOutlet UILabel *totalNumOfTasksLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfTasksForTodayLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneIcon1;
@property (weak, nonatomic) IBOutlet UIButton *phoneIcon2;
@property (strong, nonatomic) NSMutableArray * serviceTaskArray,* todayServiceTasksLocationArray;
@property (weak, nonatomic) NSString *contactNumber;
@property (weak, nonatomic) IBOutlet UIButton *emailIDButton;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIWebView *mapWebView;
@property (nonatomic) CLLocationCoordinate2D coords;
@property (nonatomic) CLLocationCoordinate2D currentLocation;

@end

@implementation GSPViewController

GSPAppDelegate *appDelegateObj;
ServiceTask *serviceTask;
int numOfTasksForToday;
//NSMutableArray *diagnoseArray1;


/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
//    GSPViewController *view = (GSPViewController *)[nibNameOrNil dequeueReusableCellWithIdentifier:@"GSPViewController_iPad"];
    

    /NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:@"GSPViewController_iPad" owner:self options:nil];
    
    if (self.interfaceOrientation == UIDeviceOrientationPortrait || self.interfaceOrientation == UIDeviceOrientationPortraitUpsideDown){
        self = (GSPViewController *)[nib objectAtIndex:1];
    }
    else {
        self = (GSPViewController *)[nib objectAtIndex:0];
    }
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
   // diagnoseArray1=[[NSMutableArray alloc]init];
    
//    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
//    [self setUpViewForOrientation:interfaceOrientation];
    appDelegateObj = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];
    appDelegateObj.mainViewController=self;

    [self createDataBases];
      objContextDataClass  = [ContextDataClass new];
    
    _diagnoseArray1 = [[NSMutableArray alloc]init];
    
    
    
   //    [[NSNotificationCenter defaultCenter] postNotificationName:@"StartAcitivityIndicator" object:nil];
    
 //   [[NSNotificationCenter defaultCenter] postNotificationName:@"AcitivityIndicatorForContextData" object:nil];
    
    
    
//    [self initialiseVariables];
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self setUpViewForOrientation:toInterfaceOrientation];
}

-(void)setUpViewForOrientation:(UIInterfaceOrientation)orientation
{
    //[self.view removeFromSuperview];
    GSPViewController *screen;
    if (IS_IPAD) {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if(UIInterfaceOrientationIsLandscape(orientation))
            screen= [[GSPViewController alloc] initWithNibName:@"GSPViewController_iPad" bundle:nil];
        else
            screen= [[GSPViewController alloc] initWithNibName:@"GSPViewController_iPad_Portrait" bundle:nil];
    }
    else
    {
        screen = [[GSPViewController alloc] initWithNibName:@"GSPViewController" bundle:nil];
    }
    [self.navigationController pushViewController:screen animated:YES];
    
  //  [self viewDidLoad];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:appDelegateObj];
   }

-(void)viewDidAppear:(BOOL)animated {
    NSLog(@"View did appear called");
}
-(void)viewWillAppear:(BOOL)animated
{
    [self viewDidLoad];
    [super viewWillAppear:animated];
    
   
    
/*    if (self.interfaceOrientation == UIDeviceOrientationPortrait || self.interfaceOrientation == UIDeviceOrientationPortraitUpsideDown)
    {
        self.view = [[GSPViewController alloc] initWithNibName:@"GSPViewController_iPad_Portrait" bundle:nil];
    } else {
        self.view = [[GSPViewController alloc] initWithNibName:@"GSPViewController_iPad" bundle:nil];
    }
*/
    
   
//    diagnoseArray1=[[NSMutableArray alloc]init];
   
  //  [self setUpViewForOrientation:interfaceOrientation];
    [[GSPOfflineViewConfiguration sharedInstance] checkReachabilityAndCofigureView:self];

  //  appDelegateObj = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];
    appDelegateObj.activeApp = @"Main";
    
    [self setNavigationTitleWithBrandImage:nil];
    [self setLeftNavigationBarButtonWithImage:@"ServiceProIcon.png"];
    
    [self initialiseVariables];
    
    [self getUserCurrentLocation];
//    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
//  [self setUpViewForOrientation:interfaceOrientation];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBtnClicked) name:@"callServiceOrderApi" object:nil];
    
//    if((!appDelegateObj.didResignActive)&&(!appDelegateObj.didFinishLaunchFlag)){
    
    
    if(appDelegateObj.appFirstLaunchFlag){
        appDelegateObj.appFirstLaunchFlag =FALSE;
        
        appDelegateObj.openQPApp = FALSE;
        if(!appDelegateObj.QPinstalledFlag){
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerForServiceTask:) name:@"StartAcitivityIndicator" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerForServiceTask:) name:@"AcitivityIndicatorForContextData" object:nil];
        
        [self initializeServiceTasksApiCall];
       
    }
        
    }
    
    
    
//    else if(!appDelegateObj.appFirstLaunchFlag){
//
//   
//    
//    if ( appDelegateObj.saveChangesFlag) {
//        
//        appDelegateObj.saveChangesFlag = FALSE;
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerForServiceTask:) name:@"StartAcitivityIndicator" object:nil];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerForServiceTask:) name:@"AcitivityIndicatorForContextData" object:nil];
//        
//        [self initializeServiceTasksApiCall];
//    }
//    else if (appDelegateObj.didBecomeActive) {
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerForServiceTask:) name:@"StartAcitivityIndicator" object:nil];
//        [self initializeServiceTasksApiCall];
//        
//        appDelegateObj.didBecomeActive = FALSE;
//    }
//    }
    [self initialiseVariables];
    
    [self setUpView];
   

}

//  ***** Added by Harshitha starts here  *****
- (void) getServiceTasksFromStorage
{
    ServiceOrderClass * serviceOrderClass = [ServiceOrderClass new];
    self.serviceTaskArray =  [serviceOrderClass GetAllServiceOrder];
}




- (void) initialiseVariables
{
    
    
  // diagnoseArray1=[[NSMutableArray alloc]init];
  //  appDelegateObj = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];
  
    
    self.serviceTaskArray    = [[NSMutableArray alloc]init];
    self.todayServiceTasksLocationArray = [[NSMutableArray alloc]init];
    
    [self getServiceTasksFromStorage];
    
    if (self.serviceTaskArray.count > 0)
    {
//    ServiceTask *serviceTask;
    serviceTask = [self.serviceTaskArray objectAtIndex:0];
    
    self.totalNumOfTasksLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.serviceTaskArray.count];
    self.nextServiceOrgName.text = serviceTask.serviceLocation;
    self.nextServiceLocation1.text = serviceTask.locationAddress1;
    self.nextServiceLocation2.text = serviceTask.locationAddress2;
    self.nextServiceLocation3.text = serviceTask.locationAddress3;
    self.contactName.text = serviceTask.contactName;
    if (serviceTask.telNum.length > 0) {
        self.phoneIcon1.hidden = NO;
        self.contactNum1Button.hidden = NO;
        [self.contactNum1Button setTitle:serviceTask.telNum forState:UIControlStateNormal];
        self.contactNum1Button.tag = 1;
        [self.contactNum1Button addTarget:self action:@selector(callButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.phoneIcon1.tag = 1;
        [self.phoneIcon1 addTarget:self action:@selector(callButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (serviceTask.altTelNum.length > 0) {
        self.phoneIcon2.hidden = NO;
        self.contactNum2Button.hidden = NO;
        [self.contactNum2Button setTitle:serviceTask.altTelNum forState:UIControlStateNormal];
        self.contactNum2Button.tag = 2;
        [self.contactNum2Button addTarget:self action:@selector(callButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }

    self.coords = [self addressLocationWithAdress:serviceTask.locationAddress];
        
    numOfTasksForToday = 0;
    GSPDateUtility *objCurrentDateTime = [GSPDateUtility sharedInstance];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *todayDate = [formatter stringFromDate:[NSDate date]];
    todayDate = [objCurrentDateTime convertShortDateToStringFormat:todayDate];
    for (int i=0 ; i<self.serviceTaskArray.count ; i++)
    {
        ServiceTask *task = [self.serviceTaskArray objectAtIndex:i];
        if ([todayDate isEqualToString:task.startDate]) {
            numOfTasksForToday++;
            [self.todayServiceTasksLocationArray addObject:task.locationAddress];
        }
    }
    self.numOfTasksForTodayLabel.text = [NSString stringWithFormat:@"%d", numOfTasksForToday];
        NSLog(@"today's task %d",numOfTasksForToday);
    }
    
    [self setUpView];

}

- (void)setUpView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
  //  [self setCustomRightBarButtonItem:@selector(infoBarButtonClicked) withImageNamed:@"info_btn.png"];
   // diagnoseArray1=[[NSMutableArray alloc]init];
    if(IS_IPAD){
    UIButton *refreshBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(refreshBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [refreshBtn setFrame:CGRectMake(150, 0, 32, 32)];
    
    
    UIButton *settingsBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsBtn setImage:[UIImage imageNamed:@"info_btn.png"] forState:UIControlStateNormal];
[settingsBtn addTarget:self action:@selector(infoBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [settingsBtn setFrame:CGRectMake(190, 0, 32, 32)];
    
    NSString *lastSyncTime=[[NSUserDefaults standardUserDefaults]stringForKey:@"last_sync_time"];
    
    UILabel *refreshLabel=[[UILabel alloc]initWithFrame:(CGRectMake(0, 0, 150, 42))];
    
    refreshLabel.text=[NSString stringWithFormat:@"Last synced\n%@",lastSyncTime];
    refreshLabel.adjustsFontSizeToFitWidth = YES;
    refreshLabel.numberOfLines = 0;
    refreshLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:20];
    NSLog(@"Last synced time %@",refreshLabel.text);
  
    
    UIView *rightBarButtonItems = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 230, 32)];
    [rightBarButtonItems addSubview:refreshBtn];
    [rightBarButtonItems addSubview:settingsBtn];
    [rightBarButtonItems addSubview:refreshLabel];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonItems];
    
    
    self.mapWebView.layer.cornerRadius = 7.0;
    self.mapWebView.layer.borderWidth  = 2.0;
    self.mapWebView.layer.borderColor  = [[UIColor darkGrayColor]CGColor];
    
    [self.segmentedControl addTarget:self
                              action:@selector(segmentControllerSelectionChanged:)
                    forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.selectedSegmentIndex = 0;
    [self segmentControllerSelectionChanged:nil];
    }
    else
        [self setCustomRightBarButtonItem:@selector(infoBarButtonClicked) withImageNamed:@"info_btn.png"];

   }


-(void) segmentControllerSelectionChanged:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    
    switch ([segmentedControl selectedSegmentIndex]) {
        case 0:
            [self showGoogleMap];
            break;
            
        case 1:
            [self showItinerary];
            break;
            
        default:
            break;
    }
    
}


- (void) showGoogleMap
{
    [[NSUserDefaults standardUserDefaults] setInteger:GoogleMapSelected forKey:DEFAULT_SELECTED_MAP];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.mapWebView setHidden:NO];
    if (self.serviceTaskArray.count > 0)
        [self showMapOnWebview];
}

-(void)showMapOnWebview
{
    NSString *fullUrl = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f&view=map&output=embed",self.currentLocation.latitude,self.currentLocation.longitude,self.coords.latitude,self.coords.longitude];
    
    NSURL *url = [NSURL URLWithString:[fullUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSString *embedHTML = [NSString stringWithFormat:@"<html><head><title>.</title><style>body,html,iframe{margin:0;padding:0;}</style></head><body><iframe width=\"%f\" height=\"%f\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe></body></html>" ,self.mapWebView.frame.size.width, self.mapWebView.frame.size.height, url];
    
    [self.mapWebView loadHTMLString:embedHTML baseURL:url];
    
}

- (void) showItinerary
{
    [[NSUserDefaults standardUserDefaults] setInteger:GoogleMapSelected forKey:DEFAULT_SELECTED_MAP];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.mapWebView setHidden:NO];
//    if (self.todayServiceTasksLocationArray.count > 0)
        [self showItineraryOnWebview];
}

-(void)showItineraryOnWebview
{
    NSString *fullUrl = [NSString stringWithFormat:@"https://www.google.co.in/maps/dir/505 Thornall St, Edison, NJ 08837, USA"];

    for (int i = 0;  i < self.todayServiceTasksLocationArray.count; i++ )
    {
        fullUrl = [NSString stringWithFormat:@"%@/%@",fullUrl,self.todayServiceTasksLocationArray[i]];
    }
    fullUrl = [NSString stringWithFormat:@"%@/US&view=map&output=embed",fullUrl];
    
//    NSString *fullUrl = [NSString stringWithFormat:@"https://maps.google.com/maps/dir/Mysore/Chennai/Bengaluru/Coimbatore/Mangalore/Hassan&view=map&output=embed"];
    
    NSURL *url = [NSURL URLWithString:[fullUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSString *embedHTML = [NSString stringWithFormat:@"<html><head><title>.</title><style>body,html,iframe{margin:0;padding:0;}</style></head><body><iframe width=\"%f\" height=\"%f\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe></body></html>" ,self.mapWebView.frame.size.width, self.mapWebView.frame.size.height, url];
    
    [self.mapWebView loadHTMLString:embedHTML baseURL:url];
    
}

-(void)getUserCurrentLocation
{
//DISABLED  FOR TESTING PURPOSE
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    
    if ([CLLocationManager locationServicesEnabled])
    {
        locationManager.delegate        = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter  = kCLDistanceFilterNone;
        [locationManager startUpdatingLocation];
    }
    
    CLLocation *location    = [locationManager location];
    self.currentLocation        = [location coordinate];
    
    NSString *str=[[NSString alloc] initWithFormat:@" latitude:%f longitude:%f",_currentLocation.latitude,_currentLocation.longitude];
    NSLog(@"%@",str);
    
//END
    
//    Hardcoded by Harshitha for demo purpose
    _currentLocation.latitude = 40.56509;
    _currentLocation.longitude = -74.33130;
    
}

-(CLLocationCoordinate2D) addressLocationWithAdress: (NSString*) addressString {
    
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    
    if (result) {
        
        NSScanner *scanner = [NSScanner scannerWithString:result];
        
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            
            [scanner scanDouble:&latitude];
            
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                
                [scanner scanDouble:&longitude];
            }
        }
    }
    
    CLLocationCoordinate2D center;
    center.latitude=latitude;
    center.longitude = longitude;
    NSLog(@"Latitude : %f",center.latitude);
    NSLog(@"Longitude : %f",center.longitude);
    return center;
    
}

- (void) callButtonClicked:(id)sender
{
    UIButton * callbutton = (UIButton*) sender;
    
    //    NSString * contactNumber;
    
    switch (callbutton.tag) {
        case 1:
            self.contactNumber = serviceTask.telNum;
            break;
            // Original code
            //        case AltrTeleNumRow:
            // Modified by Harshitha
        case 2:
            self.contactNumber = serviceTask.altTelNum;
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
    callActionSheet.tag = 1;
    [callActionSheet showInView:self.view];
}

- (void) callActionSheetActionWithIndex:(NSInteger) buttonIndex
{
    NSString *cleanedString = [[self.contactNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1)
    {
        [self callActionSheetActionWithIndex:buttonIndex];
    }
    
}
//  ***** Added by Harshitha ends here  *****

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createDataBases
{
    GssMobileConsoleiOS *objCRMMobileAppManager = [[GssMobileConsoleiOS alloc] init];
    [objCRMMobileAppManager createEmptyDatabase];
    
    //Set delegate flag
    // objCRMMobileAppManager.CRMdelegate = self;
    
}


-(void) refreshBtnClicked{
    appDelegateObj.refreshClicked =YES;
    
    
    if([CheckedNetwork connectedToNetwork]){
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:appDelegateObj];

   
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerForServiceTask:) name:@"StartAcitivityIndicator" object:nil];
    
    
                                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerForServiceTask:) name:@"AcitivityIndicatorForContextData" object:nil];
          [self initializeServiceTasksApiCall];
    
    }
    else {
       [[GSPUtility sharedInstance]showAlertWithTitle:@"Internet Unavailable" message:@"Could not connect to server " otherButton:nil tag:0 andDelegate:self];    }
    }
    

    
-(void)initializeServiceTasksApiCall{
    
    ServiceOrderClass *objServiceOrderClass = [[ServiceOrderClass alloc] init];
    
    [objServiceOrderClass DownloadServiceDataFromSAP];
    
}
- (void)initializeContextDataApiCall
{
   // ContextDataClass *objContextDataClass=[[ContextDataClass alloc]init];
    [objContextDataClass downloadContextDataFrmSAP];
}



- (void)SAPResponseHandlerForServiceTask:(NSNotification*)notification
{
    NSDictionary* userInfo  = notification.userInfo;
    // NSString *action        = [userInfo objectForKey:@"action"];
    NSString *message       = [userInfo objectForKey:@"responseMsg"];
    
    NSString * statusMessage;
    
    /*    GSPAppDelegate * appDelegateObj = (GSPAppDelegate *)[[UIApplication sharedApplication]delegate];
     BOOL databaseEmptyFlag = appDelegateObj.databaseEmptyFlag;
     //    objServiceMngtCls                   = [[GSPAppDelegate alloc] init];
     //    BOOL databaseEmptyFlag = objServiceMngtCls.databaseEmptyFlag;
     */
    if ([notification.name isEqualToString:@"ActivityIndicatorQueueData"]) {
        [SVProgressHUD showWithStatus:nil];
        return;
    }

    if ([notification.name isEqualToString:@"StartAcitivityIndicator"]) {
        
//        [appDelegateObj changePriority];
        
                statusMessage = NSLocalizedString(@"FETCH_SERVICETASK", nil);
    }
    else if ([notification.name isEqualToString:@"AcitivityIndicatorForContextData"]) {
        
                statusMessage = NSLocalizedString(@"FETCH_CONTEXTDATA", nil);
    }
    
    
    if ([message isEqualToString:@"Loading Activity Indicator"])
    {
        //        if (self.refreshButtonClicked || databaseEmptyFlag)
                    [SVProgressHUD showWithStatus:statusMessage];
//        [SVProgressHUD showWithStatus:nil];
    }
    else if ([message isEqualToString:@"Stop Loading Activity Indicator"] && [notification.name isEqualToString:@"StartAcitivityIndicator"])
    {
        //  *****   Added by Harshitha   *****
      //  GSPAppDelegate *appDelegateObj = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];
        
        //        if (!isOnlyRefresh)
               if (!appDelegateObj.refreshClicked && appDelegateObj.callContextDataApiFlag)
        {
//            appDelegateObj.refreshClicked = NO;
//            appDelegateObj.callContextDataApiFlag = FALSE;
            
            if([userInfo objectForKey:@"FLDVC"])
                [_diagnoseArray1 addObject:[userInfo objectForKey:@"FLDVC"]];
            
            [self initializeContextDataApiCall];
            return;
        }
        /*        if (!self.refreshButtonClicked && !appDelegateObj.callContextDataApiFlag && [[GSPOfflineViewConfiguration sharedInstance] IsConnectionAvailable]) {
         [[GSPUtility sharedInstance]showAlertWithTitle:@"Overview screen refreshed" message:@"ServiceTasks updated from server" otherButton:nil tag:0 andDelegate:self];
         }
         */
        
    //[self getServiceTasksFromStorage];
         [self initialiseVariables];
        appDelegateObj.refreshClicked = NO;
                [SVProgressHUD dismiss];
       
    }
    else if ([message isEqualToString:@"Stop Loading Activity Indicator"] && [notification.name isEqualToString:@"AcitivityIndicatorForContextData"])
    {
        
        //    *****   Added by Harshitha   *****
        if([userInfo objectForKey:@"FLDVC"])
            [_diagnoseArray1 addObject:[userInfo objectForKey:@"FLDVC"]];
             // [self getServiceTasksFromStorage];
        appDelegateObj.refreshClicked = NO;
        [SVProgressHUD dismiss];
        
        /*        if (!self.refreshButtonClicked && [[GSPOfflineViewConfiguration sharedInstance] IsConnectionAvailable])
         [[GSPUtility sharedInstance]showAlertWithTitle:@"Overview screen refreshed" message:@"ServiceTasks updated from server" otherButton:nil tag:0 andDelegate:self];
         */
        NSLog(@"The diagnose array is %@",_diagnoseArray1);
        
        [self initialiseVariables];

        [self checkPopUpStatusAndCallPopUpView];
    }

    else
    {
        //        if (self.refreshButtonClicked && [[GSPOfflineViewConfiguration sharedInstance] IsConnectionAvailable])
        
        [self initialiseVariables];
        [SVProgressHUD dismiss];
        //        else
        //            [[GSPUtility sharedInstance]showAlertWithTitle:@"Overview screen refreshed" message:@"ServiceTasks updated from server" otherButton:nil tag:0 andDelegate:self];
    }
}


- (void) checkPopUpStatusAndCallPopUpView
{
    
    NSString *popUpStatus= [[NSUserDefaults standardUserDefaults] stringForKey:@"stateOfSwitch"];
    
    if([popUpStatus isEqual: @"ON"]){
       [self diagnoseInfo];
    }
}

- (void) diagnoseInfo
{
    GSPDiagnosePopUpViewController *diagpopup;
    NSLog(@"Diagnose array of dashboard %@",_diagnoseArray1);
    
    if (IS_IPAD) {
        diagpopup = [[GSPDiagnosePopUpViewController alloc]initWithNibName:@"GSPDiagnosePopUpViewController" bundle:nil withDiagnoseInfo:_diagnoseArray1 andDisableDiagButton:1 fromScreen:nil];
        
        diagpopup.view.frame = CGRectMake(self.view.bounds.size.width/2 - diagpopup.view.frame.size.width/2, self.view.bounds.size.height - (diagpopup.view.frame.size.height + 400 ), 495, 234);
    }
    else {
        diagpopup = [[GSPDiagnosePopUpViewController alloc]initWithNibName:@"GSPDiagnosePopUpViewController_iPhone" bundle:nil withDiagnoseInfo:_diagnoseArray1 andDisableDiagButton:1 fromScreen:nil];
        
        diagpopup.view.frame = CGRectMake(self.view.bounds.size.width/2 - diagpopup.view.frame.size.width/2, self.view.bounds.size.height - (diagpopup.view.frame.size.height + 200 ), 310, 188);
    }
    
    diagpopup.view.layer.borderColor = [UIColor blackColor].CGColor;
    diagpopup.view.layer.borderWidth = 1.0f;
    
    [self.view addSubview:diagpopup.view];
    
    [self addChildViewController:diagpopup];
    [diagpopup didMoveToParentViewController:self];
}


- (void) infoBarButtonClicked
{
    GSPInfoScreenViewController * infoScreenVC;
    
    if (IS_IPAD) {
        infoScreenVC = [[GSPInfoScreenViewController alloc]initWithNibName:@"GSPInfoScreenViewController_iPad" bundle:nil];
    }
//  Added by Harshitha
    else {
        infoScreenVC = [[GSPInfoScreenViewController alloc]initWithNibName:@"GSPInfoScreenViewController" bundle:nil];
    }
    
    [self.navigationController pushViewController:infoScreenVC animated:YES];
}

- (IBAction)totalServiceTasksButtonClick:(id)sender
{
    appDelegateObj.activeApp = @"ServiceOrders";
    appDelegateObj.isTaskForTodayScreen = FALSE;
    [self loadServiceTaskOverviewScreen];
}

- (void) loadServiceTaskOverviewScreen
{
// Added by Harshitha.....On opening ServicePro app,to prioritize the execution of queued items from ServicePro app on QueueProcessor
//    BOOL rtnResult;
//    GssMobileConsoleiOS *objServiceMngtCls = [[GssMobileConsoleiOS alloc] init];
//    objServiceMngtCls.TargetDatabase = @"db_queueprocessor";
//    objServiceMngtCls.qryString = [NSString stringWithFormat:@"UPDATE QP0610114_2456 SET periority = 1 WHERE subapplication = %@",@"Service Orders"];
//    
//    NSLog(@"Update query %@", objServiceMngtCls.qryString);
//    
//    rtnResult = [objServiceMngtCls excuteSqliteQryString];

    
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
    
}



//-(void)checkForPriority{
//    
//    @try{
//    @synchronized(self){
//    NSLog(@"Timer fired");
//    NSMutableArray *errorKeyChainArray = [[NSMutableArray alloc]init];
//    errorKeyChainArray = [GSPKeychainStoreManager getErrorItemsFromKeyChain];
//    if(errorKeyChainArray.count>0){
//        NSLog(@"Error items before API call %@",errorKeyChainArray);
//        for(NSDictionary *dic in errorKeyChainArray){
//            if([[dic valueForKey:@"periority"]isEqualToString:@"3"]){
//                _keyChainProcessed= TRUE;
//            }
//        }
//
//    
//    if(_keyChainProcessed){
//        _keyChainProcessed  = FALSE ;
//        [timer invalidate];
//        NSLog(@"Error items during API call %@",errorKeyChainArray);
//        [self initializeServiceTasksApiCall];
//    }
//    }
//    else{
//        [self initializeServiceTasksApiCall];
//    }
//    }
//    }
//    @catch (NSException * e) {
//        NSLog(@"%@",e.reason );
//    }
//}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 3)
    {
        if (buttonIndex == 0)
        {
            [appDelegateObj openReceiverApp:nil];
        }
    
    else if (buttonIndex == 1)
    {
//        [alertView dismissWithClickedButtonIndex:1 animated:TRUE];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerForServiceTask:) name:@"StartAcitivityIndicator" object:nil];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerForServiceTask:) name:@"AcitivityIndicatorForContextData" object:nil];
        
        [self initializeServiceTasksApiCall];

    }
    }
}
- (IBAction)taskForTheDayButtonClicked:(id)sender
{
    appDelegateObj.activeApp = @"ServiceOrders";
    appDelegateObj.isTaskForTodayScreen = TRUE;
    [self loadServiceTaskOverviewScreen];
}

- (IBAction)vanStockButtonClicked:(id)sender {
    [self notAvailableForDemoAlert];
}

- (IBAction)utilizationButtonClicked:(id)sender {
    [self notAvailableForDemoAlert];
}

- (IBAction)contactsButtonClicked:(id)sender {
    [self notAvailableForDemoAlert];
}

- (IBAction)billableButtonClicked:(id)sender {
    [self notAvailableForDemoAlert];
}

- (IBAction)activitiesButtonClicked:(id)sender {
    [self notAvailableForDemoAlert];
}

- (void)notAvailableForDemoAlert
{
    [[GSPUtility sharedInstance] showAlertWithTitle:@"" message:@"Functionality not available for demo version" otherButton:nil tag:0 andDelegate:self];
}

@end
