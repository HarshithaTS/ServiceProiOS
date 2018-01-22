//
//  GSPPartnerViewController.m
//  GssServicePro
//
//  Created by Harshitha on 10/1/15.
//  Copyright (c) 2015 Harshitha. All rights reserved.
//

#import "GSPPartnerViewController.h"
#import "Partners.h"
#import "GSPPartnerViewCell.h"

@interface GSPPartnerViewController ()
{
    Partners * partnersObj;
}

@property (nonatomic, strong) ServiceTask * serviceTask;
@property (strong, nonatomic) NSMutableArray * partnerArray;
@property (weak, nonatomic) IBOutlet UIScrollView *tableViewHorizontalScrollView;
@property (strong, nonatomic) IBOutlet UITableView *partnerTableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;

@end

@implementation GSPPartnerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withServiceOrder:(ServiceTask *)task
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Additional Partners";
        self.serviceTask    = task;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupView];
   
    [self initialiseVariables];
    
    [self getPartnerDetails];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView
{
    self.navigationController.navigationBarHidden = NO;
    
/*    if (IS_IPAD)
    {
//        [self.tableViewHorizontalScrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self.tableViewHorizontalScrollView setScrollEnabled:YES];
        [self.tableViewHorizontalScrollView setShowsHorizontalScrollIndicator:YES];
        [self.tableViewHorizontalScrollView setContentSize:(CGSizeMake(950,800))];
//        [self.partnerTableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
//        [self.partnerTableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self.partnerTableView setFrame:CGRectMake(0, 0, 950, self.partnerTableView.frame.size.height)];
    }
*/
}

- (void) initialiseVariables
{
    self.partnerArray    = [[NSMutableArray alloc]init];
    
    partnersObj          = [Partners new];
}

- (void) getPartnerDetails
{
    self.partnerArray   = [partnersObj getPartnersDetails:self.serviceTask.serviceOrder andFirstServiceItem:self.serviceTask.firstServiceItem];
}

#pragma mark TableView Delegates and datasources

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.partnerArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"GSPPartnerViewCell";
    
    GSPPartnerViewCell *cell = (GSPPartnerViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        
        if (IS_IPAD)
        {
            cell            = (GSPPartnerViewCell *)[nib objectAtIndex:0];
        }
        else
        {
            cell            = (GSPPartnerViewCell *)[nib objectAtIndex:1];
        }
        
    }
    
    cell.backgroundView     = nil;
    cell.backgroundColor    = [UIColor clearColor];
    
    [self setLabelColorsIntableViewCell:cell];
    
    cell.callButton1.hidden              = YES;
    cell.callButton1.tag                 = indexPath.row;
    [cell.callButton1 addTarget:self action:@selector(callButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.callButton2.hidden              = YES;
    cell.callButton2.tag                 = indexPath.row + 2000;
    [cell.callButton2 addTarget:self action:@selector(callButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    Partners * partners ;
    
    partners = [self.partnerArray objectAtIndex:indexPath.row];
    
    NSString *secondName = @"";
    if (![self checkforNullValues:partners.nameTwo])
    {
        secondName = partners.nameTwo;
    }
    
    cell.partnerTypeLabel.text      = [NSString stringWithFormat:@"%@",partners.parvw];
    cell.partnerNameLabel.text      = [NSString stringWithFormat:@"%@ %@ (%@)",partners.nameOne,secondName,partners.partnerNum];
    
    if (![self checkforNullValues:partners.telNum1])
    {
        cell.telNum1_label.text     = [NSString stringWithFormat:@"%@",partners.telNum1];
        cell.callButton1.hidden     = NO;
    }
    if (![self checkforNullValues:partners.telNum2])
    {
        cell.telNum2_label.text     = [NSString stringWithFormat:@"%@",partners.telNum2];
        cell.callButton2.hidden     = NO;
    }
    
    return cell;
}

- (void) setLabelColorsIntableViewCell:(GSPPartnerViewCell*)cell
{
    [cell.partnerTypeLabel setOverViewTableLabel];
    [cell.partnerNameLabel setOverViewTableLabel];
    [cell.telNum1_label setOverViewTableLabel];
    [cell.telNum2_label setOverViewTableLabel];
}

- (BOOL) checkforNullValues:(NSString*)partner_detail
{
    if ([partner_detail isEqualToString:@""] || [partner_detail isEqual:[NSNull null]] || partner_detail == nil || [partner_detail isEqualToString:@"(null)"])
    {
        return YES;
    }
    
    return NO;
}

- (void) callButtonClicked:(id)sender
{
    UIButton * callbutton = (UIButton*) sender;
    
    NSString * contactNumber;
    
    Partners *selectedpartner = [self.partnerArray copy];
    
    if ((callbutton.tag - 2000) >= 0) {
        selectedpartner = [self.partnerArray objectAtIndex:(callbutton.tag - 2000)];
        contactNumber = selectedpartner.telNum2;

    }
    else {
        selectedpartner = [self.partnerArray objectAtIndex:callbutton.tag];
        contactNumber = selectedpartner.telNum1;
    }

    
    NSString *cleanedString = [[contactNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    if (IS_IPAD) {
        
        NSURL    *facetimeURL = [NSURL URLWithString:[NSString stringWithFormat:@"facetime://%@", escapedPhoneNumber]];
        
        // Facetime is available or not
        if ([[UIApplication sharedApplication] canOpenURL:facetimeURL])
        {
            [[UIApplication sharedApplication] openURL:facetimeURL];
        }
        else
        {
            [[GSPUtility sharedInstance] showAlertWithTitle:@"Ooops!" message:@"Facetime not available." otherButton:nil tag:0 andDelegate:self];
        }
    }
    else
    {
        NSURL    *phoneNumbURL = [NSURL URLWithString:[@"telprompt://" stringByAppendingString:escapedPhoneNumber]];
        
        [[UIApplication sharedApplication] openURL:phoneNumbURL];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2)
    {
        cell.backgroundColor =  [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (IS_IPAD)
    {
        return 22;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    [self.headerView setBackgroundColor:TABLE_HEADER_BGCOLOR];
    
    return self.headerView;
}

@end
