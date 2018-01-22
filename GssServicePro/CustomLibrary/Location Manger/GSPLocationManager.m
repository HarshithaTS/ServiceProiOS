	//
//  GSPLocationManager.m
//  GssServicePro
//
//  Created by Riyas Hassan on 11/12/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPLocationManager.h"



@implementation GSPLocationManager 

+ (id)sharedInstance
{
    static GSPLocationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        
    });
    
    return sharedInstance;
}

- (void) initLocationMnager
{
    locationManager                 = [[CLLocationManager alloc] init];
    locationManager.delegate        = self;
    locationManager.distanceFilter  = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
//        [locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
}
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations lastObject];
    NSLog(@"lat%f - lon%f", self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude);
    [locationManager stopUpdatingLocation];

}

@end
