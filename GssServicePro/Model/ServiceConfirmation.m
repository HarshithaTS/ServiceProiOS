//
//  ServiceConfirmation.m
//  GssServicePro
//
//  Created by Riyas Hassan on 01/10/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "ServiceConfirmation.h"
#import <sqlite3.h>

@implementation ServiceConfirmation

@synthesize tableName;

- (NSMutableArray*) getFaultsOptionArraysWithQuery:(NSString*)sqlQuery
{
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.TargetDatabase    = contextDB;
    objServiceMngtCls.qryString         = sqlQuery;//[NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",@"ZGSXSMST_SYMPTMCODELIST10"];;
    
    NSMutableArray * statusDicArray     =[objServiceMngtCls fetchDataFrmSqlite];
    
    cntxResultArry                      = [[NSMutableArray alloc]init];
    
    
    for (NSDictionary * dic in statusDicArray)
    {
        NSString * codeGrpId = [dic valueForKey:@"CODEGRUPPE"];
        
        codeGrpId = [codeGrpId stringByAppendingString:[NSString stringWithFormat:@" %@",[dic valueForKey:@"KURZTEXT"]]];
        
        [cntxResultArry addObject:codeGrpId];
    }
    
    return cntxResultArry ;
    
}


- (BOOL) updateServicesConfirmationData: (NSString *) _queryString
{
    
    BOOL resp;
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.CRMdelegate       = self;
    objServiceMngtCls.TargetDatabase    = serviceRepotsDB;
    objServiceMngtCls.qryString         = _queryString;
    
    NSString *docsDir;
    NSArray *dirPaths;
    
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
            const char *sql_stmt ="CREATE TABLE IF NOT EXISTS ZGSXSMST_SRVCACTVTY10_TEMP (OBJECT_ID TEXT,SRCDOC_NUMBER_EXT INTEGER,NUMBER_EXT INTEGER,PRODUCT_ID TEXT,QUANTITY TEXT,PROCESS_QTY_UNIT TEXT,ZZITEM_DESCRIPTION TEXT,ZZITEM_TEXT TEXT,DATETIME_FROM TEXT,DATETIME_TO TEXT,DATE_FROM TEXT,DATE_TO TEXT,TIME_FROM TEXT,TIME_TO TEXT,TIMEZONE_FROM TEXT)";
            
            if (sqlite3_exec(contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table");
            }
        }
    }
    
    resp = [objServiceMngtCls excuteSqliteQryString];
    
    
    return resp;
    
}

- (BOOL) updateFaultData: (NSString *) _queryString
{
    
    BOOL resp;
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.CRMdelegate       = self;
    objServiceMngtCls.TargetDatabase    = serviceRepotsDB;
    objServiceMngtCls.qryString         = _queryString;
    
    NSString *docsDir;
    NSArray *dirPaths;
    
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
            const char *sql_stmt ="CREATE TABLE IF NOT EXISTS ZGSXSMST_SRVCCNFRMTNFAULT20 (NUMBER_EXT TEXT,ZZSYMPTMCODEGROUP TEXT,ZZSYMPTMCODE TEXT,ZZSYMPTMTEXT TEXT,ZZPRBLMCODEGROUP TEXT,ZZPRBLMCODE TEXT,ZZPRBLMTEXT TEXT,ZZCAUSECODEGROUP TEXT,ZZCAUSECODE TEXT,ZZCAUSETEXT TEXT)";
            
            if (sqlite3_exec(contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table");
            }
        }
    }
    
    resp = [objServiceMngtCls excuteSqliteQryString];
    
    
    return resp;
    
}

- (BOOL) updateSparesDataInDb: (NSString *) _queryString
{
    BOOL resp;
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.CRMdelegate       = self;
    objServiceMngtCls.TargetDatabase    = serviceRepotsDB;
    objServiceMngtCls.qryString         = _queryString;
    
    NSString *docsDir;
    NSArray *dirPaths;
    
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
            const char *sql_stmt ="CREATE TABLE IF NOT EXISTS ZGSXSMST_SRVCSPARE10_TEMP (NUMBER_EXT TEXT ,OBJECT_ID TEXT,PRODUCT_ID TEXT,QUANTITY TEXT,PROCESS_QTY_UNIT TEXT,ZZITEM_DESCRIPTION TEXT,ZZITEM_TEXT TEXT,SERIAL_NUMBER TEXT)";
            
            if (sqlite3_exec(contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table");
            }
        }
    }
    
    resp = [objServiceMngtCls excuteSqliteQryString];
    
    
    return resp;

}

