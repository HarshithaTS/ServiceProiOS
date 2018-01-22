//
//  GSPServiceTasksViewController.m
//  GssServicePro
//
//  Created by Riyas Hassan on 04/06/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPServiceTasksViewController.h"
#import "GSPServiceTaskTableViewCell.h"
#import "GSPServiceTaskDetailViewController.h"
#import "GSPPickerController.h"
#import "ServiceOrderClass.h"
#import "GSPColleguesViewController.h"
#import "ContextDataClass.h"
#import "GSPCommonTableView.h"
#import "GSPOfflineViewConfiguration.h"
#import "GSPKeychainStoreManager.h"
#import "GSPDiagnosePopUpViewController.h"
#import "GSPAppDelegate.h"
#import "CheckedNetwork.h"

#define SORT_PICKER_TAG 1000

@interface GSPServiceTasksViewController ()<CustomPickerDelegate, UISearchBarDelegate,UIActionSheetDelegate>
{
    GSPPickerController *pickerController;
    BOOL  isSearching, isSortingAscending;
    int sortedButtonTag;
    ContextDataClass * contextDataClass ;
    Colleagues * colleaguesObj;

}
@property (weak, nonatomic) IBOutlet UIScrollView *tableViewHorizontalScrollView;

- (IBAction)otherColleguesTaskButtonClick:(id)sender;

- (IBAction)refreshButtonClick:(id)sender;


@property (nonatomic) ScreenType screenType;


@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet GSPCommonTableView *serviceTaskTabelView;
@property (strong, nonatomic) NSMutableArray * dataSourceArray, *searchArray, *errorListArray;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *headerViewLandscapeMode;

#pragma mark header View Button outlets

@property (weak, nonatomic) IBOutlet UIButton *priorityButton;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (weak, nonatomic) IBOutlet UIButton *startDateButton;
@property (weak, nonatomic) IBOutlet UIButton *customerLocationButton;
@property (weak, nonatomic) IBOutlet UIButton *estArrivalButton;
@property (weak, nonatomic) IBOutlet UIButton *serviceDocButton;
@property (weak, nonatomic) IBOutlet UIButton *contactNameButton;
@property (weak, nonatomic) IBOutlet UIButton *descriptionButton;

- (IBAction)sortButtonClicked:(id)sender;

// Added by Harshitha
@property (strong, nonatomic) Colleagues * selectedColleague;
@property (strong, nonatomic) NSArray *rearrangedOrderArray;
@property (nonatomic, assign) BOOL refreshButtonClicked;
@property (nonatomic, strong) ServiceTask *taskToTransfer;

@end

@implementation GSPServiceTasksViewController

NSMutableArray *diagnoseArray;
UIInterfaceOrientation interfaceOrientation;
GSPAppDelegate *appDelegateObj1;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forView:(ScreenType)type withTitle:(NSString*)selectedColleagueName anduName:(NSString*)uName
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forView:(ScreenType)type withTitle:(NSString*)selectedColleagueName andSelectedColleague:(Colleagues*)selected_colleague transferTask:(ServiceTask *)transferTask
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    GSPAppDelegate *appDelegateObj = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];
    if (self) {
        self.screenType = type;
        
        switch (type) {
            case serviceTaskOverView:
                if (!appDelegateObj.isTaskForTodayScreen)
                    [self setNavigationTitleWithBrandImage: NSLocalizedString(@"SERVICE_TASKS", nil)];
                else
                    [self setNavigationTitleWithBrandImage: NSLocalizedString(@"SERVICE_TASKS_FOR_THE_DAY", nil)];
                break;
                
            case colleguesServiceTaskView:
                self.taskToTransfer = transferTask;
                [self setNavigationTitleWithBrandImage:[NSString stringWithFormat:@"%@-%@",NSLocalizedString(@"COLLEGUES_TASK", nil),selectedColleagueName]];
                self.selectedColleague = selected_colleague;
//                [self setNavigationTitleWithBrandImage:self.title];
                
                break;
                
            default:
                break;
        }
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.serviceTaskTabelView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    appDelegateObj1 = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];

    appDelegateObj1.overViewController = self;
    [self setupView];
    
    [self initialiseVariables];
    
    UIBarButtonItem *barBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClicked)];
    [barBackButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = barBackButton;
    
// Original code
//    if (self.screenType == serviceTaskOverView)
//    {
//        [self getServiceTasksFromStorageAndReloadTableView];
//    }

//    [[GSPOfflineViewConfiguration sharedInstance] checkReachabilityAndCofigureView:self];
}

-(void)backButtonClicked
{
//Added by Harshitha
   // GSPAppDelegate *appDelegateObj = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];
    appDelegateObj1.activeApp = @"Main";
    if (IS_IPAD) {
        
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
            appDelegateObj1.mainView = [[GSPViewController alloc] initWithNibName:@"GSPViewController_iPad" bundle:nil];
        else
            appDelegateObj1.mainView = [[GSPViewController alloc] initWithNibName:@"GSPViewController_iPad_Portrait" bundle:nil];
    }
    else
    {
        appDelegateObj1.mainView = [[GSPViewController alloc] initWithNibName:@"GSPViewController" bundle:nil];
    }
    
    [self.navigationController pushViewController:appDelegateObj1.mainView animated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
}
 


-(void)viewWillAppear:(BOOL)animated
{
    
    
    [super viewWillAppear:animated];
     [[GSPOfflineViewConfiguration sharedInstance] checkReachabilityAndCofigureView:self];
   
    interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
// Added by Harshitha to recognize long press gesture used to sort ServiceOrders
/*    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.serviceTaskTabelView addGestureRecognizer:longPress];
*/
   // GSPAppDelegate *appDelegateObj = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];
    if (self.screenType == serviceTaskOverView  && !appDelegateObj1.saveChangesFlag && !appDelegateObj1.didBecomeActive)
    {
        [self getServiceTasksFromStorageAndReloadTableView];
    }
    
    else if (self.screenType == serviceTaskOverView && ![[GSPOfflineViewConfiguration sharedInstance] IsConnectionAvailable])
    {
        [self getServiceTasksFromStorageAndReloadTableView];
    }
  /*
  else if (self.screenType == serviceTaskOverView  && appDelegateObj.saveChangesFlag && !appDelegateObj.didBecomeActive)
    {
        [self getServiceTasksFromStorageAndReloadTableView];
    }
*/
    else if (self.screenType == colleguesServiceTaskView)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerForTransferServiceTask:) name:@"TransferTasksForColleagues" object:nil];
    }
    
    [self getErrorListArray];
    
       
