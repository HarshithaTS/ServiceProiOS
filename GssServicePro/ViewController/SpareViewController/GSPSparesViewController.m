//
//  GSPSparesViewController.m
//  GssServicePro
//
//  Created by Riyas Hassan on 08/10/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPSparesViewController.h"
#import "ServiceTask.h"
#import "GSPCommonTableView.h"
#import "ServiceConfirmation.h"
#import "GSPServiceConfCreationViewController.h"
#import "GSPSparesListTableViewCell.h"
#import "GSPSparesEditViewController.h"
#import "GSPOfflineViewConfiguration.h"

@interface GSPSparesViewController ()<UIActionSheetDelegate>

@property (nonatomic,strong) ServiceTask *serviceOrder;

@property (weak, nonatomic) IBOutlet UIScrollView *tableViewHorizontalScrollView;
@property (weak, nonatomic) IBOutlet GSPCommonTableView *sparesTableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderViewForLandscape;


@property (nonatomic,strong) NSMutableArray * dataSourceArray;

- (IBAction)bottomToolBarButtonsClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *serviceOrgName;
@property (weak, nonatomic) IBOutlet UILabel *locationAddress1;
@property (weak, nonatomic) IBOutlet UILabel *locationAddress2;
@property (weak, nonatomic) IBOutlet UILabel *locationAddress3;
@property (weak, nonatomic) IBOutlet UILabel *startDatelabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceOrderLabel;

@end

@implementation GSPSparesViewController

UIInterfaceOrientation interfaceOrientation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withObject:(ServiceTask*)serviceTask
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.serviceOrder = serviceTask;
//        self.title        = @"Spares Overview";
        [self setNavigationTitleWithBrandImage:@"Spares Overview"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self setupView];
    
    [[GSPOfflineViewConfiguration sharedInstance] checkReachabilityAndCofigureView:self];

    
    self.sparesTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    [self reloadSparesListTableView];
}

- (void) setupView
{
    [self.tableViewHorizontalScrollView setScrollEnabled:YES];
    [self.tableViewHorizontalScrollView setShowsHorizontalScrollIndicator:YES];
    
    if (IS_IPAD)
    {
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
        {
        [self.tableViewHorizontalScrollView setContentSize:(CGSizeMake(908,600))];
            [self.sparesTableView setFrame:CGRectMake(0, 0, 908, 650)];
        }
        else if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
        {
            [self.tableViewHorizontalScrollView setContentSize:(CGSizeMake(908,400))];
            [self.sparesTableView setFrame:CGRectMake(0, 0, 908, 400)];
        }

    }
    else
    {
        [self.tableViewHorizontalScrollView setContentSize:(CGSizeMake(908,300))];
        [self.sparesTableView setFrame:CGRectMake(0, 0, 908, 300)];
    }
    
//    self.serviceTaskDescriptionLabel.layer.borderColor  = [[UIColor blackColor]CGColor];
//    self.serviceTaskDescriptionLabel.layer.borderWidth  = 2.0;
//    self.serviceTaskDescriptionLabel.text = [NSString stringWithFormat:@" Customer: %@ \n Start Date: %@ \n Service Order: %@, %@",
//                                             [self.serviceOrder locationAddress],
//                                             [self.serviceOrder startDate],
//                                             [self.serviceOrder serviceOrder],
//                                             [self.serviceOrder serviceOrderDescription]];
    
    self.serviceOrgName.text = self.serviceOrder.serviceLocation;
    self.locationAddress1.text = self.serviceOrder.locationAddress1;
    self.locationAddress2.text = self.serviceOrder.locationAddress2;
    self.locationAddress3.text = self.serviceOrder.locationAddress3;
    self.startDatelabel.text = self.serviceOrder.startDate;
    self.serviceOrderLabel.text = self.serviceOrder.serviceOrder;
    if (self.serviceOrder.serviceOrderDescription.length > 0)
        self.serviceOrderLabel.text = [NSString stringWithFormat:@"%@ , %@",self.serviceOrderLabel.text,self.serviceOrder.serviceOrderDescription];
    
    [self setRightNavigationBarButtonItemsWithMenu:YES andOtherBarButtonWithImageNamed:nil andSelector:nil];
    
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonClicked:)];
    self.navigationItem.leftBarButtonItem=newBackButton;
}


- (void)menuButtonClick:(id)sender
{
    UIActionSheet* menuActionSheet = [[UIActionSheet alloc]
                                      initWithTitle:NSLocalizedString(@"CHOOSE_ACTION", nil)
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"CANCEL", nil)
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:NSLocalizedString(@"ADD_NEW_SPARE", nil),nil];
    [menuActionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    GSPSparesEditViewController *editVC ;
    if (IS_IPAD) {
        editVC         = [[GSPSparesEditViewController alloc]initWithNibName:@"GSPSparesEditViewController_iPad" bundle:nil WithObjectID:self.serviceOrder andSpareObject:nil];
    }
    else
    {
        editVC         = [[GSPSparesEditViewController alloc]initWithNibName:@"GSPSparesEditViewController" bundle:nil WithObjectID:self.serviceOrder andSpareObject:nil];
    }
    [self.navigationController pushViewController:editVC animated:YES];
}


