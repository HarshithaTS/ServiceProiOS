//
//  GSPFaultEditScreenViewController.m
//  GssServicePro
//
//  Created by Riyas Hassan on 07/10/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPFaultEditScreenViewController.h"
#import "GSPPickerController.h"
#import "ServiceConfirmation.h"
#import "GSPFaultsViewController.h"
#import "GSPOfflineViewConfiguration.h"


@interface GSPFaultEditScreenViewController ()
{
    
    GSPPickerController *  pickerController;
    BOOL isEditing;
}

@property (nonatomic,strong) NSMutableArray * symptomGroupArray, * symptomCodeArray, *problemGroupArray, *problemCodeArray, *causeGroupArray, *causeCodeArray;

@property (nonatomic, strong) NSMutableDictionary *faultDataDictionary;

@property (nonatomic,strong) ServiceTask *serviceOrder;

@property (weak, nonatomic) IBOutlet UIButton *symptomCodeButton;
@property (weak, nonatomic) IBOutlet UITextView *symptomDescTextView;
@property (weak, nonatomic) IBOutlet UIButton *symptonGroupButton;
@property (weak, nonatomic) IBOutlet UIButton *problemGroupButton;
@property (weak, nonatomic) IBOutlet UIButton *problemCodeButton;
@property (weak, nonatomic) IBOutlet UITextView *problemDescTextView;
@property (weak, nonatomic) IBOutlet UIButton *causeGropuButton;
@property (weak, nonatomic) IBOutlet UIButton *causeCodeButton;
@property (weak, nonatomic) IBOutlet UITextView *causeDescTextView;

- (IBAction)dropDownButtonsClicked:(id)sender;

- (IBAction) saveButtonClick :(id)sender;

@end

@implementation GSPFaultEditScreenViewController

@synthesize tableName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withServiceObject:(ServiceTask*)serviceTask andFaultObject:(NSMutableDictionary*)faultObj
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.serviceOrder           = serviceTask;
        self.faultDataDictionary    = faultObj;
//        self.title                  = @"Faults";
        [self setNavigationTitleWithBrandImage:@"Faults"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpView];
    
//    [[GSPOfflineViewConfiguration sharedInstance] checkReachabilityAndCofigureView:self];

    
    [self initializeVariables];
}