// Added by Harshitha to call ServiceTask api everytime app comes to foreground
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshButtonClick:) name:@"callServiceOrderApi" object:nil];
    
    if (self.screenType == serviceTaskOverView) {
        //GSPAppDelegate *appDelegateObj = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];
        appDelegateObj1.activeApp = @"ServiceOrders";
    }
    
    if ( appDelegateObj1.saveChangesFlag) {
        
        appDelegateObj1.saveChangesFlag = FALSE;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandler:) name:@"StartAcitivityIndicator" object:nil];
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandler:) name:@"AcitivityIndicatorForContextData" object:nil];
    
        [self initializeWebServiceCall];
    }
    else if (appDelegateObj1.didBecomeActive) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandler:) name:@"StartAcitivityIndicator" object:nil];
        [self initializeServiceTasksWebserviceCall];
        
        appDelegateObj1.didBecomeActive = FALSE;
    }
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255.0/255 green:143.0/255 blue:30.0/255 alpha:0.0];
    self.navigationController.navigationBar.translucent = NO;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
   
    [[NSNotificationCenter defaultCenter] removeObserver:self];
   
}

#pragma mark Webservice methods

- (void)initializeWebServiceCall
{
    switch (self.screenType)
    {
        case serviceTaskOverView:
        [self initializeServiceTasksWebserviceCall];
            break;
        case colleguesServiceTaskView:
            [self getColleaguesServiceTasksAndReloadTableView];
            break;
        default:
            break;
    }
 

}

- (void) initializeServiceTasksWebserviceCall
{
    
    [diagnoseArray removeAllObjects];
    
    ServiceOrderClass *objServiceOrderClass = [[ServiceOrderClass alloc] init];
    
    [objServiceOrderClass DownloadServiceDataFromSAP];
    
}

- (void)initializeContextDataWebServiceCall
{
    
    [contextDataClass downloadContextDataFrmSAP];
}


