//
//  GSPAppDelegate.m
//  GssServicePro
//
//  Created by Riyas Hassan on 04/06/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "GSPAppDelegate.h"
#import "GSPLocationManager.h"
#import "GSPLocationPingService.h"
#import "ServiceOrderClass.h"
#import "ContextDataClass.h"
#import "GSPServiceTasksViewController.h"
#import "GSPBaseViewController.h"
#import "GSPDiagnosePopUpViewController.h"
#import "GSPServiceTaskDetailViewController.h"
#import "GSPKeychainStoreManager.h"
#import "GSPOfflineViewConfiguration.h"
#import "GSPViewController.h"


@interface GSPAppDelegate()<UINavigationControllerDelegate>
@end

@implementation GSPAppDelegate {
  
    GCDThreads *objGCDThreads;

  
}
NSMutableArray *diagnoseArray2;

NSTimer *timer;

// Added by Harshitha
@synthesize callContextDataApiFlag;
@synthesize didBecomeActive;
@synthesize activeApp;
@synthesize updateFailureFlag;
@synthesize QPinstalledFlag;
//@synthesize databaseEmptyFlag;
//Added on 10th Aug 2015 by Selvan
@synthesize saveChangesFlag;
@synthesize isTaskForTodayScreen;
@synthesize appFirstLaunchFlag;

@synthesize isFirstLaunch;
//@synthesize didResignActive;


@synthesize callContextFlag;

@synthesize refreshClicked;


@synthesize isOnlyRefreshOverView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
// Added by Harshitha    
    callContextDataApiFlag = TRUE;
    didBecomeActive = FALSE;
    activeApp = @"";
    updateFailureFlag = TRUE;
    QPinstalledFlag = FALSE;
//    databaseEmptyFlag = FALSE;
    isTaskForTodayScreen = FALSE;
    
    appFirstLaunchFlag = TRUE;
//    didResignActive = TRUE;
    
    _iSOnlySync = FALSE;
    
//Added on 10th Aug 2015 by Selvan
    saveChangesFlag = FALSE;
    
    callContextFlag = TRUE;
    
    _IsNotification = TRUE;
    
    isFirstLaunch = TRUE;
    
    _openQPApp = FALSE;
    
    _openQPAppAtLaunch = TRUE;
    
    objGCDThreads = [GCDThreads sharedInstance];
    
    
    
    
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"FirstRun"]) {
    
        // Delete values from keychain here
        
        
        [GSPKeychainStoreManager deleteAllItemsFromGSMKeyChain];
        [GSPKeychainStoreManager deleteErrorItemsFromKeyChain];
        [GSPKeychainStoreManager deleteItemsFromKeyChain];
        [[NSUserDefaults standardUserDefaults] setValue:@"1strun" forKey:@"FirstRun"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    
//    [self changePriority];
//    
//    [self openReceiverApp:nil];
  
//    if(_openQPApp){
//        
//        if(QPinstalledFlag){
//            
//            [self changePriority];
//            
//            [self openReceiverApp:nil];
//            
//            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
//                timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(checkForPriority) userInfo:nil repeats:YES];
//            });
//        }
//    }

//    [self openReceiverApp:nil];
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self setUpViewForOrientation:interfaceOrientation];
    
    
    UILocalNotification  *notificationPayload = [launchOptions objectForKey: UIApplicationLaunchOptionsLocalNotificationKey];
    NSLog(@"Notifocation payload %@",notificationPayload);

    
    if(notificationPayload){
        
        _notificationLaunched =TRUE;
        
        NSLog(@"Notifocation payload %@",notificationPayload);
        
//        [[GSPUtility sharedInstance]showAlertWithTitle:@"notification received" message:@"hi" otherButton:nil tag:0 andDelegate:self];

        
//
        NSString *ident = [notificationPayload.userInfo objectForKey :@"referenceID"];
        NSLog(@"ident of notification %@",ident);
        
        NSString *ident2 = [notificationPayload.userInfo objectForKey:@"firstServiceItem"];
        NSLog(@"ident of notification %@",ident2);
        
        
        
        [GSPKeychainStoreManager setLocalNotifVariable : ident andServiceItem :ident2 ];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openDetailScreen:) name:@"notificationDetailScreen" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationDetailScreen" object:nil];
//
        

     
    }
    else{
        [self changePriority];
        
        [self openReceiverApp:nil];

    }
    
/*    if (IS_IPAD) {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
            self.mainView = [[GSPViewController alloc] initWithNibName:@"GSPViewController_iPad" bundle:nil];
        else
            self.mainView = [[GSPViewController alloc] initWithNibName:@"GSPViewController_iPad_Portrait" bundle:nil];
    }
    else
    {
        self.mainView =  [[GSPViewController alloc] initWithNibName:@"GSPViewController" bundle:nil];
    }
*/
    
    GSPAppDelegate *appDelegateObj = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];
    
    diagnoseArray2 =[[NSMutableArray alloc]init];
    
    
    self.mainController = [[UINavigationController alloc] initWithRootViewController:self.mainView];
	self.mainController.navigationBarHidden = NO;
    self.window.backgroundColor = [UIColor whiteColor];//BACKGROUND_COLOR;
    [self.window setRootViewController:self.mainController];
	[self.window addSubview:self.mainController.view];
	[self.window makeKeyAndVisible];

    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:255.0/255 green:143.0/255 blue:30.0/255 alpha:1.0]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
