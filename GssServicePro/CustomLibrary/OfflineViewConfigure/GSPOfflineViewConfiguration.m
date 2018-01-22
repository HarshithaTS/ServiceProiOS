//
//  GSPOfflineViewConfiguration.m
//  GssServicePro
//
//  Created by Riyas Hassan on 01/08/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPOfflineViewConfiguration.h"
#import "CheckedNetwork.h"

@implementation GSPOfflineViewConfiguration

+ (id)sharedInstance
{
    static GSPOfflineViewConfiguration *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void) checkReachabilityAndCofigureView:(UIViewController*)viewController
{
    BOOL networkAvailable = [self IsConnectionAvailable];
    
    if(networkAvailable)
    {
        [self setViewForOfflineMode:NO forView:viewController];
    }
    else
    {
        [self setViewForOfflineMode:YES forView:viewController];
    }
    
}


- (void) setViewForOfflineMode:(BOOL)isOffline forView:(UIViewController*)viewController
{
    
    if (isOffline)
    {
        viewController.view.layer.borderWidth   = 5.0;
        viewController.view.layer.borderColor   = [[UIColor redColor]CGColor];
        
        [viewController.navigationController.navigationBar setBarTintColor:[UIColor lightGrayColor]];
        [viewController.navigationController.navigationBar setTranslucent:NO];
        viewController.title = [viewController.title stringByReplacingOccurrencesOfString:@" (Offline)" withString:@""];
        viewController.title = [viewController.title stringByAppendingString:@" (Offline)"];
        return;
    }
    
    [viewController.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:255.0/255 green:143.0/255 blue:30.0/255 alpha:1.0 ]];
    [viewController.navigationController.navigationBar setTranslucent:YES];
    viewController.view.layer.borderWidth   = 0.0;
    viewController.title                     = [viewController.title stringByReplacingOccurrencesOfString:@" (Offline)" withString:@""];
    
    viewController.view.layer.borderColor   = [[UIColor clearColor]CGColor];
    
    
}


- (BOOL) IsConnectionAvailable {
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
	
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
	
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
	
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return 0;
    }
	
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}



@end
