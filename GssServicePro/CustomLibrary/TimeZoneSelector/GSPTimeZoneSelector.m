//
//  GSPTimeZoneSelector.m
//  GssServicePro
//
//  Created by Riyas Hassan on 06/08/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPTimeZoneSelector.h"

#define RECENTLY_USED_ZONES @"Recently Used Time Zones"

@interface GSPTimeZoneSelector ()
{
    NSMutableArray * recentlyUsedTimeZoneArray, *availableTimeZoneArray, *matchedTimeZonesArray;
    
    NSIndexPath *selectedIndexPath;
    
    NSString *timeZoneOffset;
    
    id timeZoneSelected;
}

@end

@implementation GSPTimeZoneSelector



- (id)initWithStyle:(UITableViewStyle)style currentTimeZoneOffset:(NSString*)offset
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
        
        timeZoneOffset = offset;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

     self.clearsSelectionOnViewWillAppear = NO;
    
    [self initailizeVariables];
 
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (timeZoneSelected)
    {
        if (![recentlyUsedTimeZoneArray containsObject:timeZoneSelected]) {
            
            if (recentlyUsedTimeZoneArray.count >=10)
            {
                [recentlyUsedTimeZoneArray removeObjectAtIndex:0];
            }

            [self saveSelectedTimeZoneInUserDefaults:timeZoneSelected];
            return;
        }
    }
}

- (void) initailizeVariables
{
    
    recentlyUsedTimeZoneArray   = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:RECENTLY_USED_ZONES]];
 
    if (!recentlyUsedTimeZoneArray)
    {
        recentlyUsedTimeZoneArray   = [NSMutableArray new];
    }
    availableTimeZoneArray      = [[NSMutableArray alloc]initWithArray:[NSTimeZone knownTimeZoneNames]];
    
    matchedTimeZonesArray       = [self  getRelativeTimeZoneListForTimezoneOffset:timeZoneOffset];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) selectedTimeZoneIs:(id)selectedTimeZone
{
    if (self.timeZoneSelectorDelegate && [self.timeZoneSelectorDelegate respondsToSelector:@selector(selectedTimeZoneIs:)])
    {
        [self.timeZoneSelectorDelegate selectedTimeZoneIs:selectedTimeZone];
    }
    
    timeZoneSelected = selectedTimeZone;
 
}

-(void) saveSelectedTimeZoneInUserDefaults:(id)selectedTimeZone
{
    [recentlyUsedTimeZoneArray addObject:selectedTimeZone];
    
    [[NSUserDefaults standardUserDefaults] setObject:recentlyUsedTimeZoneArray forKey:RECENTLY_USED_ZONES];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    NSInteger noOfRows;
    
    switch (section) {
        case 0:
            noOfRows = 1;
            break;
        case 1:
            noOfRows = recentlyUsedTimeZoneArray.count;
            break;
        case 2:
            noOfRows = matchedTimeZonesArray.count;
            break;
        case 3:
            noOfRows = availableTimeZoneArray.count;
            break;
        
        default:
            break;
    }
    
    return noOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if ([indexPath compare:selectedIndexPath] == NSOrderedSame)
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[[NSTimeZone systemTimeZone] name]];
            break;
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[recentlyUsedTimeZoneArray objectAtIndex:indexPath.row]];
            break;
        case 3:
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[availableTimeZoneArray objectAtIndex:indexPath.row]];
            break;
        case 2:
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[matchedTimeZonesArray objectAtIndex:indexPath.row]];
            break;
        default:
            break;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    selectedIndexPath = indexPath;

    [self.tableView reloadData];
    
    switch (indexPath.section) {
        case 0:
            [self selectedTimeZoneIs:[[NSTimeZone systemTimeZone] name]];
            break;
        case 1:
        {
            [self selectedTimeZoneIs:[recentlyUsedTimeZoneArray objectAtIndex:indexPath.row]];
            
        }
            break;
        case 2:
            [self selectedTimeZoneIs:[matchedTimeZonesArray objectAtIndex:indexPath.row]];
            break;
            
        case 3:
            [self selectedTimeZoneIs:[availableTimeZoneArray objectAtIndex:indexPath.row]];
            break;
        
        default:
            break;
    }
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    if (recentlyUsedTimeZoneArray.count <= 0 && section == 1)
    {
        return 1;
    }
    else
    
        return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
 
    UILabel *headerLabel    = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 60 , 25)];
    headerLabel.font        = [UIFont boldSystemFontOfSize:15];
    switch (section)
    {
        case 0:
            headerLabel.text    =   @"Device Time Zone";
            break;
        case 1:
            headerLabel.text    =   @"Recently Selected Time Zones";
            break;
        case 2:
            headerLabel.text    =   @"Matching Time Zones";
            break;
        case 3:
            headerLabel.text    =   @"Available Time Zones";
            break;
        
        default:
            break;
    }
    
    if (recentlyUsedTimeZoneArray.count <= 0 && section == 1)
    {
        return [[UIView alloc]initWithFrame:CGRectZero];
    }
    else
    
        return headerLabel;
}


- (NSMutableArray*)getRelativeTimeZoneListForTimezoneOffset:(NSString*)offset
{
    
    
    NSInteger timeZoneFromServer            = [[offset substringToIndex:6] integerValue];

    NSMutableArray * matchingTimeZoneArray  = [NSMutableArray new];
    
    if (timeZoneFromServer == 0)
    {
        NSArray *timeZoneNames                  = [NSTimeZone knownTimeZoneNames];
        
        for (NSString *name in timeZoneNames)
        {
            NSTimeZone *tz      = [NSTimeZone timeZoneWithName:offset];
            NSTimeZone *tzName  = [NSTimeZone timeZoneWithName:name];
            
            if ([tzName secondsFromGMT] == [tz secondsFromGMT])
            {
                [matchingTimeZoneArray addObject:[tzName name]];
            }
        }

    }
    
    else
    {
        NSArray *timeZoneNames                  = [NSTimeZone knownTimeZoneNames];
        
        for (NSString *name in timeZoneNames)
        {
            NSTimeZone *tz = [NSTimeZone timeZoneWithName:name];
            
            if (timeZoneFromServer == [tz secondsFromGMT])
            {
                [matchingTimeZoneArray addObject:[tz name]];
            }
        }
    }
    
    return matchingTimeZoneArray;
}

@end
