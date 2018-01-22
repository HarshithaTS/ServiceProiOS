//
//  GSPOfflineViewConfiguration.h
//  GssServicePro
//
//  Created by Riyas Hassan on 01/08/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSPOfflineViewConfiguration : NSObject

+ (id)sharedInstance;

- (void) setViewForOfflineMode:(BOOL)isOffline forView:(UIViewController*)viewController;

- (void) checkReachabilityAndCofigureView:(UIViewController*)viewController;

- (BOOL) IsConnectionAvailable;

@end
