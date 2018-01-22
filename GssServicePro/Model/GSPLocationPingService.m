//
//  GSPLocationPingService.m
//  GssServicePro
//
//  Created by Riyas Hassan on 11/12/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPLocationPingService.h"

@implementation GSPLocationPingService


- (void) initializePingServiceCall
{

    NSMutableArray *getInputArray       = [[NSMutableArray alloc] init];
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.CRMdelegate       = self;
    
    
    objServiceMngtCls.ApplicationName           = @"SERVICEPRO";
    objServiceMngtCls.ApplicationVersion        = @"0";
    objServiceMngtCls.ApplicationResponseType   = @"";
    objServiceMngtCls.ApplicationEventAPI       = @"PING-SERVER";
    objServiceMngtCls.InputDataArray            = getInputArray;
    objServiceMngtCls.subApp                    = @"Current Location";
//    objServiceMngtCls.objectType                = @"Current Location";
    //objServiceMngtCls.TargetDatabase            = serviceRepotsDB;
    objServiceMngtCls.RefernceID                = @"";
    
    objServiceMngtCls.objectType                = @"PingSrv";
    
    [objServiceMngtCls callSOAPWebMethod];
    
    getInputArray = nil;
    objServiceMngtCls = nil;
}
//================================================================================================================================
//MESSAGE SHOWING TO USER - START
//Delegate for Service Management
-(void)GssMobileConsoleiOS_Response_Message:(NSString*)msg_type andMsgDesc :(NSString*)message andFLD:(NSMutableArray *) FLD_VC
{
    
    
    NSLog(@"SAPCRMMobileAppConsole Return Message Type: %@",msg_type);
    
    
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    
    [userInfo setObject:msg_type    forKey:@"action"];
    [userInfo setObject:message     forKey:@"responseMsg"];
    
    if (FLD_VC)
    {
        [userInfo setObject:FLD_VC      forKey:@"FLD_VC"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StartAcitivityIndicator" object:nil userInfo:userInfo];
    
    
}

@end
