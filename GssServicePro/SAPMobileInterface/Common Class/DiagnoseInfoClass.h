//
//  DiagnoseInfoClass.h
//  GssServicePro
//
//  Created by Harshitha on 5/29/15.
//  Copyright (c) 2015 Harshitha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiagnoseInfoClass : NSObject


@property (strong, nonatomic) NSMutableArray *diagnoseInfoArray;

-(NSMutableArray*)getDiagnoseInfo;

@end
