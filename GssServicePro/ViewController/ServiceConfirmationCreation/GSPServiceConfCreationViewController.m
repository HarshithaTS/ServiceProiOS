//
//  GSPServiceConfCreationViewController.m
//  GssServicePro
//
//  Created by Riyas Hassan on 12/09/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPServiceConfCreationViewController.h"
#import "GSPConfirmationCreationCell.h"
#import "ServiceTask.h"
#import "GSPUtility.h"
#import "GSPConfEditActvityViewController.h"
#import "GSPFaultsViewController.h"
#import "GSPSparesEditViewController.h"
#import "GSPFaultEditScreenViewController.h"
#import "ServiceConfirmation.h"
#import "GSPSparesViewController.h"
#import "GSPCommonTableView.h"
#import "CheckedNetwork.h"
#import "GSPServiceConfirmationViewController.h"
#import "GSPDateUtility.h"
#import "GSPSignatureCaptureView.h"
#import "GSPConfirmationCreationDetailView_iPhoneViewController.h"
#import "GSPServiceTasksViewController.h"
#import "GSPAppDelegate.h"
#import "GSPOfflineViewConfiguration.h"

@interface GSPServiceConfCreationViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    int itemSelectedToDelete;
    ServiceConfirmation     * serviceDataObj;
    GSPSignatureCaptureView * signatureView;
}

@property (nonatomic,strong) NSMutableArray *dataSourceArray, *selectedItemsArray ;

@property (weak, nonatomic) IBOutlet UIScrollView *tableViewHorizontalScrollView;

@property (strong, nonatomic) IBOutlet UIView *tabelHeaderView;
@property (weak, nonatomic) IBOutlet GSPCommonTableView *servicesTabelView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedController;
@property (weak, nonatomic) IBOutlet UIButton *servicesButton;
@property (weak, nonatomic) IBOutlet UIButton *faultButton;
@property (weak, nonatomic) IBOutlet UIButton *sparesButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (strong, nonatomic) NSString *serviceType;
@property (strong, nonatomic) NSString *serviceOrder;
@property (strong, nonatomic) NSString *locationAddress;
@property (strong, nonatomic) NSString *serviceOrderDescription;

- (IBAction)toolBarButtonsClicked:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *serviceOrgName;
@property (weak, nonatomic) IBOutlet UILabel *locationAddress1;
@property (weak, nonatomic) IBOutlet UILabel *locationAddress2;
@property (weak, nonatomic) IBOutlet UILabel *locationAddress3;
@property (weak, nonatomic) IBOutlet UILabel *startDatelabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceOrderLabel;

@property (strong, nonatomic) NSString *serviceOrgnizationName;
@property (strong, nonatomic) NSString *locationAdd1;
@property (strong, nonatomic) NSString *locationAdd2;
@property (strong, nonatomic) NSString *locationAdd3;

@end

@implementation GSPServiceConfCreationViewController

@synthesize tableName;
UIInterfaceOrientation interfaceOrientation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSelectedOrders:(NSMutableArray*)selectedArray
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      
        self.dataSourceArray = [[NSMutableArray alloc]init];
        self.dataSourceArray = (NSMutableArray*)[selectedArray mutableCopy];
        
//        self.title = @"Service Confirmation Creation";
        [self setNavigationTitleWithBrandImage:@"Service Confirmation Creation"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initializeVariables];
    
    [self setUpView];
    
//    [[GSPOfflineViewConfiguration sharedInstance] checkReachabilityAndCofigureView:self];
    
    self.servicesTabelView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
   
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[GSPOfflineViewConfiguration sharedInstance] checkReachabilityAndCofigureView:self];

    
    interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateConfirmationResponseHandler:) name:@"AcitivityIndicatorForServiceConfirmation" object:nil];

    [self getTempDataArrayFromDBandReloadTableView];
}

//     *****   Added by Harshitha   *****
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//    *****   Added by Harshitha ends   *****

-(void) setUpView
{
    [self emptyServiceConfirmationTempDB];
    
    [self saveSelectedItemsIntoTempDB];
    
    
    ServiceTask *serviceTask = [self.dataSourceArray objectAtIndex:0];
    
    _increNumExt= [serviceTask.numberExtension intValue]+5000;

//    self.serviceTaskDescriptionLabel.layer.borderColor  = [[UIColor blackColor]CGColor];
//    self.serviceTaskDescriptionLabel.layer.borderWidth  = 2.0;
//    
//    self.serviceTaskDescriptionLabel.text = [NSString stringWithFormat:@" Customer: %@ \n Start Date: %@ \n Service Order: %@, %@",
//                                             [serviceTask locationAddress],
//                                             [serviceTask startDate],
//                                             [serviceTask serviceOrder],
//                                             [serviceTask serviceOrderDescription]];
    
    self.serviceOrgName.text = serviceTask.serviceLocation;
    self.locationAddress1.text = serviceTask.locationAddress1;
    self.locationAddress2.text = serviceTask.locationAddress2;
    self.locationAddress3.text = serviceTask.locationAddress3;
    self.startDatelabel.text = serviceTask.startDate;
    self.serviceOrderLabel.text = serviceTask.serviceOrder;
    if (serviceTask.serviceOrderDescription.length > 0)
        self.serviceOrderLabel.text = [NSString stringWithFormat:@"%@ , %@",self.serviceOrderLabel.text,serviceTask.serviceOrderDescription];
    
    if (IS_IPAD)
    {
        [self.tableViewHorizontalScrollView setScrollEnabled:YES];
        [self.tableViewHorizontalScrollView setShowsHorizontalScrollIndicator:YES];
//        [self.tableViewHorizontalScrollView setContentSize:(CGSizeMake(1122,700))];
        if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
        {
            [self.tableViewHorizontalScrollView setContentSize:(CGSizeMake(1122,580))];
            [self.servicesTabelView setFrame:CGRectMake(0, 0, 1122, 700)];
        }

        else if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
        {
            [self.tableViewHorizontalScrollView setContentSize:(CGSizeMake(1122,400))];
            [self.servicesTabelView setFrame:CGRectMake(0, 0, 1122, 650)];
        }
        
        [self.segmentedController addTarget:self action:@selector(segmentControllerSelectionChanged:)
                           forControlEvents:UIControlEventValueChanged];
        self.segmentedController.selectedSegmentIndex = 0;

        [self setUpBottomSegmentController];
    }
    
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonClicked)];
    self.navigationItem.leftBarButtonItem=newBackButton;
    
    [self setRightNavigationBarButtonItemsWithMenu:YES andOtherBarButtonWithImageNamed:nil andSelector:nil];
}

