//
//  GSPFaultsViewController.m
//  GssServicePro
//
//  Created by Riyas Hassan on 18/09/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPFaultsViewController.h"
#import "GSPPickerController.h"
#import "ServiceConfirmation.h"
#import "GSPFaultEditScreenViewController.h"
#import "GSPFaultTableViewCell.h"
#import "GSPCommonTableView.h"
#import "GSPServiceConfCreationViewController.h"
#import "GSPSparesViewController.h"
#import "GSPSparesEditViewController.h"
#import "GSPOfflineViewConfiguration.h"

@interface GSPFaultsViewController ()<CustomPickerDelegate, UIActionSheetDelegate>
{
    GSPPickerController *  pickerController;

}

@property (weak, nonatomic) IBOutlet UIScrollView *tableViewHorizontalScrollView;
@property (weak, nonatomic) IBOutlet GSPCommonTableView *faultsTableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;


@property (nonatomic,strong) NSMutableArray * dataSourceArray;

@property (nonatomic, strong) NSMutableDictionary *faultDataDictionary;

@property (nonatomic,strong) ServiceTask *serviceOrder;

- (IBAction) saveButtonClick :(id)sender;

- (IBAction)bottomToolBarButtonsClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *serviceOrgName;
@property (weak, nonatomic) IBOutlet UILabel *locationAddress1;
@property (weak, nonatomic) IBOutlet UILabel *locationAddress2;
@property (weak, nonatomic) IBOutlet UILabel *locationAddress3;
@property (weak, nonatomic) IBOutlet UILabel *startDatelabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceOrderLabel;

@end

@implementation GSPFaultsViewController

UIInterfaceOrientation interfaceOrientation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withObject:(ServiceTask*)serviceTask
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.serviceOrder = serviceTask;
//        self.title        = @"Faults Overview";
        [self setNavigationTitleWithBrandImage:@"Fault Overview"];
    }
    return self;
}

- (void)viewDidLoad
{
   
    [super viewDidLoad];
    
    [self setUpView];
    
    [self initializeVariables];
    
    [[GSPOfflineViewConfiguration sharedInstance] checkReachabilityAndCofigureView:self];

    
    self.faultsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    [self reloadFaultsListTableView];

}
- (void) initializeVariables
{
    
}

- (void ) setUpView
{
    
    [self.tableViewHorizontalScrollView setScrollEnabled:YES];
    [self.tableViewHorizontalScrollView setShowsHorizontalScrollIndicator:YES];
    

    if (IS_IPAD)
    {
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
        {
        [self.tableViewHorizontalScrollView setContentSize:(CGSizeMake(1306,600))];

        [self.faultsTableView setFrame:CGRectMake(0, 0, 1306, 650)];
        }
        else if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
        {
            [self.tableViewHorizontalScrollView setContentSize:(CGSizeMake(1306,400))];
            
            [self.faultsTableView setFrame:CGRectMake(0, 0, 1306, 400)];
        }
    }
    else
    {
        [self.tableViewHorizontalScrollView setContentSize:(CGSizeMake(1306,300))];
        [self.faultsTableView setFrame:CGRectMake(0, 0, 1306, 300)];
    }
    
    
//    self.serviceTaskDescriptionLabel.layer.borderColor  = [[UIColor blackColor]CGColor];
//    self.serviceTaskDescriptionLabel.layer.borderWidth  = 2.0;
//    self.serviceTaskDescriptionLabel.text = [NSString stringWithFormat:@" Customer: %@ \n Start Date: %@ \n Service Order: %@, %@",
//                                             [self.serviceOrder locationAddress],
//                                             [self.serviceOrder startDate],
//                                             [self.serviceOrder serviceOrder],
//                                             [self.serviceOrder serviceOrderDescription]];
    
//    ServiceTask *serviceTask = [self.dataSourceArray objectAtIndex:0];

    self.serviceOrgName.text = self.serviceOrder.serviceLocation;
    self.locationAddress1.text = self.serviceOrder.locationAddress1;
    self.locationAddress2.text = self.serviceOrder.locationAddress2;
    self.locationAddress3.text = self.serviceOrder.locationAddress3;
    self.startDatelabel.text = self.serviceOrder.startDate;
    self.serviceOrderLabel.text = self.serviceOrder.serviceOrder;
    if (self.serviceOrder.serviceOrderDescription.length > 0)
        self.serviceOrderLabel.text = [NSString stringWithFormat:@"%@ , %@",self.serviceOrderLabel.text,self.serviceOrder.serviceOrderDescription];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonClicked:)];
    self.navigationItem.leftBarButtonItem=newBackButton;
    
    [self setRightNavigationBarButtonItemsWithMenu:YES andOtherBarButtonWithImageNamed:nil andSelector:nil];
}


