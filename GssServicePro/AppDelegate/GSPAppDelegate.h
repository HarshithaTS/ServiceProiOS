//
//  GSPAppDelegate.h
//  GssServicePro
//
//  Created by Riyas Hassan on 04/06/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSPViewController.h"

@class GSPViewController;

@class GSPServiceTasksViewController;
@interface GSPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIViewController * mainView;

@property (nonatomic, retain) UINavigationController *mainController;

// Added by Harshitha
@property (nonatomic, assign) BOOL callContextDataApiFlag;
@property (nonatomic, assign) BOOL didBecomeActive;
@property (nonatomic, retain) NSString * activeApp;
@property (nonatomic, assign) BOOL updateFailureFlag;
@property (nonatomic, assign) BOOL QPinstalledFlag;
//@property (nonatomic, assign) BOOL databaseEmptyFlag;
@property (nonatomic, assign) BOOL isTaskForTodayScreen;

@property(nonatomic,assign)BOOL notificationLaunched;
@property (atomic,assign) BOOL appFirstLaunchFlag;
//@property (atomic,assign) BOOL didResignActive;

@property(atomic,assign)BOOL callContextFlag;

@property(atomic,assign )BOOL iSOnlySync;

@property(atomic,assign)BOOL IsNotification;
@property (weak, nonatomic) GSPViewController *mainViewController;
@property (weak, nonatomic) GSPServiceTasksViewController *overViewController;

@property(nonatomic,assign)NSString *localNotifVariable;
//Added on 10th Aug 2015 by Selvan
@property (nonatomic, assign) BOOL saveChangesFlag;

@property(nonatomic ,assign)BOOL isFirstLaunch;
@property(strong,nonatomic)NSMutableArray *notificationDataArray;


@property(assign,nonatomic)BOOL refreshClicked;

@property(nonatomic,assign)BOOL isOnlyRefreshOverView;

@property(nonatomic,retain)NSString *notifObjectID;


@property(nonatomic,assign)BOOL keyChainProcessed;

@property(nonatomic,assign) BOOL openQPApp;

@property (nonatomic,assign) NSInteger counter;

@property (nonatomic,assign) NSInteger didBecomeActiveCounter;

@property(nonatomic,assign)BOOL openQPAppAtLaunch;
-(void)initializeServiceTasksApiCall;
-(IBAction) openReceiverApp:(id)sender ;

-(void)changePriority;
@end