- (void)SAPResponseHandler:(NSNotification*)notification
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

    if ([notification.name isEqualToString:@"StartAcitivityIndicator"]) {
       
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
       // GSPAppDelegate *appDelegateObj = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];

//        if (!isOnlyRefresh)
//        if (appDelegateObj1.isOnlyRefreshOverView )
//        {
////            appDelegateObj1.isOnlyRefreshOverView=NO;
//            //appDelegateObj1.callContextDataApiFlag = FALSE;
//
//            if([userInfo objectForKey:@"FLDVC"])
//            [diagnoseArray addObject:[userInfo objectForKey:@"FLDVC"]];
//            
//            [self initializeContextDataWebServiceCall];
//            return;
//        }
/*        if (!self.refreshButtonClicked && !appDelegateObj.callContextDataApiFlag && [[GSPOfflineViewConfiguration sharedInstance] Is ConnectionAvailable]) {
            [[GSPUtility sharedInstance]showAlertWithTitle:@"Overview screen refreshed" message:@"ServiceTasks updated from server" otherButton:nil tag:0 andDelegate:self];
        }
*/
        [self getServiceTasksFromStorageAndReloadTableView];
        appDelegateObj1.isOnlyRefreshOverView = NO;
        [SVProgressHUD dismiss];
    }
    else if ([message isEqualToString:@"Stop Loading Activity Indicator"] && [notification.name isEqualToString:@"AcitivityIndicatorForContextData"])
    {
        
//    *****   Added by Harshitha   *****
        if([userInfo objectForKey:@"FLDVC"])
        [diagnoseArray addObject:[userInfo objectForKey:@"FLDVC"]];
        
        [self getServiceTasksFromStorageAndReloadTableView];
        appDelegateObj1.isOnlyRefreshOverView = NO;
        [SVProgressHUD dismiss];
/*        if (!self.refreshButtonClicked && [[GSPOfflineViewConfiguration sharedInstance] IsConnectionAvailable])
            [[GSPUtility sharedInstance]showAlertWithTitle:@"Overview screen refreshed" message:@"ServiceTasks updated from server" otherButton:nil tag:0 andDelegate:self];
*/
        [self checkPopUpStatusAndCallPopUpView];
    }
    
    else
    {
//        if (self.refreshButtonClicked && [[GSPOfflineViewConfiguration sharedInstance] IsConnectionAvailable])
            [SVProgressHUD dismiss];
//        else
//            [[GSPUtility sharedInstance]showAlertWithTitle:@"Overview screen refreshed" message:@"ServiceTasks updated from server" otherButton:nil tag:0 andDelegate:self];
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

- (void) getServiceTasksFromStorageAndReloadTableView
{
    ServiceOrderClass * serviceOrderClass = [ServiceOrderClass new];
    self.dataSourceArray =  [serviceOrderClass GetAllServiceOrder];
    
//    GSPAppDelegate *appDelegateObj = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];
    if (self.screenType == serviceTaskOverView && appDelegateObj1.isTaskForTodayScreen)
    {
        NSMutableArray *serviceTasksForTodayArray = [[NSMutableArray alloc]init];
        GSPDateUtility *objCurrentDateTime = [GSPDateUtility sharedInstance];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *todayDate = [formatter stringFromDate:[NSDate date]];
        todayDate = [objCurrentDateTime convertShortDateToStringFormat:todayDate];
        for (int i=0 ; i<self.dataSourceArray.count ; i++)
        {
            ServiceTask *serviceTask = [self.dataSourceArray objectAtIndex:i];
            if ([todayDate isEqualToString:serviceTask.startDate]) {
                [serviceTasksForTodayArray addObject:[self.dataSourceArray objectAtIndex:i]];
            }
        }
        [self.dataSourceArray removeAllObjects];
        self.dataSourceArray = [NSMutableArray arrayWithArray:(NSMutableArray*)serviceTasksForTodayArray];
    }
    [self.serviceTaskTabelView reloadData];
}


- (void)getColleaguesServiceTasksAndReloadTableView
{
    ServiceOrderClass * serviceOrderClass   =  [ServiceOrderClass new];
    self.dataSourceArray                    =  [serviceOrderClass getAllServiceTasksForCollegues];
    [self.serviceTaskTabelView reloadData];
}


#pragma mark setupview methods

- (void)setupView
{
    self.navigationController.navigationBarHidden = NO;

    if (IS_IPAD)
    {
//        [self createUnderLinedButtonsForHeader];
        
        [self.tableViewHorizontalScrollView setScrollEnabled:YES];
        [self.tableViewHorizontalScrollView setShowsHorizontalScrollIndicator:YES];
        [self.tableViewHorizontalScrollView setContentSize:(CGSizeMake(1000,800))];
        [self.serviceTaskTabelView setFrame:CGRectMake(0, 0, 1000, self.serviceTaskTabelView.frame.size.height)];
        
//        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
//            [self.serviceTaskTabelView setFrame:CGRectMake(0, 44, 950, self.serviceTaskTabelView.frame.size.height)];
    }

// *** Added by Harshitha to avoid menu button on Colleague's ServiceTaskview ***
    if (self.screenType == serviceTaskOverView) {
        [self setRightNavigationBarButtonItemsWithMenu:YES andOtherBarButtonWithImageNamed:nil andSelector:nil];
    }
/*    else if (self.screenType == colleguesServiceTaskView) {
        if (self.taskToTransfer)
        {
            [self setRightNavigationBarButtonItemsWithMenu:NO andOtherBarButtonWithImageNamed:@"TransferIcon.png" andSelector:@selector(transferTaskToRep)];
        }
    }
*/
    //[self setLeftNavigationBarButtonWithImage: nil];//@"backButton.png"];
    
    [self changeSortIcontoNil];
    
}

-(void)setBottomToolBarMenu
{
    UIBarButtonItem *menuItem       = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu28-b.png"] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonClick:)];
    UIBarButtonItem *fixSpaceItem   = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    if(IS_IPHONE)
        fixSpaceItem.width = (self.view.bounds.size.width/2)-20;
    else
        fixSpaceItem.width = 350.0f;
    
    NSArray * toolBarItemsArray = [[NSArray alloc]initWithObjects:fixSpaceItem, menuItem ,nil];
    
    [self setBottomMenuBarWithArrayOfBarButtons:toolBarItemsArray];
    
}



- (void) createUnderLinedButtonsForHeader
{
    [[GSPUtility sharedInstance]underLineButtonTitle:self.priorityButton WithTitle:NSLocalizedString(@"PRIORITY", nil)];
    [[GSPUtility sharedInstance]underLineButtonTitle:self.statusButton WithTitle:NSLocalizedString(@"STATUS", nil)];
    [[GSPUtility sharedInstance]underLineButtonTitle:self.startDateButton WithTitle:NSLocalizedString(@"START_DATE", nil)];
    [[GSPUtility sharedInstance]underLineButtonTitle:self.customerLocationButton WithTitle:NSLocalizedString(@"CUSTOMER_LOCATION", nil)];
    [[GSPUtility sharedInstance]underLineButtonTitle:self.estArrivalButton WithTitle:NSLocalizedString(@"ESTIMATED_ARRIVAL", nil)];
    [[GSPUtility sharedInstance]underLineButtonTitle:self.serviceDocButton WithTitle:NSLocalizedString(@"SERVICE_DOC", nil)];
    [[GSPUtility sharedInstance]underLineButtonTitle:self.contactNameButton WithTitle:NSLocalizedString(@"CONTACT_NAME", nil)];
    
    self.descriptionButton.layer.borderColor    = TABLE_HEADER_BORDERCOLOR;
    self.descriptionButton.layer.borderWidth    = 0.7;
}
- (void) initialiseVariables
{
    self.dataSourceArray    = [[NSMutableArray alloc]init];
    contextDataClass        = [ContextDataClass new];
    diagnoseArray           = [[NSMutableArray alloc]init];
    colleaguesObj           = [Colleagues new];
}


- (void) getErrorListArray
{
    self.errorListArray                     =  [GSPKeychainStoreManager getErrorItemsFromKeyChain];
    NSMutableArray *queueData               = [GSPKeychainStoreManager arrayFromKeychain];
    
    NSLog(@"Array from ServicePro keychain %@",queueData);
    
    NSLog(@"Array from errorlisr arrat %@",self.errorListArray);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView Delegates and datasources

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSearching)
        return self.searchArray.count;
    else
        return [self.dataSourceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"GSPServiceTaskTableViewCell";
    
    ServiceOrderClass * serviceOrderClass = [ServiceOrderClass new];
    [serviceOrderClass storeOrderForServices];
    
    GSPServiceTaskTableViewCell *cell = (GSPServiceTaskTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
   if (cell == nil)
   {
        NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        
        if (IS_IPAD)
        {
            if (self.interfaceOrientation == UIDeviceOrientationPortrait || self.interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
                cell            = (GSPServiceTaskTableViewCell *)[nib objectAtIndex:0];
            }
            else
                cell            = (GSPServiceTaskTableViewCell *)[nib objectAtIndex:2];
        }
        else
        {
            cell            = (GSPServiceTaskTableViewCell *)[nib objectAtIndex:1];
        }
       
    }
    
    cell.backgroundView     = nil;
    cell.backgroundColor    = [UIColor clearColor];
    
    ServiceTask * serviceTask ;
    
    if (isSearching)
    {
        serviceTask = [self.searchArray objectAtIndex:indexPath.row];
    }
    else
    {
        serviceTask = [self.dataSourceArray objectAtIndex:indexPath.row];
    }
    
/*
// ***** Modified by Harshitha starts here.....As the delegate data to populate table differs on adding the drag and drop functionality for ServiceOrders *****
    self.rearrangedOrderArray = [[NSArray alloc]init];
    
    if (isSearching)
    {
        NSString *rearrangeOrderStatus= [[NSUserDefaults standardUserDefaults] stringForKey:@"reorderServices"];
        if([rearrangeOrderStatus isEqual: @"ON"] || rearrangeOrderStatus == nil || self.screenType == colleguesServiceTaskView){
            serviceTask = [self.searchArray objectAtIndex:indexPath.row];
        }
        else{
            objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
            objServiceMngtCls.TargetDatabase    = serviceRepotsDB;
            
            NSString *tableName = [SERVICEORDER_OBJTYPE stringByAppendingString:@"ZGSXSMST_SRVCDCMNT10"];
            
            NSString *qryString         = [NSString stringWithFormat:@"SELECT * FROM '%@' A INNER JOIN ZGSXSMST_SRVCDCMNT10_REARRANGE_ORDER B ON A.OBJECT_ID=B.OBJECT_ID WHERE A.ZZSERVICEITEM = B.ZZSERVICEITEM",tableName];
            
            NSMutableArray *cntxResultArry = [serviceOrderClass getAllServiceOrdersFromDB:qryString];
            
            self.searchArray = [NSMutableArray new];
            NSString *searchText = self.searchBar.text;
            
            for (ServiceTask *serviceTask in cntxResultArry)
            {
                if ([serviceTask.searchString rangeOfString:searchText options:NSCaseInsensitiveSearch ].location != NSNotFound) {
                    [self.searchArray addObject:serviceTask];
                }
            }
            
            NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"rearrangeOrder" ascending:YES];
            self.rearrangedOrderArray = [self.searchArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
            serviceTask = [self.rearrangedOrderArray objectAtIndex:indexPath.row];
        }
    }
    else
    {
        NSString *rearrangeOrderStatus= [[NSUserDefaults standardUserDefaults] stringForKey:@"reorderServices"];
        if([rearrangeOrderStatus isEqual: @"ON"] || rearrangeOrderStatus == nil || self.screenType == colleguesServiceTaskView){
            serviceTask = [self.dataSourceArray objectAtIndex:indexPath.row];
        }
        else{
            objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
            objServiceMngtCls.TargetDatabase    = serviceRepotsDB;
            
            NSString *tableName = [SERVICEORDER_OBJTYPE stringByAppendingString:@"ZGSXSMST_SRVCDCMNT10"];
            
            NSString *qryString         = [NSString stringWithFormat:@"SELECT * FROM '%@' A INNER JOIN ZGSXSMST_SRVCDCMNT10_REARRANGE_ORDER B ON A.OBJECT_ID=B.OBJECT_ID WHERE A.ZZSERVICEITEM = B.ZZSERVICEITEM",tableName];
            
            NSMutableArray *cntxResultArry = [serviceOrderClass getAllServiceOrdersFromDB:qryString];
            
            NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"rearrangeOrder" ascending:YES];
            self.rearrangedOrderArray = [cntxResultArry sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
            serviceTask = [self.rearrangedOrderArray objectAtIndex:indexPath.row];
        }
    }
// ***** Modified by Harshitha ends here *****
*/
    
//    [self setLabelColorsIntableViewCell:cell];
    
    cell.startDateLabel.text        = [self formateStartDateString:serviceTask.startDate];
    cell.cutomerLocationLabel.text  = [serviceTask.serviceLocation stringByAppendingString:[NSString stringWithFormat:@", %@", serviceTask.locationAddress]];
    cell.estimatedArrivallabel.text = serviceTask.estimatedArrivalDate;
    cell.discriptionLabel.text      = serviceTask.serviceOrderDescription;
    cell.contactNameLabel.text      = serviceTask.contactName;
// ***** Added by Harshitha starts here *****
    NSDateFormatter *dateFormat     = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm:ss"];
    NSDate *dateStr                 = [dateFormat dateFromString:serviceTask.startTime];
    [dateFormat setDateFormat:@"HH:mm"];
    cell.startTimeLabel.text        = [dateFormat stringFromDate:dateStr];
// ***** Added by Harshitha ends here *****
    
    if (IS_IPAD)
    {
        cell.serviceDocLabel.text       = serviceTask.serviceOrder;
        if (serviceTask.firstServiceItem.length != 0) {
            cell.serviceDocLabel.text   = [NSString stringWithFormat:@"%@/%@",cell.serviceDocLabel.text,serviceTask.firstServiceItem];
        }
    }
    else
    {
        cell.serviceDocLabel.text       = [NSString stringWithFormat:@"Doc# %@",serviceTask.serviceOrder];
        if (serviceTask.firstServiceItem.length != 0) {
            cell.serviceDocLabel.text   = [NSString stringWithFormat:@"%@/%@",cell.serviceDocLabel.text,serviceTask.firstServiceItem];
        }
    }
    
    
    
    cell.statusImageView.image      = [UIImage imageNamed:[contextDataClass getStatusIconImageName:serviceTask.statusText]];
    
    
    [self setPriorityImagesInView:cell.priorityImageView forStatus:serviceTask.priority];
    
    [self setErrorImageIfErrorExistsInCell:cell forObject:serviceTask.serviceOrder];
    return cell;
}

- (void) setPriorityImagesInView:(UIImageView*)imgView forStatus:(NSString*)status
{
    if ([status isEqualToString:@"LOW"]) {
//        imgView.image = [UIImage imageNamed:@"PRIORITY-ICON-LO.png"];
        imgView.image = [UIImage imageNamed:@"LowPriority.png"];
    }
    else if ([status isEqualToString:@"HIGH"])
    {
//        imgView.image = [UIImage imageNamed:@"PRIORITY-ICON-HI.png"];
        imgView.image = [UIImage imageNamed:@"HighPriority.png"];
    }
    else if ([status isEqualToString:@"NORMAL"] || [status isEqualToString:@""])
    {
//        imgView.image = [UIImage imageNamed:@"normal_icon_l.png"];
        imgView.image = [UIImage imageNamed:@"MediumPriority.png"];
    }
}

- (void) setErrorImageIfErrorExistsInCell:(GSPServiceTaskTableViewCell*)cell forObject:(NSString*)serviceOrder
{
    cell.errorImageView.hidden = YES;
    for (NSDictionary *dic in self.errorListArray)
    {
        if ([[dic valueForKey:@"referenceID"] isEqualToString:serviceOrder])
        {
            cell.errorImageView.hidden = NO;
        }
    }
}

- (void) setLabelColorsIntableViewCell:(GSPServiceTaskTableViewCell*)cell
{
    [cell.startDateLabel setOverViewTableLabel];
    [cell.cutomerLocationLabel setOverViewTableLabel];
    [cell.estimatedArrivallabel setOverViewTableLabel];
    [cell.discriptionLabel setOverViewTableLabel];
    [cell.contactNameLabel setOverViewTableLabel];
    [cell.serviceDocLabel setOverViewTableLabel];
    [cell.startTimeLabel setOverViewTableLabel];
}

- (NSString*) formateStartDateString:(NSString*)dateStr
{
    
    NSRange range = [dateStr rangeOfString:@","];
    
    if (range.location == NSNotFound)
    {
        return dateStr;
    }
    else {
        
         NSString *substring = [dateStr substringToIndex:range.location];
         return  substring;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.screenType == serviceTaskOverView)
  {

// Added by Harshitha
   // GSPAppDelegate *appDelegateObj = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];
    appDelegateObj1.activeApp = @"ServiceOrderEdit";
    
    ServiceTask     * serviceTask;
    NSMutableArray  * serviceOrdersArray;
    
    ServiceOrderClass *serviceOrderClass = [ServiceOrderClass new];
 
    if (isSearching)
    {
        serviceTask         = [self.searchArray objectAtIndex:indexPath.row];
        serviceOrdersArray  = self.searchArray;
    }
    else
    {
        serviceTask         = [self.dataSourceArray objectAtIndex:indexPath.row];
        serviceOrdersArray  = self.dataSourceArray;
    }

      
      
//      NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
//      
//      [navigationArray removeAllObjects ];
//      
//      
//            self.navigationController.viewControllers=navigationArray;

/*
 
 
 
 
// ***** Modified by Harshitha starts here *****
    if (isSearching)
    {
        NSString *rearrangeOrderStatus= [[NSUserDefaults standardUserDefaults] stringForKey:@"reorderServices"];
        if([rearrangeOrderStatus isEqual: @"ON"] || rearrangeOrderStatus == nil || self.screenType == colleguesServiceTaskView) {
            serviceTask = [self.searchArray objectAtIndex:indexPath.row];
            serviceOrdersArray  = self.searchArray;
        }
        else {
            objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
            objServiceMngtCls.TargetDatabase    = serviceRepotsDB;
            
            NSString *tableName = [SERVICEORDER_OBJTYPE stringByAppendingString:@"ZGSXSMST_SRVCDCMNT10"];
            
            NSString *qryString         = [NSString stringWithFormat:@"SELECT * FROM '%@' A INNER JOIN ZGSXSMST_SRVCDCMNT10_REARRANGE_ORDER B ON A.OBJECT_ID=B.OBJECT_ID WHERE A.ZZSERVICEITEM = B.ZZSERVICEITEM",tableName];
            
            NSMutableArray *cntxResultArry = [serviceOrderClass getAllServiceOrdersFromDB:qryString];
            
            self.searchArray = [NSMutableArray new];
            NSString *searchText = self.searchBar.text;
            
            for (ServiceTask *serviceTask in cntxResultArry)
            {
                if ([serviceTask.searchString rangeOfString:searchText options:NSCaseInsensitiveSearch ].location != NSNotFound) {
                    [self.searchArray addObject:serviceTask];
                }
            }
            
            NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"rearrangeOrder" ascending:YES];
            self.rearrangedOrderArray = [self.searchArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
            serviceTask = [self.rearrangedOrderArray objectAtIndex:indexPath.row];
            serviceOrdersArray = (NSMutableArray *)self.rearrangedOrderArray;
        }
    }
    else
    {
        NSString *rearrangeOrderStatus= [[NSUserDefaults standardUserDefaults] stringForKey:@"reorderServices"];
        if([rearrangeOrderStatus isEqual: @"ON"] || rearrangeOrderStatus == nil || self.screenType == colleguesServiceTaskView) {
            serviceTask = [self.dataSourceArray objectAtIndex:indexPath.row];
            serviceOrdersArray  = self.dataSourceArray;
        }
        else {
            objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
            objServiceMngtCls.TargetDatabase    = serviceRepotsDB;
            
            NSString *tableName = [SERVICEORDER_OBJTYPE stringByAppendingString:@"ZGSXSMST_SRVCDCMNT10"];
            
            NSString *qryString         = [NSString stringWithFormat:@"SELECT * FROM '%@' A INNER JOIN ZGSXSMST_SRVCDCMNT10_REARRANGE_ORDER B ON A.OBJECT_ID=B.OBJECT_ID WHERE A.ZZSERVICEITEM = B.ZZSERVICEITEM",tableName];
            
            NSMutableArray *cntxResultArry = [serviceOrderClass getAllServiceOrdersFromDB:qryString];
            
            NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"rearrangeOrder" ascending:YES];
            self.rearrangedOrderArray = [cntxResultArry sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
            serviceTask = [self.rearrangedOrderArray objectAtIndex:indexPath.row];
            serviceOrdersArray = (NSMutableArray *)self.rearrangedOrderArray;
        }
    }
// ***** Modified by Harshitha ends here *****
*/
    
    GSPServiceTaskDetailViewController * taskDetailVC;
    
    if (IS_IPAD)
    {
//        taskDetailVC = [[GSPServiceTaskDetailViewController alloc]initWithNibName:@"GSPServiceTaskDetailViewController_iPad" bundle:nil withObject:serviceTask atIndex:(int)indexPath.row andOrdersArray:serviceOrdersArray];
        
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        
      

//        if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
//            taskDetailVC = [[GSPServiceTaskDetailViewController alloc]initWithNibName:@"GSPServiceTa               skDetailVC_iPad" bundle:nil withObject:serviceTask atIndex:(int)indexPath.row andOrdersArray:serviceOrdersArray];
//        else if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
            taskDetailVC = [[GSPServiceTaskDetailViewController alloc]initWithNibName:@"GSPServiceTaskDetailVC_iPad_Landscape" bundle:nil withObject:serviceTask atIndex:(int)indexPath.row andOrdersArray:serviceOrdersArray];
           }
    else
    {
        taskDetailVC = [[GSPServiceTaskDetailViewController alloc]initWithNibName:@"GSPServiceTaskDetailViewController" bundle:nil withObject:serviceTask atIndex:(int)indexPath.row andOrdersArray:serviceOrdersArray];
        
        
    }
    
    
    
    
    
    [self.navigationController pushViewController:taskDetailVC animated:YES];
  }
}

/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2)
    {
        cell.backgroundColor =  [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
    }
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (IS_IPAD)
    {
//        return 22;
        return 38;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    [self.headerView setBackgroundColor:TABLE_HEADER_BGCOLOR];
    if (self.interfaceOrientation == UIDeviceOrientationPortrait || self.interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        return self.headerView;
    }
    return self.headerViewLandscapeMode;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

/*
// ***** Added by Harshitha to drag and drop ServiceOrders *****
- (IBAction)longPressGestureRecognized:(id)sender {
    
  if (self.screenType == serviceTaskOverView)
  {
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.serviceTaskTabelView];
    NSIndexPath *indexPath = [self.serviceTaskTabelView indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.serviceTaskTabelView cellForRowAtIndexPath:indexPath];
                
// Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshotFromView:cell];
                
// Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.serviceTaskTabelView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
// Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    
// Fade out.
                    cell.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
// Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                ServiceOrderClass * serviceOrderClass = [ServiceOrderClass new];
                ServiceTask *serviceTask1, *serviceTask2;
                
// ... update data source.
                if (isSearching)
                {
                    NSString *rearrangeOrderStatus= [[NSUserDefaults standardUserDefaults] stringForKey:@"reorderServices"];
                    if([rearrangeOrderStatus isEqual: @"ON"] || rearrangeOrderStatus == nil){
                        [self.searchArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                        
                        serviceTask1 = [self.searchArray objectAtIndex:indexPath.row];
                        serviceTask2 = [self.searchArray objectAtIndex:sourceIndexPath.row];
                        
                        [serviceOrderClass inTableSwapRowWithID:serviceTask1.serviceOrder andServiceItem:serviceTask1.firstServiceItem withID:serviceTask2.serviceOrder andItem:serviceTask2.firstServiceItem];
                    }
                    else{
                        objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
                        objServiceMngtCls.TargetDatabase    = serviceRepotsDB;
                        
                        NSString *tableName = [SERVICEORDER_OBJTYPE stringByAppendingString:@"ZGSXSMST_SRVCDCMNT10"];
                        
                        NSString *qryString         = [NSString stringWithFormat:@"SELECT * FROM '%@' A INNER JOIN ZGSXSMST_SRVCDCMNT10_REARRANGE_ORDER B ON A.OBJECT_ID=B.OBJECT_ID WHERE A.ZZSERVICEITEM = B.ZZSERVICEITEM",tableName];
                        
                        NSMutableArray *cntxResultArry               = [serviceOrderClass getAllServiceOrdersFromDB:qryString];
                        
                        self.searchArray = [NSMutableArray new];
                        NSString *searchText = self.searchBar.text;
                        
                        for (ServiceTask *serviceTask in cntxResultArry)
                        {
                            if ([serviceTask.searchString rangeOfString:searchText options:NSCaseInsensitiveSearch ].location != NSNotFound) {
                                [self.searchArray addObject:serviceTask];
                            }
                        }
                        
                        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"rearrangeOrder" ascending:YES];
                        self.rearrangedOrderArray = [self.searchArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
                        
                        NSMutableArray *rearrangedArray = [[NSMutableArray alloc]init];
                        [rearrangedArray addObjectsFromArray:self.rearrangedOrderArray];
                        
                        [rearrangedArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                        serviceTask1 = [self.rearrangedOrderArray objectAtIndex:indexPath.row];
                        serviceTask2 = [self.rearrangedOrderArray objectAtIndex:sourceIndexPath.row];
                        
                        [serviceOrderClass inTableSwapRowWithID:serviceTask1.serviceOrder andServiceItem:serviceTask1.firstServiceItem withID:serviceTask2.serviceOrder andItem:serviceTask2.firstServiceItem];
                    }
                }
                else
                {
                    NSString *rearrangeOrderStatus= [[NSUserDefaults standardUserDefaults] stringForKey:@"reorderServices"];
                    if([rearrangeOrderStatus isEqual: @"ON"] || rearrangeOrderStatus == nil){
                        [self.dataSourceArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                        
                        serviceTask1 = [self.dataSourceArray objectAtIndex:indexPath.row];
                        serviceTask2 = [self.dataSourceArray objectAtIndex:sourceIndexPath.row];
                        
                        [serviceOrderClass inTableSwapRowWithID:serviceTask1.serviceOrder andServiceItem:serviceTask1.firstServiceItem withID:serviceTask2.serviceOrder andItem:serviceTask2.firstServiceItem];

                    }
                    else{
                        objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
                        objServiceMngtCls.TargetDatabase    = serviceRepotsDB;
                        
                        NSString *tableName = [SERVICEORDER_OBJTYPE stringByAppendingString:@"ZGSXSMST_SRVCDCMNT10"];
                        
                        objServiceMngtCls.qryString         = [NSString stringWithFormat:@"SELECT * FROM '%@' A INNER JOIN ZGSXSMST_SRVCDCMNT10_REARRANGE_ORDER B ON A.OBJECT_ID=B.OBJECT_ID WHERE A.ZZSERVICEITEM = B.ZZSERVICEITEM",tableName];
                        
                        NSMutableArray *cntxResultArry               = [objServiceMngtCls fetchDataFrmSqlite];
                        
                        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"REARRANGE_ORDER" ascending:YES];
                        self.rearrangedOrderArray = [cntxResultArry sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
                        
                        NSMutableArray *rearrangedArray = [[NSMutableArray alloc]init];
                        [rearrangedArray addObjectsFromArray:self.rearrangedOrderArray];

                        [rearrangedArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                        serviceTask1 = [self.rearrangedOrderArray objectAtIndex:indexPath.row];
                        serviceTask2 = [self.rearrangedOrderArray objectAtIndex:sourceIndexPath.row];
                        
                        [serviceOrderClass inTableSwapRowWithID:[serviceTask1 valueForKey:@"OBJECT_ID"] andServiceItem:[serviceTask1 valueForKey:@"ZZSERVICEITEM"] withID:[serviceTask2 valueForKey:@"OBJECT_ID"] andItem:[serviceTask2 valueForKey:@"ZZSERVICEITEM"]];

                    }
                }
                
// ... move the rows.
                [self.serviceTaskTabelView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
// ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
                
                NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
                [userPreferences setObject:@"OFF" forKey:@"reorderServices"];
            }
            break;
        }
        default: {
            // Clean up.
            UITableViewCell *cell = [self.serviceTaskTabelView cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                
                // Undo fade out.
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            break;
        }
    }
  }
}

- (UIView *)customSnapshotFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}
// ***** Added by Harshitha ends here *****
*/

#pragma mark - Transfer Task to other Colleagues

- (void) transferTaskToRep
{
    
    NSString * alertMesssage = [NSString stringWithFormat:@"Are you sure you want to transfer task to %@ %@",self.selectedColleague.nameOne,self.selectedColleague.nameTwo];
    
    [[GSPUtility sharedInstance] showAlertWithTitle:@"Task Transfer Alert" message:alertMesssage otherButton:@"Cancel" tag:1 andDelegate:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag != 0)
    {
        switch (buttonIndex)
        {
            case 0:
                [self transferColleagueTaskListServiceCall:self.selectedColleague];
                break;
                
            default:
                break;
        }
        
    }
    
}


-(void) transferColleagueTaskListServiceCall:(Colleagues*)colleague
{
    // Added on 12th Aug 2015 by Selvan
 //   GSPAppDelegate *appDelegateObj = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];
    appDelegateObj1.saveChangesFlag = TRUE;
    // Added by Selvan ends here
    
    NSString *strMetaData = [NSString stringWithFormat:@"DATA-TYPE[.]ZGSXSMST_SRVCDCMNTTRNSFR20[.]OBJECT_ID[.]PROCESS_TYPE[.]NUMBER_EXT[.]SERVICE_EMPLOYEE"];
    
    NSString *strPar5 = [NSString stringWithFormat:@"ZGSXSMST_SRVCDCMNTTRNSFR20[.]%@[.]%@[.]%@[.]%@",self.taskToTransfer.serviceOrder,self.taskToTransfer.serviceOrderType,self.taskToTransfer.firstServiceItem,colleague.partner];
    
    
    [colleaguesObj transferColleaguesTaskServiceCall:[NSMutableArray arrayWithObjects:strMetaData,strPar5, nil]];
    
}

- (void)SAPResponseHandlerForTransferServiceTask:(NSNotification*)notification
{
    NSDictionary* userInfo          = notification.userInfo;
    NSString        * message       = [userInfo objectForKey:@"responseMsg"];
    NSMutableArray  * reponseArray  = [userInfo objectForKey:@"FLD_VC"];
    
    NSString * statusMessage;
    
    if ([notification.name isEqualToString:@"TransferTasksForColleagues"]) {
        
        statusMessage = @"Please wait while transfering task...";
    }
    
    if ([message isEqualToString:@"Loading Activity Indicator"])
    {
//        [SVProgressHUD showWithStatus:statusMessage];
        [SVProgressHUD showWithStatus:nil];
    }
    else if ([message isEqualToString:@"SAP Response Message"] && [notification.name isEqualToString:@"TransferTasksForColleagues"])
    {
        
        NSLog(@"RESPONSE ARRAY :%@",reponseArray);
        [SVProgressHUD dismiss];
        if (reponseArray.count > 3)
        {
            NSString * message = [[reponseArray objectAtIndex:0] objectAtIndex:0];
            
            if ([message isEqualToString:@"E"])
            {
                [[GSPUtility sharedInstance]showAlertWithTitle:@"" message:[[reponseArray objectAtIndex:3] objectAtIndex:0] otherButton:nil tag:0 andDelegate:self];
            }
            else  if ([message isEqualToString:@"S"])
            {
//  Original code....Commented by Harshitha to avoid explicit deletion of servicetask
//                ServiceOrderClass *serviceOrderObject = [ServiceOrderClass new];
//                [serviceOrderObject deleteServiceOrder:self.taskToTransfer.serviceOrder andFirstServiceItem:self.taskToTransfer.firstServiceItem];
                [[GSPUtility sharedInstance]showAlertWithTitle:@"" message:[[reponseArray objectAtIndex:3] objectAtIndex:0] otherButton:nil tag:0 andDelegate:self];
            }
            
        }
        
    }
    else
    {
        [SVProgressHUD dismiss];
    }
    
}

#pragma mark Search methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    isSearching = NO;
    if ([searchText isEqualToString:@""]) {
        if (self.screenType == serviceTaskOverView)
            [self getServiceTasksFromStorageAndReloadTableView];
        else if (self.screenType == colleguesServiceTaskView)
            [self getColleaguesServiceTasksAndReloadTableView];
        return;
    }
    
    [self searchTableView];

}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
	
	if([theSearchBar.text isEqualToString:self.searchBar.text])
		[theSearchBar resignFirstResponder];
	else
		[self searchTableView];
}

- (void) searchTableView {
	
	self.searchArray = [NSMutableArray new];
	isSearching = YES;
    NSString *searchText = self.searchBar.text;

	for (ServiceTask *serviceTask in self.dataSourceArray)
    {
        if ([serviceTask.searchString rangeOfString:searchText options:NSCaseInsensitiveSearch ].location != NSNotFound) {
            [self.searchArray addObject:serviceTask];
        }
    }
    
	[self.serviceTaskTabelView reloadData];
    
}



#pragma mark Button Actions

- (IBAction)otherColleguesTaskButtonClick:(id)sender
{
// Added by Harshitha
  //  GSPAppDelegate *appDelegateObj = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];
    appDelegateObj1.activeApp = @"ColleagueList";
    
    GSPColleguesViewController * colleguesViewController;
    
    if (IS_IPAD)
    {
        colleguesViewController = [[GSPColleguesViewController alloc]initWithNibName:@"GSPColleguesViewController_iPad" bundle:nil];
    }
    else
    {
        colleguesViewController = [[GSPColleguesViewController alloc]initWithNibName:@"GSPColleguesViewController" bundle:nil];
    }
    
    [self.navigationController pushViewController:colleguesViewController animated:YES];

}


- (IBAction)refreshButtonClick:(id)sender
{
    isSearching = NO;
    appDelegateObj1.isOnlyRefreshOverView = YES;
// ***** Original Code *****
//    [self initializeServiceTasksWebserviceCall];
    
// ***** Added by Harshitha *****
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
    if([CheckedNetwork connectedToNetwork]){

    switch (self.screenType)
    {
        case serviceTaskOverView:
            
//            if (self.refreshButtonClicked) {
//                [userPreferences setObject:@"ON" forKey:@"reorderServices"];
//                self.refreshButtonClicked = NO;
//            }
            /*
            else {
                self.refreshButtonClicked = NO;
            }
            */
                       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshButtonClick:) name:@"callServiceOrderApi" object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandler:) name:@"StartAcitivityIndicator" object:nil];
            
             [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandler:) name:@"AcitivityIndicatorForContextData" object:nil];
            [self initializeServiceTasksWebserviceCall];
            break;

        default:
            break;
