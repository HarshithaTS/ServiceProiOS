//
//  GSPColleguesViewController.m
//  GssServicePro
//
//  Created by Riyas Hassan on 05/08/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPColleguesViewController.h"
#import "Colleagues.h"
#import "GSPServiceTasksViewController.h"
#import "GSPCommonTableView.h"
#import "GSPUtility.h"
#import "ServiceOrderClass.h"
#import "GSPAppDelegate.h"
#import "GSPOfflineViewConfiguration.h"


@interface GSPColleguesViewController ()
{
    Colleagues * colleaguesObj;
    BOOL isSearching;
    
}

@property (nonatomic, strong) ServiceTask *taskToTransfer;

@property (nonatomic, strong) NSMutableArray * dataSourceArray, *searchArray, *colleageNamesArray;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet GSPCommonTableView *colleaguesTableView;

@property (strong, nonatomic) Colleagues * selectedColleague;

@property (strong, nonatomic) NSString * selectedColleagueName;

@end

@implementation GSPColleguesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
//        self.title = @"Tasks for which Rep ?";
        [self setNavigationTitleWithBrandImage:@"Tasks for which Rep ?"];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forTaskTasnfer:(ServiceTask*)serviceOrder
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
//        self.title = @"Tasks for which Rep ?";
        [self setNavigationTitleWithBrandImage:@"Tasks for which Rep ?"];
        
        self.taskToTransfer =   serviceOrder;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[GSPOfflineViewConfiguration sharedInstance] checkReachabilityAndCofigureView:self];

    
    [self setUpView];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

//    [self setUpView];
    
//    [[GSPOfflineViewConfiguration sharedInstance] checkReachabilityAndCofigureView:self];

    
    [self initializeVariables];
    
    [self getColleguesList];
}

- (void) initializeVariables
{
    self.dataSourceArray    = [[NSMutableArray alloc]init];
    
    self.searchArray        = [NSMutableArray new];
    
    self.colleageNamesArray    = [[NSMutableArray alloc]init];
    
    colleaguesObj           = [Colleagues new];
}

-(void) setUpView
{
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandler:) name:@"FetchingServiceTasksForColleagues" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SAPResponseHandlerForTransferServiceTask:) name:@"TransferTasksForColleagues" object:nil];
    
}

//     *****   Added by Harshitha   *****
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//    *****   Added by Harshitha ends   *****

- (void) getColleguesList
{
    
    self.dataSourceArray        = [colleaguesObj getColleguesList];
}

#pragma mark TableView Delegates and datasources

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (isSearching)
        return self.searchArray.count;
    else
        return [self.dataSourceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
    
    cell.backgroundColor = [UIColor clearColor];
    
    Colleagues *colleague;
    
    if (isSearching)
    {
        colleague    = [self.searchArray objectAtIndex:indexPath.row];
    }
    else
    {
        colleague    = [self.dataSourceArray objectAtIndex:indexPath.row];
    }

    
    NSString * name = @"";
    
    if (colleague.nameOne.length > 0)
    {
        name = colleague.nameOne;
    }
    if (colleague.nameTwo.length > 0)
    {
        name = [name stringByAppendingString:[NSString stringWithFormat:@" %@", colleague.nameTwo]];
    }
    
    cell.textLabel.text       = name;
    
    [self.colleageNamesArray addObject:name];
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (isSearching)
    {
        self.selectedColleague           = [self.searchArray objectAtIndex:indexPath.row];
        
        NSString *name = @"";
        if (self.selectedColleague.nameOne.length > 0)
        {
            name = self.selectedColleague.nameOne;
        }
        if (self.selectedColleague.nameTwo.length > 0)
        {
            name = [name stringByAppendingString:[NSString stringWithFormat:@" %@", self.selectedColleague.nameTwo]];
        }
        
        self.selectedColleagueName = name;
    }
    else
    {
        self.selectedColleague           = [self.dataSourceArray objectAtIndex:indexPath.row];
        self.selectedColleagueName = [self.colleageNamesArray objectAtIndex:indexPath.row];
    }
    
    if (self.taskToTransfer)
    {
        [self transferTaskToRep:self.selectedColleague ];
    }
    else
    {
       [self getColleagueTaskListFromSAPForPartner:self.selectedColleague .uName];
    }
    
    
}

