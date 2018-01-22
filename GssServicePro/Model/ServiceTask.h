//
//  ServiceTask.h
//  GssServicePro
//
//  Created by Riyas Hassan on 04/06/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceTask : NSObject <NSCopying>

@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * priority;
@property (strong, nonatomic) NSString * statusText;
@property (strong, nonatomic) NSString * status;
@property (strong, nonatomic) NSString * serviceOrderDescription;
@property (strong, nonatomic) NSString * startDate;
@property (strong, nonatomic) NSString * estimatedArrivalDate;
@property (strong, nonatomic) NSString * estimatedArrivalTime;
@property (strong, nonatomic) NSString * serviceOrder;
@property (strong, nonatomic) NSString * serviceOrderRejectionReason;
@property (strong, nonatomic) NSString * rejectionDescription;
@property (strong, nonatomic) NSString * serviceOrderTypeDesc;
@property (strong, nonatomic) NSString * serviceOrderType;
@property (strong, nonatomic) NSString * contactName;
@property (strong, nonatomic) NSString * telNum;
@property (strong, nonatomic) NSString * altTelNum;
@property (strong, nonatomic) NSString * serviceNote;
@property (strong, nonatomic) NSString * otherDetails;
@property (strong, nonatomic) NSString * serviceLocation;
@property (strong, nonatomic) NSString * fieldNote;
@property (strong, nonatomic) NSString * searchString;
@property (strong, nonatomic) NSString * locationAddress;
@property (strong, nonatomic) NSString * serviceItem;
@property (strong, nonatomic) NSString * firstServiceItem;
@property (strong, nonatomic) NSString * timeZoneFrom;
@property (strong, nonatomic) NSString * partner;
@property (strong, nonatomic) NSString * firstServiceProduct;
@property (strong, nonatomic) NSString * firstServiceProductDescription;

@property (strong, nonatomic) NSString * serialNumber;
@property (strong, nonatomic) NSString * IB_description;
@property (strong, nonatomic) NSString * IB_INS_description;
@property (strong, nonatomic) NSString * IB_iBase;
@property (strong, nonatomic) NSString * IB_Instance;
@property (strong, nonatomic) NSString * refObjProductID;
@property (strong, nonatomic) NSString * refObjProductDescription;

@property (strong, nonatomic) NSString *numberExtension;

@property (strong, nonatomic) NSString *duration;

@property (strong, nonatomic) NSString *confirmationId; //Added by Harshitha

//selvan add this code
@property (strong, nonatomic) NSString *product_id;
@property (strong, nonatomic) NSString *quantity;
@property (strong, nonatomic) NSString *processqtyunit;
@property (strong, nonatomic) NSString *zzitemdescription;
@property (strong, nonatomic) NSString *zzitemtext;
//end

// Added by Harshitha
@property (strong, nonatomic) NSString * startTime;
@property (strong, nonatomic) NSString * startDateAndTime;
@property (strong, nonatomic) NSString * rearrangeOrder;
@property (strong, nonatomic) NSString * locationAddress1;
@property (strong, nonatomic) NSString * locationAddress2;
@property (strong, nonatomic) NSString * locationAddress3;

-(id) copyWithZone: (NSZone *) zone;


@end
