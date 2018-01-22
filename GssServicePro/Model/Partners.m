//
//  Partners.m
//  GssServicePro
//
//  Created by Harshitha on 10/1/15.
//  Copyright (c) 2015 Harshitha. All rights reserved.
//

#import "Partners.h"

@implementation Partners

@synthesize objectId;
@synthesize processType;
@synthesize numberExt;
@synthesize parvw;
@synthesize partnerNum;
@synthesize nameOne;
@synthesize nameTwo;
@synthesize telNum1;
@synthesize telNum2;
@synthesize searchString;
@synthesize tableName;

- (NSMutableArray*) getPartnersDetails:(NSString *)service_objectId andFirstServiceItem:(NSString *)firstServiceItem
{
    
    objServiceMngtCls                       = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.TargetDatabase        = serviceRepotsDB;
    
    tableName = [SERVICEORDER_OBJTYPE stringByAppendingString:@"ZGSXCAST_DCMNTPRTNR10EC"];
    objServiceMngtCls.qryString             = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE OBJECT_ID = '%@' AND (NUMBER_EXT='%@' OR NUMBER_EXT='')",tableName,service_objectId,firstServiceItem];
    
    NSMutableArray * partnerObjectsArray  =[objServiceMngtCls fetchDataFrmSqlite];
    
    NSMutableArray * partnerArray         = [NSMutableArray new];
    
    for (Partners * partners in partnerObjectsArray) {
        
        Partners * partner = [Partners new];
        [partnerArray addObject:partner];
        
        partner.objectId        = [partners valueForKey:@"OBJECT_ID"];
        partner.processType     = [partners valueForKey:@"PROCESS_TYPE"];
//        if ([partners valueForKey:@"NUMBER_EXT"])
            partner.numberExt   = [partners valueForKey:@"NUMBER_EXT"];
//        else
//            partner.numberExt   = @"";
        partner.parvw           = [partners valueForKey:@"PARVW"];
        partner.partnerNum      = [partners valueForKey:@"PARTNER_NO"];
        partner.nameOne         = [partners valueForKey:@"NAME1"];
        partner.nameTwo         = [partners valueForKey:@"NAME2"];
        partner.telNum1         = [partners valueForKey:@"TELF1"];
        partner.telNum2         = [partners valueForKey:@"TELF2"];
        partner.searchString    = [partners valueForKey:@"SEARCH_STRING"];
        
    }
    
    return partnerArray;
}

@end
