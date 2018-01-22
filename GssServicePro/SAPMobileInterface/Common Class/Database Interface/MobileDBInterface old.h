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


@interface MobileDBInterface : NSObject
{
    GCDThreads *objGCDThreads;
    
    InputProperties *objInputProperties;

}



-(void) createSQLQueryStringFromParsedData:(NSMutableArray *) parsedResponseArry;
-(void) pushParsedDataIntoSqliteDatabase: (NSMutableArray *) dbData;

-(BOOL) parseResponseType:(NSString *) strResponseType;

@end
