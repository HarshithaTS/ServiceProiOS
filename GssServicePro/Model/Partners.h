//
//  Partners.h
//  GssServicePro
//
//  Created by Harshitha on 10/1/15.
//  Copyright (c) 2015 Harshitha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GssMobileConsoleiOS.h"

@interface Partners : NSObject<GssMobileConsoleiOSDelegate>

{
    GssMobileConsoleiOS *objServiceMngtCls;
//    GCDThreads *objGCDThreads;
}

@property (strong, nonatomic) NSString * objectId;
@property (strong, nonatomic) NSString * processType;
@property (strong, nonatomic) NSString * numberExt;
@property (strong, nonatomic) NSString * parvw;
@property (strong, nonatomic) NSString * partnerNum;
@property (strong, nonatomic) NSString * nameOne;
@property (strong, nonatomic) NSString * nameTwo;
@property (strong, nonatomic) NSString * telNum1;
@property (strong, nonatomic) NSString * telNum2;
@property (strong, nonatomic) NSString * searchString;
@property (nonatomic, strong) NSString *tableName;

- (NSMutableArray*) getPartnersDetails:(NSString *)service_objectId andFirstServiceItem:(NSString *)firstServiceItem;

@end
