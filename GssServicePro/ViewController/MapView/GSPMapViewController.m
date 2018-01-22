//
//  GSPMapViewController.m
//  GssServicePro
//
//  Created by Riyas Hassan on 23/06/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPMapViewController.h"
#import <MapKit/MapKit.h>
#import <AVFoundation/AVFoundation.h>

#define METERS_PER_MILE 1609.344

@interface GSPMapViewController ()<CLLocationManagerDelegate,UIActionSheetDelegate,MKMapViewDelegate>

@property (nonatomic) CLLocationCoordinate2D coords;
@property (nonatomic) CLLocationCoordinate2D currentLocation;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIWebView *mapWebView;
@property (weak, nonatomic) IBOutlet MKMapView *directionsMapView;

@property (nonatomic, strong) NSString      * addressLocation;
@property (nonatomic, strong) NSArray       * routePointsArray;
@property (nonatomic, strong) MKPolyline    * objPolyline;


- (IBAction)closeButtonClick:(id)sender;
@end

@implementation GSPMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withAddress:(NSString*)address
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    
        self.addressLocation = address;
        self.title           = @"Customer's Location Map";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.routePointsArray = [NSArray new];
    
    [self getUserCurrentLocation];
    
    self.coords = [self addressLocationWithAdress:self.addressLocation];
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setUpView];
}

- (void)setUpView
{
    self.directionsMapView.layer.cornerRadius = 8.0;
    self.directionsMapView.layer.borderWidth  = 2.0;
    self.directionsMapView.layer.borderColor  = [[UIColor darkGrayColor]CGColor];
    
    
    self.mapWebView.layer.cornerRadius = 7.0;
    self.mapWebView.layer.borderWidth  = 2.0;
    self.mapWebView.layer.borderColor  = [[UIColor darkGrayColor]CGColor];
    
    [self.segmentedControl addTarget:self
                              action:@selector(segmentControllerSelectionChanged:)
                    forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.selectedSegmentIndex = 0;
    [self segmentControllerSelectionChanged:nil];
}


-(void) segmentControllerSelectionChanged:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    
    switch ([segmentedControl selectedSegmentIndex]) {
        case 0:
            [self showAppleMap];
            break;
            
        case 1:
            [self showGoogleMap];
            break;
            
        default:
            break;
    }

}


- (void) showGoogleMap
{
    [[NSUserDefaults standardUserDefaults] setInteger:GoogleMapSelected forKey:DEFAULT_SELECTED_MAP];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.mapWebView setHidden:NO];
    [self.directionsMapView setHidden:YES];
    [self showMapOnWebview];
}

- (void) showAppleMap
{
    [[NSUserDefaults standardUserDefaults] setInteger:AppleMapSelected forKey:DEFAULT_SELECTED_MAP];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.directionsMapView setHidden:NO];
    [self.mapWebView setHidden:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self showDirectionInMapView];
    });
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeButtonClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)showMapOnWebview
{
    NSString *fullUrl = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f&view=map&output=embed",self.currentLocation.latitude,self.currentLocation.longitude,self.coords.latitude,self.coords.longitude];
    
    NSURL *url = [NSURL URLWithString:[fullUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSString *embedHTML = [NSString stringWithFormat:@"<html><head><title>.</title><style>body,html,iframe{margin:0;padding:0;}</style></head><body><iframe width=\"%f\" height=\"%f\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe></body></html>" ,self.mapWebView.frame.size.width, self.mapWebView.frame.size.height, url];
    
    [self.mapWebView loadHTMLString:embedHTML baseURL:url];
    
}

-(void)getUserCurrentLocation
{
    //DISABLED  FOR TESTING PURPOSE
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    
    if ([CLLocationManager locationServicesEnabled])
    {
        locationManager.delegate        = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter  = kCLDistanceFilterNone;
        [locationManager startUpdatingLocation];
    }
    
    CLLocation *location    = [locationManager location];
    self.currentLocation        = [location coordinate];
    
    NSString *str=[[NSString alloc] initWithFormat:@" latitude:%f longitude:%f",_currentLocation.latitude,_currentLocation.longitude];
    NSLog(@"%@",str);
    
    //END
    
//    Hardcoded by Harshitha for demo purpose
        _currentLocation.latitude = 40.56509;
        _currentLocation.longitude = -74.33130;
    
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
            [[GSPUtility sharedInstance] showAlertWithTitle:@"Alert" message:@"Address is not valid. Unable to load Map."otherButton:nil tag:0 andDelegate:self];
            
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


- (void)webViewDidStartLoad:(UIWebView *)webView
{
	printf("\n started");
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	printf("\n stopped");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

#pragma MKMapview Methods

- (void)showDirectionInMapView
{
    self.directionsMapView.showsUserLocation = YES;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.currentLocation,2000, 2000);
    [self.directionsMapView setRegion:region animated:NO];
    self.directionsMapView.delegate = self;
    [self getDirections];

}

- (void)getDirections
{
    CLLocationCoordinate2D loc1;
    loc1.latitude = 33.872767;
    loc1.longitude = -118.284903;
    
    CLLocationCoordinate2D loc2;
  loc2.latitude = 33.856161;
   loc2.longitude = -117.982864;
    
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    MKMapItem *origin = [MKMapItem new];
    request.source = [origin initWithPlacemark:[[MKPlacemark alloc]initWithCoordinate:self.currentLocation addressDictionary:nil]];//[MKMapItem mapItemForCurrentLocation];
    
    MKMapItem *destination = [MKMapItem new];
   
    request.destination = [destination initWithPlacemark:[[MKPlacemark alloc]initWithCoordinate:self.coords addressDictionary:nil]];
    request.requestsAlternateRoutes = YES;
    MKDirections *directions =
    [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
            
             if (error.domain == MKErrorDomain && error.code == 5) {
                 [[GSPUtility sharedInstance] showAlertWithTitle:@"Directions Not Available" message:@"A route to the nearest road cannot be determined." otherButton:nil tag:0 andDelegate:self];
                 return ;
             }
             
             
         } else {
             [self showRoute:response];
         }
     }];
}

-(void)showRoute:(MKDirectionsResponse *)response
{
    for (MKRoute *route in response.routes)
    {
        [self.directionsMapView addOverlay:route.polyline  level:MKOverlayLevelAboveRoads];
        
     /*   NSLog(@"Direction name %@", route.name);
        
        NSString * directionString = @"";
        for (MKRouteStep *step in route.steps)
        {

            NSLog(@"Direction steps are %@", step.instructions);
            if (![directionString isEqualToString:@""])
            {
                directionString = [directionString stringByAppendingString:@" and then "];
            }
            directionString = [directionString stringByAppendingString:step.instructions];
            
            
        }
       
        AVSpeechSynthesizer *av         = [[AVSpeechSynthesizer alloc] init];
        AVSpeechUtterance *utterance    = [[AVSpeechUtterance alloc]initWithString: directionString];
        utterance.voice                 = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
        utterance.rate                  = 0.3;
        [av speakUtterance:utterance];
       */
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 5.0;
    return renderer;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 2000, 2000);
    
    [self.directionsMapView setRegion:[self.directionsMapView regionThatFits:region] animated:YES];
    self.currentLocation = region.center;
   
//  Hardcoded by Harshitha for demo
    _currentLocation.latitude = 40.56509;
    _currentLocation.longitude = -74.33130;
    
    [self getDirections];
}

@end
