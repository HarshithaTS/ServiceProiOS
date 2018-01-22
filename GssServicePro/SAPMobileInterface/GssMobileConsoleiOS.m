//
//  GssMobileConsoleiOS.m
//  GssMobileConsoleiOS
//
//  Created by GSS Mysore on 8/4/14.
//  Copyright (c) 2014 GSS Mysore. All rights reserved.
//

#import "GssMobileConsoleiOS.h"

#import "SingletonClass.h"
#import "ServiceDBHandler.h"
#import "TouchXMLPARSER.h"
#import "serviceSOAPHandler.h"
#import "CheckedNetwork.h"
#import "UIDevice+IdentifierAddition.h"
//#import "GCDThreads.h"
#import "MobileDBInterface.h"
#import "GSSQProcessor.h"
#import "GSSBackgroundTask.h"

#import "InputProperties.h"
#import "GSPLocationManager.h"

#import "DiagnoseInfoClass.h"

#import "GSPKeychainStoreManager.h"

#import "GSPAppDelegate.h"

@implementation GssMobileConsoleiOS
@synthesize CRMdelegate;

@synthesize WebR_Thread_block;

@synthesize appDatabases;


@synthesize gssWebServiceUrl;

//XML Parser
@synthesize DatabaseCreateFlag;
@synthesize Options;
@synthesize OtherString;
@synthesize xmlDocument;
//***************************************************************************************



//Database
@synthesize dbName;
@synthesize qryString;

//*****************************************************************************************


@synthesize qProgressPgLoaded;

//static dispatch_once_t onceToken;

//Added by Harshitha
DiagnoseInfoClass *diagnosisInfoObj;

// We can still have a regular init method, that will get called the first time the Singleton is used.
- (id)init
{
    self = [super init];
    if (self) {
        
        objGCDThreads = [GCDThreads sharedInstance];
        
        objInputProperties = [InputProperties sharedInstance];
        
        qProgressPgLoaded = FALSE;
    }
    return self;
}
//*********************************************************************************************
//
//
//Plist Section
//
//
//
//*********************************************************************************************

-(void) readplistfile {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MobileSetup" ofType:@"plist"];
    MobileSetupDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    NSLog(@"%@",MobileSetupDictionary);
    //self.service_url = [dictionary objectForKey:@"SERVICEURL_PRD"];
    //self.service_url = [dictionary objectForKey:@"SERVICEURL_QA"];
    //self.buildName = [dictionary objectForKey:@"BUILDNAME"];
    
    self.gssWebServiceUrl =[MobileSetupDictionary objectForKey:@"ServiceURL3"];
    //self.PackageName = [MobileSetupDictionary objectForKey:@"PackageName"];
    self.appDatabases = [MobileSetupDictionary objectForKey:@"Database"];
    NSLog(@"web service url %@", self.gssWebServiceUrl);
    
}
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//End Plist Section
//>>>>>>>>>>>>>>>>>>>>>x>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


//*********************************************************************************************
//
//
//Database Section
//
//
//*********************************************************************************************

-(void) createEmptyDatabase {
    
    //Create DBHandler Instants and assign value to its property
    ServiceDBHandler *objServiceDBHandler = [[ServiceDBHandler alloc] init];
    
    [self readplistfile];
    
    
    for (int i=0; i<[self.appDatabases count]; i++) {
        
        
        NSLog(@"Creating Database %@",[self.appDatabases objectAtIndex:i]);
        
        objInputProperties.TargetDatabase = [self.appDatabases objectAtIndex:i];
        BOOL returnValue =  [objServiceDBHandler createEditableCopyOfDatabaseIfNotThere];
        
        if (returnValue) {
            NSLog(@"Database Created: %@", objInputProperties.TargetDatabase);
        }
        
    }
    
    
    objServiceDBHandler= nil;
}

//Execute all sqlite query
-(BOOL)excuteSqliteQryString{
    //Create DBHandler Instants and assign value to its property
    ServiceDBHandler *objServiceDBHandler = [[ServiceDBHandler alloc] init];
    
    objInputProperties.TargetDatabase = self.TargetDatabase;
    objServiceDBHandler.qryString = self.qryString;
    return [objServiceDBHandler excuteSqliteQryString];
    
}

//insert query into sqlite
-(int)insertSqliteQryString{
    //Create DBHandler Instants and assign value to its property
    ServiceDBHandler *objServiceDBHandler = [[ServiceDBHandler alloc] init];
    
    objInputProperties.TargetDatabase = self.TargetDatabase;
    objServiceDBHandler.qryString = self.qryString;
    return [objServiceDBHandler insertDataIntoDB];
    
}