// ***** Added by Harshitha ends here *****
    }
    }
    else
         [[GSPUtility sharedInstance]showAlertWithTitle:@"Internet Unavailable" message:@"Could not connect to server " otherButton:nil tag:0 andDelegate:self];
    
}

/*
// Added by Harshitha to resort the sorted oders using drag and drop feature
-(void) resetServicesToOriginalOrder:(id)sender
{    
    NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
    [userPreferences setObject:@"ON" forKey:@"reorderServices"];
    
    [self.serviceTaskTabelView reloadData];
}
*/

- (void)menuButtonClick:(id)sender
{
    UIActionSheet* orderTaskActionSheet;
    
    if (IS_IPAD) {
        orderTaskActionSheet = [[UIActionSheet alloc]
                                initWithTitle:NSLocalizedString(@"MENU", nil)
                                delegate:self
                                cancelButtonTitle:NSLocalizedString(@"CANCEL", nil)
                                destructiveButtonTitle:nil
                                otherButtonTitles:NSLocalizedString(@"REFRESH_DATA", nil),NSLocalizedString(@"TASKS_OTHER_REP", nil),nil];
    }
    else
    {
        orderTaskActionSheet = [[UIActionSheet alloc]
                                initWithTitle:NSLocalizedString(@"MENU", nil)
                                delegate:self
                                cancelButtonTitle:NSLocalizedString(@"CANCEL", nil)
                                destructiveButtonTitle:nil
                                otherButtonTitles:NSLocalizedString(@"REFRESH_DATA", nil),NSLocalizedString(@"TASKS_OTHER_REP", nil),NSLocalizedString(@"SORT_BY_DATE", nil),NSLocalizedString(@"SORT_BY_PRIORITY", nil),NSLocalizedString(@"SORT_BY_STATUS", nil),NSLocalizedString(@"SORT_BY_SUBJECT", nil),nil];
    }
    [orderTaskActionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            self.refreshButtonClicked = YES;
            [self refreshButtonClick:nil];
            break;
        case 1:
            [self otherColleguesTaskButtonClick:nil];
            break;
     
        if (IS_IPHONE) {
            case 2:
                [self sortTaskTableWithKey:@"startDate" isAscending:YES];
                break;
            case 3:
                [self sortTaskTableWithKey:@"priority" isAscending:YES];
                break;
            case 4:
                [self sortTaskTableWithKey:@"status" isAscending:YES];
                break;
            case 5:
                [self sortTaskTableWithKey:@"serviceLocation" isAscending:YES];
                break;
            }
        
            
        default:
            break;
    }
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.serviceTaskTabelView reloadData ];
}

