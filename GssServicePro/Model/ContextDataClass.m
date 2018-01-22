//
//  class_contextData.m
//  ServiceProUniverse
//
//  Created by GSS Mysore on 17/05/13.
//
//

#import "ContextDataClass.h"
#import "GssMobileConsoleiOS.h"
#import <sqlite3.h>

#import "diagnoseInfoClass.h"

@implementation ContextDataClass

NSMutableArray *cntxResultArry;

// Added by Harshitha
DiagnoseInfoClass *diagnosisInfoObj;
@synthesize tableName;
@synthesize tableName2;
@synthesize objType;

//=========SOAP CODE
-(void) downloadContextDataFrmSAP {
    
    
    NSMutableArray *getInputArray   = [[NSMutableArray alloc] init];
    objServiceMngtCls               = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.CRMdelegate   = self;
    
    
    objServiceMngtCls.ApplicationName           = @"SERVICEPRO";
    objServiceMngtCls.ApplicationVersion        = @"0";
    objServiceMngtCls.ApplicationResponseType   = @"";//@"FULL-SETS";
    objServiceMngtCls.ApplicationEventAPI       = @"SERVICE-DOX-CONTEXT-DATA-GET";
    objServiceMngtCls.InputDataArray            = getInputArray;
    
    
    objServiceMngtCls.TargetDatabase            = contextDB;
    objServiceMngtCls.DatabaseCreateFlag        = @"1";
    objServiceMngtCls.Options                   = @"GETDATA";
    objServiceMngtCls.OtherString               = @"";

    objServiceMngtCls.objectType                = @"SOContext";
    
    
    [objServiceMngtCls callSOAPWebMethod];
    
    
    getInputArray = nil;
    objServiceMngtCls = nil;
    
 
}

-(void)GssMobileConsoleiOS_Response_Message:(NSString*)msg_type andMsgDesc :(NSString*)message andFLD:(NSMutableArray *) FLD_VC {
    
    
    NSLog(@"SAPCRMMobileAppConsole Return Message Type: %@",msg_type);
    
    
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:msg_type forKey:@"action"];
    [userInfo setObject:message forKey:@"responseMsg"];
    
//   *****     Added by Harshitha    *****
//    For Diagnosis feature
    if([msg_type isEqualToString:@"S"])
    {
        
        NSMutableArray *diagnoseInfoArray = [[NSMutableArray alloc]init];
        
        if(FLD_VC) {
            
            diagnoseInfoArray = [diagnosisInfoObj getDiagnoseInfo];
            
            [userInfo setObject:diagnoseInfoArray      forKey:@"FLDVC"];

        }
    }
//   *****     Added by Harshitha ends   *****
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AcitivityIndicatorForContextData" object:nil userInfo:userInfo];
    
    
}





