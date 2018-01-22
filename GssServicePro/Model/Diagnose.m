//
//  Diagnose.m
//  GssServicePro
//
//  Created by Harshitha on 2/23/15.
//  Copyright (c) 2015 Harshitha. All rights reserved.
//

#import "Diagnose.h"

@implementation Diagnose

-(void) DownloadServiceDataFromSAP {
    
    
    
    NSMutableArray *getInputArray       = [[NSMutableArray alloc] init];
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.CRMdelegate       = self;
    
    
    objServiceMngtCls.ApplicationName           = @"SERVICEPRO";
    objServiceMngtCls.ApplicationVersion        = @"0";
    objServiceMngtCls.ApplicationResponseType   = @"";
    objServiceMngtCls.ApplicationEventAPI       = @"DIAGNOSIS-AND-CHECKS";
    objServiceMngtCls.InputDataArray            = getInputArray;
    objServiceMngtCls.subApp                    = @"Service Orders";
    objServiceMngtCls.objectType                = @"Diagnosis";
    objServiceMngtCls.TargetDatabase            = serviceRepotsDB;
    objServiceMngtCls.RefernceID                = @"";
    
    [objServiceMngtCls callSOAPWebMethod];
    
    getInputArray = nil;
    objServiceMngtCls = nil;
}

-(void)GssMobileConsoleiOS_Response_Message:(NSString*)msg_type andMsgDesc :(NSString*)message andFLD:(NSMutableArray *) FLD_VC
{
    
    if ([msg_type isEqualToString:@"S"] && FLD_VC.count > 0) {
//        if (FLD_VC.count > 0) {
        NSMutableArray *diagnoseInfo = [[NSMutableArray alloc]init];
        [diagnoseInfo addObject:[[FLD_VC objectAtIndex:2]objectAtIndex:1]];
        [diagnoseInfo addObject:[[FLD_VC objectAtIndex:3]objectAtIndex:1]];
        [diagnoseInfo addObject:[[FLD_VC objectAtIndex:4]objectAtIndex:1]];
        [diagnoseInfo addObject:[[FLD_VC objectAtIndex:5]objectAtIndex:1]];
        
        
        NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
        
        if (FLD_VC)
        {
            [userInfo setObject:diagnoseInfo      forKey:@"FLD_VC"];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DiagnoseNotification" object:nil userInfo:userInfo];
    }
    
   
}

@end
