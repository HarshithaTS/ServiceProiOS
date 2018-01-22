//
//  GSPServiceConfirmationViewController.m
//  GssServicePro
//
//  Created by Riyas Hassan on 09/09/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPServiceConfirmationViewController.h"
#import "GSPCommonTableView.h"
#import "GSPConfirmationCell.h"
#import "ServiceOrderClass.h"
#import "GSPServiceConfCreationViewController.h"
#import "GSPOfflineViewConfiguration.h"

@interface GSPServiceConfirmationViewController ()

@property (weak, nonatomic) IBOutlet GSPCommonTableView *confirmationListTableView;


@property (strong, nonatomic) NSMutableArray * serviceOrderActivityArray, *serviceOrderConfirmationArray, *selectedServiceOrderActivityArray;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderViewForLandscape;

@property (strong, nonatomic) ServiceTask * serviceTask;
//@property (weak, nonatomic) IBOutlet UILabel *ServiceTaskDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *iPhoneHorizontalScrollView;
@property (weak, nonatomic) IBOutlet UILabel *serviceOrgName;
@property (weak, nonatomic) IBOutlet UILabel *locationAddress1;
@property (weak, nonatomic) IBOutlet UILabel *locationAddress2;
@property (weak, nonatomic) IBOutlet UILabel *locationAddress3;
@property (weak, nonatomic) IBOutlet UILabel *startDatelabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceOrderLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *tableHorizontalScroll;

@end

@implementation GSPServiceConfirmationViewController

@synthesize tableName;
UIInterfaceOrientation interfaceOrientation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forObject:(ServiceTask*)serviceOrder
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.serviceTask = serviceOrder;
        
//        self.title = @"Service Confirmation Overview";
        [self setNavigationTitleWithBrandImage:@"Service Confirmation Overview"];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    [[GSPOfflineViewConfiguration sharedInstance] checkReachabilityAndCofigureView:self];

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self initializeVariables];
    
//    [[GSPOfflineViewConfiguration sharedInstance] checkReachabilityAndCofigureView:self];

    
    self.confirmationListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self setUpView];
}

- (void) initializeVariables
{
    self.serviceOrderActivityArray      = [NSMutableArray new];
    self.serviceOrderConfirmationArray  = [NSMutableArray new];
    self.selectedServiceOrderActivityArray = [NSMutableArray new];
    
    ServiceOrderClass *serviceOrder     = [ServiceOrderClass new];
    
// Original code
//    NSString* sqlQryStr                 = [NSString stringWithFormat:@"SELECT * FROM 'ZGSXSMST_SRVCACTVTY10' WHERE OBJECT_ID= %@",self.serviceTask.serviceOrder];
    
// Modified by Harshitha
    tableName = [SERVICEORDER_OBJTYPE stringByAppendingString:@"ZGSXSMST_SRVCACTVTY10"];
    NSString* sqlQryStr                 = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE OBJECT_ID= %@",tableName,self.serviceTask.serviceOrder];

    self.serviceOrderActivityArray      = [serviceOrder getServiceConfirmatiomnsActivityList:sqlQryStr];
    
    NSLog(@"acitivity %@", self.serviceOrderActivityArray);
    
// Original code
//    sqlQryStr                           = [NSString stringWithFormat:@"SELECT * FROM 'ZGSXSMST_SRVCCNFRMTN12' WHERE 1"];
    
// Modified by Harshitha
    tableName = [SERVICEORDER_OBJTYPE stringByAppendingString:@"ZGSXSMST_SRVCCNFRMTN12"];
    sqlQryStr                           = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",tableName];

    self.serviceOrderConfirmationArray  = [serviceOrder getServiceConfirmatiomnsActivityList:sqlQryStr];
    NSLog(@"confirmation array %@", self.serviceOrderConfirmationArray);
}