-(NSMutableArray *)fetchDataFrmSqlite {
    ServiceDBHandler *objServiceDBHandler = [[ServiceDBHandler alloc] init];
    NSMutableArray *resultMutArray = [[NSMutableArray alloc] init];

    objInputProperties.TargetDatabase = self.TargetDatabase;
    objServiceDBHandler.qryString = self.qryString;
    
    NSLog(@"target db: %@",objInputProperties.TargetDatabase);
    NSLog(@"query str: %@",objServiceDBHandler.qryString);
    
    
    return resultMutArray = [objServiceDBHandler fetchDataFrmSqlite];
    
}

-(void) verifyDatabaseTableEmpty {
    
       GSPAppDelegate *appdelegateObject = (GSPAppDelegate*) [[UIApplication sharedApplication]delegate];
    
    //Create DBHandler Instants and assign value to its property
    ServiceDBHandler *objServiceDBHandler = [[ServiceDBHandler alloc] init];
    
    //Declare Local array for tables
    NSMutableArray *sqliteMasterDBTables = [[NSMutableArray alloc] init];
    
    objInputProperties.TargetDatabase = self.TargetDatabase;
    objServiceDBHandler.qryString = @"SELECT name FROM SQLITE_MASTER WHERE type='table'";
    sqliteMasterDBTables = [objServiceDBHandler fetchDataFrmSqlite];
    //NSLog(@"List tables available %@",sqliteMasterDBTables);
    
    //Declare local dictionary for tables
    NSMutableArray *sqliteMasterDBTablesArray = [[NSMutableArray alloc] init];
    
    //Re-Group/Simplify sqliteMasterDBTables Array
    for (int cnt=0; cnt < [sqliteMasterDBTables count]; cnt++) {
        
        [sqliteMasterDBTablesArray addObject:[[sqliteMasterDBTables objectAtIndex:cnt] objectForKey:@"name"]];
    }
    
    NSLog(@"List tables available %@",sqliteMasterDBTablesArray);
    NSMutableArray *resultArray;
    int cntEmptyTbls =0;
    
    
    //Read Array
    for (int cnt=0; cnt < [sqliteMasterDBTablesArray count]; cnt++) {
        objInputProperties.TargetDatabase = self.TargetDatabase;
        objServiceDBHandler.qryString = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",[sqliteMasterDBTablesArray objectAtIndex:cnt]];
        resultArray = [objServiceDBHandler fetchDataFrmSqlite];
        //Count Empty Tables
        if (resultArray == nil || [resultArray count] == 0)
            cntEmptyTbls = cntEmptyTbls + 1;
        
    }

// Added by Harshitha on 13th-Aug-2015 to call colleagues on FULL-SETS
    if (self.ApplicationResponseType.length == 0) {
       
    //Finalize FullSet/Delta Set here
    //if all tables are empty or no tables in DB then call Full Set otherwise delta set
        if (cntEmptyTbls >= [sqliteMasterDBTables count]) {
            self.ApplicationResponseType = @"[.]RESPONSE-TYPE[.]FULL-SETS";
        }
     
//        else if(appdelegateObject.refreshClicked || appdelegateObject.isOnlyRefreshOverView){
//           self.ApplicationResponseType = @"[.]RESPONSE-TYPE[.]REFRESHED";
//        }
        else
            self.ApplicationResponseType = @"";
    }
    
//    GSPAppDelegate * appDelegateObj = (GSPAppDelegate *)[[UIApplication sharedApplication]delegate];
//    appDelegateObj.databaseEmptyFlag = (cntEmptyTbls >= [sqliteMasterDBTables count]);
}

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//End Database Section
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


//*********************************************************************************************
//
//
//Webservice Section
//
//
//*********************************************************************************************
-(void) callSOAPWebMethod {
    
//   *****   Added by Harshitha    *****
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    GSPAppDelegate *appDelegateObj = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];
    
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *currentTime = [dateFormatter stringFromDate:[NSDate date]];
    
    diagnosisInfoObj = [DiagnoseInfoClass new];
    
    diagnosisInfoObj.diagnoseInfoArray = [[NSMutableArray alloc]init];
    
    [diagnosisInfoObj.diagnoseInfoArray addObject:[NSString stringWithFormat:@"START PROCESSING DEVICE %@",currentTime] ];
    
    [diagnosisInfoObj.diagnoseInfoArray addObject:[NSString stringWithFormat:@"EVENT: %@",self.ApplicationEventAPI]];
    
