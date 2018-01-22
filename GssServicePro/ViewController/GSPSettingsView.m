//
//  GSPSettingsView.m
//  GssServicePro
//
//  Created by Harshitha on 3/6/15.
//  Copyright (c) 2015 Harshitha. All rights reserved.
//

#import "GSPSettingsView.h"
//#import "GSPServiceTasksViewController.h"

@implementation GSPSettingsView

@synthesize settingsView;
@synthesize diagSwitch;

- (IBAction)doneButtonClicked:(id)sender {
    [self removeFromSuperview];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)diagnosisSwitch:(id)sender {
    
    NSString *value = @"ON";
    NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
    if(!diagSwitch.on){
        value = @"OFF";
        [userPreferences setObject:value forKey:@"stateOfSwitch"];
    }
    [userPreferences setObject:value forKey:@"stateOfSwitch"];
    
}

-(void)drawRect:(CGRect)rect
{
    
    NSString *_value= [[NSUserDefaults standardUserDefaults] stringForKey:@"stateOfSwitch"];
    
//    if([_value compare:@"ON"] == NSOrderedSame){
    if ([_value isEqual:@"ON"]) {
        diagSwitch.on = YES;
    }
    else {
        diagSwitch.on = NO;
    }
}

@end