- (void) setUpView
{
//    self.ServiceTaskDescriptionLabel.layer.borderColor  = [[UIColor blackColor]CGColor];
//    self.ServiceTaskDescriptionLabel.layer.borderWidth  = 2.0;
//    self.ServiceTaskDescriptionLabel.text = [NSString stringWithFormat:@" Customer: %@ \n Start Date: %@ \n Service Order: %@, %@",
//                                [self.serviceTask locationAddress],
//                                [self.serviceTask startDate],
//                                [self.serviceTask serviceOrder],
//                                [self.serviceTask serviceOrderDescription]];
    
    self.serviceOrgName.text = self.serviceTask.serviceLocation;
    self.locationAddress1.text = self.serviceTask.locationAddress1;
    self.locationAddress2.text = self.serviceTask.locationAddress2;
    self.locationAddress3.text = self.serviceTask.locationAddress3;
    self.startDatelabel.text = self.serviceTask.startDate;
    self.serviceOrderLabel.text = self.serviceTask.serviceOrder;
    if (self.serviceTask.serviceOrderDescription.length > 0)
        self.serviceOrderLabel.text = [NSString stringWithFormat:@"%@ , %@",self.serviceOrderLabel.text,self.serviceTask.serviceOrderDescription];
    
    if (IS_IPHONE)
    {
        
        [self.iPhoneHorizontalScrollView setScrollEnabled:YES];
        [self.iPhoneHorizontalScrollView setShowsHorizontalScrollIndicator:YES];
        [self.iPhoneHorizontalScrollView setContentSize:(CGSizeMake(640,290))];
        [self.confirmationListTableView setFrame:CGRectMake(0, 0, 640, self.confirmationListTableView.frame.size.height)];
//        [self.confirmationListTableView setFrame:CGRectMake(0, 35, 640, self.confirmationListTableView.frame.size.height)];
    }
//added by sahana
    if(IS_IPAD){
    [self.tableHorizontalScroll setScrollEnabled:YES];
    [self.tableHorizontalScroll setShowsHorizontalScrollIndicator:YES];
        if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
        {
            [self.tableHorizontalScroll setContentSize:(CGSizeMake(1122,580))];
            [self.confirmationListTableView setFrame:CGRectMake(0, 0, 1122, 750)];
        }
        
        else if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
        {
            [self.tableHorizontalScroll setContentSize:(CGSizeMake(1122,400))];
            [self.confirmationListTableView  setFrame:CGRectMake(0, 0, 1122, 650)];
        }


    }
}