//   *****     Added by Harshitha ends   *****
    
    //SingletonClass* sharedSingleton = [SingletonClass sharedInstance];
    serviceSOAPHandler *objserviceSOAPHandler = [[serviceSOAPHandler alloc] init];
    TouchXMLPARSER *objTouchXMLPARSER = [[TouchXMLPARSER alloc] init];
    MobileDBInterface *objMobileDBInterface = [[MobileDBInterface alloc] init];
    
    
    //Read plist for webservice link
    [self readplistfile];
    
    //Check datbase table whether has empty or not to call full sets or delta sets
    [self verifyDatabaseTableEmpty];
    
    //Use singleton inputproperties
    objserviceSOAPHandler.whdlServiceURL = self.gssWebServiceUrl;
    objInputProperties.WebServiceUrl = self.gssWebServiceUrl;
    
    
    //USE WITH SOAP ENVALOP
    //Generate Own Device ID
    objInputProperties.CustomGCID = [[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier] uppercaseString];
    //objInputProperties.CustomGCID = self.CustomGCID;
    objInputProperties.ApplicationName = self.ApplicationName;
    
    if (!IS_SIMULATOR) {
        [[GSPLocationManager sharedInstance]initLocationMnager];
   
        objInputProperties.currentLocation =[[GSPLocationManager sharedInstance] currentLocation];
    }
    
//  Original code
//    objInputProperties.SoapDeviceIdentificationNumber = [NSString stringWithFormat:@"DEVICE-ID:%@:DEVICE-TYPE:IOS:APPLICATION-ID:%@:GLTTD:%f:GLNGTD:%f:",objInputProperties.CustomGCID,objInputProperties.ApplicationName,objInputProperties.currentLocation.coordinate.latitude,objInputProperties.currentLocation.coordinate.longitude];
    
//  Modified by Harshitha
    objInputProperties.SoapDeviceIdentificationNumber = [NSString stringWithFormat:@"DEVICE-ID:%@:DEVICE-TYPE:IOS:APPLICATION-ID:%@:DEVICE-ALTID:%@:GLTTD:%f:GLNGTD:%f:",objInputProperties.CustomGCID,objInputProperties.ApplicationName,[[[UIDevice currentDevice] uniqueDeviceIdentifier] uppercaseString],objInputProperties.currentLocation.coordinate.latitude,objInputProperties.currentLocation.coordinate.longitude];
    
//    NSLog(@"customGCID %@", objInputProperties.CustomGCID);
//    NSLog(@"Application Name %@", objInputProperties.ApplicationName);
//    NSLog(@"Device ID %@",objInputProperties.SoapDeviceIdentificationNumber);
    
    NSString *tempServiceItem;
    if([self.InputDataArray count]>=2){
    NSArray *tempArray = [[self.InputDataArray objectAtIndex:1]componentsSeparatedByString:@"[.]"];
    
   tempServiceItem= [tempArray objectAtIndex:3];
    NSLog(@"the item service number %@",tempServiceItem);
    }
    
    
    objInputProperties.NotationString           = @"NOTATION:ZML:VERSION:0:DELIMITER:[.]";
    objInputProperties.ApplicationName          = self.ApplicationName;
    objInputProperties.ApplicationVersion       = self.ApplicationVersion;
    objInputProperties.ApplicationResponseType  = self.ApplicationResponseType;
    objInputProperties.ApplicationEventAPI      = self.ApplicationEventAPI;
    objInputProperties.InputDataArray           = self.InputDataArray;
    objInputProperties.RefernceID               = self.RefernceID;
  //  objInputProperties.PackageName              = self.PackageName;
    objInputProperties.objectType               = self.objectType;
    objInputProperties.subApp                   = self.subApp;
    
    
    objInputProperties.firstItemService=tempServiceItem;
    
    NSLog(@"pro %@  %@",objInputProperties.ApplicationEventAPI,self.ApplicationEventAPI);
    //Convert input array as string to past it in clipboard
    objInputProperties.InputDataArrayStg = [self.InputDataArray componentsJoinedByString:@","];
  
    //Convert parsed data to sql query format to execute easly
    objInputProperties.TargetDatabase = self.TargetDatabase;
    
    NSLog(@"Target Database %@", objInputProperties.TargetDatabase);
    //End

    
    NSLog(@"is Internet Connection Available %hhd", [CheckedNetwork connectedToNetwork]);
   
    
    if ([CheckedNetwork connectedToNetwork]) {
        
        //dispatch_group_async(objGCDThreads.Task_Group,objGCDThreads.Concurrent_Queue_High,^{
    GSPAppDelegate *appDelegateObj = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];
        
            GSSQProcessor *objGSSQProcessor = [[GSSQProcessor alloc] init];
        
        if([objGSSQProcessor putOnlineDataIntoQtable]&& ( appDelegateObj.QPinstalledFlag)){
  
                NSLog(@"online data saved to Keycahin");
//                 dispatch_async(objGCDThreads.Concurrent_Queue_Default_SAPCRM, ^{
//                GSSQProcessor *objGSSQProcessor = [[GSSQProcessor alloc] init];
//                
//                
//                [objGSSQProcessor startProcessQueuedData];
//            GSSBackgroundTask * bgTask =[[GSSBackgroundTask alloc] init];
//
//            [bgTask stopBackgroundTask];
//                 });

            
        
        NSMutableArray *arrayOfTasksFromKeychain =[GSPKeychainStoreManager arrayFromKeychain];
        NSLog(@"The fetched items from keychain[ServicePro] %@",arrayOfTasksFromKeychain);
        
        NSMutableArray *errorItemsFromKeychain = [GSPKeychainStoreManager getErrorItemsFromKeyChain];
        if(errorItemsFromKeychain.count > 0){
            [ GSPKeychainStoreManager deleteErrorItemsFromKeyChain];
            for(NSDictionary *dic in errorItemsFromKeychain){
                if([[dic valueForKey:@"referenceID"]isEqualToString:objInputProperties.RefernceID]&& [[dic valueForKey:@"appName"]isEqualToString:objInputProperties.ApplicationName]){
                    
                    [errorItemsFromKeychain removeObject :dic];
                }
            }
            [GSPKeychainStoreManager saveErrorItemsInKeychain:errorItemsFromKeychain  ];
        }
        }
