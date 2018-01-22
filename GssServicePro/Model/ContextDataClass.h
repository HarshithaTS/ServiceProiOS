//
//  class_contextData.h
//  ServiceProUniverse
//
//  Created by GSS Mysore on 17/05/13.
//
//

#import <Foundation/Foundation.h>
//Integrate CRM Mobile Application Manager to Acces webservice and local database
#import "GssMobileConsoleiOS.h"


@interface ContextDataClass : NSObject <GssMobileConsoleiOSDelegate>
{

    GssMobileConsoleiOS *objServiceMngtCls;
}

// Added by Harshitha
@property (nonatomic, retain) NSString *tableName;
@property (nonatomic, retain) NSString *tableName2;
@property (nonatomic, retain) NSString *objType;

-(void) downloadContextDataFrmSAP;


-(id) GetPeriority: (NSString *) _periority;


-(id) GetStatus;
-(id) GetStatus: (NSString *) _status;
-(id) GetTXTStatus: (NSString *) _txtstatus;
-(id) GetStatusFlow: (NSString *) _status;


-(id) GetError: (NSString *) _objectid;

//Added by Riyas

- (NSMutableArray*) getStatusListArray;

- (NSMutableArray*) getTaskReasonArray;

- (NSString*) getStatusIconImageName:(NSString*)statusText;

- (NSString*) getStatusCodeForStatusText:(NSString*)statusText;

- (NSString*) getstatusPostSetActionForText:(NSString*)statusText;


// Added by Harshitha to fetch the next possible statuses

- (NSMutableArray*) getStatusListArrayForPicker: (NSString *) _status andProcessType : (NSString*) processType;

- (NSString*) getStatusTextForStatusCode:(NSString*)statusCode;

@end
