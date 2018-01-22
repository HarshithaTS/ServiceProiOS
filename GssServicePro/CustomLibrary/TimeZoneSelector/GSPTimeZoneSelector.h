//
//  GSPTimeZoneSelector.h
//  GssServicePro
//
//  Created by Riyas Hassan on 06/08/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimeZoneSelectorDelegate <NSObject>

@optional
- (void) selectedTimeZoneIs:(id)timezone;

@end

@interface GSPTimeZoneSelector : UITableViewController

- (id)initWithStyle:(UITableViewStyle)style currentTimeZoneOffset:(NSString*)offset;

@property (nonatomic, strong) id <TimeZoneSelectorDelegate> timeZoneSelectorDelegate;

@end