- (IBAction)sortButtonClicked:(id)sender
{
    //[self changeBackGroundColorOfHeaderButtonsWhenSortButtonClicked];
    
    [self changeSortIcontoNil];
    UIButton * button = (UIButton*)sender;
    
    
    
    BOOL isAscending = YES;
    
    int buttonTag = (int)button.tag;
    
   
    
    
    if (sortedButtonTag == buttonTag)
    {
       // button.backgroundColor = [UIColor lightGrayColor];
        

        isAscending = NO;
        sortedButtonTag = 0;
    }
    else
    {
       // button.backgroundColor = [UIColor grayColor];
                sortedButtonTag = buttonTag;
    }

    NSString * sortKey;
    
    switch (buttonTag) {
        case prioTag:
            sortKey = @"priority";
                        break;
        case statusTag:
            sortKey = @"status";
            break;
        case startDateTag:
            sortKey = @"startDate";
            break;
        case customerLocTag:
            sortKey = @"serviceLocation";
           
            break;
        case estArrivalTag:
            sortKey = @"estimatedArrivalDate";
            break;
        case serviceDocTag:
            sortKey = @"serviceOrder";
            break;
        case contactNameTag:
            sortKey = @"contactName";
            break;
            
        default:
            break;
    }
    
    [self changeSortIcon:buttonTag withOrder:isAscending];
    [self sortTaskTableWithKey:sortKey isAscending:isAscending];
    
}


