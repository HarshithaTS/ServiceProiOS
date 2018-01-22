//
//  class_ServiceOrder.h
//  ServiceProUniverse
//
//  Created by GSS Mysore on 17/05/13.
//
//

#import <Foundation/Foundation.h>


//Integrate CRM Mobile Application Manager to Acces webservice and local database
#import "GssMobileConsoleiOS.h"

@class ServiceOrders;




@interface ServiceOrderClass : NSObject <GssMobileConsoleiOSDelegate>

{

    ServiceOrders *objServiceOrders;
    GssMobileConsoleiOS *objServiceMngtCls;
    GCDThreads *objGCDThreads;
    
}




@property (nonatomic, retain) NSString *objectID;
@property (nonatomic, retain) NSMutableArray *allServiceOrderArray;


@property (nonatomic, retain) NSString *editTaskId;
@property (nonatomic, retain) NSString *itemId;

//colleague
@property (nonatomic, retain)  NSString *colleagueName;
@property (nonatomic, retain)  NSString *colleagueTelNo;
@property (nonatomic, retain)  NSString *colleagueTelNo2;
@property (nonatomic, retain) NSString *colleagueAction;
@property (nonatomic, retain) NSMutableArray *colleagueListArray;


@property (nonatomic, retain) NSString *taskTranFrom;
@property (nonatomic, retain) NSString *taskTranTo;


@property (nonatomic, retain) NSString *tableName;





- (void) DownloadServiceDataFromSAP;
- (NSMutableArray *) GetAllServiceOrder;
- (NSMutableArray *) GetServiceOrder:(NSString *) _objectid;
- (NSMutableArray *) ServiceOrder :(NSString *) _query;
- (BOOL) updateServiceOrder: (NSString *) _queryString;
//- (BOOL) CheckServerAttachments:(NSString *) _objectID;
-(BOOL) CheckServerAttachments:(NSString *) _ServiceobjectID andExtNum:(NSString *)num;


//Added by Riaz

- (BOOL) deleteServiceOrder: (NSString *)serviceOrder andFirstServiceItem:(NSString*)serviceItem;

- (NSMutableArray *) getMultipleTasksForServiceOrder:(NSString *) _objectid;

- (NSMutableArray*) getTaskListRelatedTableNameArray;

- (NSMutableArray *) getAllServiceTasksForCollegues;

- (NSMutableArray*) getAllServiceOrdersFromDB:(NSString *) _query;

- (void) updateServiceOrderInSAPServerWithInputArray:(NSMutableArray*)inputArray andReferenceID:(NSString*)referenceId;


- (BOOL) deleteErrorTable:(NSString *) queryString;

- (NSMutableArray*) getErrorListArray:(NSString*)queryString;

- (NSMutableArray*) getPendingTasksFromQueProcessor;

- (NSMutableArray*) getServiceConfirmatiomnsActivityList:(NSString*)queryString;

// Added by Harshitha
- (BOOL) checkAdditionalPartners:(NSString *) _serviceobjectID andFirstServiceItem:(NSString *)firstServiceItem;
-(NSMutableArray *) getMultipleTasksForSO:(NSString *) _objectid;
- (void) inTableSwapRowWithID:(NSString *)objectID1 andServiceItem:(NSString *)serviceItem1 withID:(NSString *)objectID2 andItem:(NSString *)serviceItem2;
- (void) storeOrderForServices;


-(NSMutableArray *) GetServiceOrderOntapNotif:(NSString *) _objectid andExtNum :(NSString *)numberExt;
@end
