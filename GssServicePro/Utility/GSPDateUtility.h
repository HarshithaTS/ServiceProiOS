//
//  GSPDateUtility.h
//  GssServicePro
//
//  Created by Riyas Hassan on 30/06/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSPDateUtility : NSObject

+ (id)sharedInstance;

- (NSString *) currentdate;
- (NSString *) currentdatewithnexthour;
- (NSString *) getDateFromString: (NSString *)paraDateTime;
- (NSString *) getTimeFromString: (NSString *)paraDateTime;
- (NSString *) getShortDateFromString: (NSDate *)paraDateTime;

- (NSString *) convertMMMDDformattoyyyMMdd:(NSString *)dateString;
- (NSString *) convertMMMDDYYYYHHMMSSformattoyyyMMdd:(NSString *)dateString;
- (NSString *) StringConverttoFormat:(NSString *)dateString;
- (NSString *) convertShortDateToStringFormat:(NSString *)dateString;
- (NSString *) convertShortDateToStringFormat1:(NSString *)dateString;

- (NSString*)getTimeZoneNameForTimezoneOffset:(NSString*)offset;

// Added by Harshitha
- (NSString *)convertHHMMSStoHHMM:(NSString *)dateString;
- (NSString *)convertYYYYMMDDHHMMSStoMMMDDYYYYHHMM:(NSString *)dateString;

@end