-(void)backButtonClicked
{
    
    [[GSPUtility sharedInstance] showAlertWithTitle:@"" message:@"Data entered so far will be lost! Are you sure you want to exit?" otherButton:@"Cancel" tag:3 andDelegate:self];
}


- (void) emptyServiceConfirmationTempDB
{
    [serviceDataObj deleteTemporaryConfirmationRecordsFromDB];
    [[GSPUtility sharedInstance] deleteServiceConfirmationDocsDirectory:@"ConfirmationAttachedSignatures" ];
    [[GSPUtility sharedInstance] deleteServiceConfirmationDocsDirectory:@"ConfirmationAttchedImages" ];
}


-(void) setUpBottomSegmentController
{
    UIImage *firstSegmentImage = [UIImage imageNamed:@"service_32.png"];
    UIImage *secondSegmentImage = [UIImage imageNamed:@"service_32.png"];
    UIImage *thirdSegmentImage = [UIImage imageNamed:@"service_32.png"];
    UIImage *fourthSegmentImage = [UIImage imageNamed:@"service_32.png"];
    

    
    [self.segmentedController setImage:firstSegmentImage forSegmentAtIndex:0];
    [self.segmentedController setImage:secondSegmentImage forSegmentAtIndex:1];
    [self.segmentedController setImage:thirdSegmentImage forSegmentAtIndex:2];
    [self.segmentedController setImage:fourthSegmentImage forSegmentAtIndex:3];

}

- (void)initializeVariables
{
    serviceDataObj              = [ServiceConfirmation new];
    self.selectedItemsArray     = [NSMutableArray new];
    self.serviceType            = [[self.dataSourceArray objectAtIndex:0] serviceOrderType];
    self.serviceOrder           = [[self.dataSourceArray objectAtIndex:0] serviceOrder];
    self.locationAddress        = [[self.dataSourceArray objectAtIndex:0] locationAddress];
    self.serviceOrderDescription= [[self.dataSourceArray objectAtIndex:0] serviceOrderDescription];
    
    self.serviceOrgnizationName = [[self.dataSourceArray objectAtIndex:0] serviceLocation];
    self.locationAdd1 = [[self.dataSourceArray objectAtIndex:0] locationAddress1];
    self.locationAdd2 = [[self.dataSourceArray objectAtIndex:0] locationAddress2];
    self.locationAdd3 = [[self.dataSourceArray objectAtIndex:0] locationAddress3];
    
// Original code.....Moved to ViewDidLoad() by Harshitha
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateConfirmationResponseHandler:) name:@"AcitivityIndicatorForServiceConfirmation" object:nil];
}

- (void) saveSelectedItemsIntoTempDB
{
    int mNUMBER_EXT = 5100;
    
    
    NSLog(@"datasource arrya %@",self.dataSourceArray);
    
    
    for (ServiceTask *task in self.dataSourceArray) {
        
        
        NSLog(@"task: %@", task);
        
        int mSRCDOC_NUMBER_EXT   = [task.numberExtension intValue];
        mNUMBER_EXT              = mNUMBER_EXT + 10;
        
        NSRange range           = [task.serviceItem rangeOfString:@" "];
        NSString *productID     = [task.serviceItem substringToIndex:range.location];
        NSString *itemDesc      = [task.serviceItem substringFromIndex:range.location+1];
        //Selvan Add this code
        NSString *serviceNote = task.zzitemtext;
        NSString *estimatedArrivalDate = @"";
        NSString *estimatedArrivalTime = @"";
        
        if ([task.estimatedArrivalDate length] > 0) {
            estimatedArrivalDate = [[GSPDateUtility sharedInstance] getDateFromString: task.estimatedArrivalDate];
            estimatedArrivalTime = [[GSPDateUtility sharedInstance] getTimeFromString: task.estimatedArrivalDate];
        }
// Original code
/*        NSString * tempValueStr = [NSString stringWithFormat:@"'%@',%d,%d,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@'",
                                   task.serviceOrder,mSRCDOC_NUMBER_EXT, mSRCDOC_NUMBER_EXT, productID, @"", @"",itemDesc,serviceNote,
                                   task.startDate,
                                   task.estimatedArrivalDate,
                                   [[GSPDateUtility sharedInstance] getDateFromString: task.startDate],
                                   estimatedArrivalDate,
                                   [[GSPDateUtility sharedInstance] getTimeFromString: task.startDate],
                                   estimatedArrivalTime,
                                   task.timeZoneFrom
                                   ];
*/
// Modified by Harshitha
        NSString * tempValueStr = [NSString stringWithFormat:@"'%@',%d,%d,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@'",
                                   task.serviceOrder,mNUMBER_EXT, mSRCDOC_NUMBER_EXT, productID, @"", @"",itemDesc,serviceNote,
                                   task.startDateAndTime,
                                   task.estimatedArrivalDate,
                                   [[GSPDateUtility sharedInstance] getDateFromString: task.startDateAndTime],
                                   estimatedArrivalDate,
                                   [[GSPDateUtility sharedInstance] getTimeFromString: task.startDateAndTime],
                                   estimatedArrivalTime,
                                   task.timeZoneFrom
                                   ];
        
        NSString *sqlQuery = [NSString stringWithFormat:@"INSERT INTO  ZGSXSMST_SRVCACTVTY10_TEMP (%@) VALUES (%@)",@"OBJECT_ID,SRCDOC_NUMBER_EXT,NUMBER_EXT,PRODUCT_ID,QUANTITY,PROCESS_QTY_UNIT,ZZITEM_DESCRIPTION,ZZITEM_TEXT,DATETIME_FROM,DATETIME_TO,DATE_FROM,DATE_TO,TIME_FROM,TIME_TO,TIMEZONE_FROM",tempValueStr];
        
        [serviceDataObj updateServicesConfirmationData:sqlQuery];
    }
}