-(void)changeSortIcon:(NSInteger)butTag withOrder:(BOOL)ascending{
    if(!ascending){
        switch (butTag) {
            case prioTag:
                self.sortPrioIcon.image=[UIImage imageNamed:@"dropDown_icon.png"];
                self.sortPrioIcon.image=[UIImage imageNamed:@"dropDown_icon.png"];
                break;
            case statusTag:
            self.sortStatIcon.image=[UIImage imageNamed:@"dropDown_icon.png"];
                self.sortStatPortrait.image=[UIImage imageNamed:@"dropDown_icon.png"];
                break;
            case startDateTag:
               self.sortStartDateIcon.image=[UIImage imageNamed:@"dropDown_icon.png"];
                self.sortDatePortrait.image=[UIImage imageNamed:@"dropDown_icon.png"];
                break;
            case customerLocTag:
                self.sortCustIcon.image=[UIImage imageNamed:@"dropDown_icon.png"];
                self.sortCustIconPortrait.image=[UIImage imageNamed:@"dropDown_icon.png"];
                
                break;
            case estArrivalTag:
                self.sortEstimatIcon .image=[UIImage imageNamed:@"dropDown_icon.png"];
                self.sortEstPortrait.image=[UIImage imageNamed:@"dropDown_icon.png"];

                break;
            case serviceDocTag:
                self.sortOrderIcon.image=[UIImage imageNamed:@"dropDown_icon.png"];
                self.sortDocPortrait .image=[UIImage imageNamed:@"dropDown_icon.png"];

                break;
            case contactNameTag:
                self.sortContIcon.image=[UIImage imageNamed:@"dropDown_icon.png"];
                self.sortContPortrait .image=[UIImage imageNamed:@"dropDown_icon.png"];

                break;
                
            default:
                break;
    }
    
}
    else{
        switch (butTag) {
            case prioTag:
                 self.sortPrioIcon.image=[UIImage imageNamed:@"dropUp_icon.png"];
                self.sortPrioPortait.image=[UIImage imageNamed:@"dropUp_icon.png"];
                break;
            case statusTag:
                 self.sortStatIcon.image=[UIImage imageNamed:@"dropUp_icon.png"];
                self.sortStatPortrait.image=[UIImage imageNamed:@"dropUp_icon.png"];
                break;
            case startDateTag:
                 self.sortStartDateIcon.image=[UIImage imageNamed:@"dropUp_icon.png"];
                self.sortDatePortrait.image=[UIImage imageNamed:@"dropUp_icon.png"];
                break;
            case customerLocTag:
                self.sortCustIcon.image=[UIImage imageNamed:@"dropUp_icon.png"];
                self.sortCustIconPortrait.image=[UIImage imageNamed:@"dropUp_icon.png"];
                break;
            case estArrivalTag:
                self.sortEstimatIcon .image=[UIImage imageNamed:@"dropUp_icon.png"];
                self.sortEstPortrait.image=[UIImage imageNamed:@"dropUp_icon.png"];
                break;
            case serviceDocTag:
                self.sortOrderIcon.image=[UIImage imageNamed:@"dropUp_icon.png"];
                self.sortDocPortrait.image=[UIImage imageNamed:@"dropUp_icon.png"];
                break;
            case contactNameTag:
                self.sortContIcon.image=[UIImage imageNamed:@"dropUp_icon.png"];
                self.sortContPortrait.image=[UIImage imageNamed:@"dropUp_icon.png"];
                break;
                
            default:
                break;
        }

    }
    
  
}