- (void) initializeVariables
{
    
    ServiceConfirmation *serviceDataObj = [ServiceConfirmation new];
    
    objServiceMngtCls = [[GssMobileConsoleiOS alloc]init];

// Original code
//    NSString *queryString               = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",@"ZGSXSMST_SYMPTMCODEGROUPLIST10"];
    
//  Modified by Harshitha
    tableName = [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXSMST_SYMPTMCODEGROUPLIST10"];
    NSString *queryString               = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",tableName];
    
    self.symptomGroupArray              = [serviceDataObj getFaultsOptionArraysWithQuery:queryString];
    
//  Original code
//    queryString                         = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",@"ZGSXSMST_SYMPTMCODELIST10"];
    
//  Modified by Harshitha
    tableName = [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXSMST_SYMPTMCODELIST10"];
    queryString                         = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",tableName];

    self.symptomCodeArray               = [serviceDataObj getFaultsOptionArraysWithQuery:queryString];
    
// Original code
//    queryString                         = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",@"ZGSXSMST_PRBLMCODEGROUPLIST10"];
    
//  Modified by Harshitha
    tableName = [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXSMST_PRBLMCODEGROUPLIST10"];
    queryString                         = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",tableName];

    self.problemGroupArray              = [serviceDataObj getFaultsOptionArraysWithQuery:queryString];

//  Original code
//    queryString                         = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",@"ZGSXSMST_PRBLMCODELIST10"];
    
//  Modified by Harshitha
    tableName = [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXSMST_PRBLMCODELIST10"];
    queryString                         = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",tableName];

    self.problemCodeArray               = [serviceDataObj getFaultsOptionArraysWithQuery:queryString];

// Original codes
//    queryString                         = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",@"ZGSXSMST_CAUSECODEGROUPLIST10"];
    
//  Modified by Harshitha
    tableName = [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXSMST_CAUSECODEGROUPLIST10"];
    queryString                         = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",tableName];

    self.causeGroupArray                = [serviceDataObj getFaultsOptionArraysWithQuery:queryString];

//  Original code
//    queryString                         = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",@"ZGSXSMST_CAUSECODELIST10"];
    
//  Modified by Harshitha
    tableName = [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXSMST_CAUSECODELIST10"];
    queryString                         = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE 1",tableName];
    
    self.causeCodeArray                 = [serviceDataObj getFaultsOptionArraysWithQuery:queryString];
    
    if (!self.faultDataDictionary)
    {
        self.faultDataDictionary        = [NSMutableDictionary new];
        
        [self.symptonGroupButton setTitle:[self.symptomGroupArray objectAtIndex:0] forState:UIControlStateNormal];
        
        [self.symptomCodeButton setTitle:[self.symptomCodeArray objectAtIndex:0] forState:UIControlStateNormal];
        
        [self.problemGroupButton setTitle:[self.problemGroupArray objectAtIndex:0] forState:UIControlStateNormal];
        [self.problemCodeButton setTitle:[self.problemCodeArray objectAtIndex:0] forState:UIControlStateNormal];
        
        [self.causeGropuButton setTitle:[self.causeGroupArray objectAtIndex:0] forState:UIControlStateNormal];
        [self.causeCodeButton setTitle:[self.causeCodeArray objectAtIndex:0] forState:UIControlStateNormal];
        
        [self.faultDataDictionary setValue:[self.symptomGroupArray objectAtIndex:0] forKey:@"ZZSYMPTMCODEGROUP"];
        [self.faultDataDictionary setValue:[self.symptomCodeArray objectAtIndex:0] forKey:@"ZZSYMPTMCODE"];
        [self.faultDataDictionary setValue:[self.problemGroupArray objectAtIndex:0] forKey:@"ZZPRBLMCODEGROUP"];
        [self.faultDataDictionary setValue:[self.problemCodeArray objectAtIndex:0] forKey:@"ZZPRBLMCODE"];
        [self.faultDataDictionary setValue:[self.causeGroupArray objectAtIndex:0] forKey:@"ZZCAUSECODEGROUP"];
        [self.faultDataDictionary setValue:[self.causeCodeArray objectAtIndex:0] forKey:@"ZZCAUSECODE"];
        
    }
    else
    {
        isEditing = YES;
        [self.symptonGroupButton setTitle:[self.faultDataDictionary objectForKey:@"ZZSYMPTMCODEGROUP"] forState:UIControlStateNormal];
        [self.symptomCodeButton setTitle:[self.faultDataDictionary objectForKey:@"ZZSYMPTMCODE"] forState:UIControlStateNormal];
        
        [self.problemGroupButton setTitle:[self.faultDataDictionary objectForKey:@"ZZPRBLMCODEGROUP"] forState:UIControlStateNormal];
        [self.problemCodeButton setTitle:[self.faultDataDictionary objectForKey:@"ZZPRBLMCODE"] forState:UIControlStateNormal];
        
        [self.causeGropuButton setTitle:[self.faultDataDictionary objectForKey:@"ZZCAUSECODEGROUP"] forState:UIControlStateNormal];
        [self.causeCodeButton setTitle:[self.faultDataDictionary objectForKey:@"ZZCAUSECODE"] forState:UIControlStateNormal];
    }
 
    
}

- (void ) setUpView
{
//    [self setRightNavigationBarButtonItemsWithMenu:NO andOtherBarButtonWithImageNamed:@"Save.png" andSelector:@selector(saveButtonClick:)];
    [self setRightNavigationBarButtonItemsWithMenu:NO andOtherBarButtonWithImageNamed:@"SaveIcon.png" andSelector:@selector(saveButtonClick:)];
    
    self.symptomDescTextView.layer.cornerRadius   = 3.0;
    self.symptomDescTextView.layer.borderColor    = [[UIColor lightGrayColor]CGColor];
    self.symptomDescTextView.layer.borderWidth    = 1.0f;
    
    self.problemDescTextView.layer.cornerRadius   = 3.0;
    self.problemDescTextView.layer.borderColor    = [[UIColor lightGrayColor]CGColor];
    self.problemDescTextView.layer.borderWidth    = 1.0f;
    
    self.causeDescTextView.layer.cornerRadius   = 3.0;
    self.causeDescTextView.layer.borderColor    = [[UIColor lightGrayColor]CGColor];
    self.causeDescTextView.layer.borderWidth    = 1.0f;
}


- (IBAction) saveButtonClick :(id)sender
{
    
    
    NSLog(@"faultdictionary %@",self.faultDataDictionary);
    
    ServiceConfirmation *serviceDataObj = [ServiceConfirmation new];
    
    NSString *sqlQuery;
    
    
    
    //Selvan added this code to avoid null values
    NSString *zzsymptmtext = @"";
    NSString *zzprblmtext  = @"";
    NSString *zzcausetext  = @"";
    
    if (![[self.faultDataDictionary objectForKey:@"ZZSYMPTMTEXT"] isEqualToString:@"(null)"] && ([self.faultDataDictionary objectForKey:@"ZZSYMPTMTEXT"]))
        zzsymptmtext = [self.faultDataDictionary objectForKey:@"ZZSYMPTMTEXT"];
        
    if (![[self.faultDataDictionary objectForKey:@"ZZPRBLMTEXT"] isEqualToString:@"(null)"]  && ([self.faultDataDictionary objectForKey:@"ZZPRBLMTEXT"]))
        zzprblmtext = [self.faultDataDictionary objectForKey:@"ZZPRBLMTEXT"];
    
    if (![[self.faultDataDictionary objectForKey:@"ZZCAUSETEXT"] isEqualToString:@"(null)"]  && ([self.faultDataDictionary objectForKey:@"ZZCAUSETEXT"]))
        zzcausetext = [self.faultDataDictionary objectForKey:@"ZZCAUSETEXT"];
    //end
    
    
    if (isEditing)
    {
        sqlQuery    = [NSString stringWithFormat:@"UPDATE ZGSXSMST_SRVCCNFRMTNFAULT20 SET ZZSYMPTMCODEGROUP = '%@',ZZSYMPTMCODE = '%@',ZZSYMPTMTEXT = '%@',ZZPRBLMCODEGROUP = '%@',ZZPRBLMCODE = '%@', ZZPRBLMTEXT = '%@',ZZCAUSECODEGROUP = '%@',ZZCAUSECODE = '%@',ZZCAUSETEXT = '%@' WHERE NUMBER_EXT = %@",
							  [self.faultDataDictionary objectForKey:@"ZZSYMPTMCODEGROUP"],
							  [self.faultDataDictionary objectForKey:@"ZZSYMPTMCODE"],
							  zzsymptmtext,
							  [self.faultDataDictionary objectForKey:@"ZZPRBLMCODEGROUP"],
							  [self.faultDataDictionary objectForKey:@"ZZPRBLMCODE"],
							  zzprblmtext,
							  [self.faultDataDictionary objectForKey:@"ZZCAUSECODEGROUP"],
							  [self.faultDataDictionary objectForKey:@"ZZCAUSECODE"],
							  zzcausetext,
							  [self.faultDataDictionary objectForKey:@"NUMBER_EXT"]];
    }
    else
    {
        NSString *tempValueStr = [NSString stringWithFormat:@"'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@'",
                                  [self.serviceOrder numberExtension],
                                  [self.faultDataDictionary objectForKey:@"ZZSYMPTMCODEGROUP"],
                                  [self.faultDataDictionary objectForKey:@"ZZSYMPTMCODE"],
                                  zzsymptmtext,
                                  [self.faultDataDictionary objectForKey:@"ZZPRBLMCODEGROUP"],
                                  [self.faultDataDictionary objectForKey:@"ZZPRBLMCODE"],
                                  zzprblmtext,
                                  [self.faultDataDictionary objectForKey:@"ZZCAUSECODEGROUP"],
                                  [self.faultDataDictionary objectForKey:@"ZZCAUSECODE"],
                                  zzcausetext];
        
        sqlQuery = [NSString stringWithFormat:@"INSERT INTO  %@ (%@) VALUES (%@)",
                              @"ZGSXSMST_SRVCCNFRMTNFAULT20",
                              @"NUMBER_EXT,ZZSYMPTMCODEGROUP,ZZSYMPTMCODE, ZZSYMPTMTEXT,ZZPRBLMCODEGROUP,ZZPRBLMCODE,ZZPRBLMTEXT, ZZCAUSECODEGROUP,ZZCAUSECODE,ZZCAUSETEXT",tempValueStr];
        
//        NSString * faultData            = [NSString stringWithFormat:@"%@_%@", self.serviceOrder.serviceOrder,self.serviceOrder.numberExtension];
        
    }
    
    if ([serviceDataObj updateFaultData:sqlQuery]) {
        
        GSPFaultsViewController     * faultsVC ;
        
        if (IS_IPAD) {
            faultsVC = [[GSPFaultsViewController alloc]initWithNibName:@"GSPFaultsViewController_iPad" bundle:nil withObject:self.serviceOrder];
        }
        else
        {
            faultsVC = [[GSPFaultsViewController alloc]initWithNibName:@"GSPFaultsViewController" bundle:nil withObject:self.serviceOrder];
        }
        
        [self.navigationController pushViewController:faultsVC animated:YES];
        
    }    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dropDownButtonsClicked:(id)sender
{
    UIButton * dropDownButtons = (id)sender;
    
    NSMutableArray *popUpOptionArray ;
    
    switch (dropDownButtons.tag) {
        case 10:
            popUpOptionArray = self.symptomGroupArray;
            break;
        case 11:
            popUpOptionArray = self.symptomCodeArray;
            break;
        case 12:
            popUpOptionArray = self.problemGroupArray;
            break;
        case 13:
            popUpOptionArray = self.problemCodeArray;
            break;
        case 14:
            popUpOptionArray = self.causeGroupArray;
            break;
        case 15:
            popUpOptionArray = self.causeCodeArray;
            break;
        default:
            break;
    }
    
    
    
    
    pickerController = [GSPPickerController new];
    pickerController.pickerDelegate = self;
    [pickerController showPickerViewInView:self.view fromRectOfView:dropDownButtons withPickerArray:popUpOptionArray andPickerTag:dropDownButtons.tag];
    
}

- (void) pickerValueChanged:(NSString*)selectedString forPickerWithTag:(int)tag
{
// ***** added by Harshitha on 10th Aug 2015 *****
    ServiceConfirmation *serviceDataObj = [ServiceConfirmation new];
    NSString *queryString, *myString, *substring;
    NSRange range;
    objServiceMngtCls = [[GssMobileConsoleiOS alloc]init];
// ***** added by Harshitha on 10th Aug 2015 ends *****
    
    switch (tag) {
        case 10:
            [self.faultDataDictionary setValue:selectedString forKey:@"ZZSYMPTMCODEGROUP"];
            [self.symptonGroupButton setTitle:selectedString forState:UIControlStateNormal];
            
    // ***** added by Harshitha on 10th Aug 2015 *****
            myString = [self.faultDataDictionary valueForKey:@"ZZSYMPTMCODEGROUP"];
            range = [myString rangeOfString:@" "];
            substring = [myString substringToIndex:range.location];
            NSLog(@"substring: '%@'", substring);
//            queryString = [NSString stringWithFormat:@"SELECT * FROM ZGSXSMST_SYMPTMCODELIST10 WHERE CODEGRUPPE = '%@'",substring];
            tableName = [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXSMST_SYMPTMCODELIST10"];
            queryString = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE CODEGRUPPE = '%@'",tableName,substring];
            
            self.symptomCodeArray = [serviceDataObj getFaultsOptionArraysWithQuery:queryString];
            [self.faultDataDictionary setValue:[self.symptomCodeArray objectAtIndex:0] forKey:@"ZZSYMPTMCODE"];
            [self.symptomCodeButton setTitle:[self.symptomCodeArray objectAtIndex:0] forState:UIControlStateNormal];
    // ***** added by Harshitha on 10th Aug 2015 ends *****
            
            break;
        case 11:
            [self.faultDataDictionary setValue:selectedString forKey:@"ZZSYMPTMCODE"];
            [self.symptomCodeButton setTitle:selectedString forState:UIControlStateNormal];
            
    // ***** added by Harshitha on 10th Aug 2015 *****
            myString = [self.faultDataDictionary valueForKey:@"ZZSYMPTMCODE"];
            range = [myString rangeOfString:@" "];
            substring = [myString substringToIndex:range.location];
            NSLog(@"substring: '%@'", substring);
//            queryString = [NSString stringWithFormat:@"SELECT * FROM ZGSXSMST_SYMPTMCODEGROUPLIST10 WHERE CODEGRUPPE = '%@'",substring];
            tableName = [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXSMST_SYMPTMCODEGROUPLIST10"];
            queryString = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE CODEGRUPPE = '%@'",tableName,substring];
            self.symptomGroupArray = [serviceDataObj getFaultsOptionArraysWithQuery:queryString];
            [self.faultDataDictionary setValue:[self.symptomGroupArray objectAtIndex:0] forKey:@"ZZSYMPTMCODEGROUP"];
            [self.symptonGroupButton setTitle:[self.symptomGroupArray objectAtIndex:0] forState:UIControlStateNormal];
    // ***** added by Harshitha on 10th Aug 2015 ends *****
            
            break;
        case 12:
            [self.faultDataDictionary setValue:selectedString forKey:@"ZZPRBLMCODEGROUP"];
            [self.problemGroupButton setTitle:selectedString forState:UIControlStateNormal];
            
    // ***** added by Harshitha on 10th Aug 2015 *****
            myString = [self.faultDataDictionary valueForKey:@"ZZPRBLMCODEGROUP"];
            range = [myString rangeOfString:@" "];
            substring = [myString substringToIndex:range.location];
            NSLog(@"substring: '%@'", substring);
//            queryString = [NSString stringWithFormat:@"SELECT * FROM ZGSXSMST_PRBLMCODELIST10 WHERE CODEGRUPPE = '%@'",substring];
            tableName = [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXSMST_PRBLMCODELIST10"];
            queryString = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE CODEGRUPPE = '%@'",tableName,substring];
            self.problemCodeArray = [serviceDataObj getFaultsOptionArraysWithQuery:queryString];
            [self.faultDataDictionary setValue:[self.problemCodeArray objectAtIndex:0] forKey:@"ZZPRBLMCODE"];
            [self.problemCodeButton setTitle:[self.problemCodeArray objectAtIndex:0] forState:UIControlStateNormal];
    // ***** added by Harshitha on 10th Aug 2015 ends *****
            
            break;
        case 13:
            [self.faultDataDictionary setValue:selectedString forKey:@"ZZPRBLMCODE"];
            [self.problemCodeButton setTitle:selectedString forState:UIControlStateNormal];
            
    // ***** added by Harshitha on 10th Aug 2015 *****
            myString = [self.faultDataDictionary valueForKey:@"ZZPRBLMCODE"];
            range = [myString rangeOfString:@" "];
            substring = [myString substringToIndex:range.location];
            NSLog(@"substring: '%@'", substring);
//            queryString = [NSString stringWithFormat:@"SELECT * FROM ZGSXSMST_PRBLMCODEGROUPLIST10 WHERE CODEGRUPPE = '%@'",substring];
            tableName = [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXSMST_PRBLMCODEGROUPLIST10"];
            queryString = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE CODEGRUPPE = '%@'",tableName,substring];
            self.problemGroupArray = [serviceDataObj getFaultsOptionArraysWithQuery:queryString];
            [self.faultDataDictionary setValue:[self.problemGroupArray objectAtIndex:0] forKey:@"ZZPRBLMCODEGROUP"];
            [self.problemGroupButton setTitle:[self.problemGroupArray objectAtIndex:0] forState:UIControlStateNormal];
    // ***** added by Harshitha on 10th Aug 2015 ends *****
            
            break;
        case 14:
            [self.faultDataDictionary setValue:selectedString forKey:@"ZZCAUSECODEGROUP"];
            [self.causeGropuButton setTitle:selectedString forState:UIControlStateNormal];
            
    // ***** added by Harshitha on 10th Aug 2015 *****
            myString = [self.faultDataDictionary valueForKey:@"ZZCAUSECODEGROUP"];
            range = [myString rangeOfString:@" "];
            substring = [myString substringToIndex:range.location];
            NSLog(@"substring: '%@'", substring);
//            queryString = [NSString stringWithFormat:@"SELECT * FROM ZGSXSMST_CAUSECODELIST10 WHERE CODEGRUPPE = '%@'",substring];
            tableName = [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXSMST_CAUSECODELIST10"];
            queryString = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE CODEGRUPPE = '%@'",tableName,substring];
            self.causeCodeArray = [serviceDataObj getFaultsOptionArraysWithQuery:queryString];
            [self.faultDataDictionary setValue:[self.causeCodeArray objectAtIndex:0] forKey:@"ZZCAUSECODE"];
            [self.causeCodeButton setTitle:[self.causeCodeArray objectAtIndex:0] forState:UIControlStateNormal];
    // ***** added by Harshitha on 10th Aug 2015 ends *****
            
            break;
        case 15:
            [self.faultDataDictionary setValue:selectedString forKey:@"ZZCAUSECODE"];
            [self.causeCodeButton setTitle:selectedString forState:UIControlStateNormal];
            
    // ***** added by Harshitha on 10th Aug 2015 *****
            myString = [self.faultDataDictionary valueForKey:@"ZZCAUSECODE"];
            range = [myString rangeOfString:@" "];
            substring = [myString substringToIndex:range.location];
            NSLog(@"substring: '%@'", substring);
//            queryString = [NSString stringWithFormat:@"SELECT * FROM ZGSXSMST_CAUSECODEGROUPLIST10 WHERE CODEGRUPPE = '%@'",substring];
            tableName = [CONTEXT_OBJTYPE stringByAppendingString:@"ZGSXSMST_CAUSECODEGROUPLIST10"];
            queryString = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE CODEGRUPPE = '%@'",tableName,substring];
            self.causeGroupArray = [serviceDataObj getFaultsOptionArraysWithQuery:queryString];
            [self.faultDataDictionary setValue:[self.causeGroupArray objectAtIndex:0] forKey:@"ZZCAUSECODEGROUP"];
            [self.causeGropuButton setTitle:[self.causeGroupArray objectAtIndex:0] forState:UIControlStateNormal];
    // ***** added by Harshitha on 10th Aug 2015 ends *****
            
            break;
        default:
            break;
            
    }
}

#pragma mark Texview Delegates

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSString * inputString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if ([text isEqualToString:@"\n"])
    {
		[textView resignFirstResponder];
		return FALSE;
	}
    
    if (textView.tag == 16) {
        [self.faultDataDictionary setValue:inputString forKey:@"ZZSYMPTMTEXT"];
    }
    else if (textView.tag == 17)
    {
        [self.faultDataDictionary setValue:inputString forKey:@"ZZPRBLMTEXT"];
    }
    else if (textView.tag == 18)
    {
        [self.faultDataDictionary setValue:inputString forKey:@"ZZCAUSETEXT"];
    }
    
	
    
    return YES;
}


@end