-(void)backButtonClicked:(UIBarButtonItem *)sender
{
    
    NSArray * navigationViewControllerArray = [self.navigationController viewControllers];
    
    for (UIViewController *VC in navigationViewControllerArray) {
        if ([VC isKindOfClass:[GSPServiceConfCreationViewController class] ]) {
            [self.navigationController popToViewController:VC animated:YES];
            return;
        }
    }
}

- (void) reloadSparesListTableView
{
    ServiceConfirmation *serviceDataObj = [ServiceConfirmation new];
    
    NSString *sqlQryStr                 = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE NUMBER_EXT = %@  AND OBJECT_ID='%@'",@"ZGSXSMST_SRVCSPARE10_TEMP",[self.serviceOrder numberExtension],self.serviceOrder.serviceOrder];
    
    
    self.dataSourceArray                = [serviceDataObj getTempServiceConfirmationDataArrayWithQueryStr:sqlQryStr];
    
    [self.sparesTableView reloadData];
}


#pragma mark - UITableViewDataSource


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
    
    
    return self.dataSourceArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellIdentifier = @"GSPSparesListTableViewCell";
    
    GSPSparesListTableViewCell *cell = (GSPSparesListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        
        if (IS_IPAD)
        {
            if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
                cell            = (GSPSparesListTableViewCell *)[nib objectAtIndex:0];
            else if (UIInterfaceOrientationIsLandscape(interfaceOrientation))
                cell            = (GSPSparesListTableViewCell *)[nib objectAtIndex:1];
        }
        else
        {
            cell            = (GSPSparesListTableViewCell *)[nib objectAtIndex:0];
        }
        
       
    }
    
//    [self setLabelColorsIntableViewCell:cell];
    cell.backgroundView     = nil;
    cell.backgroundColor    = [UIColor clearColor];
    
    
    NSDictionary *serviceSparesDict = [self.dataSourceArray objectAtIndex:indexPath.row];
    
    cell.materialIDLabel.text       = [self checkNullString:[serviceSparesDict objectForKey:@"PRODUCT_ID"]];
    cell.materialDescLabel.text     = [self checkNullString:[serviceSparesDict objectForKey:@"ZZITEM_DESCRIPTION"]];
    cell.qtyLabel.text              = [self checkNullString:[serviceSparesDict objectForKey:@"QUANTITY"]];
    cell.unitLabel.text             = [self checkNullString:[serviceSparesDict objectForKey:@"PROCESS_QTY_UNIT"]];
    cell.serialLabel.text           = [self checkNullString:[serviceSparesDict objectForKey:@"SERIAL_NUMBER"]];
    
    cell.editButton.tag         = indexPath.row;
    cell.deleteButton.tag       = indexPath.row;
    
    [cell.editButton addTarget:self action:@selector(editButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}

- (NSString*) checkNullString:(NSString*)objectStr
{
    
    if ([objectStr isEqualToString:@"(null)"])
        
        return @"";
    
    else
        
        return objectStr;
    
}

/*
- (void)setLabelColorsIntableViewCell:(GSPSparesListTableViewCell*)cell
{
    [cell.materialIDLabel setFont:[UIFont systemFontOfSize:13]];
    [cell.materialDescLabel setFont:[UIFont systemFontOfSize:13]];
    [cell.qtyLabel setFont:[UIFont systemFontOfSize:13]];
    [cell.unitLabel setFont:[UIFont systemFontOfSize:13]];
    [cell.serialLabel setFont:[UIFont systemFontOfSize:13]];
}
*/

- (void) editButtonClicked:(UIButton*)sender
{
    NSMutableDictionary *serviceFaultsDict      = (NSMutableDictionary*)[self.dataSourceArray objectAtIndex:sender.tag];
   
    GSPSparesEditViewController *editVC ;
    
    if (IS_IPAD) {
        editVC         = [[GSPSparesEditViewController alloc]initWithNibName:@"GSPSparesEditViewController_iPad" bundle:nil WithObjectID:self.serviceOrder andSpareObject:serviceFaultsDict];
    }
    else
    {
        editVC         = [[GSPSparesEditViewController alloc]initWithNibName:@"GSPSparesEditViewController" bundle:nil WithObjectID:self.serviceOrder andSpareObject:serviceFaultsDict];
    }
    
    [self.navigationController pushViewController:editVC animated:YES];
    
}

- (void) deleteButtonClicked: (UIButton*)sender
{
    [[GSPUtility sharedInstance] showAlertWithTitle:@"" message:@"Are you sure you want to delete this Item?" otherButton:@"Cancel" tag:sender.tag andDelegate:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self deleteSpareRecordFromDBAndReloadTable:alertView.tag];
            break;
            
        default:
            break;
    }
}

-(void) deleteSpareRecordFromDBAndReloadTable:(int)alertTag
{
    NSMutableDictionary *serviceFaultsDictf      = (NSMutableDictionary*)[self.dataSourceArray objectAtIndex:alertTag];
    NSString *deleteQuery = [NSString stringWithFormat:@"DELETE FROM ZGSXSMST_SRVCSPARE10_TEMP WHERE NUMBER_EXT = %@",[serviceFaultsDictf objectForKey:@"NUMBER_EXT"]];
    
    ServiceConfirmation *serviceDataObj = [ServiceConfirmation new];
    
    if ([serviceDataObj deleteTempServiceConfirmationDataFromDBWithQueryString:deleteQuery])
    {
        [self reloadSparesListTableView];
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)bottomToolBarButtonsClick:(UIButton *)sender
{

    [self backButtonClicked:nil];

}
@end
