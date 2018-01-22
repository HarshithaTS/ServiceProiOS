//
//  GSPLocationManager.h
//  GssServicePro
//
//  Created by Riyas Hassan on 11/12/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GSPLocationManager : NSObject <CLLocationManagerDelegate>
{
    
    CLLocationManager *locationManager;
    
}

@property (nonatomic,strong)  CLLocation *currentLocation;

+ (id)sharedInstance;

- (void) initLocationMnager;

@end