//        NSMutableArray * arrayOfTasksFromKeyChain = [GSPKeychainStoreManager allItemsArrayFromKeychain];
//        NSLog(@"The fetched items from keychain %@",arrayOfTasksFromKeyChain);
//            
//            if([arrayOfTasksFromKeyChain count]>0){
//                
//                [GSPKeychainStoreManager deleteAllItemsFromGSMKeyChain];
//                
//                for(NSDictionary *dic in arrayOfTasksFromKeyChain){
//
//                    if([[dic valueForKey:@"referenceID"]isEqualToString:objInputProperties.RefernceID]&&[[dic valueForKey:@"objectType"]isEqualToString:objInputProperties.objectType]&&[[dic valueForKey:@"firstServiceitem"]isEqualToString:objInputProperties.firstItemService]){
//                        
//                        [arrayOfTasksFromKeyChain removeObject:dic];
//                        
//                    }
//                }
//                
//            }
//            [GSPKeychainStoreManager saveAllItemsInKeychain:arrayOfTasksFromKeyChain];
 
        
        
        dispatch_async(objGCDThreads.Concurrent_Queue_Default_SAPCRM, ^{
            
//  *****  Added by Harshitha  *****
            [diagnosisInfoObj.diagnoseInfoArray addObject:[NSString stringWithFormat:@"API-BEGIN-TIME DEVICE %@",currentTime]];

            //SOPA CALL
            [objserviceSOAPHandler getResponseSAP];
            
            [diagnosisInfoObj.diagnoseInfoArray addObject:[NSString stringWithFormat:@"API-END-TIME DEVICE %@",currentTime]];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create
            dateFormatter.locale=[[NSLocale alloc ]initWithLocaleIdentifier:@"en-US" ];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            //This would be in hh:mm a
            [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
            NSString *convertedDateString = [dateFormatter stringFromDate:[NSDate date]];// here convert date
            NSLog(@"Today formatted date is %@",convertedDateString);

            NSUserDefaults *userPreferences1 = [NSUserDefaults standardUserDefaults];
           
            [userPreferences1 setObject:convertedDateString forKey:@"last_sync_time"];
             [[NSUserDefaults standardUserDefaults] synchronize];
            
            [diagnosisInfoObj.diagnoseInfoArray addObject:[NSString stringWithFormat:@"START PARSING %@",currentTime]];
            
            //XML PARSER (USING TouchXMLPARSER)
            NSMutableArray *postMssg = [objTouchXMLPARSER startParsingUsingData:objInputProperties.SAP_Response_Data nodesForXPath:@"//DpostMssg"];
            
            if (postMssg == nil) {
                
                postMssg = [objTouchXMLPARSER startParsingUsingData:objInputProperties.SAP_Response_Data nodesForXPath:@"//DpostOtpt"];
                
//   *****     Added by Harshitha    *****
                [diagnosisInfoObj.diagnoseInfoArray addObject:[NSString stringWithFormat:@"STOP PARSING %@",currentTime]];
                
                [diagnosisInfoObj.diagnoseInfoArray addObject:[NSString stringWithFormat:@"START DATABASE PROCESSING %@",currentTime]];
//   *****    Added by Harshitha ends   *****
                
                [objMobileDBInterface createSQLQueryStringFromParsedData:postMssg];
         
                NSString *objectString = [objMobileDBInterface.objectIdIndex valueForKey:@"ZGSXSMST_SRVCDCMNT10"];
                NSLog(@"the object string %@",objectString);
//   *****     Added by Harshitha    *****
                [diagnosisInfoObj.diagnoseInfoArray addObject:[NSString stringWithFormat:@"STOP DATABASE PROCESSING %@",currentTime]];
                
                [diagnosisInfoObj.diagnoseInfoArray addObject:[NSString stringWithFormat:@"STOP PROCESSING DEVICE %@",currentTime] ];
//   *****     Added by Harshitha ends   *****
                
            }
            else
            {
//   *****     Added by Harshitha    *****
                [diagnosisInfoObj.diagnoseInfoArray addObject:[NSString stringWithFormat:@"STOP PARSING %@",currentTime]];
                
                [diagnosisInfoObj.diagnoseInfoArray addObject:[NSString stringWithFormat:@"STOP DATABASE PROCESSING %@",currentTime]];
//   *****     Added by Harshitha ends   *****

                
                [self.CRMdelegate GssMobileConsoleiOS_Response_Message:@"Response" andMsgDesc:@"SAP Response Message" andFLD:postMssg];
                return ;
                
            }
            
            
            [self.CRMdelegate GssMobileConsoleiOS_Response_Message:@"Load" andMsgDesc:@"Loading Activity Indicator" andFLD:nil];
            
            //NSLog(@"Parsed data:%@", postMssg);
            dispatch_group_async(objGCDThreads.Task_Group_SAPCRM, objGCDThreads.Main_Queue_SAPCRM, ^{
                //Stop Active Indicator
                [self.CRMdelegate GssMobileConsoleiOS_Response_Message:@"S" andMsgDesc:@"Stop Loading Activity Indicator" andFLD:postMssg];
                
                appDelegateObj.updateFailureFlag = FALSE;
            });
            
            
            
        });
        
        
        dispatch_group_async(objGCDThreads.Task_Group_SAPCRM,objGCDThreads.Main_Queue_SAPCRM,^{
            [self.CRMdelegate GssMobileConsoleiOS_Response_Message:@"Load" andMsgDesc:@"Loading Activity Indicator" andFLD:nil];
            
        });
        
        
    }
    else {
        
        //re-direct data to queue processor table for later process
        GSSQProcessor *objGSSQProcessor = [[GSSQProcessor alloc] init];
// Flags added by Harshitha to check status of updation
        if ([objGSSQProcessor putDataIntoQtable] && appDelegateObj.QPinstalledFlag) {
            
            appDelegateObj.updateFailureFlag = FALSE;
            GSSBackgroundTask * bgTask =[[GSSBackgroundTask alloc] init];
            
            //Star the timer
            [bgTask startBackgroundTasks:20 target:self selector:@selector(backgroundCallback:)];
            // where call back  is -(void) backgroundCallback:(id)info
            
            //Stop the task
            [bgTask stopBackgroundTask];
        
        }
        
        else {
            appDelegateObj.updateFailureFlag = TRUE;
        }
        
        }
    
    objserviceSOAPHandler=nil ;
    objTouchXMLPARSER = nil ;
    
}

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//End Webservice Section
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-(void) backgroundCallback:(id)info{
    NSLog(@"call back code called");
    //Write code to check internect connectivity until it back
    GSSBackgroundTask * bgTask =[[GSSBackgroundTask alloc] init];
    
    
    if ([CheckedNetwork connectedToNetwork]) {
        
        GSSQProcessor *objGSSQProcessor = [[GSSQProcessor alloc] init];
        
        
        [objGSSQProcessor startProcessQueuedData];
        
        //Stop the task
        [bgTask stopBackgroundTask];

    }

}

// ***** Added by Harshitha *****
-(NSString*)getObjectType
{
//    return self.objectType;
    return objInputProperties.objectType;
}


@end
