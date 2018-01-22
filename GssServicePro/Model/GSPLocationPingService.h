//
//  GSPLocationPingService.h
//  GssServicePro
//
//  Created by Riyas Hassan on 11/12/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GssMobileConsoleiOS.h"

@interface GSPLocationPingService : NSObject <GssMobileConsoleiOSDelegate>

{
    GssMobileConsoleiOS * objServiceMngtCls;
    GCDThreads          * objGCDThreads;
}

- (void) initializePingServiceCall;


@end