-(void)changeSortIcontoNil{
    self.sortCustIcon.image=[UIImage imageNamed:@"upAndDownArrow.jpg"];
    
    self.sortEstimatIcon .image=[UIImage imageNamed:@"upAndDownArrow.jpg"];
    self.sortOrderIcon.image=[UIImage imageNamed:@"upAndDownArrow.jpg"];

    self.sortContIcon.image=[UIImage imageNamed:@"upAndDownArrow.jpg"];
    self.sortPrioIcon.image=[UIImage imageNamed:@"upAndDownArrow.jpg"];
    self.sortStatIcon.image=[UIImage imageNamed:@"upAndDownArrow.jpg"];
    self.sortStartDateIcon.image=[UIImage imageNamed:@"upAndDownArrow.jpg"];
    self.sortContPortrait.image=[UIImage imageNamed:@"upAndDownArrow.jpg"];
    self.sortEstPortrait.image=[UIImage imageNamed:@"upAndDownArrow.jpg"];
    self.sortCustIconPortrait.image=[UIImage imageNamed:@"upAndDownArrow.jpg"];
    self.sortDocPortrait.image=[UIImage imageNamed:@"upAndDownArrow.jpg"];
    self.sortPrioPortait.image=[UIImage imageNamed:@"upAndDownArrow.jpg"];
    self.sortStatPortrait.image=[UIImage imageNamed:@"upAndDownArrow.jpg"];
    self.sortDatePortrait.image=[UIImage imageNamed:@"upAndDownArrow.jpg"];



    
    
}
- (void) sortTaskTableWithKey:(NSString*)sortKey isAscending:(BOOL)ascending
{
    if (isSearching)
    {
        self.searchArray =  [[GSPUtility sharedInstance]sortArray:self.searchArray withKey:sortKey ascending:ascending];
    }
    else
    {
        self.dataSourceArray =  [[GSPUtility sharedInstance]sortArray:self.dataSourceArray withKey:sortKey ascending:ascending];
    }
    
    
    [self.serviceTaskTabelView reloadData];
}


