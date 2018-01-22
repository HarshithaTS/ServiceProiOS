
//
//  Colleagues.h
//  GssServicePro
//
//  Created by Riyas Hassan on 18/08/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GssMobileConsoleiOS.h"

@interface Colleagues : NSObject<GssMobileConsoleiOSDelegate>
{
    GssMobileConsoleiOS *objServiceMngtCls;
    GCDThreads *objGCDThreads;
}

@property (nonatomic, strong) NSString * nameOne;
@property (nonatomic, strong) NSString * nameTwo;
@property (nonatomic, strong) NSString * partner;
@property (nonatomic, strong) NSString * plant;
@property (nonatomic, strong) NSString * searachString;
@property (nonatomic, strong) NSString * storageLoc;
@property (nonatomic, strong) NSString * telNumber;
@property (nonatomic, strong) NSString * telNumberTwo;
@property (nonatomic, strong) NSString * uName;

@property (nonatomic, strong) NSString *tableName;

- (void) downloadColleguesTaskListFromSAP:(NSMutableArray*)inputArray;

- (NSMutableArray*) getColleguesList;

- (void)deleteColleguesTaskTableContents;

- (void) transferColleaguesTaskServiceCall:(NSMutableArray*)inputArray;

@end
