//
//  ServiceConfirmation.h
//  GssServicePro
//
//  Created by Riyas Hassan on 01/10/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GssMobileConsoleiOS.h"

@interface ServiceConfirmation : NSObject<GssMobileConsoleiOSDelegate>
{
    
    GssMobileConsoleiOS *objServiceMngtCls;
    NSMutableArray      *cntxResultArry;
}

@property (nonatomic, strong) NSString *tableName;

- (NSMutableArray*) getServicePoupArrayForType;

- (BOOL) updateServicesConfirmationData: (NSString *) _queryString;

- (NSMutableArray*) getFaultsOptionArraysWithQuery:(NSString*) sqlQuery;

- (BOOL) updateFaultData: (NSString *) _queryString;

- (NSMutableArray*) getTempServiceConfirmationDataArrayWithQueryStr:(NSString*)queryStr;

- (BOOL) deleteTempServiceConfirmationDataFromDBWithQueryString:(NSString*)queryStr;

- (void) deleteTemporaryConfirmationRecordsFromDB;

- (NSMutableArray*) getSparesIdArray;

- (NSString*) getSpareUnitForMaterialID:(NSString*)materialID;

- (BOOL) updateSparesDataInDb: (NSString *) _queryString;

-(void) updateServiceConfirmationInSAPServerWithInputArray:(NSMutableArray*)inputArray andReferenceID:(NSString*)referenceId;

// Added by Harshitha on 10th Aug 2015
- (NSMutableArray*) getUnitsIdArray;
- (NSMutableArray*) getMaterialIDArrayForSpareUnit:(NSString*)spareUnit;

@end