//    [self openReceiverApp:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"StartAcitivityIndicator" object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"AcitivityIndicatorForContextData" object:nil];
    
    
    
    

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"StartAcitivityIndicator" object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"AcitivityIndicatorForContextData" object:nil];
//
//    [self initializeServiceTasksApiCall];
    //[[GSPLocationManager sharedInstance]initLocationMnager];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openDetailScreen:) name:@"notificationDetailScreen" object:nil];
    
    
   
    
    [self startTimer];
    return YES;

}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self setUpViewForOrientation:toInterfaceOrientation];
}

-(void)setUpViewForOrientation:(UIInterfaceOrientation)orientation
{
    [self.mainView.view removeFromSuperview];
    if (IS_IPAD) {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
            self.mainView = [[GSPViewController alloc] initWithNibName:@"GSPViewController_iPad" bundle:nil];
        else
            self.mainView = [[GSPViewController alloc] initWithNibName:@"GSPViewController_iPad_Portrait" bundle:nil];
    }
    else
    {
        self.mainView = [[GSPViewController alloc] initWithNibName:@"GSPViewController" bundle:nil];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

// Added by Harshitha
//    BOOL rtnResult;
//    GssMobileConsoleiOS *objServiceMngtCls = [[GssMobileConsoleiOS alloc] init];
//    //    objServiceMngtCls.CRMdelegate = self;
//    objServiceMngtCls.TargetDatabase = @"db_queueprocessor";
//    objServiceMngtCls.qryString = [NSString stringWithFormat:@"UPDATE QP0610114_2456 SET periority = 2 WHERE subapplication = %@",@"Service Orders"];
//    
//    NSLog(@"Update query %@", objServiceMngtCls.qryString);
//    
//    rtnResult = [objServiceMngtCls excuteSqliteQryString];
//    
//    if(didResignActive){
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"StartAcitivityIndicator" object:nil];
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"AcitivityIndicatorForContextData" object:nil];
//        didResignActive  = FALSE;
//    }
//    
    
    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   
    BOOL rtnResult;
    GssMobileConsoleiOS *objServiceMngtCls = [[GssMobileConsoleiOS alloc] init];
    //    objServiceMngtCls.CRMdelegate = self;
    objServiceMngtCls.TargetDatabase = @"db_queueprocessor";
    objServiceMngtCls.qryString = [NSString stringWithFormat:@"UPDATE QP0610114_2456 SET periority = 2 WHERE subapplication = %@",@"Service Orders"];
    
    NSLog(@"Update query %@", objServiceMngtCls.qryString);
    
    rtnResult = [objServiceMngtCls excuteSqliteQryString];
    
    
    _openQPApp =TRUE;
    
    if(_counter == 2)
    {
        _counter=0;
    }
    
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerForTransferServiceTask:) name:@"StartAcitivityInd÷ææææ÷÷÷æicator" object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"StartAcitivityIndicator" object:nil];
//  [[NSNotificationCenter defaultCenter] postNotificationName:@"AcitivityIndicatorForContextData" object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerForServiceTask:) name:@"AcitivityIndicatorForContextData" object:nil];
    
//    didResignActive =FALSE;
//    GSPAppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];

//    if(didLaunchQP){
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"StartAcitivityIndicator" object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"AcitivityIndicatorForContextData" object:nil];
//    
//    [self initializeServiceTasksApiCall];
//        didLaunchQP = FALSE;
//
//    }

}



