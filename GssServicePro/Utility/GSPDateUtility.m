//
//  GSPDateUtility.m
//  GssServicePro
//
//  Created by Riyas Hassan on 30/06/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPDateUtility.h"

@implementation GSPDateUtility

+ (id)sharedInstance
{
    static GSPDateUtility *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(NSString *)currentdate

{
	
	NSDate* mDate = [NSDate date];
    
    //Create the dateformatter object
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	//Set the required date format
	//[formatter setDateFormat:@"yyyy-MM-dd HH:MM:00"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
	//Get the string date
	NSString* str = [formatter stringFromDate:mDate];
	//Display on the console
 	//Set in the lable
	return str;
	
}
-(NSString *)currentdatewithnexthour

{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
	NSDate* mDate = [NSDate date];
	// now build a NSDate object for the next day
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setHour:1];
    NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate: mDate options:0];
	
	
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	//Set the required date format
	//[formatter setDateFormat:@"yyyy-MM-dd HH:MM:00"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
	//Get the string date
	NSString* str = [formatter stringFromDate:nextDate];
	NSLog(@"next date %@",str);
	return str;
	
}

-(NSString *)getDateFromString: (NSString *)paraDateTime
{
	NSDate* mDate = [NSDate date];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
//  Original code
	//[formatter setDateFormat:@"yyyy-MM-dd"];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//	NSString *str = [formatter stringFromDate:mDate];
    
// *** Modified by Harshitha starts here ***
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss '+0000'"];
    mDate = [formatter dateFromString:paraDateTime];
    if (mDate == NULL) {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        mDate = [formatter dateFromString:paraDateTime];
    }
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str= [formatter stringFromDate:mDate];
// *** Modified by Harshitha ends here ***

	NSLog(@"DATE %@, %@", mDate,str);
	return str;
}


-(NSString *)getShortDateFromString: (NSDate *)paraDateTime
{
    NSDateFormatter *simpleDateFormat = [[NSDateFormatter alloc] init];
    simpleDateFormat.dateFormat = @"yyyy-MM-dd";
	//[simpleDateFormat setDateFormat:@"yyyy-MM-dd"];
	NSString *str = [simpleDateFormat stringFromDate:paraDateTime];
	NSLog(@"DATE %@, %@", paraDateTime,str);
	return str;
}

-(NSString *)getTimeFromString: (NSString *)paraDateTime
{
	NSDate *mDate = [NSDate date];
	
    //Convert String to date
	//create the dateformater object
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
	//set the required date format
	//[formatter setDateFormat:@"yyyy-MM-dd HH:MM:SS"];
//  Original code
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
	//Get the string date
//	mDate = [formatter dateFromString:paraDateTime];

// *** Modified by Harshitha starts here ***
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss '+0000'"];
    mDate = [formatter dateFromString:paraDateTime];
    if (mDate == NULL) {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        mDate = [formatter dateFromString:paraDateTime];
    }
// *** Modified by Harshitha ends here ***

	//Convert date to string
	[formatter setDateFormat:@"HH:mm:ss"];
	NSString *str = [formatter stringFromDate:mDate];
	return str;
	
	
}

-(NSString *) convertShortDateToStringFormat:(NSString *)dateString
{
    NSString *dateStr = @"";
    
    @try {
        // Convert string to date object
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormat dateFromString:dateString];
        
        // Convert date object to desired output format
        [dateFormat setDateFormat:@"MMM d, yyyy"];
        dateStr = [dateFormat stringFromDate:date];
        
        NSLog(@"%@, %@ %@",dateString,date,dateStr);
        return dateStr;
    }
    @catch (NSException *exception) {
        return dateStr;
    }
    
}
-(NSString *) convertShortDateToStringFormat1:(NSString *)dateString
{
    // Convert string to date object
    NSString *dateStr = @"";
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormat dateFromString:dateString];
    
    // Convert date object to desired output format
    [dateFormat setDateFormat:@"MMM d"];
    dateStr = [dateFormat stringFromDate:date];
    
    NSLog(@"%@, %@ %@",dateString,date,dateStr);
    return dateStr;
    
}

-(NSString *) convertMMMDDformattoyyyMMdd:(NSString *)dateString
{
    // Convert string to date object
    NSString *dateStr = @"";
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM dd,yyyy"];
   
    NSDate *date = [dateFormat dateFromString:dateString];
    
    // Convert date object to desired output format
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    dateStr = [dateFormat stringFromDate:date];
    
    NSLog(@"%@, %@ %@",dateString,date,dateStr);
    return dateStr;
    
}
-(NSString *) convertMMMDDYYYYHHMMSSformattoyyyMMdd:(NSString *)dateString
{
    // Convert string to date object
    NSString *dateStr = @"";
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMMM d, YYYY hh:MM:ss"];
    NSDate *date = [dateFormat dateFromString:dateString];
    
    // Convert date object to desired output format
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    dateStr = [dateFormat stringFromDate:date];
    return dateStr;
    
}

-(NSString*)StringConverttoFormat:(NSString *)dateString
{
    
    NSArray *date_array1 = [dateString componentsSeparatedByString:@" "];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM"];
    NSDate* myDate = [dateFormatter dateFromString:[date_array1 objectAtIndex:0]];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM"];
    NSString *month = [formatter stringFromDate:myDate];
    
    NSArray *date_array2 = [[date_array1 objectAtIndex:1] componentsSeparatedByString:@","];
    
    
    NSString *dateFormat = [NSString stringWithFormat:@"%@-%@-%@",[date_array2 objectAtIndex:1],month,[date_array2 objectAtIndex:0]];
    
    return dateFormat;
}


//Added by riaz

- (NSString*)getTimeZoneNameForTimezoneOffset:(NSString*)offset
{
    
    
    NSInteger timeZoneFromServer = [[offset substringToIndex:6] integerValue];
    
    NSArray *timeZoneNames = [NSTimeZone knownTimeZoneNames];
    
    for (NSString *name in timeZoneNames)
    {
        NSTimeZone *tz = [NSTimeZone timeZoneWithName:name];
        
        if (timeZoneFromServer == [tz secondsFromGMT])
        {
            return name;
        }
    }
    
    return offset;
}

// ***** Added by Harshitha starts here *****
- (NSString *)convertHHMMSStoHHMM:(NSString *)dateString
{
    NSString *dateStrng               = @"";
    NSDateFormatter *dateFormat     = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM dd,yyyy HH:mm:ss"];
    NSDate *dateStr                 = [dateFormat dateFromString:dateString];
    [dateFormat setDateFormat:@"MMM dd,yyyy HH:mm"];
    dateStrng                         = [dateFormat stringFromDate:dateStr];
    return dateStrng;
}

- (NSString *)convertYYYYMMDDHHMMSStoMMMDDYYYYHHMM:(NSString *)dateString
{
    NSString *dateStrng             = @"";
    NSDateFormatter *dateFormat     = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateStr                 = [dateFormat dateFromString:dateString];
    if (dateStr == NULL) {
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss '+0000'"];
        dateStr                     = [dateFormat dateFromString:dateString];
    }
    [dateFormat setDateFormat:@"MMM dd,yyyy HH:mm"];
    dateStrng                       = [dateFormat stringFromDate:dateStr];
    return dateStrng;
}
// ***** Added by Harshitha ends here *****

@end
