//
//  GSPTaskLocationMapViewController.m
//  GssServicePro
//
//  Created by Riyas Hassan on 01/07/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPTaskLocationMapViewController.h"
#import <MapKit/MapKit.h>

@interface GSPTaskLocationMapViewController ()<CLLocationManagerDelegate>

@property (nonatomic) CLLocationCoordinate2D serviceLoc;

@property (nonatomic, strong) NSString  * serviceLocation;
@property (nonatomic, strong) NSString  * addressLocation;

@property (weak, nonatomic) IBOutlet MKMapView *serviceLocationMapView;

@end

@implementation GSPTaskLocationMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withAddress:(NSString*)address
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.addressLocation = address;
        self.title           = @"Customer's Location Map";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showServiceLocationInMap];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showServiceLocationInMap
{
    
    self.serviceLoc = [self addressLocationWithAdress:self.addressLocation];
    
    MKPointAnnotation *destAnnotation   = [[MKPointAnnotation alloc]init];
    destAnnotation.coordinate           = self.serviceLoc;
    
    [self.serviceLocationMapView addAnnotation:destAnnotation];
    
    [self centerMap];
}
/*
-(CLLocationCoordinate2D) addressLocationWithAdress:(NSString*)addressString {
    
	NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv",
                           [addressString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
	NSError* error              = nil;
    NSString *locationString    = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSASCIIStringEncoding error:&error];
    
    if (locationString)
    {
        NSLog(@"Response is: %@", locationString);
    }
    else
    {
        NSLog(@"Error :%@", error);
    }
	
    NSArray *listItems  = [locationString componentsSeparatedByString:@","];
	NSLog(@"response from google : %@", listItems);
    
    double latitude     = 0.0;
	double longitude    = 0.0;

	if([listItems count] >= 4 && [[listItems objectAtIndex:0] isEqualToString:@"200"])
    {
		latitude = [[listItems objectAtIndex:2] floatValue];
		longitude = [[listItems objectAtIndex:3] floatValue];
	}
	else
    {
        if ([[listItems objectAtIndex:0] isEqualToString:@"602"])
        {
            [[GSPUtility sharedInstance] showAlertWithTitle:@"Alert" message:@"Address is not valid. Unable to load Map." otherButton:nil tag:0 andDelegate:self];
            
        }
		
	}
	
	CLLocationCoordinate2D location;
	location.latitude   = latitude;
	location.longitude  = longitude;
	
	return location;
	
}
*/

//    ****    Added by Harshitha    ****

-(CLLocationCoordinate2D) addressLocationWithAdress: (NSString*) addressString {
    
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    
    if (result) {
        
        NSScanner *scanner = [NSScanner scannerWithString:result];
        
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            
            [scanner scanDouble:&latitude];
            
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                
                [scanner scanDouble:&longitude];
            }
        }
    }
    
    CLLocationCoordinate2D center;
    center.latitude=latitude;
    center.longitude = longitude;
    NSLog(@"Latitude : %f",center.latitude);
    NSLog(@"Longitude : %f",center.longitude);
    return center;
    
}
//    ****    Added by Harshitha ends here    ****

- (void)centerMap
{
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = self.serviceLoc.latitude;
    zoomLocation.longitude= self.serviceLoc.longitude;
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.2,0.2);
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 4500,4500);
    [self.serviceLocationMapView setRegion:viewRegion animated:YES];
    [self.serviceLocationMapView regionThatFits:viewRegion];
    
}



@end
