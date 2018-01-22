//
//  Colleagues.m
//  GssServicePro
//
//  Created by Riyas Hassan on 18/08/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "Colleagues.h"


@implementation Colleagues

@synthesize nameOne;
@synthesize nameTwo;
@synthesize partner;
@synthesize plant;
@synthesize searachString;
@synthesize storageLoc;
@synthesize telNumber;
@synthesize telNumberTwo;
@synthesize uName;

@synthesize tableName;

- (void) downloadColleguesTaskListFromSAP:(NSMutableArray*)inputArray
{
    
    objServiceMngtCls                           = [[GssMobileConsoleiOS alloc] init];
  
    objServiceMngtCls.CRMdelegate               = self;
    
    objServiceMngtCls.ApplicationName           = @"SERVICEPRO";
    objServiceMngtCls.ApplicationVersion        = @"0";
    objServiceMngtCls.ApplicationResponseType   = @"[.]RESPONSE-TYPE[.]FULL-SETS";
    objServiceMngtCls.ApplicationEventAPI       = @"SERVICE-DOX-FOR-COLLEAGUE-GET";
    objServiceMngtCls.InputDataArray            = inputArray;
    
    objServiceMngtCls.DatabaseCreateFlag        = @"2";
    objServiceMngtCls.Options                   = @"GETDATA";
    objServiceMngtCls.OtherString               = @"";
    objServiceMngtCls.TargetDatabase            = serviceRepotsDB;
    
    objServiceMngtCls.objectType                = @"ColgList";
    
    objGCDThreads = [GCDThreads sharedInstance];
    
    [objServiceMngtCls callSOAPWebMethod];
    
    
}

-(void)GssMobileConsoleiOS_Response_Message:(NSString*)msg_type andMsgDesc :(NSString*)message andFLD:(NSMutableArray *) FLD_VC{
    
    
    NSLog(@"SAPCRMMobileAppConsole Return Message Type: %@",msg_type);
    
    
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    
    [userInfo setObject:msg_type    forKey:@"action"];
    [userInfo setObject:message     forKey:@"responseMsg"];
    
    if (FLD_VC)
    {
        [userInfo setObject:FLD_VC      forKey:@"FLD_VC"];
    }
    
    if ([objServiceMngtCls.ApplicationEventAPI  isEqualToString:@"SERVICE-DOX-FOR-COLLEAGUE-GET"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchingServiceTasksForColleagues" object:nil userInfo:userInfo];
    }
    else
    {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"TransferTasksForColleagues" object:nil userInfo:userInfo];
    }
    
    
}


- (NSMutableArray*) getColleguesList
{
    
    objServiceMngtCls                       = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.TargetDatabase        = contextDB;

//  Original code
//    objServiceMngtCls.qryString             = [NSString stringWithFormat:@"SELECT * FROM 'ZGSXCAST_EMPLY01' WHERE 1"];
    
// Modified by Harshitha
    tableName = [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXCAST_EMPLY01"];
    objServiceMngtCls.qryString             = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",tableName];
    
    NSMutableArray * colleguesObjectsArray  =[objServiceMngtCls fetchDataFrmSqlite];
    
    NSMutableArray * colleguesArray         = [NSMutableArray new];
    
    for (Colleagues * collegues in colleguesObjectsArray) {
        
        Colleagues * colleague = [Colleagues new];
        [colleguesArray addObject:colleague];
        
        colleague.nameOne       = [collegues valueForKey:@"MC_NAME1"];
        colleague.nameTwo       = [collegues valueForKey:@"MC_NAME2"];
        colleague.partner       = [collegues valueForKey:@"PARTNER"];
        colleague.plant         = [collegues valueForKey:@"PLANT"];
        colleague.storageLoc    = [collegues valueForKey:@"STORAGE_LOC"];
        colleague.searachString = [collegues valueForKey:@"SEARCH_STRING"];
        colleague.telNumber     = [collegues valueForKey:@"TEL_NO"];
        colleague.telNumberTwo  = [collegues valueForKey:@"TEL_NO2"];
        colleague.uName         = [collegues valueForKey:@"UNAME"];

    }

    return colleguesArray;
}

- (void)deleteColleguesTaskTableContents
{
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.TargetDatabase    = serviceRepotsDB;

// Original code
//    objServiceMngtCls.qryString         = [NSString stringWithFormat:@"DELETE FROM ZGSCSMST_SRVCDCMNT10_COLLEAGUE WHERE 1"];
    
// Modified by Harshitha
    tableName = [COLLEAGUE_OBJTYPE stringByAppendingString:@"ZGSXSMST_SRVCDCMNT10"];
    objServiceMngtCls.qryString         = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE 1",tableName];

    [objServiceMngtCls excuteSqliteQryString];
}

- (void) transferColleaguesTaskServiceCall:(NSMutableArray*)inputArray
{
    objServiceMngtCls                           = [[GssMobileConsoleiOS alloc] init];
    
    objServiceMngtCls.CRMdelegate               = self;
    
    objServiceMngtCls.ApplicationName           = @"SERVICEPRO";
    objServiceMngtCls.ApplicationVersion        = @"0";
    objServiceMngtCls.ApplicationResponseType   = @"NO";
    objServiceMngtCls.ApplicationEventAPI       = @"SERVICE-DOX-TRANSFER";
    objServiceMngtCls.InputDataArray            = inputArray;
    
    objServiceMngtCls.DatabaseCreateFlag        = @"2";
    objServiceMngtCls.Options                   = @"UPDATEDATA";
    objServiceMngtCls.OtherString               = @"";
    objServiceMngtCls.TargetDatabase            = serviceRepotsDB;
    
    objServiceMngtCls.objectType                = @"Transfer";
    
    objGCDThreads = [GCDThreads sharedInstance];
    
    [objServiceMngtCls callSOAPWebMethod];
}



@end
