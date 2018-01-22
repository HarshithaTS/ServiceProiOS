//
//  MobileDBInterface.m
//  ServiceProUniverse
//
//  Created by GSS Mysore on 2/19/14.
//
//

#import "MobileDBInterface.h"

#import "ServiceDBHandler.h"
#import "GCDThreads.h"
#import "InputProperties.h"

#import "GSPAppDelegate.h"
#import "GSPKeychainStoreManager.h"


#import "GssMobileConsoleiOS.h"

@implementation MobileDBInterface

// We can still have a regular init method, that will get called the first time the Singleton is used.
- (id)init
{
    self = [super init];
    if (self) {
        
        objGCDThreads = [GCDThreads sharedInstance];
        
        objInputProperties = [InputProperties sharedInstance];
        
       
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

-(void) createSQLQueryStringFromParsedData:(NSMutableArray *) parsedResponseArry {
    
    NSString *tableName;
    NSString *createFieldStr = @"";
    NSString *insertFieldStrValue = @"";
    NSString *tempValueStr = @"";
    NSString *cdataStr = @"";
    NSString *responseType = @"";
   // NSString *respTypeStr = @"";
    NSMutableArray *createTableDescStrArry = [[NSMutableArray alloc] init];
    NSMutableArray *InsertQryStrArry = [[NSMutableArray alloc] init];
    NSMutableArray *dropTableStrArry = [[NSMutableArray alloc] init];
    NSMutableArray *deleteTblRcdArry = [[NSMutableArray alloc] init];
    _objectIdIndex = [[NSMutableDictionary alloc]init];
    
    _numberExtIndex = [[NSMutableDictionary alloc]init];
    
    
//  Added on 13th aug by Selvan
    NSMutableDictionary *tblNameResType = [[NSMutableDictionary alloc] init];
    
    
    NSMutableArray *tableNameArray = [[NSMutableArray alloc]init];
    
    NSMutableArray *objectIdArray = [[NSMutableArray alloc]init];
    
    NSMutableArray *numExtArray = [[NSMutableArray alloc]init];
    
    
        
    if (parsedResponseArry != NULL || [parsedResponseArry count]>0) {
   
    for (int index=0; index < [parsedResponseArry count]; index++) {
        
        NSArray *dataTypeFieldArray = [parsedResponseArry objectAtIndex:index];
        int strIndex = 0;
        //NSLog(@"Datatypefield array:%@",dataTypeFieldArray);
        
        
        //Index = 0  -  DATA-TYPE String
        //Index = 1  -  Table Name
        //Index = 2  -  Response Type & Row Count Details (Optional)
        
        //Based on this string we can call metadata part or data part
        cdataStr = [dataTypeFieldArray objectAtIndex:0];
   
        //Get Metadata for table creation/table structure
        if ([cdataStr isEqualToString:@"DATA-TYPE"]) {
            
            //Get Table Name to local variable
//  Original code
//            tableName = [dataTypeFieldArray objectAtIndex:1];
//  Modified by Harshitha
            tableName = [objInputProperties.objectType stringByAppendingString:[dataTypeFieldArray objectAtIndex:1]];
            
            [tableNameArray addObject:tableName];
            
            
            
            NSLog(@"Insert Query String %@",InsertQryStrArry);
            //Colleagues task data also come under ZGSXSMST_SRVCDCMNT10 table. this condition rename existing table and create new table for colleauge details based on the API name
// Original code
   /*         if ([objInputProperties.ApplicationEventAPI isEqualToString:@"SERVICE-DOX-FOR-COLLEAGUE-GET"] && [tableName isEqualToString:@"ZGSXSMST_SRVCDCMNT10"]) {
                tableName = @"ZGSCSMST_SRVCDCMNT10_COLLEAGUE";
            }
*/
            
            
            
            //Get response type to local variable
            if ([[dataTypeFieldArray objectAtIndex:2] hasPrefix:@"RESPONSE-TYPE"]) {
                responseType = [dataTypeFieldArray objectAtIndex:2];
                strIndex = 3;
            }
            else {
                responseType = @"";
                strIndex = 2;
            }
            
            createFieldStr = @"";
            
            

            
            
            //Get fields from index 3
            for (int fields=strIndex; fields <= [dataTypeFieldArray count]-1; fields++) {
                
                
                if([[dataTypeFieldArray objectAtIndex:fields]isEqualToString:@"OBJECT_ID"]){
                    [_objectIdIndex setObject :[NSString stringWithFormat :@"%d",fields]forKey :[dataTypeFieldArray objectAtIndex:1]];
                }
                if([[dataTypeFieldArray objectAtIndex:fields]isEqualToString:@"NUMBER_EXT"]||[[dataTypeFieldArray objectAtIndex:fields]isEqualToString:@"ZZSERVICEITEM"]){
                    [_numberExtIndex setObject :[NSString stringWithFormat :@"%d",fields]forKey :[dataTypeFieldArray objectAtIndex:1]];
                }
                
                    //Prepare create table string
                    createFieldStr = [createFieldStr stringByAppendingString:[dataTypeFieldArray objectAtIndex:fields]];
                    createFieldStr = [createFieldStr stringByAppendingString:@" TEXT"];
                    
                    if(fields<([dataTypeFieldArray count]- 1))
                    {
                        createFieldStr = [createFieldStr stringByAppendingString:@","];
                        
                    }
                
                    //Prepare table description
                    insertFieldStrValue = [insertFieldStrValue stringByAppendingString:[dataTypeFieldArray objectAtIndex:fields]];
                    if(fields<([dataTypeFieldArray count]- 1))
                    {
                        insertFieldStrValue = [insertFieldStrValue stringByAppendingString:@","];
                    
                    }
                
            }
            
// Added on 13th aug by Selvan
            //Store Response Type
            
            [tblNameResType setObject:[NSString stringWithFormat:@"%hhd",[self parseResponseType:responseType]] forKey:tableName];
// Added by Selvan ends here
            
            //Based on the response type, condition will work
            
           

            if ([self parseResponseType:responseType]) {
                //Drop Table string
                [dropTableStrArry addObject:[NSString stringWithFormat:@"DROP TABLE IF EXISTS %@",tableName]];
                
                //Add created query string into temporary array to later process
                [createTableDescStrArry addObject:[NSString stringWithFormat:@"CREATE TABLE %@ (%@)",tableName,createFieldStr]];
            }
            
            
            
            //Collect table and field name into one table for developer purpose
            //Add created query string into temporary array to later process
            [InsertQryStrArry addObject:[NSString stringWithFormat:@"INSERT INTO Table_Desc VALUES ('%@','%@')", tableName, insertFieldStrValue]];

        }
        //Filter Data part
        else if (![cdataStr hasPrefix:@"NOTATION"] && ![cdataStr hasPrefix:@"EVENT-RESPONSE"] && ![cdataStr hasPrefix:@"DATA-TYPE"]) {
            
            //Get tablename from Array
// Original code
//            tableName = [dataTypeFieldArray objectAtIndex:0];
// Modified by Harshitha
            tableName = [objInputProperties.objectType stringByAppendingString:[dataTypeFieldArray objectAtIndex:0]];

// Original code
/*           if ([objInputProperties.ApplicationEventAPI isEqualToString:@"SERVICE-DOX-FOR-COLLEAGUE-GET"] && [tableName isEqualToString:@"ZGSXSMST_SRVCDCMNT10"]) {
//                tableName = @"ZGSCSMST_SRVCDCMNT10_COLLEAGUE";
            }
*/
            
// Original code
            //Based on the response type, condition will work
/*            if (![self parseResponseType:responseType]) {
                //DELETE ALL RECORDS FROM THE TABLE (for full-sets and delta-sets feature)
                [deleteTblRcdArry addObject:[NSString stringWithFormat:@"DELETE FROM %@",tableName]];
            }
*/
            
// Modified on 13th aug by Selvan
            
           GSPAppDelegate *appDelegateObj = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];
            
            NSLog(@"responsetype = %@",tblNameResType);
            
            //Read Response Type From Dictionary
            BOOL apiResponseType;
            apiResponseType = [tblNameResType[tableName] boolValue];
            
            
            if(!(appDelegateObj.QPinstalledFlag)||[[parsedResponseArry objectAtIndex:1] containsObject:@"DIAGNOSIS-AND-CHECKS"]){
                
            //Based on the response type, condition will work
            if (!(apiResponseType)) {
                //DELETE ALL RECORDS FROM THE TABLE (for full-sets and delta-sets feature)
                [deleteTblRcdArry addObject:[NSString stringWithFormat:@"DELETE FROM %@",tableName]];
            }
//Modified on 13th aug by Selvan ends here
            
            for (int values=1; values <= [dataTypeFieldArray count]-1; values++) {
                tempValueStr = [tempValueStr stringByAppendingString:@"'"];
                tempValueStr = [tempValueStr stringByAppendingString:[[[dataTypeFieldArray objectAtIndex:values] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] stringByReplacingOccurrencesOfString:@"'" withString:@"`"] ];
                tempValueStr = [tempValueStr stringByAppendingString:@"'"];
                
                if(values<([dataTypeFieldArray count]- 1))
                {
                    tempValueStr = [tempValueStr stringByAppendingString:@","];
                }
            }
            
            //Inserting data into Sqlite DB
            [InsertQryStrArry addObject:[NSString stringWithFormat:@"INSERT INTO  %@ VALUES (%@)",tableName,tempValueStr]];
            tempValueStr = @"";
        }
            else {
                NSMutableArray * arrayOfTasksFromKeyChain = [GSPKeychainStoreManager getErrorItemsFromKeyChain];
                NSLog(@"The fetched items from keychain %@",arrayOfTasksFromKeyChain);
                
                
                
                if([arrayOfTasksFromKeyChain count]>0){
                    NSMutableArray *array=[[NSMutableArray alloc]init];
                    
                  if (!(apiResponseType)) {
                        for (NSDictionary *dic in arrayOfTasksFromKeyChain)
                        {
                            [array addObject:[dic objectForKey:@"referenceID"]];
                        }
                        
                        NSUInteger   objIndex= [[_objectIdIndex valueForKey:[dataTypeFieldArray objectAtIndex:0]]integerValue];
                        objIndex= objIndex-2;
                      
                      NSUInteger itemIndex = [[_numberExtIndex valueForKey:[dataTypeFieldArray objectAtIndex:0]]integerValue];
                      itemIndex = itemIndex-2;
//                        NSString *objectID= [dataTypeFieldArray objectAtIndex:[[objectIdIndex valueForKey:[dataTypeFieldArray objectAtIndex:0]]integerValue]];
                        
                        NSString *objectID=[dataTypeFieldArray objectAtIndex:objIndex];
                        NSLog(@"The object iD %@",objectID);
                        
                        [objectIdArray addObject:objectID];
                      
                      
                      NSString *numExt = [dataTypeFieldArray objectAtIndex:itemIndex];
                      NSLog(@"number extension %@",numExt);
                      
                      [numExtArray addObject:numExt];
                      
//                            if ([[dic valueForKey:@"referenceID"] isEqualToString:objectID]){
                                     if ([array containsObject:objectID]){

                                //DO NOTHING
                                
                            }
                            else{
                                [deleteTblRcdArry addObject:[NSString stringWithFormat:@"DELETE FROM %@ WHERE OBJECT_ID= %@ ",tableName,objectID]];
                            
                            for (int values=1; values <= [dataTypeFieldArray count]-1; values++) {
                                tempValueStr = [tempValueStr stringByAppendingString:@"'"];
                                tempValueStr = [tempValueStr stringByAppendingString:[[[dataTypeFieldArray objectAtIndex:values] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] stringByReplacingOccurrencesOfString:@"'" withString:@"`"] ];
                                tempValueStr = [tempValueStr stringByAppendingString:@"'"];
                                
                                if(values<([dataTypeFieldArray count]- 1))
                                {
                                    tempValueStr = [tempValueStr stringByAppendingString:@","];
                                }
                            }
                            
                            //Inserting data into Sqlite DB
                            [InsertQryStrArry addObject:[NSString stringWithFormat:@"INSERT INTO  %@ VALUES (%@)",tableName,tempValueStr]];
                            tempValueStr = @"";
                            
                        }

                    
                  }
                  else{
                      for (int values=1; values <= [dataTypeFieldArray count]-1; values++) {
                          tempValueStr = [tempValueStr stringByAppendingString:@"'"];
                          tempValueStr = [tempValueStr stringByAppendingString:[[[dataTypeFieldArray objectAtIndex:values] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] stringByReplacingOccurrencesOfString:@"'" withString:@"`"] ];
                          tempValueStr = [tempValueStr stringByAppendingString:@"'"];
                          
                          if(values<([dataTypeFieldArray count]- 1))
                          {
                              tempValueStr = [tempValueStr stringByAppendingString:@","];
                          }
                      }
                      
                      //Inserting data into Sqlite DB
                      [InsertQryStrArry addObject:[NSString stringWithFormat:@"INSERT INTO  %@ VALUES (%@)",tableName,tempValueStr]];
                      tempValueStr = @"";
                  }
                    
                }
                else{
                    if (!(apiResponseType)) {
                        //DELETE ALL RECORDS FROM THE TABLE (for full-sets and delta-sets feature)
                        [deleteTblRcdArry addObject:[NSString stringWithFormat:@"DELETE FROM %@",tableName]];
                    }
                    //Modified on 13th aug by Selvan ends here
                    
                    for (int values=1; values <= [dataTypeFieldArray count]-1; values++) {
                        tempValueStr = [tempValueStr stringByAppendingString:@"'"];
                        tempValueStr = [tempValueStr stringByAppendingString:[[[dataTypeFieldArray objectAtIndex:values] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] stringByReplacingOccurrencesOfString:@"'" withString:@"`"] ];
                        tempValueStr = [tempValueStr stringByAppendingString:@"'"];
                        
                        if(values<([dataTypeFieldArray count]- 1))
                        {
                            tempValueStr = [tempValueStr stringByAppendingString:@","];
                        }
                    }
                    
                    //Inserting data into Sqlite DB
                    [InsertQryStrArry addObject:[NSString stringWithFormat:@"INSERT INTO  %@ VALUES (%@)",tableName,tempValueStr]];
                    tempValueStr = @"";
                }
                
                
            }
        
    }
    }
    //Add created query string into temporary array to later process
    //NSLog(@"Table Creation Query Array: %@",createTableStrArry);
     NSLog(@"Insert Query String %@",InsertQryStrArry);
    
    //create table description table
    [createTableDescStrArry addObject:[NSString stringWithFormat:@"CREATE TABLE Table_Desc (TABLENAME TEXT,FIELDS TEXT)"]];
        
    //Delete existing record from table description table
    [dropTableStrArry addObject:[NSString stringWithFormat:@"DROP TABLE IF EXISTS Table_Desc"]];
        
    //Push All constructed query strings into sqlite
    
    //Drop table if exists
    [self pushParsedDataIntoSqliteDatabase:dropTableStrArry];
    //Table Structure Creation
    [self pushParsedDataIntoSqliteDatabase:createTableDescStrArry];
    //Delete records from existing table if necessary
    [self pushParsedDataIntoSqliteDatabase:deleteTblRcdArry];
    //Insert data into table
    [self pushParsedDataIntoSqliteDatabase:InsertQryStrArry];
    //End data creation
        
       [self deleteRowNotinServer:tableNameArray andObjectId:objectIdArray];
        
        [GSPKeychainStoreManager deleteItemsinGSMKeyChainNotinServer:objectIdArray];
        [GSPKeychainStoreManager deleteItemsinErrorKeyChainNotinServer:objectIdArray];
    
    // Empty created array
     createTableDescStrArry =nil;
     InsertQryStrArry = nil;
     dropTableStrArry = nil;
    
    
     }
    
}


-(void) pushParsedDataIntoSqliteDatabase: (NSMutableArray *) dbData {
    
    //Create DBHandler Instants and assign value to its property
    ServiceDBHandler *objServiceDBHandler = [[ServiceDBHandler alloc] init];
    
    
    if (dbData != NULL && [dbData count]>0) {
        //Open Database
        if ([objServiceDBHandler OpenSqliteDBConnection]) {
            //Execute sqlite query
            for (int rowCount=0; rowCount <= [dbData count]-1; rowCount++) {
                
//                if(rowCount==1000){
//                    
//                    objServiceDBHandler.qryString = [NSString stringWithFormat:@"COMMIT"];
//                    
//                    
//                    if ([objServiceDBHandler excuteSqliteQryString]) {
//                        NSLog(@"Query Executed!!");
//                    }
//                    else {
//                        NSLog(@"Qry Str : %@", [dbData objectAtIndex:rowCount]);
//                        NSLog(@"Query Not Executed!! %s",sqlite3_errmsg((__bridge sqlite3 *)(dbData)));
//                    }
//                        objServiceDBHandler.qryString = @"";
//                    
//                    //close database
//                    [objServiceDBHandler closeSqliteDBConnection];
//                    
//                }


               
                
                objServiceDBHandler.qryString = [dbData objectAtIndex:rowCount];
                
                if ([objServiceDBHandler excuteSqliteQryString]) {
                    NSLog(@"Query Executed!!");
                }
                else {
                    NSLog(@"Qry Str : %@", [dbData objectAtIndex:rowCount]);
                    NSLog(@"Query Not Executed!! %s",sqlite3_errmsg((__bridge sqlite3 *)(dbData)));
                    
                    
                    
                }
                objServiceDBHandler.qryString = @"";
            } 
            //close database
            [objServiceDBHandler closeSqliteDBConnection];
            
        }
    }
    
   objServiceDBHandler= nil;
    
}

-(BOOL) parseResponseType:(NSString *) strResponseType {
    
    //IF RESPONSE IS NOT BLANK THEN FULLSETS/DELTASETS FEATURE ENABLED SO FURTHER DATA HANDLING PROCESS WILL GO WITH FULL SETS CONDITIONS
    
     GSPAppDelegate *appDelegateObj = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];
    if (![strResponseType isEqualToString:@""]) {
   
        NSString *responseType = @"";
        NSInteger rowCount;
        
        
        NSArray *parseDataType = [strResponseType componentsSeparatedByString:@";"];
        
        
        NSRange range = [[parseDataType objectAtIndex:0] rangeOfString:@"="];
        responseType = [[[parseDataType objectAtIndex:0] substringFromIndex:NSMaxRange(range)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        
        range = [[parseDataType objectAtIndex:1] rangeOfString:@"="];
        rowCount = [[[[parseDataType objectAtIndex:1] substringFromIndex:NSMaxRange(range)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] integerValue];
        
        if ([responseType isEqualToString:@"FULL-SETS"] && rowCount == 0) {
            
            //Clear the table for the data type in the LDB
            //selvan = Drop Table and Create Table
            
            if(appDelegateObj.refreshClicked || appDelegateObj.isOnlyRefreshOverView){
                return NO;
            }
            
            return YES;
        }
        else if ([responseType isEqualToString:@"FULL-SETS"] && rowCount > 0) {
            
            //Refresh the table in the local DB with the n rows from SAP
            
            //selvan =  Drop Table and Create Table
            
            if(appDelegateObj.refreshClicked || appDelegateObj.isOnlyRefreshOverView){
                return NO;
            }
            return YES;
            
            
        }
        else if ([responseType isEqualToString:@"DELTA-SETS"] && rowCount == 0)
        {
            //If item selection is not applicable (e.g. SO list), Clear the table for the data type in the LDB; if item selection is applicable (e.g. Inventory for specific materials), delete the rows in the LDB corresponding to the item selection
            return YES;
            
        }
        else if ([responseType isEqualToString:@"DELTA-SETS"] && rowCount > 0)
        {
            //If item selection is not applicable (e.g. SO list), Refresh the table for the data type in the LDB with the data set received form the server; if item selection is applicable (e.g. Inventory for specific materials), refresh the rows in the LDB corresponding to the item selection with the data set received from the server
            return NO;
            
        }
       
       
        else
        {
            return YES;
        }
       
//        NSLog(@"Response %@", parseDataType);
//        NSLog(@"Response Type %@", responseType);
//        NSLog(@"Row Count %d", rowCount);
    }
    else
        return YES;
}

-(void)deleteRowNotinServer:(NSArray *)tableNameArray andObjectId:(NSArray*)objectIDArray{
    
    NSLog(@"All object ID array %@",objectIDArray);
    
  ServiceDBHandler* objServiceMngtCls                   = [[ServiceDBHandler alloc] init];

    for(int i=0;i<[tableNameArray count];i++){
        
        NSString *queryString1 = [NSString stringWithFormat:@"SELECT * FROM %@",[tableNameArray objectAtIndex:i]];
        objServiceMngtCls.qryString = queryString1;
        NSMutableArray  *resultArray = [objServiceMngtCls fetchDataFrmSqlite];
        NSLog(@"ALL rows from a table %@ =%@",[tableNameArray objectAtIndex:i],resultArray);
        
        for(NSDictionary *dic in resultArray){
            if([objectIDArray count]>0){
            if(![objectIDArray containsObject:[dic valueForKey:@"OBJECT_ID"]]){
                NSString *queryString2 = [NSString stringWithFormat:@"DELETE FROM %@ WHERE OBJECT_ID = %@",[tableNameArray objectAtIndex:i],[dic valueForKey:@"OBJECT_ID"]];
                objServiceMngtCls.qryString=queryString2;
                
                [objServiceMngtCls excuteSqliteQryString];
            
            }
            }
        }
        
        
    }
}
@end