#pragma mark - UITableViewDataSource


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPHONE)
    {
        return 53.0;
    }
    else
    
        return 50;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString * headerStr =@"";
    
    return headerStr;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
    {
        return self.tableHeaderView;
    }
    return self.tableHeaderViewForLandscape;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
    
    return self.serviceOrderActivityArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellIdentifier = @"GSPConfirmationCell";
    
    GSPConfirmationCell *cell = (GSPConfirmationCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        
        if (IS_IPAD)
        {
            if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
                cell            = (GSPConfirmationCell *)[nib objectAtIndex:0];
            else if (UIInterfaceOrientationIsLandscape(interfaceOrientation))
                cell            = (GSPConfirmationCell *)[nib objectAtIndex:2];
        }
        else
        {
            cell            = (GSPConfirmationCell *)[nib objectAtIndex:1];
        }
        
//        [self setLabelColorsIntableViewCell:cell];
    }

    cell.backgroundView     = nil;
    cell.backgroundColor    = [UIColor clearColor];
    
    
    ServiceTask *serviceOrder    = [self.serviceOrderActivityArray objectAtIndex:indexPath.row];
    
    NSRange range = [serviceOrder.serviceItem rangeOfString:@" "];
   
    NSString * itemId , *description= @"";
    
    if (range.location == NSNotFound)
    {
        itemId      = serviceOrder.serviceItem;
        description = serviceOrder.serviceItem;
    }
    else
    {
        itemId      = [serviceOrder.serviceItem substringToIndex:range.location];
        description = [serviceOrder.serviceItem substringFromIndex:range.location];
    }

    
    cell.itemLabel.text         = serviceOrder.numberExtension;
    cell.productLabel.text      = itemId;
    cell.descriptionLabel.text  = description;
    cell.checkButton.tag        = indexPath.row;
    [cell.checkButton addTarget:self action:@selector(checkBoxClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    for(ServiceTask * serviceTask in self.serviceOrderConfirmationArray)
	{
   
//        Original Code
//        if ([serviceOrder.serviceOrder  isEqualToString:serviceTask.serviceOrder] &&  [serviceOrder.numberExtension  isEqualToString:serviceTask.numberExtension])
 
//        Modified by Harshitha
        if ([serviceOrder.serviceOrder  isEqualToString:serviceTask.confirmationId] &&  [serviceOrder.numberExtension  isEqualToString:serviceTask.numberExtension])
        {
            cell.confirmationIdLabel.text = serviceTask.serviceOrder;
            
//            [self setCheckBoxButtonImageChecked:YES forButton:cell.checkButton];
            cell.userInteractionEnabled = NO;
//            cell.backgroundColor = [UIColor lightGrayColor];
            cell.backgroundColor = [UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1.0];
            [cell.checkButton setBackgroundImage:nil forState:UIControlStateNormal];
        }
    }
    
    return cell;
    
}

/*
- (void) setLabelColorsIntableViewCell:(GSPConfirmationCell*)cell
{
    
    if (IS_IPAD)
    {
        [cell.itemLabel boldLabelsForDetailTableTitles];
        [cell.productLabel boldLabelsForDetailTableTitles];
        [cell.descriptionLabel boldLabelsForDetailTableTitles];
//        Added by Harshitha
        [cell.confirmationIdLabel boldLabelsForDetailTableTitles];
    }
    
  
}
*/

- (void) checkBoxClicked:(id)sender
{
    UIButton * button = (UIButton*) sender;
    
    [self setCheckBoxImageForButton:button];
}

- (void) setCheckBoxImageForButton:(UIButton*)button
{
    
//    if ([[button backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"checkedBoxpng"]])
    if ([[button backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"CheckedCheckbox"]])
    {
        [self setCheckBoxButtonImageChecked:NO forButton:button];
    }
    else
        [self setCheckBoxButtonImageChecked:YES forButton:button];
}


- (void) setCheckBoxButtonImageChecked:(BOOL)isChecked forButton:(UIButton*)button
{
    if (isChecked) {
        
        [self.selectedServiceOrderActivityArray addObject:[self.serviceOrderActivityArray objectAtIndex:button.tag]];
        
//        [button setBackgroundImage:[UIImage imageNamed:@"checkedBoxpng"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"CheckedCheckbox"] forState:UIControlStateNormal];
        return;
    }
    
    if ([self.selectedServiceOrderActivityArray containsObject:[self.serviceOrderActivityArray objectAtIndex:button.tag]])
    {
        [self.selectedServiceOrderActivityArray removeObject:[self.serviceOrderActivityArray objectAtIndex:button.tag]];
    }
 
//    [button setBackgroundImage:[UIImage imageNamed:@"uncheckedBox"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"UncheckedCheckbox"] forState:UIControlStateNormal];
}

/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    Original Code
//    if (indexPath.row % 2)
    
//    Modofied by Harshitha
    if (indexPath.row % 2 && (cell.backgroundColor != [UIColor lightGrayColor]))
    {
        cell.backgroundColor =  [UIColor colorWithRed:206.0/255 green:232.0/255 blue:255.0/255 alpha:1.0];
    }
}
*/

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (IBAction)addNewConfirmationAction:(id)sender
{

    if (self.selectedServiceOrderActivityArray.count <= 0)
    {
        [[GSPUtility sharedInstance] showAlertWithTitle:@"Empty Selection !" message:@"Please select atleast one service task to create new confirmation." otherButton:nil tag:0 andDelegate:self];
        return;
    }

    GSPServiceConfCreationViewController *confCreationVC ;

    if (IS_IPAD)
    {
        confCreationVC = [[GSPServiceConfCreationViewController alloc]initWithNibName:@"GSPServiceConfCreationViewController_iPad" bundle:nil withSelectedOrders:self.selectedServiceOrderActivityArray];
    }
    else
    {
        confCreationVC = [[GSPServiceConfCreationViewController alloc]initWithNibName:@"GSPServiceConfCreationViewController" bundle:nil withSelectedOrders:self.selectedServiceOrderActivityArray];
    }
    
    [self.navigationController pushViewController:confCreationVC animated:YES];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
