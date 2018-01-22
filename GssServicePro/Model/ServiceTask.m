//
//  ServiceTask.m
//  GssServicePro
//
//  Created by Riyas Hassan on 04/06/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "ServiceTask.h"

@implementation ServiceTask

@synthesize serviceOrderDescription;
@synthesize estimatedArrivalDate;
@synthesize estimatedArrivalTime;
@synthesize priority;
@synthesize startDate;
@synthesize status;
@synthesize statusText;
@synthesize title;
@synthesize altTelNum;
@synthesize contactName;
@synthesize otherDetails;
@synthesize serviceLocation;
@synthesize serviceNote;
@synthesize serviceOrder;
@synthesize serviceOrderTypeDesc;
@synthesize serviceOrderType;
@synthesize telNum;
@synthesize serviceOrderRejectionReason;
@synthesize rejectionDescription;
@synthesize fieldNote;
@synthesize searchString;
@synthesize locationAddress;
@synthesize firstServiceItem;
@synthesize timeZoneFrom;
@synthesize firstServiceProduct;
@synthesize firstServiceProductDescription;
@synthesize partner;
@synthesize IB_description;
@synthesize IB_INS_description;
@synthesize refObjProductID;
@synthesize serialNumber;
@synthesize IB_iBase;
@synthesize IB_Instance;
@synthesize refObjProductDescription;
@synthesize numberExtension;
@synthesize serviceItem;
//Added by Harshitha
@synthesize startTime;
@synthesize startDateAndTime;
@synthesize rearrangeOrder;
@synthesize locationAddress1;
@synthesize locationAddress2;
@synthesize locationAddress3;

-(id) copyWithZone: (NSZone *) zone
{
    ServiceTask *serviceCopy = [[ServiceTask allocWithZone: zone] init];
    serviceCopy.serviceOrderDescription = self.serviceOrderDescription;
    serviceCopy.estimatedArrivalDate = self.estimatedArrivalDate;
    serviceCopy.estimatedArrivalTime = self.estimatedArrivalTime;
    serviceCopy.priority = self.priority;
    serviceCopy.startDate = self.startDate;
    serviceCopy.status = self.status;
    serviceCopy.statusText = self.statusText;
    serviceCopy.title = self.title;
    serviceCopy.altTelNum = self.altTelNum;
    serviceCopy.contactName = self.contactName;
    serviceCopy.otherDetails = self.otherDetails;
    serviceCopy.serviceLocation = self.serviceLocation;
    serviceCopy.serviceNote = self.serviceNote;
    serviceCopy.serviceOrder = self.serviceOrder;
    serviceCopy.serviceOrderTypeDesc = self.serviceOrderTypeDesc;
    serviceCopy.serviceOrderType = self.serviceOrderType;
    serviceCopy.telNum = self.telNum;
    serviceCopy.serviceOrderRejectionReason = self.serviceOrderRejectionReason;
    serviceCopy.rejectionDescription = self.rejectionDescription;
    serviceCopy.fieldNote = self.fieldNote;
    serviceCopy.searchString = self.searchString;
    serviceCopy.locationAddress = self.locationAddress;
    serviceCopy.firstServiceItem = self.firstServiceItem;
    serviceCopy.timeZoneFrom = self.timeZoneFrom;
    serviceCopy.firstServiceProduct = self.firstServiceProduct;
    serviceCopy.firstServiceProductDescription = self.firstServiceProductDescription;
    serviceCopy.partner = self.partner;
    serviceCopy.IB_description = self.IB_description;
    serviceCopy.IB_INS_description = self.IB_INS_description;
    serviceCopy.refObjProductID = self.refObjProductID;
    serviceCopy.serialNumber = self.serialNumber;
    serviceCopy.IB_iBase = self.IB_iBase;
    serviceCopy.IB_Instance = self.IB_Instance;
    serviceCopy.refObjProductDescription = self.refObjProductDescription;
    serviceCopy.numberExtension = self.numberExtension;
    serviceCopy.serviceItem = self.serviceItem;
    serviceCopy.duration    = self.duration;
    serviceCopy.confirmationId = self.confirmationId;  //Added by Harshitha
    
    //selvan add this code
    serviceCopy.product_id = self.product_id;
    serviceCopy.quantity = self.quantity;
    serviceCopy.processqtyunit = self.processqtyunit;
    serviceCopy.zzitemdescription = self.zzitemdescription;
    serviceCopy.zzitemtext = self.zzitemtext;
    //end
    
//  Added by Harshitha
    serviceCopy.startTime = self.startTime;
    serviceCopy.startDateAndTime = [NSString stringWithFormat:@"%@ %@",self.startDate,self.startTime];
    serviceCopy.rearrangeOrder = self.rearrangeOrder;
    serviceCopy.locationAddress1 = self.locationAddress1;
    serviceCopy.locationAddress2 = self.locationAddress2;
    serviceCopy.locationAddress3 = self.locationAddress3;
    
    return serviceCopy;
}

@end
