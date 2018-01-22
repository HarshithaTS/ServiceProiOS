//
//  MobileDBInterface.h
//  ServiceProUniverse
//
//  Created by GSS Mysore on 2/19/14.
//
//

#import <Foundation/Foundation.h>
#import "GCDThreads.h"
#import "InputProperties.h"
#import "GssMobileConsoleiOS.h"



@interface MobileDBInterface : NSObject
{
    GCDThreads *objGCDThreads;
    
    InputProperties *objInputProperties;
    
  
}

@property(strong,retain)NSMutableDictionary *objectIdIndex;

@property(strong,retain)NSMutableDictionary *numberExtIndex;

-(void) createSQLQueryStringFromParsedData:(NSMutableArray *) parsedResponseArry;
-(void) pushParsedDataIntoSqliteDatabase: (NSMutableArray *) dbData;

-(BOOL) parseResponseType:(NSString *) strResponseType;
 @end