- (void)changeBackGroundColorOfHeaderButtonsWhenSortButtonClicked
{
    self.priorityButton.backgroundColor = [UIColor clearColor];
    self.statusButton.backgroundColor = [UIColor clearColor];
    self.startDateButton.backgroundColor = [UIColor clearColor];
    self.customerLocationButton.backgroundColor = [UIColor clearColor];
    self.estArrivalButton.backgroundColor = [UIColor clearColor];
    self.serviceDocButton.backgroundColor = [UIColor clearColor];
    self.contactNameButton.backgroundColor = [UIColor clearColor];
    self.descriptionButton.backgroundColor = [UIColor clearColor];
}

//  Added by Harshitha
- (void) diagnoseInfo
{
    GSPDiagnosePopUpViewController *diagpopup;
    
    if (IS_IPAD) {
        diagpopup = [[GSPDiagnosePopUpViewController alloc]initWithNibName:@"GSPDiagnosePopUpViewController" bundle:nil withDiagnoseInfo:diagnoseArray andDisableDiagButton:1 fromScreen:nil];
    
        diagpopup.view.frame = CGRectMake(self.view.bounds.size.width/2 - diagpopup.view.frame.size.width/2, self.view.bounds.size.height - (diagpopup.view.frame.size.height + 400 ), 495, 234);
    }
    else {
        diagpopup = [[GSPDiagnosePopUpViewController alloc]initWithNibName:@"GSPDiagnosePopUpViewController_iPhone" bundle:nil withDiagnoseInfo:diagnoseArray andDisableDiagButton:1 fromScreen:nil];
        
        diagpopup.view.frame = CGRectMake(self.view.bounds.size.width/2 - diagpopup.view.frame.size.width/2, self.view.bounds.size.height - (diagpopup.view.frame.size.height + 200 ), 310, 188);
    }
    
    diagpopup.view.layer.borderColor = [UIColor blackColor].CGColor;
    diagpopup.view.layer.borderWidth = 1.0f;
    
    [self.view addSubview:diagpopup.view];
    
    [self addChildViewController:diagpopup];
    [diagpopup didMoveToParentViewController:self];
}
/*
- (void)openDetailScreen:(NSNotification*)notification
{
  [[GSPUtility sharedInstance]showAlertWithTitle:@"notification received" message:@"hi" otherButton:nil tag:0 andDelegate:self];
}
*/
@end