- (void) getTempDataArrayFromDBandReloadTableView
{
    self.dataSourceArray    = nil;
    
    NSString *sqlQryStr     = [NSString stringWithFormat:@"SELECT * FROM ZGSXSMST_SRVCACTVTY10_TEMP WHERE 1"];
    
    self.dataSourceArray    = [NSMutableArray new];
    
    NSMutableArray *tempArray    = [serviceDataObj getTempServiceConfirmationDataArrayWithQueryStr:sqlQryStr];
    
       for (NSDictionary *tempDic in tempArray) {
        
        ServiceTask * newTask   = [ServiceTask new];
        newTask.numberExtension = [tempDic valueForKey:@"NUMBER_EXT"];
        newTask.serviceOrder    = [tempDic valueForKey:@"OBJECT_ID"];
        newTask.serviceItem     = [NSString stringWithFormat:@"%@", [tempDic valueForKey:@"ZZITEM_DESCRIPTION"]];
        newTask.startDate       = [tempDic valueForKey:@"DATETIME_FROM"];
        newTask.startDateAndTime = [tempDic valueForKey:@"DATETIME_FROM"];
//        newTask.estimatedArrivalTime = [tempDic valueForKey:@"DATETIME_TO"];
        if ([[tempDic valueForKey:@"DATETIME_TO"] length] > 0) {
            newTask.estimatedArrivalDate = [tempDic valueForKey:@"DATETIME_TO"];
        }
        else {
            /*commented by sahana
            newTask.estimatedArrivalDate = [NSString stringWithFormat:@"%@",[NSDate date]];
             */
            
            //Added by sahana
            NSDate *todayDate=[NSDate date];
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
           [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *convertedDateString = [dateFormatter stringFromDate:todayDate];
            newTask.estimatedArrivalDate=convertedDateString;
                       //ends here
        }
        newTask.serviceNote     = [tempDic valueForKey:@"ZZITEM_TEXT"];
        newTask.duration        = [tempDic valueForKey:@"QUANTITY"];
        newTask.locationAddress = self.locationAddress;
        newTask.serviceOrderDescription = self.serviceOrderDescription;
        
        newTask.serviceLocation = self.serviceOrgnizationName;
        newTask.locationAddress1 = self.locationAdd1;
        newTask.locationAddress2 = self.locationAdd2;
        newTask.locationAddress3 = self.locationAdd3;
        
        [self.dataSourceArray addObject:newTask];
    }

    
    [self.servicesTabelView reloadData];
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
    return self.tabelHeaderView;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return self.dataSourceArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellIdentifier = @"GSPConfirmationCreationCell";
    
    GSPConfirmationCreationCell *cell = (GSPConfirmationCreationCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        
        if (IS_IPAD)
        {
            cell            = (GSPConfirmationCreationCell *)[nib objectAtIndex:0];
        }
        else
        {
            cell            = (GSPConfirmationCreationCell *)[nib objectAtIndex:1];
        }
        
//        [self setLabelColorsIntableViewCell:cell];
    }
    
    cell.backgroundView     = nil;
    cell.backgroundColor    = [UIColor clearColor];
    
    ServiceTask *serviceOrder        = [self.dataSourceArray objectAtIndex:indexPath.row];
    
    
    cell.serviceDescriptionLabel.text   = [self checkNullString:serviceOrder.serviceItem];
    cell.durationLabel.text             = [self checkNullString:serviceOrder.duration];
    cell.startDateLabel.text            = [self checkNullString:[NSString stringWithFormat:@"%@",[[GSPDateUtility sharedInstance]convertYYYYMMDDHHMMSStoMMMDDYYYYHHMM:serviceOrder.startDate]]];
// Original code
//    cell.endDateLabel.text              = [self checkNullString:[NSString stringWithFormat:@"%@",serviceOrder.estimatedArrivalDate]];
    
   // Modified by Harshitha
    
    if ([serviceOrder.estimatedArrivalDate length] > 0) {
    
        cell.endDateLabel.text              = [self checkNullString:[NSString stringWithFormat:@"%@",[[GSPDateUtility sharedInstance]convertYYYYMMDDHHMMSStoMMMDDYYYYHHMM:serviceOrder.estimatedArrivalDate]]];
        
        
        
    }
    else {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM dd,yyyy HH:MM"];
        cell.endDateLabel.text              = [self checkNullString:[NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]]];
    }

    cell.serviceLabel.text              = [self checkNullString:serviceOrder.numberExtension];
    cell.notesLabel.text                = [self checkNullString:serviceOrder.serviceNote];
    
    cell.editButton.tag                 = indexPath.row;
    cell.deleteButton.tag               = indexPath.row;
    cell.checkBoxButton.tag             = indexPath.row;
    
    [cell.editButton addTarget:self action:@selector(editButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.checkBoxButton addTarget:self action:@selector(checkBoxButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

   _increNumExt=[serviceOrder.numberExtension integerValue];
    NSLog(@"Incremented service item number %d",_increNumExt);
    
    for(ServiceTask * serviceTask in self.selectedItemsArray)
	{
        
        if ([serviceOrder.serviceOrder  isEqualToString:serviceTask.serviceOrder] &&  [serviceOrder.numberExtension  isEqualToString:serviceTask.numberExtension])
        {
//            [cell.checkBoxButton setBackgroundImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
            [cell.checkBoxButton setBackgroundImage:[UIImage imageNamed:@"Checkmark"] forState:UIControlStateNormal];
        }else{
             [cell.checkBoxButton setBackgroundImage:[UIImage imageNamed:@"Uncheckmark"] forState:UIControlStateNormal];
        }
    }
    
   

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPHONE) {
        GSPConfirmationCreationDetailView_iPhoneViewController *detailVC = [[GSPConfirmationCreationDetailView_iPhoneViewController alloc]initWithNibName:@"GSPConfirmationCreationDetailView_iPhoneViewController" bundle:nil withServiceOrder:[self.dataSourceArray objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (NSString*) checkNullString:(NSString*)objectStr
{
    
    if ([objectStr isEqualToString:@"(null)"] || objectStr.length <= 0)
        
        return @"";
    
    else
        
        return objectStr;
    
}

/*
- (void) setLabelColorsIntableViewCell:(GSPConfirmationCreationCell*)cell
{
    [cell.serviceDescriptionLabel setLabelColor:[UIColor colorWithRed:1.0/255 green:150.0/255 blue:255.0/255 alpha:1.0] withFont:[UIFont systemFontOfSize:14]];
    [cell.durationLabel setLabelColor:[UIColor colorWithRed:1.0/255 green:150.0/255 blue:255.0/255 alpha:1.0] withFont:[UIFont systemFontOfSize:18]];
    [cell.startDateLabel setLabelColor:[UIColor colorWithRed:1.0/255 green:150.0/255 blue:255.0/255 alpha:1.0] withFont:[UIFont systemFontOfSize:18]];
    [cell.endDateLabel setLabelColor:[UIColor colorWithRed:1.0/255 green:150.0/255 blue:255.0/255 alpha:1.0] withFont:[UIFont systemFontOfSize:18]];
    [cell.serviceLabel setLabelColor:[UIColor colorWithRed:1.0/255 green:150.0/255 blue:255.0/255 alpha:1.0] withFont:[UIFont systemFontOfSize:18]];
    [cell.notesLabel setLabelColor:[UIColor colorWithRed:1.0/255 green:150.0/255 blue:255.0/255 alpha:1.0] withFont:[UIFont systemFontOfSize:18]];
    
}
*/

- (void) editButtonClicked:(id)sender
{
    UIButton *editButton = (UIButton*)sender;
    
    GSPConfEditActvityViewController *confEditActivityVC;
    
    if (IS_IPAD) {
        
        confEditActivityVC = [[GSPConfEditActvityViewController alloc]initWithNibName:@"GSPConfEditActvityViewController_iPad" bundle:nil withObject:[self.dataSourceArray objectAtIndex:editButton.tag] numberExtensio:[[self.dataSourceArray objectAtIndex:editButton.tag] numberExtension] andServiceID:[[self.dataSourceArray objectAtIndex:editButton.tag] serviceOrder]];
    }
    else
    {
         confEditActivityVC = [[GSPConfEditActvityViewController alloc]initWithNibName:@"GSPConfEditActvityViewController" bundle:nil withObject:[self.dataSourceArray objectAtIndex:editButton.tag] numberExtensio:[[self.dataSourceArray objectAtIndex:editButton.tag] numberExtension] andServiceID:[[self.dataSourceArray objectAtIndex:editButton.tag] serviceOrder]];
    }
    
    
    [self.navigationController pushViewController:confEditActivityVC animated:YES];
    
}
-(void) checkBoxButtonClicked:(id)sender
{
    UIButton * checkButton = (UIButton*)sender;
    
//    if ([[checkButton backgroundImageForState:UIControlStateNormal] isEqual: [UIImage imageNamed:@"unchecked"]])
    if ([[checkButton backgroundImageForState:UIControlStateNormal] isEqual: [UIImage imageNamed:@"Uncheckmark"]])
    {
        [self setCheckBoxButtonImageChecked:YES forButton:checkButton];
    }
    else
        [self setCheckBoxButtonImageChecked:NO forButton:checkButton];
    
    
}

- (void) setCheckBoxButtonImageChecked:(BOOL)isChecked forButton:(UIButton*)button
{
    if (isChecked) {
        
        [self.selectedItemsArray addObject:[self.dataSourceArray objectAtIndex:button.tag]];
        
//        [button setBackgroundImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"Checkmark"] forState:UIControlStateNormal];
        return;
    }
    
  // added by sahana on Nov 7 , 2016
    ServiceTask *serviceOrder =[self.dataSourceArray objectAtIndex:button.tag];
    NSMutableArray *tobeDeletedArray =[[NSMutableArray alloc]init];
    for(ServiceTask * serviceTask in self.selectedItemsArray)
    {
        
        if ([serviceOrder.serviceOrder  isEqualToString:serviceTask.serviceOrder] &&  [serviceOrder.numberExtension  isEqualToString:serviceTask.numberExtension])
        {
            NSLog(@"MAtch found");
            [tobeDeletedArray addObject:serviceTask];
            NSLog(@"to be deleted array %@",tobeDeletedArray);
            
           
        }
    }
    [self.selectedItemsArray removeObjectsInArray:tobeDeletedArray];

    if ([self.selectedItemsArray containsObject:[self.dataSourceArray objectAtIndex:button.tag]])
    {
        [self.selectedItemsArray removeObject:[self.dataSourceArray objectAtIndex:button.tag]];
    }
    //addition ends here
    
//    [button setBackgroundImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"Uncheckmark"] forState:UIControlStateNormal];
}

- (void) deleteButtonClicked:(id)sender
{
    UIButton * deleteButton = (UIButton*)sender;
    
    itemSelectedToDelete    = deleteButton.tag;
    
    [[GSPUtility sharedInstance] showAlertWithTitle:@"" message:@"Do you really want to delete this item ?" otherButton:@"Cancel" tag:1 andDelegate:self];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 1:
            switch (buttonIndex)
        {
            case 0:
                [self deleteItemFromListAndReloadTable];
                break;
        }
            break;
        case 2:
            switch (buttonIndex)
        {
            case 0:
                [self updateServiceConfirmationInSAP];
                break;
        }
            break;
            
        case 3:
            switch (buttonIndex)
        {
            case 0:
            {
                NSArray * navigationViewControllerArray = [self.navigationController viewControllers];
                
                for (UIViewController *VC in navigationViewControllerArray) {
                    
//    *****   Original code    *****
//                    if ([VC isKindOfClass:[GSPServiceConfirmationViewController class] ]) {
//    Modified by Harshitha
                      if ([VC isKindOfClass:[GSPServiceTasksViewController class] ]) {

                        [self.navigationController popToViewController:VC animated:YES];
                          
                        return;
                    }
                }
            }
                break;
        }
            break;
            
            
        default:
            break;
    }
    
}

- (void) deleteItemFromListAndReloadTable
{
//    [self.dataSourceArray removeObjectAtIndex:itemSelectedToDelete];
//    [self.servicesTabelView reloadData];
    
  //  Added by sahana
    [self getTempDataArrayFromDBandReloadTableView];
    NSLog(@"Source data array %@",[self.dataSourceArray objectAtIndex:itemSelectedToDelete]);
    ServiceTask *serviceOrder = [self.dataSourceArray objectAtIndex:itemSelectedToDelete];
   // NSMutableDictionary *serviceConfirmArray= [self.dataSourceArray objectAtIndex:itemSelectedToDelete];
     NSString *deleteQuery = [NSString stringWithFormat:@"DELETE FROM ZGSXSMST_SRVCACTVTY10_TEMP WHERE NUMBER_EXT = %@",[serviceOrder numberExtension]];
    ServiceConfirmation *serviceDataObj = [ServiceConfirmation new];
    
    if ([serviceDataObj deleteTempServiceConfirmationDataFromDBWithQueryString:deleteQuery])
    {
        ServiceTask *serviceOrder =[self.dataSourceArray objectAtIndex:itemSelectedToDelete ];
        NSMutableArray *tobeDeletedArray =[[NSMutableArray alloc]init];
        for(ServiceTask * serviceTask in self.selectedItemsArray)
        {
            
            if ([serviceOrder.serviceOrder  isEqualToString:serviceTask.serviceOrder] &&  [serviceOrder.numberExtension  isEqualToString:serviceTask.numberExtension])
            {
                NSLog(@"MAtch found");
                [tobeDeletedArray addObject:serviceTask];
                NSLog(@"to be deleted array %@",tobeDeletedArray);
                
                
            }
        }
        [self.selectedItemsArray removeObjectsInArray:tobeDeletedArray];

        if ([self.selectedItemsArray containsObject:[self.dataSourceArray objectAtIndex:itemSelectedToDelete]])
        {
            [self.selectedItemsArray removeObject:[self.dataSourceArray objectAtIndex:itemSelectedToDelete]];
        }

        [self.dataSourceArray removeObjectAtIndex:itemSelectedToDelete];
        

        
        [self.servicesTabelView reloadData];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) segmentControllerSelectionChanged:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    
    switch ([segmentedControl selectedSegmentIndex]) {
        
        case 0:
            //[self showFaultScreen];
            break;
            
        case 1:
            [self showFaultScreen];
            break;
            
        case 2:
            [self showSparesScreen];
            break;
            
        default:
            break;
    }
    
}

- (void) showFaultScreen
{
    
    if (self.selectedItemsArray.count <= 0) {

        [[GSPUtility sharedInstance] showAlertWithTitle:@"" message:@"Please select one checkbox of item from the list." otherButton:nil tag:0 andDelegate:self];
        
        return;
    }
    
    
    ServiceTask * serviceOrder          = [self.selectedItemsArray objectAtIndex:0];
    
    NSString *sqlQryStr                 = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE NUMBER_EXT = %@",@"ZGSXSMST_SRVCCNFRMTNFAULT20",[serviceOrder numberExtension]];
    
    
    NSMutableArray * faultsDataArray    = [serviceDataObj getTempServiceConfirmationDataArrayWithQueryStr:sqlQryStr];
    
    if(faultsDataArray.count <= 0 )
    {
        [self showFaultEditScreen];
    }
    else
    {
        [self showFaultsListScreen];
    }

}

- (void) showFaultEditScreen
{
    ServiceTask * serviceOrder                  = [self.selectedItemsArray objectAtIndex:0];
    
    
    GSPFaultEditScreenViewController *editVC ;
    
    if (IS_IPAD)
    {
        editVC    = [[GSPFaultEditScreenViewController alloc]initWithNibName:@"GSPFaultEditScreenViewController_iPad" bundle:nil withServiceObject:serviceOrder andFaultObject:nil];
    }
    else
    {
         editVC    = [[GSPFaultEditScreenViewController alloc]initWithNibName:@"GSPFaultEditScreenViewController" bundle:nil withServiceObject:serviceOrder andFaultObject:nil];
    }
    
    [self.navigationController pushViewController:editVC animated:YES];

    
}

- (void)showFaultsListScreen
{
    GSPFaultsViewController     * faultsVC;
    
    if (IS_IPAD) {
        faultsVC = [[GSPFaultsViewController alloc]initWithNibName:@"GSPFaultsViewController_iPad" bundle:nil withObject:[self.selectedItemsArray objectAtIndex:0]];
    }
    else
    {
        faultsVC = [[GSPFaultsViewController alloc]initWithNibName:@"GSPFaultsViewController" bundle:nil withObject:[self.selectedItemsArray objectAtIndex:0]];
    }
    
    [self.navigationController pushViewController:faultsVC animated:YES];
}


- (void) showSparesScreen
{
    if (self.selectedItemsArray.count <= 0) {
        
        [[GSPUtility sharedInstance] showAlertWithTitle:@"" message:@"Please select atleast one item from the list." otherButton:nil tag:0 andDelegate:self];
        
        return;
    }
    
    ServiceTask * serviceOrder          = [self.selectedItemsArray objectAtIndex:0];
    
    NSString *sqlQryStr                 = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE NUMBER_EXT = %@  AND OBJECT_ID='%@'",@"ZGSXSMST_SRVCSPARE10_TEMP",[serviceOrder numberExtension],serviceOrder.serviceOrder];
    
    
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
    GSPSparesViewController *sparesListVC  ;
    if (IS_IPAD) {
        sparesListVC            = [[GSPSparesViewController alloc]initWithNibName:@"GSPSparesViewController_iPad" bundle:nil withObject:[self.selectedItemsArray objectAtIndex:0]];
    }
    else
    {
        sparesListVC            = [[GSPSparesViewController alloc]initWithNibName:@"GSPSparesViewController" bundle:nil withObject:[self.selectedItemsArray objectAtIndex:0]];
    }
    
    [self.navigationController pushViewController:sparesListVC animated:YES];
}

- (void) showSparesEditScreen
{
    GSPSparesEditViewController *editVC   ;
    
    if (IS_IPAD) {
        editVC   = [[GSPSparesEditViewController alloc]initWithNibName:@"GSPSparesEditViewController_iPad" bundle:nil WithObjectID:[self.selectedItemsArray objectAtIndex:0] andSpareObject:nil];
    }
    else
    {
        editVC   = [[GSPSparesEditViewController alloc]initWithNibName:@"GSPSparesEditViewController" bundle:nil WithObjectID:[self.selectedItemsArray objectAtIndex:0] andSpareObject:nil];
    }
    
    [self.navigationController pushViewController:editVC animated:YES];
    
}

- (IBAction)toolBarButtonsClicked:(UIButton *)sender
{
    
    if (self.selectedItemsArray.count <= 0 || self.selectedItemsArray.count > 1) {
        
        [[GSPUtility sharedInstance] showAlertWithTitle:@"" message:@"Please select only one item from the list." otherButton:nil tag:0 andDelegate:self];
        
        return;
    }

    
    
    int buttonTag = sender.tag;
    
    switch (buttonTag) {
        case 10:
            break;
        case 11:
            [self showFaultScreen];
            break;
        case 12:
            [self showSparesScreen];
            break;
        case 13:
            [self.doneButton setHidden:NO];
            [[GSPUtility sharedInstance] showAlertWithTitle:@"" message:@"Are you fully Done? once saved can't be edited further." otherButton:@"Cancel" tag:2 andDelegate:self];
            break;
            
        default:
            break;
    }
 
}




- (void)updateServiceConfirmationInSAP
{

// Added on 12th Aug 2015 by Harshitha
    GSPAppDelegate *appDelegateObj = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];
    appDelegateObj.saveChangesFlag = TRUE;
// Added by Harshitha ends here
    
	NSMutableArray *sapRequestArray = [[NSMutableArray alloc] init];


//    NSMutableArray *serviceActivityDataArray =  [serviceDataObj getTempServiceConfirmationDataArrayWithQueryStr:[NSString stringWithFormat:@"SELECT * FROM ZGSXSMST_SRVCCNFRMTNFAULT20 WHERE 1"]];
    
	//***************Fetch All Fault data

	NSMutableArray *faultDataArray =  [serviceDataObj getTempServiceConfirmationDataArrayWithQueryStr:[NSString stringWithFormat:@"SELECT * FROM ZGSXSMST_SRVCCNFRMTNFAULT20 WHERE 1"]];
    
    
    //***************Fetch All Spare data

	NSMutableArray *sparesDataArray =  [serviceDataObj getTempServiceConfirmationDataArrayWithQueryStr:[NSString stringWithFormat:@"SELECT * FROM ZGSXSMST_SRVCSPARE10_TEMP WHERE 1"]];
    
     
//	if([CheckedNetwork connectedToNetwork]) //Checking for net connection...
//	{
        NSString *strPar1 = [NSString stringWithFormat:@"%@", @"DATA-TYPE[.]ZGSXSMST_SRVCCNFRMTN20[.]SRCDOC_OBJECT_ID[.]SRCDOC_PROCESS_TYPE[.]ZZSRVCORDRCMPLT"];
        [sapRequestArray addObject:strPar1];
	
		//Creating Confirmation the parameter of SOAP call to pass SAP...
		NSString *strPar5 = [NSString stringWithFormat:@"ZGSXSMST_SRVCCNFRMTN20[.]%@[.]%@[.]", self.serviceOrder,self.serviceType];
		
		[sapRequestArray addObject:strPar5];

        
		for (ServiceTask * serviceTask in self.dataSourceArray) {
            
            
            NSLog(@"datasource %@", self.dataSourceArray);
            //selvan 04th May, 2015 altered for range expection
            //Existing code
            //NSRange range           = [serviceTask.serviceItem rangeOfString:@" "];
            //NSString *serviceItem   = [serviceTask.serviceItem substringToIndex:range.location];
            //New code
            NSRange range;
            NSString *serviceItem =@"";
            
            if (![serviceTask.serviceItem isEqual: [NSNull null]])
            {
                range = [serviceTask.serviceItem rangeOfString:@" "];
                serviceItem = [serviceTask.serviceItem substringToIndex:range.location];
            }
            
            
            
			//Creating Activity the parameter of SOAP call to pass SAP...
/*			NSString *strActivityData = [NSString stringWithFormat:@"ZGSXSMST_SRVCCNFRMTNACTVTY20[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@",
                                         serviceTask.numberExtension,serviceTask.numberExtension,serviceItem,serviceTask.duration,@"",serviceTask.serviceItem,serviceTask.serviceNote,
                                         [[GSPDateUtility sharedInstance] convertMMMDDformattoyyyMMdd:serviceTask.startDate ],
                                         [[GSPDateUtility sharedInstance] convertMMMDDformattoyyyMMdd:serviceTask.estimatedArrivalDate],
                                         [[GSPDateUtility sharedInstance] getTimeFromString: serviceTask.startDate],
                                         [[GSPDateUtility sharedInstance] getTimeFromString: serviceTask.estimatedArrivalTime],
                                         @"-18000000" ];
*/
            
            NSString *strPar2 = [NSString stringWithFormat:@"%@", @"DATA-TYPE[.]ZGSXSMST_SRVCCNFRMTNACTVTY20[.]SRCDOC_NUMBER_EXT[.]NUMBER_EXT[.]PRODUCT_ID[.]QUANTITY[.]PROCESS_QTY_UNIT[.]ZZITEM_DESCRIPTION[.]ZZITEM_TEXT[.]DATE_FROM[.]DATE_TO[.]TIME_FROM[.]TIME_TO[.]TIMEZONE_FROM"];
            [sapRequestArray addObject:strPar2];
            
            NSString *strActivityData = [NSString stringWithFormat:@"ZGSXSMST_SRVCCNFRMTNACTVTY20[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@",
                                        serviceTask.numberExtension,serviceTask.numberExtension,serviceItem,serviceTask.duration,@"",serviceTask.serviceItem,serviceTask.serviceNote,
                                         [[GSPDateUtility sharedInstance] getDateFromString: serviceTask.startDateAndTime],
                                        [[GSPDateUtility sharedInstance] getDateFromString: serviceTask.estimatedArrivalDate],
                                        [[GSPDateUtility sharedInstance] getTimeFromString: serviceTask.startDateAndTime],
                                        [[GSPDateUtility sharedInstance] getTimeFromString: serviceTask.estimatedArrivalDate],
                                        @"-18000000" ];
        
            
			[sapRequestArray addObject:strActivityData];
		}
        
        NSString *strPar3 = [NSString stringWithFormat:@"%@", @"DATA-TYPE[.]ZGSXSMST_SRVCCNFRMTNFAULT20[.]NUMBER_EXT[.]ZZSYMPTMCODEGROUP[.]ZZSYMPTMCODE[.]ZZSYMPTMTEXT[.]ZZPRBLMCODEGROUP[.]ZZPRBLMCODE[.]ZZPRBLMTEXT[.]ZZCAUSECODEGROUP[.]ZZCAUSECODE[.]ZZCAUSETEXT"];
        [sapRequestArray addObject:strPar3];
        
			for (NSDictionary * faultDict in faultDataArray) {
				//Creating Fault the parameter of SOAP call to pass SAP...
				
				NSString *strFaultData = [NSString stringWithFormat:@"ZGSXSMST_SRVCCNFRMTNFAULT20[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@",
										  [faultDict objectForKey:@"NUMBER_EXT"],
										  [faultDict objectForKey:@"ZZSYMPTMCODEGROUP"],
										  [faultDict objectForKey:@"ZZSYMPTMCODE"],
										  [faultDict objectForKey:@"ZZSYMPTMTEXT"],
										  [faultDict objectForKey:@"ZZPRBLMCODEGROUP"],
										  [faultDict objectForKey:@"ZZPRBLMCODE"],
										  [faultDict objectForKey:@"ZZPRBLMTEXT"],
										  [faultDict objectForKey:@"ZZCAUSECODEGROUP"],
										  [faultDict objectForKey:@"ZZCAUSECODE"],
										  [faultDict objectForKey:@"ZZCAUSETEXT"]
										  ];
				
				[sapRequestArray addObject:strFaultData];
				
			}

		NSString *strPar4 = [NSString stringWithFormat:@"%@", @"DATA-TYPE[.]ZGSXSMST_SRVCCNFRMTNMTRL20[.]NUMBER_EXT[.]PRODUCT_ID[.]QUANTITY[.]PROCESS_QTY_UNIT[.]ZZITEM_DESCRIPTION[.]ZZITEM_TEXT[.]SERIAL_NUMBER"];
        [sapRequestArray addObject:strPar4];
        
        for (NSDictionary * spareDict in sparesDataArray) {
            
            //int msrcdoc_number_ext = 1000 + [[[objServiceManagementData.serviceOrderSpareTempArray objectAtIndex:0] objectForKey:@"ZGSCSMST_SRVCSPARE10Id"] intValue];
            
            //Creating Spares the parameter of SOAP call to pass SAP...
            
// Original code
/*            NSString *strSparesData = [NSString stringWithFormat:@"ZGSXSMST_SRVCCNFRMTNMTRL20[.]%@[.]%d[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@",
                                       [spareDict objectForKey:@"NUMBER_EXT"],
                                       1100,
                                       [spareDict objectForKey:@"PRODUCT_ID"],
                                       [spareDict objectForKey:@"QUANTITY"],
                                       [spareDict objectForKey:@"PROCESS_QTY_UNIT"],
                                       [spareDict objectForKey:@"ZZITEM_DESCRIPTION"],
                                       [spareDict objectForKey:@"ZZITEM_TEXT"],
                                       [spareDict objectForKey:@"SERIAL_NUMBER"]
                                       ];
*/
// Modified by Harshitha
            NSString *strSparesData = [NSString stringWithFormat:@"ZGSXSMST_SRVCCNFRMTNMTRL20[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@[.]%@",
                                       [spareDict objectForKey:@"NUMBER_EXT"],
                                       [spareDict objectForKey:@"PRODUCT_ID"],
                                       [spareDict objectForKey:@"QUANTITY"],
                                       [spareDict objectForKey:@"PROCESS_QTY_UNIT"],
                                       [spareDict objectForKey:@"ZZITEM_DESCRIPTION"],
                                       [spareDict objectForKey:@"ZZITEM_TEXT"],
                                       [spareDict objectForKey:@"SERIAL_NUMBER"]
                                       ];
            
			[sapRequestArray addObject:strSparesData];
            
            NSLog(@"spares %@",strSparesData);
            
		}
        
        
        //Attach image as a document
        
        NSMutableArray *imagesArray = [[GSPUtility sharedInstance] getAttachedImagesFromLocalFolder:self.serviceOrder forPathComponent:@"ConfirmationAttchedImages"];
        
        if (imagesArray.count > 0)
        {
            for (NSString *imagesFilePath in imagesArray)
            {
                NSString    *folderPath     = [[GSPUtility sharedInstance] getMediaLocalPathForFileName:self.serviceOrder forPathComponent:@"ConfirmationAttchedImages"];
                
                NSData      *imageData      = [UIImagePNGRepresentation([UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",folderPath,imagesFilePath]]) base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
                
                NSString    *base64ImgString= [imageData base64Encoding];
        
                NSString *strDocumentData = [NSString stringWithFormat:@"ZGSXCAST_ATTCHMNT01[.]%@[.][.]%@[.]%@",self.serviceOrder,folderPath,base64ImgString];

                [sapRequestArray addObject:strDocumentData];
            
        }
          
        }
        
        //Attach signature image as a document
        
        NSString *signatureFilePath       = [[GSPUtility sharedInstance] getSignatureFolderPathForFileName:self.serviceOrder forPathComponent:@"ConfirmationAttachedSignatures"];
        
        UIImage * signatureImage          = [UIImage imageWithContentsOfFile:signatureFilePath];
        
        if (signatureImage)
        {
            
            NSData      * imageData         = [UIImagePNGRepresentation(signatureImage) base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
            NSString    * base64ImgString   = [imageData base64Encoding];
            
            NSString *strDocumentData = [NSString stringWithFormat:@"ZGSXCAST_ATTCHMNT01[.]%@[.][.]%@[.]%@",self.serviceOrder,signatureFilePath,base64ImgString];
 
            [sapRequestArray addObject:strDocumentData];
            
        }
        
        [serviceDataObj updateServiceConfirmationInSAPServerWithInputArray:sapRequestArray andReferenceID:[[self.dataSourceArray objectAtIndex:0]serviceOrder]];
    GSPAppDelegate *appDelegateObj1 = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];
    if (![CheckedNetwork connectedToNetwork] && appDelegateObj1.updateFailureFlag) {
        
        [[GSPUtility sharedInstance] showAlertWithTitle:@"No Network Connection!" message:@"Please connect to internet to update" otherButton:nil tag:0 andDelegate:self];
        
    }
    else if(![CheckedNetwork connectedToNetwork] && !appDelegateObj1.updateFailureFlag) {
        
      //  [serviceOrderObject updateServiceOrder:_soUpdateQry];
        [[GSPUtility sharedInstance] showAlertWithTitle:@"No Network Connection" message:@"The process added to queue." otherButton:nil tag:0 andDelegate:self];
    }


        return;
	
//    }
    [[GSPUtility sharedInstance] showAlertWithTitle:@"" message:@"No network" otherButton:nil tag:0 andDelegate:self];
}


- (void)updateConfirmationResponseHandler:(NSNotification*)notification
{
    NSDictionary* userInfo          = notification.userInfo;
    NSString        * message       = [userInfo objectForKey:@"responseMsg"];
    NSMutableArray  * reponseArray  = [userInfo objectForKey:@"FLD_VC"];
    
    NSString * statusMessage;
    
    statusMessage = @"Please wait while processing...";
    
    if ([message isEqualToString:@"Loading Activity Indicator"])
    {
//        [SVProgressHUD showWithStatus:statusMessage];
        [SVProgressHUD showWithStatus:nil];
    }
    else if ([message isEqualToString:@"SAP Response Message"] )
    {
        
        NSLog(@"RESPONSE ARRAY :%@",reponseArray);
        [SVProgressHUD dismiss];
        if (reponseArray.count > 3)
        {
            NSString * message = [[reponseArray objectAtIndex:0] objectAtIndex:0];
            
            if ([message isEqualToString:@"E"] || [message isEqualToString:@"X"] || [message isEqualToString:@"S"] || [message isEqualToString:@"A"])
            {
                
                
                [[GSPUtility sharedInstance]showAlertWithTitle:@"" message:[[reponseArray objectAtIndex:3] objectAtIndex:0] otherButton:@"Cancel" tag:0 andDelegate:self];
            }
 
        }
        
    }
    else
    {
        [SVProgressHUD dismiss];
    }
    
}


#pragma mark Menu Button action and related methods

- (void)menuButtonClick:(id)sender
{
//    UIActionSheet* menuActionSheet = [[UIActionSheet alloc]
//                                      initWithTitle:NSLocalizedString(@"CHOOSE_ACTION", nil)
//                                      delegate:self
//                                      cancelButtonTitle:NSLocalizedString(@"CANCEL", nil)
//                                      destructiveButtonTitle:nil
//                                      otherButtonTitles:NSLocalizedString(@"ADD_NEW_SERVICE", nil),NSLocalizedString(@"CAPTURE_SIGNATURE", nil),NSLocalizedString(@"CAPTURE_IMAGE", nil),nil];
    UIActionSheet* menuActionSheet = [[UIActionSheet alloc]
                                      initWithTitle:NSLocalizedString(@"CHOOSE_ACTION", nil)
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"CANCEL", nil)
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:NSLocalizedString(@"ADD_NEW_SERVICE", nil),nil];

    menuActionSheet.tag             = MENU_ACTION_SHEET_TAG;
    [menuActionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet.tag == MENU_ACTION_SHEET_TAG)
    {
        [self menuActionSheetActionWithIndex:buttonIndex];
    }
    else if (actionSheet.tag == IMAGEPICKER_ACION_SHEET_TAG)
    {
        [self ImagePickerActionSheetActionWithIndex:buttonIndex];
    }
    
}

- (void) menuActionSheetActionWithIndex:(int)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            GSPConfEditActvityViewController * confEditActivityVC;
            
            if (IS_IPAD) {
                
                confEditActivityVC = [[GSPConfEditActvityViewController alloc]initWithNibName:@"GSPConfEditActvityViewController_iPad" bundle:nil withObject:nil numberExtensio:[[self.dataSourceArray objectAtIndex:0] numberExtension] andServiceID:[[self.dataSourceArray objectAtIndex:0] serviceOrder]];
                confEditActivityVC.serviceOrderIncerementd=_increNumExt;
            }
            else
            {
                confEditActivityVC = [[GSPConfEditActvityViewController alloc]initWithNibName:@"GSPConfEditActvityViewController" bundle:nil withObject:nil numberExtensio:[[self.dataSourceArray objectAtIndex:0] numberExtension] andServiceID:[[self.dataSourceArray objectAtIndex:0] serviceOrder]];
            }
            
            
            [self.navigationController pushViewController:confEditActivityVC animated:YES];
        }
            break;
/*        case 1:
            [self captureSignatureAction];
            break;
        case 2:
            [self captureImageAction];
            break;
*/            
        default:
            break;
    }
    
}

- (void) ImagePickerActionSheetActionWithIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [self imagePickerActionWithOption:CAMERA_SELECTED];
            break;
        case 1:
            [self imagePickerActionWithOption:GALLERY_SELECTED];
            break;
            
        default:
            break;
    }
    
}

- (void)captureImageAction
{
    UIActionSheet* menuActionSheet = [[UIActionSheet alloc]
                                      initWithTitle:NSLocalizedString(@"CHOOSE_ACTION", nil)
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"CANCEL", nil)
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"Camera",@"Photo Gallery",nil];
    menuActionSheet.tag           = IMAGEPICKER_ACION_SHEET_TAG;
    [menuActionSheet showInView:self.view];
    
}