-(id) GetPeriority: (NSString *) _periority {
    
    
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.TargetDatabase    = contextDB;

//  Original code
//    objServiceMngtCls.qryString         = [NSString stringWithFormat:@"SELECT * FROM ZGSXCAST_PRRTY10 WHERE PRIORITY = '%@'",_periority];
    
// Modified by Harshitha
    tableName = [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXCAST_PRRTY10"];
    objServiceMngtCls.qryString         = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE PRIORITY = '%@'",tableName,_periority];

    return cntxResultArry               = [objServiceMngtCls fetchDataFrmSqlite];

}
-(id) GetStatus {
    
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.TargetDatabase    = contextDB;

//  Original code
//    objServiceMngtCls.qryString         = [NSString stringWithFormat:@"SELECT * FROM ZGSXCAST_STTS10 WHERE 1"];
    
// Modified by Harshitha
    tableName = [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXCAST_STTS10"];
    objServiceMngtCls.qryString         = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",tableName];
    
    return cntxResultArry               = [objServiceMngtCls fetchDataFrmSqlite];
}

-(id) GetStatus: (NSString *) _status {

    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.TargetDatabase    = contextDB;

//  Original code
//    objServiceMngtCls.qryString         = [NSString stringWithFormat:@"SELECT * FROM ZGSXCAST_STTS10 WHERE STATUS = '%@'",_status];
    
//  Modified by Harshitha
    tableName = [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXCAST_STTS10"];
    objServiceMngtCls.qryString         = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE STATUS = '%@'",tableName,_status];
    
    return cntxResultArry               = [objServiceMngtCls fetchDataFrmSqlite];

}

-(id) GetTXTStatus: (NSString *) _txtstatus {
    
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.TargetDatabase    = contextDB;

// Original code
//    objServiceMngtCls.qryString         = [NSString stringWithFormat:@"SELECT * FROM ZGSXCAST_STTS10 WHERE TXT30 = '%@'",_txtstatus];

// Modified by Harshitha
    tableName = [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXCAST_STTS10"];
    objServiceMngtCls.qryString         = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE TXT30 = '%@'",tableName,_txtstatus];
    
    return cntxResultArry               = [objServiceMngtCls fetchDataFrmSqlite];

}


-(id) GetStatusFlow: (NSString *) _status {
    
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.TargetDatabase    = contextDB;
    
//  Original code
//    objServiceMngtCls.qryString         = [NSString stringWithFormat:@"SELECT B.TXT30 FROM ZGSXCAST_STTSFLOW10 A INNER JOIN ZGSXCAST_STTS10 B ON A.STATUS_NEXT=B.STATUS WHERE A.STATUS = '%@'",_status];
    
//  Modified by Harshitha      
    tableName = [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXCAST_STTSFLOW10"];
    tableName2 = [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXCAST_STTS10"];
    objServiceMngtCls.qryString         = [NSString stringWithFormat:@"SELECT B.TXT30 FROM '%@' A INNER JOIN '%@' B ON A.STATUS_NEXT=B.STATUS WHERE A.STATUS = '%@'",tableName,tableName2,_status];
    
    return cntxResultArry               = [objServiceMngtCls fetchDataFrmSqlite];
 
}

-(id) GetError: (NSString *) _objectid {
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.TargetDatabase    = contextDB;
    objServiceMngtCls.qryString         = [NSString stringWithFormat:@"SELECT * FROM 'tbl_errorlist' WHERE apprefid = '%@'",_objectid];
    
    return cntxResultArry               = [objServiceMngtCls fetchDataFrmSqlite];

    
}

//******************Added by riyas******************//

- (NSString*) getStatusCodeForStatusText:(NSString*)statusText
{
    cntxResultArry = [self GetTXTStatus:statusText];
    
    NSString * statusCode;
    
    for (NSDictionary * dic in cntxResultArry)
    {
        statusCode  = [dic valueForKey:@"STATUS"];
    }
    
    return statusCode;
}

- (NSString*) getstatusPostSetActionForText:(NSString*)statusText
{
    cntxResultArry = [self GetTXTStatus:statusText];
    
    NSString * statusPostAction;
    
    for (NSDictionary * dic in cntxResultArry)
    {
        statusPostAction  = [dic valueForKey:@"ZZSTATUS_POSTSETACTION"];
    }
    
    return statusPostAction;
}


//To get the array of status string from DB

-(NSMutableArray*)getStatusListArray
{
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.TargetDatabase    = contextDB;

//  Original code
//    objServiceMngtCls.qryString         = [NSString stringWithFormat:@"SELECT TXT30 FROM ZGSXCAST_STTS10 WHERE 1"];
    
//  Modified by Harshitha
    tableName = [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXCAST_STTS10"];
    objServiceMngtCls.qryString         = [NSString stringWithFormat:@"SELECT TXT30 FROM '%@' WHERE 1",tableName];
    
    NSMutableArray * statusDicArray     =[objServiceMngtCls fetchDataFrmSqlite];
    
    cntxResultArry                      = [[NSMutableArray alloc]init];
    
    
    for (NSDictionary * dic in statusDicArray)
    {
        NSString * statusText = [dic valueForKey:@"TXT30"];
        [cntxResultArry addObject:statusText];
    }
    
    return cntxResultArry ;
}

- (NSMutableArray*) getTaskReasonArray
{
    cntxResultArry = [[NSMutableArray alloc] initWithObjects:@"On Leave",@"Sick",@"Engaged in another Job",@"Training",@"Travelling",@"Other", nil];
    return cntxResultArry;
}

- (NSString*)getStatusIconImageName:(NSString*)statusText
{
    
    
    cntxResultArry = [self GetTXTStatus:statusText];
    
    NSString * statusImageName;
    
    for (NSDictionary * dic in cntxResultArry)
    {
      statusImageName  = [dic valueForKey:@"ZZSTATUS_ICON"];
    }

    return statusImageName;
}


//     *****     Added by Harshitha to fetch the next possible statuses     *****

-(NSMutableArray*) getStatusListArrayForPicker: (NSString *) _status andProcessType : (NSString*) processType {
    
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.TargetDatabase    = contextDB;
    
    tableName = [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXCAST_STTSFLOW10"];
    tableName2 = [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXCAST_STTS10"];
    objServiceMngtCls.qryString         = [NSString stringWithFormat:@"SELECT B.TXT30 FROM '%@' A INNER JOIN '%@' B ON A.STATUS_NEXT=B.STATUS WHERE A.STATUS = '%@' AND A.PROCESS_TYPE ='%@'",tableName,tableName2,_status,processType];
    
    NSMutableArray * statusDicArray     =[objServiceMngtCls fetchDataFrmSqlite];
    
    if ([statusDicArray count] == 0) {
        objServiceMngtCls.qryString         = [NSString stringWithFormat:@"SELECT B.TXT30 FROM '%@' A INNER JOIN '%@' B ON A.STATUS_NEXT=B.STATUS WHERE A.STATUS = '%@' AND A.PROCESS_TYPE ='*'",tableName,tableName2,_status];
        
        statusDicArray     =[objServiceMngtCls fetchDataFrmSqlite];
    }
    
    cntxResultArry                      = [[NSMutableArray alloc]init];
    
    
    for (NSDictionary * dic in statusDicArray)
    {
        NSString * statusText = [dic valueForKey:@"TXT30"];
        [cntxResultArry addObject:statusText];
    }
    
    return cntxResultArry ;
}

- (NSString*) getStatusTextForStatusCode:(NSString*)statusCode
{
    cntxResultArry = [self GetStatuscode:statusCode];
    
    NSString * statusText;
    
    for (NSDictionary * dic in cntxResultArry)
    {
        statusText  = [dic valueForKey:@"TXT30"];
    }
    
    return statusText;
}

-(id) GetStatuscode: (NSString *) _statusCode {
    
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.TargetDatabase    = contextDB;
    
    tableName = [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXCAST_STTS10"];
    objServiceMngtCls.qryString         = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE STATUS = '%@'",tableName,_statusCode];
    
    return cntxResultArry               = [objServiceMngtCls fetchDataFrmSqlite];
    
}
//     *****     Added by Harshitha ends here     *****

@end