#pragma mark - Collegues task List generating methods


-(void) getColleagueTaskListFromSAPForPartner:(NSString*)partnerUName
{
    Colleagues *colleagueObj = [Colleagues new];
    
    //NSString *responseValue;
    [colleagueObj deleteColleguesTaskTableContents];
    
    //Sending Request to SAP for Getting Colleague List
// ***** Original code *****
//    [colleaguesObj downloadColleguesTaskListFromSAP:[NSMutableArray arrayWithObjects:partnerUName, nil]];

// ***** Modified by Harshitha *****
    partnerUName = [[@"SWDTUSER" stringByAppendingString:@"[.]"]stringByAppendingString:partnerUName];
    [colleagueObj downloadColleguesTaskListFromSAP:[NSMutableArray arrayWithObjects:partnerUName, nil]];

    
}

- (void)SAPResponseHandler:(NSNotification*)notification
{
    NSDictionary* userInfo  = notification.userInfo;
    // NSString *action        = [userInfo objectForKey:@"action"];
    NSString *message       = [userInfo objectForKey:@"responseMsg"];
    
    if ([message isEqualToString:@"Loading Activity Indicator"])
    {
//        [SVProgressHUD showWithStatus:NSLocalizedString(@"FETCH_COLLEAGUES_TASK", nil)];
        [SVProgressHUD showWithStatus:nil];

    }
    else if ([message isEqualToString:@"Stop Loading Activity Indicator"] )
    {
        
        [self showColleaguesServiceTasksView];
        [SVProgressHUD dismiss];
    }
    
    else
    {
        [SVProgressHUD dismiss];
    }
}


- (void) showColleaguesServiceTasksView
{
    // Added on 12th Aug 2015 by Selvan
    GSPAppDelegate *appDelegateObj = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];
    appDelegateObj.saveChangesFlag = TRUE;
    // Added by Selvan ends here
    
    GSPServiceTasksViewController *serviceTasksVC;
    
    if (IS_IPAD)
    {
//        serviceTasksVC  = [[GSPServiceTasksViewController alloc]initWithNibName:@"GSPServiceTasksViewController_iPad" bundle:nil forView:colleguesServiceTaskView withTitle:self.selectedColleagueName anduName:self.selectedColleague.uName];
        serviceTasksVC  = [[GSPServiceTasksViewController alloc]initWithNibName:@"GSPServiceTasksViewController_iPad" bundle:nil forView:colleguesServiceTaskView withTitle:self.selectedColleagueName andSelectedColleague:self.selectedColleague transferTask:self.taskToTransfer];
    }
    else
    {
//        serviceTasksVC  = [[GSPServiceTasksViewController alloc]initWithNibName:@"GSPServiceTasksViewController" bundle:nil forView:colleguesServiceTaskView withTitle:self.selectedColleagueName anduName:self.selectedColleague.uName];
        serviceTasksVC  = [[GSPServiceTasksViewController alloc]initWithNibName:@"GSPServiceTasksViewController" bundle:nil forView:colleguesServiceTaskView withTitle:self.selectedColleagueName andSelectedColleague:self.selectedColleague transferTask:self.taskToTransfer];
    }
    
    [self.navigationController pushViewController:serviceTasksVC animated:YES];
}



#pragma mark -  Transfer Task to other Colleagues


- (void) transferTaskToRep:(Colleagues*)colleague
{
    
    NSString * alertMesssage = [NSString stringWithFormat:@"Are you sure you want to transfer task to %@ %@",colleague.nameOne,colleague.nameTwo];
    
    [[GSPUtility sharedInstance] showAlertWithTitle:@"Colleagues Transfer Alert" message:alertMesssage otherButton:@"Cancel" tag:1 andDelegate:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag != 0)
    {
        switch (buttonIndex)
        {
            case 0:
                [self transferColleagueTaskListServiceCall:self.selectedColleague];
                break;
                
            default:
                break;
        }
        
    }
    
}