#pragma mark Signature Capture Methods
- (void) captureSignatureAction
{
    
    NSArray *subviewArray   = [[NSBundle mainBundle] loadNibNamed:@"GSPSignatureCaptureView" owner:self options:nil];
    
    signatureView           = [subviewArray objectAtIndex:0];
    
    signatureView.frame     = CGRectMake(self.view.bounds.size.width/2 - signatureView.frame.size.width/2, self.view.bounds.size.height - (signatureView.frame.size.height ), signatureView.frame.size.width, signatureView.frame.size.height);
    
    [self.view addSubview:signatureView];
    
    [self.view bringSubviewToFront:signatureView];
}

- (IBAction)saveSignature:(id)sender
{
    NSData *imageData                   = [NSData dataWithData:UIImagePNGRepresentation(signatureView.drawImage.image)];
    
    NSString * signatureFolderPath      = [[GSPUtility sharedInstance] getSignatureFolderPathForFileName:self.serviceOrder forPathComponent:@"ConfirmationAttachedSignatures"];
    
    [imageData writeToFile:signatureFolderPath atomically:YES];
    
    
    [self cancelSignature:sender];
    
    [[GSPUtility sharedInstance] showAlertWithTitle:@"" message:@"Signature successfully saved " otherButton:nil tag:0 andDelegate:self];
    
}