- (NSMutableArray*) getTempServiceConfirmationDataArrayWithQueryStr:(NSString*)queryStr
{
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.TargetDatabase    = serviceRepotsDB;
    objServiceMngtCls.qryString         = queryStr;
    
    cntxResultArry                      = [objServiceMngtCls fetchDataFrmSqlite];
    
    return cntxResultArry ;
}


- (BOOL) deleteTempServiceConfirmationDataFromDBWithQueryString:(NSString*)queryStr
{
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.TargetDatabase    = serviceRepotsDB;
    objServiceMngtCls.qryString         = queryStr;
    
    BOOL resp;
    resp = [objServiceMngtCls excuteSqliteQryString];
    return resp;
    
}


- (NSMutableArray*) getServicePoupArrayForType
{
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.TargetDatabase    = contextDB;

//  Original code
//    objServiceMngtCls.qryString         = @"SELECT * FROM 'ZGSXSMST_SRVCACTVTYLIST10' WHERE 1";
    
// Modified by Harshitha
    tableName = [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXSMST_SRVCACTVTYLIST10"];
    objServiceMngtCls.qryString         = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",tableName];

    
    NSMutableArray * statusDicArray     =[objServiceMngtCls fetchDataFrmSqlite];
    
    cntxResultArry                      = [[NSMutableArray alloc]init];
    
    
    for (NSDictionary * dic in statusDicArray)
    {
        NSString * productId = [dic valueForKey:@"PRODUCT_ID"];
        
        productId = [productId stringByAppendingString:[NSString stringWithFormat:@" %@",[dic valueForKey:@"SHORT_TEXT"]]];
        
        [cntxResultArry addObject:productId];
    }
    
    return cntxResultArry ;
}

- (void) deleteTemporaryConfirmationRecordsFromDB
{
    
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.CRMdelegate       = self;
    objServiceMngtCls.TargetDatabase    = serviceRepotsDB;
    
    BOOL resp;
    NSString *_deleteSQl = @"";
    
     _deleteSQl= [NSString stringWithFormat:@"DELETE FROM ZGSXSMST_SRVCACTVTY10_TEMP WHERE 1"];
    
    objServiceMngtCls.qryString = _deleteSQl;
    resp = [objServiceMngtCls excuteSqliteQryString];
    
    //Creating Sql string delete temporary spare record already created
    _deleteSQl = [NSString stringWithFormat:@"DELETE FROM ZGSXSMST_SRVCSPARE10_TEMP WHERE 1"];
    objServiceMngtCls.qryString = _deleteSQl;
    resp = [objServiceMngtCls excuteSqliteQryString];
    
    //Create sql string to delete records from fault table
    _deleteSQl = [NSString stringWithFormat:@"DELETE FROM ZGSXSMST_SRVCCNFRMTNFAULT20 WHERE 1"];
    objServiceMngtCls.qryString = _deleteSQl;
    resp = [objServiceMngtCls excuteSqliteQryString];
 
}


- (NSMutableArray*) getSparesIdArray
{
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.TargetDatabase    = contextDB;

//  Original code
//    objServiceMngtCls.qryString         = @"SELECT * FROM 'ZGSXSMST_EMPLYMTRLLIST10' WHERE 1";
    
//  Modified by Harshitha
    tableName = [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXSMST_EMPLYMTRLLIST10"];
    objServiceMngtCls.qryString         = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",tableName];
    
    NSMutableArray * statusDicArray     =[objServiceMngtCls fetchDataFrmSqlite];
    
    cntxResultArry                      = [[NSMutableArray alloc]init];
    
    
    for (NSDictionary * dic in statusDicArray)
    {
        NSString * materialID   = [dic valueForKey:@"MATNR"];
        materialID              = [materialID stringByAppendingString:[NSString stringWithFormat:@": %@", [dic valueForKey:@"MAKTX_INSYLANGU"]]];
        
        [cntxResultArry addObject:materialID];
    }
    
    [cntxResultArry addObject:@"Other"];
    
    return cntxResultArry ;

}

// ***** Added by Harshitha on 10th Aug 2015 starts here *****
- (NSMutableArray*) getUnitsIdArray
{
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.TargetDatabase    = contextDB;
   
//    objServiceMngtCls.qryString         = @"SELECT * FROM 'ZGSXSMST_EMPLYMTRLLIST10' GROUP BY MEINS";
    tableName = [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXSMST_EMPLYMTRLLIST10"];
    objServiceMngtCls.qryString         = [NSString stringWithFormat:@"SELECT * FROM '%@' GROUP BY MEINS",tableName];
    
    NSMutableArray * statusDicArray     =[objServiceMngtCls fetchDataFrmSqlite];
    
    cntxResultArry                      = [[NSMutableArray alloc]init];
    
    
    for (NSDictionary * dic in statusDicArray)
    {
        NSString * unit   = [dic valueForKey:@"MEINS"];
        
        [cntxResultArry addObject:unit];
    }
    
    [cntxResultArry addObject:@"Other"];
    
    return cntxResultArry ;
    
}

- (NSMutableArray*) getMaterialIDArrayForSpareUnit:(NSString*)spareUnit
{
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.TargetDatabase    = contextDB;
//    objServiceMngtCls.qryString         = @"SELECT * FROM 'ZGSXSMST_EMPLYMTRLLIST10' WHERE 1";
    tableName = [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXSMST_EMPLYMTRLLIST10"];
    objServiceMngtCls.qryString         = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",tableName];
    
    NSMutableArray * statusDicArray     =[objServiceMngtCls fetchDataFrmSqlite];
    
    NSMutableArray *materialIdArray = [[NSMutableArray alloc]init];
    NSString * materialUnit = @"";
    
    if ([spareUnit isEqualToString:@"Other"]) {
        materialUnit = @"-------";
        [materialIdArray addObject:materialUnit];
    }
    
    for (NSDictionary * dic in statusDicArray)
    {
        NSString * spare_unit = [dic valueForKey:@"MEINS"];
        
        if ([spareUnit isEqualToString:spare_unit]) {
            
            materialUnit = [dic valueForKey:@"MATNR"];
            materialUnit = [materialUnit stringByAppendingString:[NSString stringWithFormat:@": %@", [dic valueForKey:@"MAKTX_INSYLANGU"]]];
            [materialIdArray addObject:materialUnit];
        }
    }
    
    return materialIdArray ;
    
}
// ***** Added by Harshitha on 10th Aug 2015 ends here *****

- (NSString*) getSpareUnitForMaterialID:(NSString*)materialID
{
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.TargetDatabase    = contextDB;

//  Original code
//    objServiceMngtCls.qryString         = @"SELECT * FROM 'ZGSXSMST_EMPLYMTRLLIST10' WHERE 1";
    
//  Modified by Harshitha
    tableName = [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXSMST_EMPLYMTRLLIST10"];
    objServiceMngtCls.qryString         = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",tableName];
    
    NSMutableArray * statusDicArray     =[objServiceMngtCls fetchDataFrmSqlite];
    
    NSString * materialUnit = @"";
    
    if ([materialID isEqualToString:@"Other"]) {
        materialUnit = @"-------";
    }
    
    for (NSDictionary * dic in statusDicArray)
    {
        NSString * materialId = [dic valueForKey:@"MATNR"];
        
        if ([materialID isEqualToString:materialId]) {

            materialUnit = [dic valueForKey:@"MEINS"];
        }
    }
    
    return materialUnit ;
    
}

-(void) updateServiceConfirmationInSAPServerWithInputArray:(NSMutableArray*)inputArray andReferenceID:(NSString*)referenceId
{
    
    objServiceMngtCls                           = [[GssMobileConsoleiOS alloc] init];
    
    objServiceMngtCls.ApplicationName           = @"SERVICEPRO";
    objServiceMngtCls.ApplicationVersion        = @"0";
    objServiceMngtCls.ApplicationResponseType   = @"";
    objServiceMngtCls.ApplicationEventAPI       = @"SERVICE-CONF-CREATE";
    objServiceMngtCls.InputDataArray            = inputArray;
    objServiceMngtCls.TargetDatabase            = serviceRepotsDB;
    objServiceMngtCls.Options                   = @"UPDATEDATA";
    objServiceMngtCls.RefernceID                = referenceId;
    objServiceMngtCls.subApp                    = @"Service Orders";

//    objServiceMngtCls.objectType                = @"Service Confirmation";
    objServiceMngtCls.objectType                = @"SOConf";
    
    objServiceMngtCls.CRMdelegate              = self;
    
    [objServiceMngtCls callSOAPWebMethod];
    
    
}

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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AcitivityIndicatorForServiceConfirmation" object:nil userInfo:userInfo];
    
    
}


@end
