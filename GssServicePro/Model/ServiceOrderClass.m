//
//  class_ServiceOrder.m
//  ServiceProUniverse
//
//  Created by GSS Mysore on 17/05/13.
//
//

#import "ServiceOrderClass.h"
#import "ContextDataClass.h"

#import "GSPDateUtility.h"
#import "ServiceTask.h"

#import "diagnoseInfoClass.h"
#import <sqlite3.h>

@implementation ServiceOrderClass



@synthesize objectID,allServiceOrderArray;

@synthesize editTaskId,itemId;

@synthesize colleagueAction,colleagueTelNo2,colleagueTelNo,colleagueName,colleagueListArray,taskTranFrom,taskTranTo;



DiagnoseInfoClass *diagnosisInfoObj;
@synthesize tableName;

//=========SOAP CODE
-(void) DownloadServiceDataFromSAP {
    
    
    
    NSMutableArray *getInputArray       = [[NSMutableArray alloc] init];
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.CRMdelegate       = self;
    
    
    objServiceMngtCls.ApplicationName           = @"SERVICEPRO";
    objServiceMngtCls.ApplicationVersion        = @"0";
    objServiceMngtCls.ApplicationResponseType   = @"";
    objServiceMngtCls.ApplicationEventAPI       = @"SERVICE-DOX-FOR-EMPLY-BP-GET";
    objServiceMngtCls.InputDataArray            = getInputArray;
    objServiceMngtCls.subApp                    = @"Service Orders";
    
//    objServiceMngtCls.objectType                = @"Service Order List";
    objServiceMngtCls.objectType                = @"SOList";
    
    objServiceMngtCls.TargetDatabase            = serviceRepotsDB;
    objServiceMngtCls.RefernceID                = @"";
  

    [objServiceMngtCls callSOAPWebMethod];
    

    
    getInputArray = nil;
    objServiceMngtCls = nil;
}
//================================================================================================================================
//MESSAGE SHOWING TO USER - START
//Delegate for Service Management
-(void)GssMobileConsoleiOS_Response_Message:(NSString*)msg_type andMsgDesc :(NSString*)message andFLD:(NSMutableArray *) FLD_VC
{


    NSLog(@"SAPCRMMobileAppConsole Return Message Type: %@",msg_type);


    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
   
    [userInfo setObject:msg_type    forKey:@"action"];
    [userInfo setObject:message     forKey:@"responseMsg"];
    
    if (FLD_VC)
    {
        [userInfo setObject:FLD_VC      forKey:@"FLD_VC"];
    }

//   *****     Added by Harshitha    *****
//    For Diagnosis feature    
     if([msg_type isEqualToString:@"S"] || [msg_type isEqualToString:@"Response"])
    {
        
        NSMutableArray *diagnoseInfoArray = [[NSMutableArray alloc]init];
        
        if(FLD_VC) {
            
            diagnoseInfoArray = [diagnosisInfoObj getDiagnoseInfo];
            
            [userInfo setObject:diagnoseInfoArray      forKey:@"FLDVC"];

        }
    }
//   *****     Added by Harshitha ends   *****
    
        [[NSNotificationCenter defaultCenter] postNotificationName:@"StartAcitivityIndicator" object:nil userInfo:userInfo];
}