- (void)SAPResponseHandlerInDashboard:(NSNotification*)notification
{
    
    
    [[GSPOfflineViewConfiguration sharedInstance] checkReachabilityAndCofigureView:self.mainViewController];
    [[GSPOfflineViewConfiguration sharedInstance] checkReachabilityAndCofigureView:self.overViewController];
    
//    self.overviewController = [[GSPServiceTasksViewController alloc]init];
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
    
    
    else if ([notification.name isEqualToString:@"ActivityIndicatorForQP"]){
        [SVProgressHUD showWithStatus:@"Opening QP"];
    }
    
    
    else if ([notification.name isEqualToString:@"StopActivityIndicatorForQP"]){
        [SVProgressHUD dismiss];
    }
    
    
    
    if ([message isEqualToString:@"Loading Activity Indicator"])
    {
        //        if (self.refreshButtonClicked || databaseEmptyFlag)
                    [SVProgressHUD showWithStatus:statusMessage];
//        [SVProgressHUD showWithStatus:nil];
    }
    else if ([message isEqualToString:@"Stop Loading Activity Indicator"] && [notification.name isEqualToString:@"StartAcitivityIndicator"])
    {
      
        
        
               if ((!_iSOnlySync)&& callContextFlag){
                   
                   if([userInfo objectForKey:@"FLDVC"])
                       [diagnoseArray2 addObject:[userInfo objectForKey:@"FLDVC"]];

                    [self initializeContextDataApiCall];
                   callContextFlag = FALSE;
            return;
        }
        
   
        [self. mainViewController initialiseVariables];
        [self.overViewController getServiceTasksFromStorageAndReloadTableView];

        
//        [self.overviewController getServiceTasksFromStorageAndReloadTableView];
        /*        if (!self.refreshButtonClicked && !appDelegateObj.callContextDataApiFlag && [[GSPOfflineViewConfiguration sharedInstance] Is ConnectionAvailable]) {
         [[GSPUtility sharedInstance]showAlertWithTitle:@"Overview screen refreshed" message:@"ServiceTasks updated from server" otherButton:nil tag:0 andDelegate:self];
         }
         */
      // [self getServiceTasksFromStorageAndReloadTableView];
    
        [SVProgressHUD dismiss];
    }
    else if ([message isEqualToString:@"Stop Loading Activity Indicator"] && [notification.name isEqualToString:@"AcitivityIndicatorForContextData"])
    {
        
        //    *****   Added by Harshitha   *****
//        if([userInfo objectForKey:@"FLDVC"])
//            [diagnoseArray addObject:[userInfo objectForKey:@"FLDVC"]];
        
      //  [self getServiceTasksFromStorageAndReloadTableView];
        if([userInfo objectForKey:@"FLDVC"])
            [diagnoseArray2 addObject:[userInfo objectForKey:@"FLDVC"]];

         [self. mainViewController initialiseVariables];
        [self.overViewController getServiceTasksFromStorageAndReloadTableView];

//          [self.overviewController getServiceTasksFromStorageAndReloadTableView];
                [SVProgressHUD dismiss];
        NSLog(@"The diagnose array is %@",diagnoseArray2);
                [self checkPopUpStatusAndCallPopUpView];
        /*        if (!self.refreshButtonClicked && [[GSPOfflineViewConfiguration sharedInstance] IsConnectionAvailable])
         [[GSPUtility sharedInstance]showAlertWithTitle:@"Overview screen refreshed" message:@"ServiceTasks updated from server" otherButton:nil tag:0 andDelegate:self];
         */
       // [self checkPopUpStatusAndCallPopUpView];
    }
    else if([notification.name isEqualToString:@"ActivityIndicatorForQP"]){
        
        [SVProgressHUD showWithStatus:@"Opening QP"];

        
    }
    else
    {
        //        if (self.refreshButtonClicked && [[GSPOfflineViewConfiguration sharedInstance] IsConnectionAvailable])
        
        [self. mainViewController initialiseVariables];
        [self.overViewController getServiceTasksFromStorageAndReloadTableView];
//          [self.overviewController getServiceTasksFromStorageAndReloadTableView];

        [SVProgressHUD dismiss];
        //        else
        //            [[GSPUtility sharedInstance]showAlertWithTitle:@"Overview screen refreshed" message:@"ServiceTasks updated from server" otherButton:nil tag:0 andDelegate:self];
    }
}

- (void) checkPopUpStatusAndCallPopUpView
{
    
    NSString *popUpStatus= [[NSUserDefaults standardUserDefaults] stringForKey:@"stateOfSwitch"];
    
    if([popUpStatus isEqual: @"ON"]){
        _mainViewController.diagnoseArray1=diagnoseArray2;
        [ _mainViewController diagnoseInfo];
        
    }
}

- (void) diagnoseInfo
{
    GSPDiagnosePopUpViewController *diagpopup1;
    
    if (IS_IPAD) {
        diagpopup1 = [[GSPDiagnosePopUpViewController alloc]initWithNibName:@"GSPDiagnosePopUpViewController" bundle:nil withDiagnoseInfo:diagnoseArray2 andDisableDiagButton:1 fromScreen:nil];
        
        diagpopup1.view.frame = CGRectMake(self.window.rootViewController.view.bounds.size.width/2 - diagpopup1.view.frame.size.width/2, self.window.rootViewController.view.bounds.size.height - (diagpopup1.view.frame.size.height + 400 ), 495, 234);
    }
    else {
        diagpopup1 = [[GSPDiagnosePopUpViewController alloc]initWithNibName:@"GSPDiagnosePopUpViewController_iPhone" bundle:nil withDiagnoseInfo:diagnoseArray2 andDisableDiagButton:1 fromScreen:nil];
        
        diagpopup1.view.frame = CGRectMake(self.window.rootViewController.view.bounds.size.width/2 - diagpopup1.view.frame.size.width/2, self.window.rootViewController.view.bounds.size.height - (diagpopup1.view.frame.size.height + 200 ), 310, 188);
    }
    
    diagpopup1.view.layer.borderColor = [UIColor blackColor].CGColor;
    diagpopup1.view.layer.borderWidth = 1.0f;
    
    [self.window  addSubview:diagpopup1.view];
  //  [diagpopup.view  removeFromSuperview];
    
//    [self addChildViewController:diagpopup];
//    [diagpopup didMoveToParentViewController:self];
   }