- (void)menuButtonClick:(id)sender
{
    UIActionSheet* menuActionSheet = [[UIActionSheet alloc]
                                      initWithTitle:NSLocalizedString(@"CHOOSE_ACTION", nil)
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"CANCEL", nil)
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:NSLocalizedString(@"ADD_NEW_FAULT", nil),nil];
    [menuActionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    GSPFaultEditScreenViewController *editVC ;
    
    if (IS_IPAD) {
        editVC         = [[GSPFaultEditScreenViewController alloc]initWithNibName:@"GSPFaultEditScreenViewController_iPad" bundle:nil withServiceObject:self.serviceOrder andFaultObject:nil];
    }
    else
    {
        editVC         = [[GSPFaultEditScreenViewController alloc]initWithNibName:@"GSPFaultEditScreenViewController" bundle:nil withServiceObject:self.serviceOrder andFaultObject:nil];
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

- (void) reloadFaultsListTableView
{
    ServiceConfirmation *serviceDataObj = [ServiceConfirmation new];
    
    NSString *sqlQryStr                 = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE NUMBER_EXT = %@",@"ZGSXSMST_SRVCCNFRMTNFAULT20",[self.serviceOrder numberExtension]];
    
    
    self.dataSourceArray                = [serviceDataObj getTempServiceConfirmationDataArrayWithQueryStr:sqlQryStr];
    
    [self.faultsTableView reloadData];
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
    return self.tableHeaderView;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return self.dataSourceArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellIdentifier = @"GSPFaultTableViewCell";
    
    GSPFaultTableViewCell *cell = (GSPFaultTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        
        if (IS_IPAD)
        {
            cell            = (GSPFaultTableViewCell *)[nib objectAtIndex:0];
        }
        else
        {
            cell            = (GSPFaultTableViewCell *)[nib objectAtIndex:0];
        }
        
//        [self setLabelColorsIntableViewCell:cell];
    }
    
    cell.backgroundView     = nil;
    cell.backgroundColor    = [UIColor clearColor];
    
    
    NSDictionary *serviceFaultsDict    = [self.dataSourceArray objectAtIndex:indexPath.row];

    cell.symptomGroupLabel.text = [self checkNullString:[serviceFaultsDict objectForKey:@"ZZSYMPTMCODEGROUP"]];
    cell.symptomCodeLabel.text  = [self checkNullString:[serviceFaultsDict objectForKey:@"ZZSYMPTMCODE"]];
    cell.symptomDescLabel.text  = [self checkNullString:[serviceFaultsDict objectForKey:@"ZZSYMPTMTEXT"]];
    cell.problemGroupLabel.text = [self checkNullString:[serviceFaultsDict objectForKey:@"ZZPRBLMCODEGROUP"]];
    cell.problemCodeLabel.text  = [self checkNullString:[serviceFaultsDict objectForKey:@"ZZPRBLMCODE"]];
    cell.problemDescLabel.text  = [self checkNullString:[serviceFaultsDict objectForKey:@"ZZPRBLMTEXT"]];
    cell.causeGroupLabel.text   = [self checkNullString:[serviceFaultsDict objectForKey:@"ZZCAUSECODEGROUP"]];
    cell.causeCodeLabel.text    = [self checkNullString:[serviceFaultsDict objectForKey:@"ZZCAUSECODE"]];
    cell.causeDesclabel.text    = [self checkNullString:[serviceFaultsDict objectForKey:@"ZZCAUSETEXT"]];
    
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
- (void) setLabelColorsIntableViewCell: (GSPFaultTableViewCell*)cell
{
    if (IS_IPHONE) {
        [cell.symptomGroupLabel setFont:[UIFont systemFontOfSize:13]];
        [cell.symptomCodeLabel setFont:[UIFont systemFontOfSize:13]];
        [cell.symptomDescLabel setFont:[UIFont systemFontOfSize:13]];
        [cell.problemGroupLabel setFont:[UIFont systemFontOfSize:13]];
        [cell.problemCodeLabel setFont:[UIFont systemFontOfSize:13]];
        [cell.problemDescLabel setFont:[UIFont systemFontOfSize:13]];
        [cell.causeGroupLabel setFont:[UIFont systemFontOfSize:13]];
        [cell.causeCodeLabel setFont:[UIFont systemFontOfSize:13]];
        [cell.causeDesclabel setFont:[UIFont systemFontOfSize:13]];
    }
}
*/

- (void) editButtonClicked:(UIButton*)sender
{
    NSMutableDictionary *serviceFaultsDict      = (NSMutableDictionary*)[self.dataSourceArray objectAtIndex:sender.tag];
    
    GSPFaultEditScreenViewController *editVC ;
    
    if (IS_IPAD) {
        editVC    = [[GSPFaultEditScreenViewController alloc]initWithNibName:@"GSPFaultEditScreenViewController_iPad" bundle:nil withServiceObject:self.serviceOrder andFaultObject:serviceFaultsDict];
    }
    else
    {
        editVC    = [[GSPFaultEditScreenViewController alloc]initWithNibName:@"GSPFaultEditScreenViewController" bundle:nil withServiceObject:self.serviceOrder andFaultObject:serviceFaultsDict];
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
            [self deleteFaultRecordFromDBAndReloadTable:alertView.tag];
            break;
            
        default:
            break;
    }
}

-(void) deleteFaultRecordFromDBAndReloadTable:(int)alertTag
{
    NSMutableDictionary *serviceFaultsDict      = (NSMutableDictionary*)[self.dataSourceArray objectAtIndex:alertTag];
    NSString *deleteQuery = [NSString stringWithFormat:@"DELETE FROM ZGSXSMST_SRVCCNFRMTNFAULT20 WHERE NUMBER_EXT = %@",[serviceFaultsDict objectForKey:@"NUMBER_EXT"]];
    
    ServiceConfirmation *serviceDataObj = [ServiceConfirmation new];
    
    if ([serviceDataObj deleteTempServiceConfirmationDataFromDBWithQueryString:deleteQuery])
    {
        [self reloadFaultsListTableView];
    }
    
}

- (IBAction)bottomToolBarButtonsClick:(UIButton *)sender
{
    
    switch (sender.tag) {
        case 10:
            [self backButtonClicked:nil];
            break;
        case 12:
            [self showSparesScreen];
            break;
            
        default:
            break;
    }
    
}
- (void) showSparesScreen
{
    ServiceConfirmation *serviceDataObj = [ServiceConfirmation new];
    
    NSString *sqlQryStr                 = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE NUMBER_EXT = %@  AND OBJECT_ID='%@'",@"ZGSXSMST_SRVCSPARE10_TEMP",[self.serviceOrder numberExtension],self.serviceOrder.serviceOrder];
    
    
    NSMutableArray * sparesDataArray    = [serviceDataObj getTempServiceConfirmationDataArrayWithQueryStr:sqlQryStr];
    
    if(sparesDataArray.count <= 0 )
    {
        [self showSparesEditScreen];
    }
    else
    {
        [self showSparesListScreen];
    }
    
}

- (void) showSparesListScreen
{
    GSPSparesViewController *sparesListVC ;
    
    if (IS_IPAD) {
        sparesListVC            = [[GSPSparesViewController alloc]initWithNibName:@"GSPSparesViewController_iPad" bundle:nil withObject:self.serviceOrder];
    }
    else
    {
        sparesListVC            = [[GSPSparesViewController alloc]initWithNibName:@"GSPSparesViewController" bundle:nil withObject:self.serviceOrder];
    }
    
    [self.navigationController pushViewController:sparesListVC animated:YES];
}

- (void) showSparesEditScreen
{
    GSPSparesEditViewController *editVC  ;
    if (IS_IPAD) {
        editVC   = [[GSPSparesEditViewController alloc]initWithNibName:@"GSPSparesEditViewController_iPad" bundle:nil WithObjectID:self.serviceOrder andSpareObject:nil];
    }
    else
    {
        editVC   = [[GSPSparesEditViewController alloc]initWithNibName:@"GSPSparesEditViewController" bundle:nil WithObjectID:self.serviceOrder andSpareObject:nil];
    }
    
    [self.navigationController pushViewController:editVC animated:YES];
    
}


@end