- (IBAction)cancelSignature:(id)sender
{
    [signatureView removeFromSuperview];
}

#pragma mark image Picker methods

- (void) imagePickerActionWithOption:(int)selectedOption
{
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    
    if(selectedOption == GALLERY_SELECTED)
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

-(void) saveImage:(UIImage*)image
{
    
    NSData *imageData                   = UIImagePNGRepresentation(image);
    
    NSString *tmpImgName                = [NSString stringWithFormat:@"%@_%@_img.png",self.serviceOrder,[NSDate date]];
    
    NSString * localFolderPathStr       = [[GSPUtility sharedInstance] getMediaLocalPathForFileName:self.serviceOrder forPathComponent:@"ConfirmationAttchedImages"];
    
    NSString * imagePath                = [localFolderPathStr stringByAppendingPathComponent:tmpImgName];
    
    [imageData writeToFile:imagePath atomically:YES];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSURL *mediaUrl;
    
    UIImage *image;
    
    mediaUrl = (NSURL *)[info valueForKey:UIImagePickerControllerMediaURL];
    
    
    if (mediaUrl == nil)
    {
        image = (UIImage *) [info valueForKey:UIImagePickerControllerEditedImage];
        
        if (image == nil)
        {
            image = (UIImage *) [info valueForKey:UIImagePickerControllerOriginalImage];
            CGSize objCGSize = CGSizeMake(100, 100);
            image = [self scaledImageForImage:image newSize:objCGSize];
            [self saveImage:image];
            
        }
        else
        {
            [self saveImage:image];
        }
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

-(UIImage *)scaledImageForImage:(UIImage*)mimage newSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [mimage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