-(void)initializeServiceTasksApiCall{
    
    ServiceOrderClass *objServiceOrderClass = [[ServiceOrderClass alloc] init];
    
    [objServiceOrderClass DownloadServiceDataFromSAP];
    
//    _openQPApp= TRUE;
    
    
}
- (void)initializeContextDataApiCall
{
    ContextDataClass *objContextDataClass=[[ContextDataClass alloc]init];
    [objContextDataClass downloadContextDataFrmSAP];
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
//  Original code.....Commented by Harshitha to call ServiceOrder api  
//    GSPLocationPingService *locationPingService = [GSPLocationPingService new];
//    [locationPingService initializePingServiceCall];
    
//    [GSPKeychainStoreManager setLocalNotifVariabletoYes];
//    if(isFirstLaunch ){
//        isFirstLaunch = FALSE ;
//        NSMutableArray *errorKeychainArray =[[NSMutableArray alloc]init];
//        errorKeychainArray = [GSPKeychainStoreManager getErrorItemsFromKeyChain];
//    
//    NSMutableDictionary *dic =[[NSMutableDictionary alloc]init];
//                   if(errorKeychainArray.count>0){
//                    [GSPKeychainStoreManager deleteErrorItemsFromKeyChain];
//
//            for(id item in errorKeychainArray){
//             
//                for( id key in item){
//                    
//                [dic setObject:[item objectForKey:key] forKey:key];
//            }
//            }
//                    
//                    NSLog(@"mutable dic %@",dic);
////
////                    for(id key in dic){
////                        id value =[dic objectForKey:@"appName"];
////                if([value isEqualToString:@"SERVICEPRO"]){
////                    
////                
////                [dic setObject:@"2" forKey:@"periority"];
////            }
////                    }
//                    NSMutableDictionary *mutableDic = [dic mutableCopy];
//                    
//                    [mutableDic setObject:@"1" forKey:@"periority"];
//                    
//                    
//                    NSLog(@"The mutated dictionary %@",mutableDic);
////                    for(NSString *key in mutableDic){
////                        id value = [dic objectForKey:key];
////                        NSLog(@"the value of a key %@",value);
////                        [value setObject:@"1" forKey:@"periority"]  ;
////                    }
////        }
////         [GSPKeychainStoreManager saveErrorItemsInKeychain:errorKeychainArray];
//                    
//                    NSMutableArray  *mutatedArray =[[NSMutableArray alloc]init];
//                    [mutatedArray addObject:mutableDic];
//                    NSLog(@"Mutated Array %@",mutatedArray);
//                    [GSPKeychainStoreManager saveErrorItemsInKeychain:mutatedArray];
//                    errorKeychainArray = [GSPKeychainStoreManager getErrorItemsFromKeyChain];
//                    NSLog(@"THe error items in error keychain %@",errorKeychainArray);
//           }
//
//    if(QPinstalledFlag){
//        [self changePriority];
//    }
//        _localNotifVariable= [GSPKeychainStoreManager fetchLocalNotifVariable];
//    NSLog(@"the notification keychain %@",_localNotifVariable);
//    
//        if([_localNotifVariable isEqualToString: @"YES"]){
////        NSArray * navigationViewControllerArray = [self.mainController viewControllers];
////        
////        for (UIViewController *VC in navigationViewControllerArray) {
////            if ([VC isKindOfClass:[GSPServiceTaskDetailViewController class] ]) {
////                [self.mainController popToViewController:VC animated:YES];
////                return;
////            }
////        }
//           
//            NSMutableArray *serviceOrderArray = [[NSMutableArray alloc]init];
//            
//            NSMutableArray  *tobeShownArray = [[NSMutableArray alloc]init];
//            
//      NSArray *  referenceIDvariable = [GSPKeychainStoreManager fetchLocalNotifReferenceID];
//        NSLog(@"The reference id for notification %@",[referenceIDvariable objectAtIndex:0]);
//        
//        NSLog(@"the serviceitem of notification %@",[referenceIDvariable objectAtIndex:1]);
//            ServiceOrderClass * serviceOrderClass   =  [ServiceOrderClass new];
////            self.notificationDataArray                    =  [serviceOrderClass GetServiceOrderOntapNotif:[referenceIDvariable objectAtIndex:0] andExtNum:[referenceIDvariable objectAtIndex:1]];
//            
//         NSString *tableName1 = [SERVICEORDER_OBJTYPE stringByAppendingString:@"ZGSXSMST_SRVCDCMNT10"];
//            
//            self.notificationDataArray =[serviceOrderClass getAllServiceOrdersFromDB:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",tableName1]];
//            NSLog(@"the notification data array %@",self.notificationDataArray);
//            
//            for(ServiceTask *serviceTask in self.notificationDataArray){
//                if([serviceTask.serviceOrder isEqualToString:[referenceIDvariable objectAtIndex:0]]&&[serviceTask.firstServiceItem isEqualToString:[referenceIDvariable objectAtIndex:1]]){
//              
//                    
//                    [tobeShownArray addObject:serviceTask];
//                   
//                }
//            }
//            
//            ServiceTask *serviceTaskObj = [tobeShownArray objectAtIndex:0];
//            NSLog(@"Notification UI Arrat %@",tobeShownArray);
//            
//            serviceOrderArray = self.notificationDataArray;
//            
//        GSPServiceTaskDetailViewController * taskDetailVC;
//
//        if(IS_IPAD){
//         taskDetailVC = [[GSPServiceTaskDetailViewController alloc]initWithNibName:@"GSPServiceTaskDetailVC_iPad_Landscape" bundle:nil withObject:serviceTaskObj atIndex:1 andOrdersArray:serviceOrderArray];    }
//    else
//    {
//        taskDetailVC = [[GSPServiceTaskDetailViewController alloc]initWithNibName:@"GSPServiceTaskDetailViewController" bundle:nil ];
//    }
//    
//    
//    
//    
//    
//    [self.mainController pushViewController:taskDetailVC animated:YES];
//        
//        [GSPKeychainStoreManager setLocalNotifVariable];
//            
//            
//// NSArray * navigationViewControllerArray = [self.navigationController viewControllers];
//
//    }
//    else{
    
    
   
        application.applicationIconBadgeNumber=0;
    NSLog(@"Entered foreground");
    
    isFirstLaunch = FALSE;
    
    
    _didBecomeActiveCounter++;
    
//
//                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"ActivityIndicatorQueueData" object:nil];
//                
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"ActivityIndicatorQueueData" object:nil userInfo:nil];
//                
//                
//                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"StartAcitivityIndicator" object:nil];
//                
//                
//                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"AcitivityIndicatorForContextData" object:nil];
//                
//                //     [self initializeServiceTasksApiCall];
//                
//                //        [appDelegateObj changePriority];
//                
//                
//                //        if([[applicationState objectAtIndex:0 ] isEqualToString:@"YES"]&& diff<=60 )
//                //        {
//                
//                dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
//                    timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(checkForPriority) userInfo:nil repeats:YES];
//                });
//            }
//            
//        }
//     }
//    
   
    
    
    
//    if(!appFirstLaunchFlag && [activeApp isEqualToString:@"Main"] && _openQPAppAtLaunch && QPinstalledFlag &&!_notificationLaunched){
//        
////        [self changePriority];
//        
//       
//        
////                             [[NSNotificationCenter defaultCenter] postNotificationName:@"ActivityIndicatorQueueData" object:nil userInfo:nil];
//        
//        
//                             [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"StartAcitivityIndicator" object:nil];
//    
//        
//                              [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"AcitivityIndicatorForContextData" object:nil];
//
//        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
//            timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(checkForPriority) userInfo:nil repeats:YES];
//        });
//        
//        _openQPAppAtLaunch = FALSE;
//    }
//    
//
// else if((!appFirstLaunchFlag  && _openQPApp  && [activeApp isEqualToString:@"ServiceOrders"] && QPinstalledFlag && !_notificationLaunched) || (!appFirstLaunchFlag  && _openQPApp  && [activeApp isEqualToString:@"Main"] && QPinstalledFlag && !_notificationLaunched)){
//     
//     
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"ActivityIndicatorForQP" object:nil];
//     
//     _counter ++;
//     
//     
//     
//     if(_counter == 1){
//         
//         
////         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"ActivityIndicatorForQP" object:nil];
////         [[NSNotificationCenter defaultCenter] postNotificationName:@"ActivityIndicatorForQP" object:nil];
//      
//       [self changePriority];
//         
////        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"ActivityIndicatorForQP" object:nil];
////          [[NSNotificationCenter defaultCenter] postNotificationName:@"ActivityIndicatorForQP" object:nil];
//      
//      [self openReceiverApp:nil];
//      
//    
////    timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(checkForPriority) userInfo:nil repeats:YES];
////     
//      
//      _openQPApp = FALSE;
//      
//     }
//     
//     else if(_counter == 2)
//     {
//         
////         [[NSNotificationCenter defaultCenter] postNotificationName:@"ActivityIndicatorQueueData" object:nil userInfo:nil];
//         
//         
//         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"StartAcitivityIndicator" object:nil];
//         
//         
//         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"AcitivityIndicatorForContextData" object:nil];
//         
//         dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
//             timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(checkForPriority) userInfo:nil repeats:YES];
//             
//         });
//         
//
//     }
//     
////    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"StartAcitivityIndicator" object:nil];
////      
////    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"AcitivityIndicatorForContextData" object:nil];
////        
////        
////    [self initializeServiceTasksApiCall];
//    }
//    
//      
//      
//      
//      
////      
////                      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"ActivityIndicatorQueueData" object:nil];
////      
////                      [[NSNotificationCenter defaultCenter] postNotificationName:@"ActivityIndicatorQueueData" object:nil userInfo:nil];
////      
////      
////                      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"StartAcitivityIndicator" object:nil];
////      
////      
////                      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"AcitivityIndicatorForContextData" object:nil];
////
////                           [self initializeServiceTasksApiCall];
////      
//                      //        [appDelegateObj changePriority];
//      
//      
//                      //        if([[applicationState objectAtIndex:0 ] isEqualToString:@"YES"]&& diff<=60 )
//                      //        {
//      
////                      dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
////                          timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(checkForPriority) userInfo:nil repeats:YES];
////                      });
//    
//
//
//  
//
//
//    
//    else if(_notificationLaunched){
//        
//        _notificationLaunched   = FALSE;
//          [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationDetailScreen" object:nil];
//        
//    }
    


        
    
    
    
    
//    if(QPinstalledFlag){
//        if(!appFirstLaunchFlag && [activeApp isEqualToString:@"Main"]){
//            [self changePriority];
//            
//            [self openReceiverApp:nil];
//
//            
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"ActivityIndicatorQueueData" object:nil];
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"ActivityIndicatorQueueData" object:nil userInfo:nil];
//            
//            
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"StartAcitivityIndicator" object:nil];
//            
//            
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"AcitivityIndicatorForContextData" object:nil];
//            
//            //     [self initializeServiceTasksApiCall];
//            
//            //        [appDelegateObj changePriority];
//            
//            
//            //        if([[applicationState objectAtIndex:0 ] isEqualToString:@"YES"]&& diff<=60 )
//            //        {
//            
//            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
//                timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(checkForPriority) userInfo:nil repeats:YES];
//            });
//        }
//
//        }
//    
}