- (NSMutableArray *) GetAllServiceOrder {

//  Original code
//    return [self getAllServiceOrdersFromDB:[NSString stringWithFormat:@"SELECT * FROM 'ZGSXSMST_SRVCDCMNT10' WHERE 1"]];
    
// Modified by Harshitha
    tableName = [SERVICEORDER_OBJTYPE stringByAppendingString:@"ZGSXSMST_SRVCDCMNT10"];
    return [self getAllServiceOrdersFromDB:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",tableName]];

}
-(NSMutableArray *) GetServiceOrder:(NSString *) _objectid {
    
//  Original code
//    return [self ServiceOrder:[NSString stringWithFormat:@"SELECT * FROM 'ZGSXSMST_SRVCDCMNT10' WHERE OBJECT_ID = %@",_objectid]];
    
//  Modified by Harshitha
    tableName = [SERVICEORDER_OBJTYPE stringByAppendingString:@"ZGSXSMST_SRVCDCMNT10"];
    return [self ServiceOrder:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE OBJECT_ID = %@",tableName,_objectid]];
    
}

-(NSMutableArray *) getMultipleTasksForServiceOrder:(NSString *) _objectid {
    
// Original code
//    return [self getAllServiceOrdersFromDB:[NSString stringWithFormat:@"SELECT * FROM 'ZGSXSMST_SRVCACTVTY10' WHERE OBJECT_ID = %@",_objectid]];
    
// Modified by Harshitha
    tableName = [SERVICEORDER_OBJTYPE stringByAppendingString:@"ZGSXSMST_SRVCACTVTY10"];
    return [self getAllServiceOrdersFromDB:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE OBJECT_ID = %@",tableName,_objectid]];

}

- (NSMutableArray *) getAllServiceTasksForCollegues
{
//  Original code
//    return [self getAllServiceOrdersFromDB:[NSString stringWithFormat:@"SELECT * FROM 'ZGSCSMST_SRVCDCMNT10_COLLEAGUE' WHERE 1"]];
   
//  Modified by Harshitha
    tableName = [COLLEAGUE_OBJTYPE stringByAppendingString:@"ZGSXSMST_SRVCDCMNT10"];
    return [self getAllServiceOrdersFromDB:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",tableName]];
}



- (BOOL) updateServiceOrder: (NSString *) _queryString
{

        BOOL resp;
        objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
        objServiceMngtCls.CRMdelegate       = self;
        objServiceMngtCls.TargetDatabase    = serviceRepotsDB;
        objServiceMngtCls.qryString         = _queryString;
    
        resp = [objServiceMngtCls excuteSqliteQryString];
        return resp;

}

//-(BOOL) CheckServerAttachments:(NSString *) _ServiceobjectID {
-(BOOL) CheckServerAttachments:(NSString *) _ServiceobjectID andExtNum:(NSString *)num {
    
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.TargetDatabase    = serviceRepotsDB;

//  Original code
//    objServiceMngtCls.qryString         = [NSString stringWithFormat:@"SELECT * FROM ZGSXCAST_ATTCHMNT01 WHERE OBJECT_ID = '%@'",_ServiceobjectID];
    
//  Modified by Harshitha
    tableName = [SERVICEORDER_OBJTYPE stringByAppendingString:@"ZGSXCAST_ATTCHMNT01"];
//    objServiceMngtCls.qryString         = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE OBJECT_ID = '%@'",tableName,_ServiceobjectID];
    objServiceMngtCls.qryString         = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE OBJECT_ID = '%@' AND (NUMBER_EXT='%@' OR NUMBER_EXT='')",tableName,_ServiceobjectID,num];
    
    
    //CHECK SERVER ATTACHMENTS.
    NSMutableArray  *cntxResultArry     = [objServiceMngtCls fetchDataFrmSqlite];

    if ([cntxResultArry count]>0)
        return YES;
    else
        return NO;
    //**************************************************************************


}

//******************Added by riyas******************//
//To get array of service order objects from DB

- (NSMutableArray*) getAllServiceOrdersFromDB:(NSString *) _query
{
   GSPDateUtility *objCurrentDateTime = [GSPDateUtility sharedInstance];
    
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.CRMdelegate       = self;
    
    //Retrieving all service list data.
    objServiceMngtCls.TargetDatabase    = serviceRepotsDB;
    objServiceMngtCls.qryString         = _query;
    self.allServiceOrderArray           = [objServiceMngtCls fetchDataFrmSqlite];
    
    NSMutableArray * serviceOrderArray = [[NSMutableArray alloc]init];
    
    
    NSLog(@"serviceorderarray %@",self.allServiceOrderArray);
    
    
    
    for (NSMutableDictionary * serviceTaskDic in self.allServiceOrderArray) {
        
        ServiceTask * serviceTask               = [ServiceTask new];
        [serviceOrderArray addObject:serviceTask];
        
        serviceTask.contactName                 = [serviceTaskDic valueForKey:@"CP1_NAME1_TEXT"];
        serviceTask.telNum                      = [serviceTaskDic valueForKey:@"CP1_TEL_NO"];
        serviceTask.altTelNum                   = [serviceTaskDic valueForKey:@"CP1_TEL_NO2"];
        serviceTask.serviceOrderDescription     = [serviceTaskDic valueForKey:@"DESCRIPTION"];
        serviceTask.serviceLocation             = [[serviceTaskDic valueForKey:@"NAME_ORG1"] stringByAppendingString:[serviceTaskDic valueForKey:@"NAME_ORG2"]];
        serviceTask.serviceOrder                = [serviceTaskDic valueForKey:@"OBJECT_ID"];
        serviceTask.priority                    = [serviceTaskDic valueForKey:@"PRIORITY"];
        // selvan moved below serviceTask.serviceOrderTypeDesc        = [serviceTaskDic valueForKey:@"PROCESS_TYPE_DESCR"];

           serviceTask.serviceOrderType            = [serviceTaskDic valueForKey:@"PROCESS_TYPE"];
        
        serviceTask.statusText                  = [serviceTaskDic valueForKey:@"STATUS_TXT30"];
        serviceTask.status                      = [serviceTaskDic valueForKey:@"STATUS"];
        //selvan moved serviceTask.fieldNote                   = [serviceTaskDic valueForKey:@"ZZFIELDNOTE"];
        
        //selvan moved serviceTask.serviceNote                 = [serviceTaskDic valueForKey:@"NOTE"];
        serviceTask.searchString                = [serviceTaskDic valueForKey:@"SEARCH_STRING"];
//  Original code
//        serviceTask.firstServiceItem            = [serviceTaskDic valueForKey:@"ZZFIRSTSERVICEITEM"];
//        serviceTask.firstServiceProduct         = [serviceTaskDic valueForKey:@"ZZFIRSTSERVICEPRODUCT"];
//        serviceTask.firstServiceProductDescription= [serviceTaskDic valueForKey:@"ZZFIRSTSERVICEPRODUCTDESCR"];

//  Modified by Harshitha due to modification in field names
        serviceTask.firstServiceItem            = [serviceTaskDic valueForKey:@"ZZSERVICEITEM"];
        serviceTask.firstServiceProduct         = [serviceTaskDic valueForKey:@"ZZSERVICEPRODUCT"];
        serviceTask.firstServiceProductDescription= [serviceTaskDic valueForKey:@"ZZSERVICEPRODUCTDESCR"];
        
        serviceTask.timeZoneFrom                = [serviceTaskDic valueForKey:@"TIMEZONE_FROM"];
        serviceTask.partner                     = [serviceTaskDic valueForKey:@"PARTNER"];
        
        serviceTask.IB_description              = [serviceTaskDic valueForKey:@"IB_DESCR"];
        serviceTask.IB_iBase                    = [serviceTaskDic valueForKey:@"IB_IBASE"];
        serviceTask.IB_INS_description          = [serviceTaskDic valueForKey:@"IB_INST_DESCR"];
        serviceTask.IB_Instance                 = [serviceTaskDic valueForKey:@"IB_INSTANCE"];
        serviceTask.refObjProductID             = [serviceTaskDic valueForKey:@"REFOBJ_PRODUCT_ID"];
        serviceTask.refObjProductDescription    = [serviceTaskDic valueForKey:@"REFOBJ_PRODUCT_DESCR"];
        
        serviceTask.startDate                   = [objCurrentDateTime convertShortDateToStringFormat: [serviceTaskDic objectForKey:@"ZZKEYDATE"]];
        
//  Added by Harshitha
        serviceTask.startTime                   = [serviceTaskDic valueForKey:@"ZZKEYTIME"];
        serviceTask.startDateAndTime            = [NSString stringWithFormat:@"%@ %@",[serviceTaskDic objectForKey:@"ZZKEYDATE"],[serviceTaskDic objectForKey:@"ZZKEYTIME"]];
        if([serviceTaskDic valueForKey:@"REARRANGE_ORDER"]) {
            serviceTask.rearrangeOrder              = [serviceTaskDic valueForKey:@"REARRANGE_ORDER"];
        }
//  Added by Harshitha ends here
        
        serviceTask.locationAddress             = [NSString stringWithFormat:@"%@ %@ %@ %@",[serviceTaskDic valueForKey:@"STRAS"],
                                                   [serviceTaskDic valueForKey:@"ORT01"],
                                                   [serviceTaskDic valueForKey:@"PSTLZ"],
                                                   [serviceTaskDic valueForKey:@"LAND1"]];
        
        serviceTask.locationAddress1            = [serviceTaskDic valueForKey:@"STRAS"];
        serviceTask.locationAddress2            = [NSString stringWithFormat:@"%@, %@",[serviceTaskDic valueForKey:@"ORT01"],[serviceTaskDic valueForKey:@"LAND1"]];
        serviceTask.locationAddress3            = [serviceTaskDic valueForKey:@"PSTLZ"];
        
        
        //selvan added this code for activity
        if ([serviceTaskDic valueForKey:@"ZZETADATE"]) {
            serviceTask.serviceOrderTypeDesc        = [serviceTaskDic valueForKey:@"PROCESS_TYPE_DESCR"];

            serviceTask.serviceNote                 = [serviceTaskDic valueForKey:@"NOTE"];
            serviceTask.fieldNote                   = [serviceTaskDic valueForKey:@"ZZFIELDNOTE"];
            
            serviceTask.estimatedArrivalDate        = [serviceTaskDic valueForKey:@"ZZETADATE"];
            serviceTask.estimatedArrivalTime        = [serviceTaskDic valueForKey:@"ZZETATIME"];
            
            if (![[serviceTaskDic objectForKey:@"ZZETADATE"] isEqualToString:@"0000-00-00"] &&  ![[serviceTaskDic objectForKey:@"ZZETADATE"] isEqualToString:@""])
            {
                serviceTask.estimatedArrivalDate = [objCurrentDateTime convertShortDateToStringFormat: [serviceTaskDic objectForKey:@"ZZETADATE"]];
            }
            else
            serviceTask.estimatedArrivalDate = @"" ;
            
            if ([[serviceTaskDic objectForKey:@"ZZETATIME"] isEqualToString:@"00:00:00"] && [[serviceTaskDic objectForKey:@"ZZETADATE"] isEqualToString:@""])
            
            serviceTask.estimatedArrivalTime = @"";
            
            serviceTask.numberExtension = @"";
        }
        else
        {
            serviceTask.serviceOrderTypeDesc = @"";
            serviceTask.serviceNote = @"";
            serviceTask.fieldNote = @"";
            serviceTask.estimatedArrivalDate = @"";
            serviceTask.estimatedArrivalTime = @"";
            
            serviceTask.numberExtension             = [serviceTaskDic valueForKey:@"NUMBER_EXT"];
            serviceTask.product_id = [serviceTaskDic valueForKey:@"PRODUCT_ID"];
            serviceTask.zzitemdescription = [serviceTaskDic valueForKey:@"ZZITEM_DESCRIPTION"];
            serviceTask.zzitemtext = [serviceTaskDic valueForKey:@"ZZITEM_TEXT"];
            serviceTask.quantity = [serviceTaskDic valueForKey:@"QUANTITY"];
            serviceTask.processqtyunit = [serviceTaskDic valueForKey:@"PROCESS_QTY_UNIT"];

            serviceTask.serviceItem = [serviceTask.product_id stringByAppendingString:[NSString stringWithFormat:@" %@", serviceTask.zzitemdescription]];
            serviceTask.confirmationId = [serviceTaskDic valueForKey:@"SRCDOC_OBJECT_ID"];
            
        }
        //end

        
    }
    
    
    return serviceOrderArray;
}



-(void) updateServiceOrderInSAPServerWithInputArray:(NSMutableArray*)inputArray andReferenceID:(NSString*)referenceId
{
    
    objServiceMngtCls                           = [[GssMobileConsoleiOS alloc] init];
   
    objServiceMngtCls.ApplicationName           = @"SERVICEPRO";
    objServiceMngtCls.ApplicationVersion        = @"0";
    objServiceMngtCls.ApplicationResponseType   = @"";
    objServiceMngtCls.ApplicationEventAPI       = @"SERVICE-DOX-STATUS-UPDATE";
    objServiceMngtCls.InputDataArray            = inputArray;
    objServiceMngtCls.TargetDatabase            = serviceRepotsDB;
    objServiceMngtCls.Options                   = @"UPDATEDATA";
    objServiceMngtCls.RefernceID                = referenceId;
    
    objServiceMngtCls.subApp                    = @"Service Orders";
//    objServiceMngtCls.objectType                = @"Service Order Update";
    objServiceMngtCls.objectType                = @"SOUpdate";
    
     objServiceMngtCls.CRMdelegate              = self;
    
    [objServiceMngtCls callSOAPWebMethod];
    
    
}

- (NSMutableArray*) getTaskListRelatedTableNameArray
{

//  Original code
/*    NSMutableArray * dataSourceArray = [NSMutableArray arrayWithObjects:
                          @"ZGSXSMST_SRVCDCMNT10",
                          @"ZGSXSMST_SRVCACTVTYLIST10",
                          @"ZGSXSMST_CAUSECODELIST10",
                          @"ZGSXSMST_CAUSECODEGROUPLIST10",
                          
                          @"ZGSXSMST_PRBLMCODELIST10",
                          @"ZGSXSMST_PRBLMCODEGROUPLIST10",
                          @"ZGSXSMST_SYMPTMCODELIST10",
                          @"ZGSXSMST_SYMPTMCODEGROUPLIST10",
                          
                          @"ZGSXSMST_EMPLYMTRLLIST10",
                          @"ZGSCSMST_SRVCRPRTDATA10",
                          @"ZGSXCAST_EMPLY01",
                          @"ZGSCSMST_SRVCDCMNT10_COLLEAGUE",
                          
                          @"SERVICE-DOX-TRANSFER",
                          @"ZGSXSMST_SRVCACTVTY10",
                          @"ZGSXSMST_SRVCSPARE10",
                          @"ZGSXSMST_SRVCCNFRMTN12",nil];
*/

// Modified by Harshitha
    NSMutableArray * dataSourceArray = [NSMutableArray arrayWithObjects:
                                        [SERVICEORDER_OBJTYPE stringByAppendingString:@"ZGSXSMST_SRVCDCMNT10"],
                                        [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXSMST_SRVCACTVTYLIST10"],
                                        [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXSMST_CAUSECODELIST10"],
                                        [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXSMST_CAUSECODEGROUPLIST10"],
                                        
                                        [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXSMST_PRBLMCODELIST10"],
                                        [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXSMST_PRBLMCODEGROUPLIST10"],
                                        [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXSMST_SYMPTMCODELIST10"],
                                        [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXSMST_SYMPTMCODEGROUPLIST10"],
                                        
                                        [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXSMST_EMPLYMTRLLIST10"],
                                        @"ZGSCSMST_SRVCRPRTDATA10",
                                        [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXCAST_EMPLY01"],
                                        [COLLEAGUE_OBJTYPE stringByAppendingString:@"ZGSXSMST_SRVCDCMNT10"],
                                        
                                        [COLLEAGUE_OBJTYPE stringByAppendingString:@"SERVICE-DOX-TRANSFER"],
                                        [SERVICEORDER_OBJTYPE stringByAppendingString:@"ZGSXSMST_SRVCACTVTY10"],
                                        [SERVICEORDER_OBJTYPE stringByAppendingString:@"ZGSXSMST_SRVCSPARE10"],
                                        [SERVICEORDER_OBJTYPE stringByAppendingString:@"ZGSXSMST_SRVCCNFRMTN12"],nil];
    
    return dataSourceArray;

}

- (BOOL) deleteErrorTable:(NSString *) queryString

{
    BOOL resp;
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.CRMdelegate       = self;
    objServiceMngtCls.TargetDatabase    = qProcessorDB;
    objServiceMngtCls.qryString         = queryString;
    
    resp = [objServiceMngtCls excuteSqliteQryString];
    return resp;
}

- (NSMutableArray*) getErrorListArray:(NSString*)queryString
{
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.CRMdelegate       = self;
    objServiceMngtCls.TargetDatabase    = qProcessorDB;
    objServiceMngtCls.qryString         = queryString;
    NSMutableArray *errorListArray      = [objServiceMngtCls fetchDataFrmSqlite];
    
    return errorListArray;
}


- (NSMutableArray*) getPendingTasksFromQueProcessor
{
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.CRMdelegate       = self;
    objServiceMngtCls.TargetDatabase    = qProcessorDB;
    objServiceMngtCls.qryString         = @"SELECT * FROM 'tbl_QProcessor' WHERE 1";
    NSMutableArray *errorListArray      = [objServiceMngtCls fetchDataFrmSqlite];
    
    return errorListArray;
}

- (NSMutableArray*) getServiceConfirmatiomnsActivityList:(NSString*)queryString
{
    NSMutableArray *confirmationArray   = [self getAllServiceOrdersFromDB:queryString];
    
    return confirmationArray;
}

//******************Added by riyas Ends Here******************//

- (NSMutableArray *) ServiceOrder:(NSString *) _query
{
    
    GSPDateUtility *objCurrentDateTime  = [GSPDateUtility sharedInstance];
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.CRMdelegate       = self;
    
    
    //Retrieving all service list data.
    objServiceMngtCls.TargetDatabase    = serviceRepotsDB;
    objServiceMngtCls.qryString         = _query;
    self.allServiceOrderArray           = [objServiceMngtCls fetchDataFrmSqlite];
    
    
    for (int row=0; row < [self.allServiceOrderArray count]; row++) {
        
        NSMutableDictionary *tempDic = [self.allServiceOrderArray objectAtIndex:row];
        
        NSLog(@"service array %@", self.allServiceOrderArray);
        
        NSLog(@"Dictionary %@",tempDic);
        
        [tempDic setObject:[tempDic objectForKey:@"ZZETADATE"] forKey:@"ETADATE"];
        
        if (![[tempDic objectForKey:@"ZZETADATE"] isEqualToString:@"0000-00-00"] &&  ![[tempDic objectForKey:@"ZZETADATE"] isEqualToString:@""])
        {
            
            [tempDic setObject:[objCurrentDateTime convertShortDateToStringFormat: [tempDic objectForKey:@"ZZETADATE"]] forKey:@"ZZETADATE"];
        }
        else
            [tempDic setObject:@"" forKey:@"ZZETADATE"];
        
        
        
        if ([[tempDic objectForKey:@"ZZETATIME"] isEqualToString:@"00:00:00"] && [[tempDic objectForKey:@"ZZETADATE"] isEqualToString:@""])
            
            [tempDic setObject:@"" forKey:@"ZZETATIME"];
        
        //Convert date to 12 Jul, 2012 format,
        
        [tempDic setObject:[objCurrentDateTime convertShortDateToStringFormat1: [tempDic objectForKey:@"ZZKEYDATE"]] forKey:@"DISPLAY_DUE_DATE"];
        [tempDic setObject: [tempDic objectForKey:@"ZZKEYDATE"] forKey:@"DATE"];
        [tempDic setObject:[objCurrentDateTime convertShortDateToStringFormat: [tempDic objectForKey:@"ZZKEYDATE"]] forKey:@"ZZKEYDATE"];
        
        
        [tempDic setObject:[NSString stringWithFormat:@"%@ %@",[tempDic objectForKey:@"NAME_ORG1"],[tempDic objectForKey:@"NAME_ORG2"]] forKey:@"ORG_CUST_NAME"];
        
        
        
    }
    
    
    //***************
    
    return self.allServiceOrderArray;
    
}

- (BOOL) deleteServiceOrder: (NSString *)serviceOrder andFirstServiceItem:(NSString*)serviceItem
{
   
    BOOL resp;
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.CRMdelegate       = self;
    objServiceMngtCls.TargetDatabase    = serviceRepotsDB;

//  Original code
//    objServiceMngtCls.qryString         = [ NSString stringWithFormat:@"DELETE FROM ZGSXSMST_SRVCDCMNT10 WHERE OBJECT_ID='%@' AND ZZFIRSTSERVICEITEM = '%@'",serviceOrder, serviceItem];
  
//  Modified by Harshitha
    tableName = [SERVICEORDER_OBJTYPE stringByAppendingString:@"ZGSXSMST_SRVCDCMNT10"];
    objServiceMngtCls.qryString         = [ NSString stringWithFormat:@"DELETE FROM %@ WHERE OBJECT_ID='%@' AND ZZFIRSTSERVICEITEM = '%@'",tableName,serviceOrder, serviceItem];
    
    resp = [objServiceMngtCls excuteSqliteQryString];
   
    return resp;



}

//- (BOOL) deleteServiceOrder: (NSString *) _objectID: (NSString *) _item
//{
//
//
//    BOOL resp;
//    SingletonClass* sharedSingleton = [SingletonClass sharedInstance];
//    ServiceDBHandler* sharedDBHandler = [ServiceDBHandler sharedInstance];
//
//    sharedDBHandler.dbName = sharedSingleton.gssSystemDB;
//    sharedDBHandler.qryString = [NSString stringWithFormat:
//                                 @"DELETE FROM '%@' WHERE OBJECT_ID='%@' AND ZZFIRSTSERVICEITEM = '%@'",
//                                 @"ZGSXSMST_SRVCDCMNT10",_objectID,_item];
//    resp = [sharedDBHandler excuteSqliteQryString];
//    return resp;
//
//}


// ***** Added by Harshitha starts here *****
- (BOOL) checkAdditionalPartners:(NSString *) _serviceobjectID andFirstServiceItem:(NSString *)firstServiceItem
{
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.TargetDatabase    = serviceRepotsDB;
    
    tableName                           = [SERVICEORDER_OBJTYPE stringByAppendingString:@"ZGSXCAST_DCMNTPRTNR10EC"];

//    objServiceMngtCls.qryString         = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE OBJECT_ID = '%@' AND (NUMBER_EXT=%@ OR NUMBER_EXT='')",tableName,_serviceobjectID,firstServiceItem];
    objServiceMngtCls.qryString         = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE OBJECT_ID = '%@'",tableName,_serviceobjectID];
    
    NSMutableArray  *cntxResultArry     = [objServiceMngtCls fetchDataFrmSqlite];
    
    if ([cntxResultArry count]>0)
        return YES;
    else
        return NO;
    
}

-(NSMutableArray *) getMultipleTasksForSO:(NSString *) _objectid {
    
    tableName = [SERVICEORDER_OBJTYPE stringByAppendingString:@"ZGSXSMST_SRVCDCMNT10"];
    return [self getAllServiceOrdersFromDB:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE OBJECT_ID = %@",tableName,_objectid]];
}

- (void) storeOrderForServices
{
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.TargetDatabase    = serviceRepotsDB;
    
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *rearrangeOrderStatus= [[NSUserDefaults standardUserDefaults] stringForKey:@"reorderServices"];
    
// Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
// Build the path to the database file
    
    NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:serviceRepotsDB]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] != NO)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3 *contactDB;
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt ="CREATE TABLE IF NOT EXISTS ZGSXSMST_SRVCDCMNT10_REARRANGE_ORDER (OBJECT_ID,ZZSERVICEITEM,REARRANGE_ORDER)";
            
            if (sqlite3_exec(contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table");
            }
        }
    }
    
    tableName                           = [SERVICEORDER_OBJTYPE stringByAppendingString:@"ZGSXSMST_SRVCDCMNT10"];
    
    objServiceMngtCls.qryString         = [NSString stringWithFormat:@"SELECT * FROM '%@'",tableName];
    
    NSMutableArray  *cntxResultArry     = [objServiceMngtCls fetchDataFrmSqlite];
    
    if ([cntxResultArry count]>0)
    {
        if([rearrangeOrderStatus isEqual: @"ON"] || rearrangeOrderStatus == nil) {
            
            objServiceMngtCls.qryString     = [NSString stringWithFormat:@"DELETE FROM ZGSXSMST_SRVCDCMNT10_REARRANGE_ORDER WHERE 1"];
            [objServiceMngtCls excuteSqliteQryString];
        }
        
        int i = 1;
        
        for (NSDictionary *dic in cntxResultArry)
        {
            if([rearrangeOrderStatus isEqual: @"ON"] || rearrangeOrderStatus == nil) {
                
                NSString * tempValueStr         = [NSString stringWithFormat:@"'%@','%@','%@'",
                                                   [dic valueForKey:@"OBJECT_ID"],
                                                   [dic valueForKey:@"ZZSERVICEITEM"],
                                                   [NSString stringWithFormat:@"%d",i]
                                                   ];
            
                objServiceMngtCls.qryString     = [NSString stringWithFormat:@"INSERT INTO ZGSXSMST_SRVCDCMNT10_REARRANGE_ORDER (%@) VALUES (%@)",@"OBJECT_ID,ZZSERVICEITEM,REARRANGE_ORDER",tempValueStr];

                [objServiceMngtCls excuteSqliteQryString];
            
                i++;
            }
            else {
                objServiceMngtCls.qryString     = [NSString stringWithFormat:@"SELECT * FROM ZGSXSMST_SRVCDCMNT10_REARRANGE_ORDER WHERE OBJECT_ID = '%@' AND (ZZSERVICEITEM = '%@' OR ZZSERVICEITEM = '')",[dic valueForKey:@"OBJECT_ID"],[dic valueForKey:@"ZZSERVICEITEM"]];
                
                cntxResultArry     = [objServiceMngtCls fetchDataFrmSqlite];
                
                if (cntxResultArry.count == 0)
                {
                    objServiceMngtCls.qryString         = [NSString stringWithFormat:@"SELECT * FROM ZGSXSMST_SRVCDCMNT10_REARRANGE_ORDER WHERE 1"];                    
                    cntxResultArry               = [objServiceMngtCls fetchDataFrmSqlite];
                    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"REARRANGE_ORDER" ascending:YES];
                    NSArray *rearrangedOrderArray = [cntxResultArry sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
                    
                    int orderNum = [[[rearrangedOrderArray objectAtIndex:rearrangedOrderArray.count-1]valueForKey:@"REARRANGE_ORDER"]intValue];
                    
                    NSString * tempValueStr         = [NSString stringWithFormat:@"'%@','%@','%@'",
                                                       [dic valueForKey:@"OBJECT_ID"],
                                                       [dic valueForKey:@"ZZSERVICEITEM"],
                                                       [NSString stringWithFormat:@"%d",orderNum+1]
                                                       ];

                    objServiceMngtCls.qryString     = [NSString stringWithFormat:@"INSERT INTO ZGSXSMST_SRVCDCMNT10_REARRANGE_ORDER (%@) VALUES (%@)",@"OBJECT_ID,ZZSERVICEITEM,REARRANGE_ORDER",tempValueStr];
                    
                    [objServiceMngtCls excuteSqliteQryString];
                }
            }
        }
    }
}

- (void) inTableSwapRowWithID:(NSString *)objectID1 andServiceItem:(NSString *)serviceItem1 withID:(NSString *)objectID2 andItem:(NSString *)serviceItem2
{
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.TargetDatabase    = serviceRepotsDB;
    
    objServiceMngtCls.qryString     = [NSString stringWithFormat:@"SELECT REARRANGE_ORDER FROM ZGSXSMST_SRVCDCMNT10_REARRANGE_ORDER WHERE OBJECT_ID = '%@' AND (ZZSERVICEITEM = '%@' OR ZZSERVICEITEM = '')",objectID1,serviceItem1];

    NSMutableArray *cntxResultArry     = [objServiceMngtCls fetchDataFrmSqlite];
    NSString * order1 = [[cntxResultArry objectAtIndex:0] valueForKey:@"REARRANGE_ORDER"];

    objServiceMngtCls.qryString     = [NSString stringWithFormat:@"SELECT REARRANGE_ORDER FROM ZGSXSMST_SRVCDCMNT10_REARRANGE_ORDER WHERE OBJECT_ID = '%@' AND (ZZSERVICEITEM = '%@' OR ZZSERVICEITEM = '')",objectID2,serviceItem2];
    cntxResultArry     = [objServiceMngtCls fetchDataFrmSqlite];
    NSString * order2 = [[cntxResultArry objectAtIndex:0] valueForKey:@"REARRANGE_ORDER"];
    
    objServiceMngtCls.qryString     = [NSString stringWithFormat:@"UPDATE ZGSXSMST_SRVCDCMNT10_REARRANGE_ORDER SET REARRANGE_ORDER = '%@' WHERE OBJECT_ID = '%@' AND (ZZSERVICEITEM = '%@' OR ZZSERVICEITEM = '')",order2,objectID1,serviceItem1];
    [objServiceMngtCls excuteSqliteQryString];
    
    objServiceMngtCls.qryString     = [NSString stringWithFormat:@"UPDATE ZGSXSMST_SRVCDCMNT10_REARRANGE_ORDER SET REARRANGE_ORDER = '%@' WHERE OBJECT_ID = '%@' AND (ZZSERVICEITEM = '%@' OR ZZSERVICEITEM = '')",order1,objectID2,serviceItem2];
    [objServiceMngtCls excuteSqliteQryString];
    
}

// ***** Added by Harshitha ends here *****


-(NSMutableArray *) GetServiceOrderOntapNotif:(NSString *) _objectid andExtNum :(NSString *)numberExt{
    
    //  Original code
    //    return [self ServiceOrder:[NSString stringWithFormat:@"SELECT * FROM 'ZGSXSMST_SRVCDCMNT10' WHERE OBJECT_ID = %@",_objectid]];
    
    //  Modified by Harshitha
    tableName = [SERVICEORDER_OBJTYPE stringByAppendingString:@"ZGSXSMST_SRVCDCMNT10"];
    return [self ServiceOrder:[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE OBJECT_ID = %@ AND ZZSERVICEITEM = '%@' ",tableName,_objectid,numberExt]];
    
}



@end