-(void) transferColleagueTaskListServiceCall:(Colleagues*)colleague
{
    // Added on 12th Aug 2015 by Selvan
    GSPAppDelegate *appDelegateObj = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];
    appDelegateObj.saveChangesFlag = TRUE;
    // Added by Selvan ends here
    
    NSString *strMetaData = [NSString stringWithFormat:@"DATA-TYPE[.]ZGSXSMST_SRVCDCMNTTRNSFR20[.]OBJECT_ID[.]PROCESS_TYPE[.]NUMBER_EXT[.]SERVICE_EMPLOYEE"];
    
    NSString *strPar5 = [NSString stringWithFormat:@"ZGSXSMST_SRVCDCMNTTRNSFR20[.]%@[.]%@[.]%@[.]%@",self.taskToTransfer.serviceOrder,self.taskToTransfer.serviceOrderType,self.taskToTransfer.firstServiceItem,colleague.partner];
    

    [colleaguesObj transferColleaguesTaskServiceCall:[NSMutableArray arrayWithObjects:strMetaData,strPar5, nil]];
    
}

- (void)SAPResponseHandlerForTransferServiceTask:(NSNotification*)notification
{
    NSDictionary* userInfo          = notification.userInfo;
    NSString        * message       = [userInfo objectForKey:@"responseMsg"];
    NSMutableArray  * reponseArray  = [userInfo objectForKey:@"FLD_VC"];
    
    NSString * statusMessage;
    
    if ([notification.name isEqualToString:@"TransferTasksForColleagues"]) {
        
        statusMessage = @"Please wait while transfering task...";
    }
    
    if ([message isEqualToString:@"Loading Activity Indicator"])
    {
//        [SVProgressHUD showWithStatus:statusMessage];
        [SVProgressHUD showWithStatus:nil];
    }
    else if ([message isEqualToString:@"SAP Response Message"] && [notification.name isEqualToString:@"TransferTasksForColleagues"])
    {
        
        NSLog(@"RESPONSE ARRAY :%@",reponseArray);
        [SVProgressHUD dismiss];
        if (reponseArray.count > 3)
        {
            NSString * message = [[reponseArray objectAtIndex:0] objectAtIndex:0];
            
            if ([message isEqualToString:@"E"])
            {
                [[GSPUtility sharedInstance]showAlertWithTitle:@"" message:[[reponseArray objectAtIndex:3] objectAtIndex:0] otherButton:nil tag:0 andDelegate:self];
            }
            else  if ([message isEqualToString:@"S"])
            {
//  Original code....Commented by Harshitha to avoid explicit deletion of servicetask
//                ServiceOrderClass *serviceOrderObject = [ServiceOrderClass new];
//                [serviceOrderObject deleteServiceOrder:self.taskToTransfer.serviceOrder andFirstServiceItem:self.taskToTransfer.firstServiceItem];
                [[GSPUtility sharedInstance]showAlertWithTitle:@"" message:[[reponseArray objectAtIndex:3] objectAtIndex:0] otherButton:nil tag:0 andDelegate:self];
            }
  
        }
        
    }
    else
    {
        [SVProgressHUD dismiss];
    }

}


#pragma mark Search methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    isSearching = NO;
    if ([searchText isEqualToString:@""]) {
        [self.colleaguesTableView reloadData];
        return;
    }
    
    [self searchTableView];
    
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
	
	if([theSearchBar.text isEqualToString:self.searchBar.text])
		[theSearchBar resignFirstResponder];
	else
		[self searchTableView];
}

- (void) searchTableView {
	
	self.searchArray = [NSMutableArray new];
	isSearching = YES;
    NSString *searchText = self.searchBar.text;
    
	for (Colleagues *colleague in self.dataSourceArray)
    {
        if ([[colleague.nameOne stringByAppendingString:colleague.nameTwo] rangeOfString:searchText options:NSCaseInsensitiveSearch ].location != NSNotFound) {

            [self.searchArray addObject:colleague];
        }
    }
    
	[self.colleaguesTableView reloadData];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