-(void)checkForPriority{
    
//    _openQPApp = FALSE;
    
    @try{
        @synchronized(self){
            NSLog(@"Timer fired");
            
            
           
            
            
            NSMutableArray *errorKeyChainArray = [[NSMutableArray alloc]init];
            errorKeyChainArray = [GSPKeychainStoreManager getErrorItemsFromKeyChain];
            if(errorKeyChainArray.count>0){
                NSLog(@"Error items before API call %@",errorKeyChainArray);
                for(NSDictionary *dic in errorKeyChainArray){
                    if([[dic valueForKey:@"periority"]isEqualToString:@"3"]){
                        _keyChainProcessed= TRUE;
                    }
                }
                
                
                if(_keyChainProcessed){
                    _keyChainProcessed  = FALSE ;
                    [timer invalidate];
                    NSLog(@"Error items during API call %@",errorKeyChainArray);
                    [self initializeServiceTasksApiCall];
                }
            }
            else{
                [timer invalidate];

                [self initializeServiceTasksApiCall];
            }
        }
    }
    @catch (NSException * e) {
        NSLog(@"%@",e.reason );
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
//  *****  Added by Harshitha to call ServiceOrder api everytime app comes to foreground  *****
  
    NSLog(@"Entered didbecomeactive");
    
    
    if(_didBecomeActiveCounter>=1)
    {
    
    if(!appFirstLaunchFlag && [activeApp isEqualToString:@"Main"] && _openQPAppAtLaunch && QPinstalledFlag &&!_notificationLaunched){
        
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"StartAcitivityIndicator" object:nil];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"AcitivityIndicatorForContextData" object:nil];
        
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
            timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(checkForPriority) userInfo:nil repeats:YES];
        });
        
        _openQPAppAtLaunch = FALSE;
    }
    
    
    else if((!appFirstLaunchFlag  && _openQPApp  && [activeApp isEqualToString:@"ServiceOrders"] && QPinstalledFlag && !_notificationLaunched) || (!appFirstLaunchFlag  && _openQPApp  && [activeApp isEqualToString:@"Main"] && QPinstalledFlag && !_notificationLaunched)){
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"ActivityIndicatorForQP" object:nil];
        
        _counter ++;
        
        
        
        if(_counter == 1){
            
            
            //         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"ActivityIndicatorForQP" object:nil];
            //         [[NSNotificationCenter defaultCenter] postNotificationName:@"ActivityIndicatorForQP" object:nil];
            
            [self changePriority];
            
//                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"ActivityIndicatorForQP" object:nil];
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"ActivityIndicatorForQP" object:nil];
            
            [self openReceiverApp:nil];
            
            
            //    timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(checkForPriority) userInfo:nil repeats:YES];
            //
            
            _openQPApp = FALSE;
            
        }
        
        else if(_counter == 2)
        {
            
            //         [[NSNotificationCenter defaultCenter] postNotificationName:@"ActivityIndicatorQueueData" object:nil userInfo:nil];
            
            
            [[NSNotificationCenter defaultCenter]
             addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"StartAcitivityIndicator" object:nil];
            
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"AcitivityIndicatorForContextData" object:nil];
            
            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
                timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(checkForPriority) userInfo:nil repeats:YES];
                
            });
            
            
        }
        
        //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"StartAcitivityIndicator" object:nil];
        //
        //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"AcitivityIndicatorForContextData" object:nil];
        //
        //
        //    [self initializeServiceTasksApiCall];
    }
    
    
    
    
    
    //
    //                      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"ActivityIndicatorQueueData" object:nil];
    //
    //                      [[NSNotificationCenter defaultCenter] postNotificationName:@"ActivityIndicatorQueueData" object:nil userInfo:nil];
    //
    //
    //                      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"StartAcitivityIndicator" object:nil];
    //
    //
    //                      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"AcitivityIndicatorForContextData" object:nil];
    //
    //                           [self initializeServiceTasksApiCall];
    //
    //        [appDelegateObj changePriority];
    
    
    //        if([[applicationState objectAtIndex:0 ] isEqualToString:@"YES"]&& diff<=60 )
    //        {
    
    //                      dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
    //                          timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(checkForPriority) userInfo:nil repeats:YES];
    //                      });
    
    
    
    
    
    
    
    else if(_notificationLaunched){
        
        _notificationLaunched   = FALSE;
       
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openDetailScreen:) name:@"notificationDetailScreen" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationDetailScreen" object:nil];
        
    }


    if (([activeApp isEqualToString:@"ServiceOrders"]&& !QPinstalledFlag)||([activeApp isEqualToString:@"Main"]&& !QPinstalledFlag && !isFirstLaunch)){
       [[NSNotificationCenter defaultCenter] postNotificationName:@"callServiceOrderApi" object:nil];
    }
    
    else if( ([activeApp isEqualToString:@"ServiceOrderEdit"] )  ||([activeApp isEqualToString:@"ColleagueList"])) {
        self.didBecomeActive= TRUE;
    }
    
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(IBAction) openReceiverApp:(id)sender {
    
    
    
   
       //    _openQPApp = FALSE;
    
        // Opens the Receiver app if installed, otherwise displays an error
    UIApplication *ourApplication = [UIApplication sharedApplication];
    NSString *URLEncodedText = [@"This is a test string" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *ourPath = [@"openQueueProcessorUI://" stringByAppendingString:URLEncodedText];//com.gss.genericIOsQueueProcessor/
    NSURL *ourURL = [NSURL URLWithString:ourPath];
    if ([ourApplication canOpenURL:ourURL]) {
        
       
            
  
    
        [ourApplication openURL:ourURL];
        QPinstalledFlag = TRUE;
      
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerInDashboard:) name:@"StopActivityIndicatorForQP" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StopActivityIndicatorForQP" object:nil];
    
  
  
//  Comment while distributing app to client to avoid the popup
/*    else {
        //Display error
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"QueueProcessor app Not found" message:@"Please install Queue Processor app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
*/
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    // Display text
//    UIAlertView *alertView;
//    NSString *text = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    alertView = [[UIAlertView alloc] initWithTitle:@"Text" message:text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alertView show];

    return YES;
}

/*
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
//    UIApplicationState state = [application applicationState];
//    if (state != UIApplicationStateActive) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationDetailScreen" object:nil];
//        [self openParentApp:nil];
//    }
//    
//    application.applicationIconBadgeNumber = notification.applicationIconBadgeNumber - 1;
    
    [[GSPUtility sharedInstance]showAlertWithTitle:@"notification received" message:@"hi" otherButton:nil tag:0 andDelegate:self];
}
*/
-(void)changePriority{
    
    NSMutableArray *errorKeychainArray =[[NSMutableArray alloc]init];
    errorKeychainArray = [GSPKeychainStoreManager getErrorItemsFromKeyChain];
    
   
    NSMutableArray  *errorArray = [[NSMutableArray alloc]init];

    if(errorKeychainArray.count>0){
        [GSPKeychainStoreManager deleteErrorItemsFromKeyChain];
        
        for(id item in errorKeychainArray){
            
            NSLog(@"Item in error array %@",item);
            
            NSMutableDictionary *dic =[[NSMutableDictionary alloc]init];
            
            
            for( id key in item){
                
                [dic setObject:[item objectForKey:key] forKey:key];
                
                
            }
            [errorArray addObject:dic];
        }
        
        NSLog(@"mutable dic [priority] %@",errorArray);
        
        
        for(NSMutableDictionary *dict in errorArray){
            
            [dict setObject:@"2" forKey: @"periority"];
            
        }
        
        
        NSLog(@"Mutated Array %@",errorArray);
        [GSPKeychainStoreManager saveErrorItemsInKeychain:errorArray];
        errorKeychainArray = [GSPKeychainStoreManager getErrorItemsFromKeyChain];
        NSLog(@"THe error items in error keychain %@",errorKeychainArray);
    }
    

    
}
- (void) startTimer
{
    //    [NSTimer scheduledTimerWithTimeInterval:900 target:self selector:@selector(processQueueDataWhenTimerFired) userInfo:nil repeats:YES];
    
    
    NSMutableArray *errorKeychainArray =[[NSMutableArray alloc]init];
    errorKeychainArray = [GSPKeychainStoreManager getErrorItemsFromKeyChain];
    
    if(errorKeychainArray.count>0)
    [NSTimer scheduledTimerWithTimeInterval:5000 target:self selector:@selector(launchNotificationForRefID) userInfo:nil repeats:YES];
}

-(void)launchNotificationForRefID
{
   
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Log May 18,2017.txt"];
    NSLog(@"filepath is %@",filePath);
    
    
    
    NSMutableArray *allKeyItemsArray =[[NSMutableArray alloc]init];
    allKeyItemsArray = [GSPKeychainStoreManager allItemsArrayFromKeychain];
    NSLog(@"All Queued items %@",allKeyItemsArray);
    for(id items in allKeyItemsArray){
        NSString *objectId=[items objectForKey:@"referenceID"];
        
        NSString *appName = [items objectForKey:@"appName"];
        NSString   *firstServiceItem = [items objectForKey:@"firstServiceItem"];
        NSNumber *processCount = [items objectForKey:@"processCount"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"objectId"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
//        NSArray *keys = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
        NSLog(@"all keys %@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
        NSUserDefaults *userPreferences11 = [NSUserDefaults standardUserDefaults];
        
        [userPreferences11 setObject:@"LAUNCH" forKey:objectId];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *notifStatus= [[NSUserDefaults standardUserDefaults] stringForKey:objectId];
        NSLog(@"notif status is %@ for refrence id %@",notifStatus,objectId);
//        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"objectId"];

       if([processCount integerValue] >=1 && [notifStatus isEqualToString:@"LAUNCH"])
              {
           NSUserDefaults *userPreferences11 = [NSUserDefaults standardUserDefaults];
           
           [userPreferences11 setObject:@"NOTIFIED" forKey:objectId];
           [[NSUserDefaults standardUserDefaults] synchronize];
           UIUserNotificationSettings* settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
           [[UIApplication sharedApplication] registerUserNotificationSettings:settings];


            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            [localNotification setAlertAction:@"Launch"];
            [localNotification setAlertBody:[NSString stringWithFormat:@"Item : %@ of application : %@ is processed with error \n",objectId,appName]];
            [localNotification setHasAction: YES];
            [localNotification setApplicationIconBadgeNumber:[[UIApplication sharedApplication] applicationIconBadgeNumber]+1];
                  
                  _notifObjectID=objectId;
            
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:objectId,@"referenceID",firstServiceItem,@"firstServiceItem", nil];
                  
            
            localNotification.userInfo=dic;
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSLog(@"Launching notification ");
//           [userPreferences11 setObject:nil forKey:@"objectID"];
//           [[NSUserDefaults standardUserDefaults]synchronize];
           

            
        }
    }
//NSString *lauchNotif= [[NSUserDefaults standardUserDefaults] stringForKey:];
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    UIApplicationState state = [application applicationState];
    if (state != UIApplicationStateActive) {
        
        
        _notificationLaunched =TRUE;
//
//        
        NSString *ident = [notification.userInfo objectForKey:@"referenceID"];
        NSLog(@"ident of notification %@",ident);
        
        NSString *ident2 = [notification.userInfo objectForKey:@"firstServiceItem"];
        NSLog(@"ident of notification %@",ident2);
        
        
        
        [GSPKeychainStoreManager setLocalNotifVariable : ident andServiceItem :ident2 ];
        
       

//
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openDetailScreen:) name:@"notificationDetailScreen" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationDetailScreen" object:nil];
        

        

}
}


- (void)openDetailScreen:(NSNotification*)notification
{
//    [[GSPUtility sharedInstance]showAlertWithTitle:@"notification received" message:@"hi" otherButton:nil tag:0 andDelegate:self];
    _localNotifVariable= [GSPKeychainStoreManager fetchLocalNotifVariable];
    NSLog(@"the notification keychain %@",_localNotifVariable);
    @try{
    if([_localNotifVariable isEqualToString: @"YES"]){
        //        NSArray * navigationViewControllerArray = [self.mainController viewControllers];
        //
        //        for (UIViewController *VC in navigationViewControllerArray) {
        //            if ([VC isKindOfClass:[GSPServiceTaskDetailViewController class] ]) {
        //                [self.mainController popToViewController:VC animated:YES];
        //                return;
        //            }
        //        }
//        _notificationLaunched =TRUE;
        NSMutableArray *serviceOrderArray = [[NSMutableArray alloc]init];
        
        NSMutableArray  *tobeShownArray = [[NSMutableArray alloc]init];
        
        NSArray *  referenceIDvariable = [GSPKeychainStoreManager fetchLocalNotifReferenceID];
//        NSLog(@"The reference id for notification %@",[referenceIDvariable objectAtIndex:0]);
//        
//        NSLog(@"the serviceitem of notification %@",[referenceIDvariable objectAtIndex:1]);
        
        NSLog(@"the reference id for notif %@",[notification.userInfo objectForKey:@"referenceID"]);
        ServiceOrderClass * serviceOrderClass   =  [ServiceOrderClass new];
        //            self.notificationDataArray                    =  [serviceOrderClass GetServiceOrderOntapNotif:[referenceIDvariable objectAtIndex:0] andExtNum:[referenceIDvariable objectAtIndex:1]];
        
        NSString *tableName1 = [SERVICEORDER_OBJTYPE stringByAppendingString:@"ZGSXSMST_SRVCDCMNT10"];
        
        self.notificationDataArray =[serviceOrderClass getAllServiceOrdersFromDB:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",tableName1]];
        NSLog(@"the notification data array %@",self.notificationDataArray);
        
        for(ServiceTask *serviceTask in self.notificationDataArray){
            if([serviceTask.serviceOrder isEqualToString:[referenceIDvariable objectAtIndex:0]]&&[serviceTask.firstServiceItem isEqualToString:[referenceIDvariable objectAtIndex:1]]){
                
                
                [tobeShownArray addObject:serviceTask];
                
            }
        }
        
        ServiceTask *serviceTaskObj = [tobeShownArray objectAtIndex:0];
        NSLog(@"Notification UI Array %@",tobeShownArray);
        
        serviceOrderArray = self.notificationDataArray;
        
        GSPServiceTaskDetailViewController * taskDetailVC;
        
        if(IS_IPAD){
            taskDetailVC = [[GSPServiceTaskDetailViewController alloc]initWithNibName:@"GSPServiceTaskDetailVC_iPad_Landscape" bundle:nil withObject:serviceTaskObj atIndex:1 andOrdersArray:serviceOrderArray];    }
        else
        {
            taskDetailVC = [[GSPServiceTaskDetailViewController alloc]initWithNibName:@"GSPServiceTaskDetailViewController" bundle:nil ];
        }
        
        
        
        
    
        [self.mainController pushViewController:taskDetailVC animated:YES];
        
        [GSPKeychainStoreManager setLocalNotifVariable];
        
        
        // NSArray * navigationViewControllerArray = [self.navigationController viewControllers];
        
    }

}
    @catch(NSException *e){
        NSLog(@"%@",e.reason);
    }
}



- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void(^)())completionHandler
{
    
    NSLog(@"App activated through Notification" );
}

@end
