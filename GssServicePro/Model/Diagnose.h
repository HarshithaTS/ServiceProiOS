//
//  Diagnose.h
//  GssServicePro
//
//  Created by Harshitha on 2/23/15.
//  Copyright (c) 2015 Harshitha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GssMobileConsoleiOS.h"

@interface Diagnose : NSObject <GssMobileConsoleiOSDelegate>
{
    GssMobileConsoleiOS *objServiceMngtCls;
}

- (void) DownloadServiceDataFromSAP;

@end
