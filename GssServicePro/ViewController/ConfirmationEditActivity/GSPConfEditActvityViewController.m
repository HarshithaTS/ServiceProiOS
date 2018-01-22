 //
//  GSPConfEditActvityViewController.m
//  GssServicePro
//
//  Created by Riyas Hassan on 18/09/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPConfEditActvityViewController.h"
#import "GSPDateUtility.h"
#import "GSPTimeZoneSelector.h"
#import "ServiceConfirmation.h"
#import "GSPOfflineViewConfiguration.h"
#import "GSPServiceConfCreationViewController.h"


@interface GSPConfEditActvityViewController ()<TimeZoneSelectorDelegate,CustomPickerDelegate>
{
    UIPopoverController     * popoverController;
    ServiceConfirmation     * serviceConfObj;
    GSPPickerController     * pickerController;
    
    //NSString     *serviceItem, *timeZoneFrom, *duration, *serviceNote, *startDate, *endDate;
    
    BOOL isEdit;
    
}





@property (weak, nonatomic) IBOutlet UIButton *serviceButton;
@property (nonatomic, strong) ServiceTask *serviceObject;

@property (weak, nonatomic) IBOutlet UITextField *durationHours;
@property (weak, nonatomic) IBOutlet UIButton *timeZoneSelectionButton;
@property (weak, nonatomic) IBOutlet UITextView *serviceNoteTextView;
@property (weak, nonatomic) IBOutlet UIButton *startDateButton;
@property (weak, nonatomic) IBOutlet UIButton *endDateButton;

//@property (strong, nonatomic) NSString * numberExt, *serviceID;

- (IBAction)serviceButtonClickAction:(id)sender;
- (IBAction)dateSelectionButtonClick:(UIButton *)sender;


- (IBAction)timeZoneButtonClicked:(id)sender;
- (IBAction)saveButtonClick:(id)sender;
- (IBAction)cancelButtonClick:(id)sender;

@end

@implementation GSPConfEditActvityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withObject:(ServiceTask*)serviceTask numberExtensio:(NSString*)numbExt andServiceID:(NSString*)serviceOrderId
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.serviceObject  = serviceTask;
        self.numberExt      = numbExt;
        self.serviceID      = serviceOrderId;
//        self.title          = @"Service Confirmation Edit";
        [self setNavigationTitleWithBrandImage:@"Service Confirmation Edit"];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initializeVariables];
    
    [self setUpview];
    
//    [[GSPOfflineViewConfiguration sharedInstance] checkReachabilityAndCofigureView:self];

}

- (void) initializeVariables
{
    IsdurationEntered = FALSE;

    serviceConfObj  = [ServiceConfirmation new];
    
    if (self.serviceObject)
    {
        isEdit = YES;
    }
    
}

-(void) setUpview
{
    [[GSPOfflineViewConfiguration sharedInstance] checkReachabilityAndCofigureView:self];

    if (self.serviceObject)
    {
        self.serviceObject.timeZoneFrom     = [[GSPDateUtility sharedInstance] getTimeZoneNameForTimezoneOffset:self.serviceObject.timeZoneFrom];
        self.durationHours.text             = self.serviceObject.duration;

// Original code
//        [self.startDateButton setTitle:self.serviceObject.startDate forState:UIControlStateNormal];
//        [self.endDateButton setTitle:[NSString stringWithFormat:@"%@", [NSDate date]] forState:UIControlStateNormal];
        
// Modified by Harshitha
        self.startDate = self.serviceObject.startDateAndTime;
        [self.startDateButton setTitle:[[GSPDateUtility sharedInstance]convertYYYYMMDDHHMMSStoMMMDDYYYYHHMM:self.serviceObject.startDateAndTime] forState:UIControlStateNormal];
        
        if ([self.serviceObject.estimatedArrivalDate length] > 0) {
            self.endDate = self.serviceObject.estimatedArrivalDate;
            [self.endDateButton setTitle:[[GSPDateUtility sharedInstance]convertYYYYMMDDHHMMSStoMMMDDYYYYHHMM:self.serviceObject.estimatedArrivalDate] forState:UIControlStateNormal];
        }
        else {
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            self.endDate = [formatter stringFromDate:[NSDate date]];
            [formatter setDateFormat:@"MMM dd,yyyy HH:MM"];
            [self.endDateButton setTitle:[NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]] forState:UIControlStateNormal];
        }
        
        self.serviceNoteTextView.layer.cornerRadius   = 3.0;
        self.serviceNoteTextView.layer.borderColor    = [[UIColor lightGrayColor]CGColor];
        self.serviceNoteTextView.layer
        .borderWidth    = 1.0f;
        
        self.durationHours.layer.cornerRadius   = 3.0;
        self.durationHours.layer.borderColor    = [[UIColor lightGrayColor]CGColor];
        self.durationHours.layer.borderWidth    = 1.0f;
//  Modified by Harshitha ends here
      //  self.serviceNoteTextView.text=self.serviceObject.serviceOrderDescription;
        self.serviceNoteTextView.text       = self.serviceObject.serviceNote;  //modified by sahana
        [self.timeZoneSelectionButton setTitle:self.serviceObject.timeZoneFrom forState:UIControlStateNormal];
        [self.serviceButton setTitle:self.serviceObject.serviceItem forState:UIControlStateNormal];
        
        
        
        
    }
    else
    {
        self.serviceObject.timeZoneFrom     = [[GSPDateUtility sharedInstance] getTimeZoneNameForTimezoneOffset:@"-1800000"];
// Modified by Harshitha starts here
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        self.startDate = self.endDate = [NSString stringWithFormat:@"%@", [formatter stringFromDate:[NSDate date]]];
        [self.startDateButton setTitle:[NSString stringWithFormat:@"%@", [[GSPDateUtility sharedInstance]convertYYYYMMDDHHMMSStoMMMDDYYYYHHMM:self.startDate]] forState:UIControlStateNormal];
        [self.endDateButton setTitle:[NSString stringWithFormat:@"%@", [[GSPDateUtility sharedInstance]convertYYYYMMDDHHMMSStoMMMDDYYYYHHMM:self.endDate]] forState:UIControlStateNormal];
// Modified by Harshitha ends here
    }

    
 
    
//    [self setRightNavigationBarButtonItemsWithMenu:NO andOtherBarButtonWithImageNamed:@"Save.png" andSelector:@selector(saveButtonClick:)];
    [self updateDurationHours];
    [self setRightNavigationBarButtonItemsWithMenu:NO andOtherBarButtonWithImageNamed:@"SaveIcon.png" andSelector:@selector(saveButtonClick:)];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)serviceButtonClickAction:(id)sender
{
    UIButton * serviceButton = (UIButton*)sender;
    
    NSMutableArray *popUpOptionArray = [serviceConfObj getServicePoupArrayForType];
    
    pickerController = [GSPPickerController new];
    pickerController.pickerDelegate = self;
    [pickerController showPickerViewInView:self.view fromRectOfView:serviceButton withPickerArray:popUpOptionArray andPickerTag:1000];
}

- (void) pickerValueChanged : (NSString *)selectedString forPickerWithTag:(int)tag
{
    
    self.serviceItem = selectedString;
    
    [self.serviceButton setTitle:selectedString forState:UIControlStateNormal];
}
- (IBAction)dateSelectionButtonClick:(UIButton *)sender
{
//    UIButton * dateButton = (UIButton *)sender;
    
    pickerController = [GSPPickerController new];
    pickerController.pickerDelegate = self;
    [pickerController showDatePickerInView:self.view fromRectOfView:sender WithPickerTag:sender.tag];
//    [pickerController showDatePickerInView:self.view fromRectOfView:dateButton WithPickerTag:sender.tag];
    
}

- (void) datePickerValueChanged:(NSDate*)selectedDate fordatePickerWithTag:(int)tag
{
//    switch (tag) {
//        case 10:
//            self.startDate   = [NSString stringWithFormat:@"%@",selectedDate];
//            [self.startDateButton setTitle:[[GSPDateUtility sharedInstance]convertYYYYMMDDHHMMSStoMMMDDYYYYHHMM:self.startDate] forState:UIControlStateNormal];
//            
//            break;
//        case 11:
//            self.endDate     = [NSString stringWithFormat:@"%@",selectedDate];
//            [self.endDateButton setTitle:[[GSPDateUtility                                                                                                                                                                                                                                                                                                                  sharedInstance]convertYYYYMMDDHHMMSStoMMMDDYYYYHHMM:self.endDate] forState:UIControlStateNormal];
//            break;
//            
//        default:
//            break;
//    }
  
    NSDateFormatter *df     = [[NSDateFormatter alloc] init];
    df.dateStyle            = NSDateFormatterMediumStyle;
    [df setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    NSString *dateString    = [NSString stringWithFormat:@"%@",[df stringFromDate:selectedDate]];
        if (tag == 10)
    {
        self.startDate = dateString;
           [self.startDateButton setTitle:[[GSPDateUtility sharedInstance]convertYYYYMMDDHHMMSStoMMMDDYYYYHHMM:dateString] forState:UIControlStateNormal];
        [self autoCalculateDuration];
    }
       else if (tag == 11)
    {
        self.endDate = dateString;
      
         [self.endDateButton setTitle:[[GSPDateUtility sharedInstance]convertYYYYMMDDHHMMSStoMMMDDYYYYHHMM:dateString] forState:UIControlStateNormal];
        [self autoCalculateDuration];
        
    }

}
//added by sahana

-(void)autoCalculateDuration{
    NSString *startDateTime=self.startDate;
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    NSDate *startTime=[dateFormat dateFromString:startDateTime];
    
    
    NSString *endDateTime=self.endDate;
    NSDate *endTime=[dateFormat dateFromString:endDateTime];
    
    if ([endTime compare:startTime] == NSOrderedAscending) {
        
        [[GSPUtility sharedInstance]showAlertWithTitle:@"" message:@"End date shouldn't be earlier to start date" otherButton:nil tag:0 andDelegate:self];
        
        return;
    }
    NSTimeInterval diff = [endTime timeIntervalSinceDate:startTime];
    int timeinSecs=diff;
    
    int numberOfhrs1=(timeinSecs/(60*60));
    
    float remainSec=timeinSecs%(60*60);
    
    float numberOfhrs=numberOfhrs1+(remainSec/(60*60));
    
    NSLog(@"hrs=%f",numberOfhrs);
    NSString *time=[NSString stringWithFormat:@"%.02f",numberOfhrs];
    _calculatedTime=[time floatValue];
    NSLog(@"double =%f",_calculatedTime);
    if(numberOfhrs<=24)
        self.durationHours.text=[NSString stringWithFormat:@"%.02f",numberOfhrs];
    
    else
        self.durationHours.text=nil;
}
-(void)updateDurationHours{
    
   
    int durationSap=[self.durationHours.text integerValue];
    
    NSString *startDateTime=self.startDate;
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    NSDate *startTime=[dateFormat dateFromString:startDateTime];
    
    
    NSString *endDateTime=self.endDate;
    NSDate *endTime=[dateFormat dateFromString:endDateTime];
    
    if ([endTime compare:startTime] == NSOrderedAscending) {
        
        [[GSPUtility sharedInstance]showAlertWithTitle:@"" message:@"End date shouldn't be earlier to start date" otherButton:nil tag:0 andDelegate:self];
        
        return;
    }
    NSTimeInterval diff = [endTime timeIntervalSinceDate:startTime];
    int timeinSecs=diff;
    
    int numberOfhrs1=(timeinSecs/(60*60));
    
    float remainSec=timeinSecs%(60*60);
   
   float numberOfhrs=numberOfhrs1+(remainSec/(60*60));
  
     NSLog(@"hrs=%f",numberOfhrs);
    NSString *time=[NSString stringWithFormat:@"%.02f",numberOfhrs];
     _calculatedTime=[time floatValue];
    NSLog(@"double =%f",_calculatedTime);
    
    if([self.serviceObject.duration isEqualToString:@"(null)"]||self.serviceObject.duration.length<=0){
        
        if(numberOfhrs <=24)
            self.durationHours.text=[NSString stringWithFormat:@"%.02f",numberOfhrs];
      //  self.serviceObject.duration=self.durationHours.text;
      
      
    else
        self.durationHours.text=nil;
    
    }
    else{
//        if(!IsdurationEntered)
//     self.durationHours.text=[NSString stringWithFormat:@"%.02fhrs",numberOfhrs];
//        else
       self.durationHours.text=self.serviceObject.duration;
        //    self.durationHours.text=self.duration;
//        NSLog(@"Duration = %@",self.duration);
    }

    /*
        int numberofDays=timeinSecs/(24*60*60);
    int numberOfhrs=((timeinSecs/(60*60))%24);
    int numberofmin=((timeinSecs/60)%60);
    
    NSLog(@" hrs = %d",numberOfhrs);
    NSLog(@"days = %d",numberofDays);
    NSLog(@"mins=%d",numberofmin);
    
        if([self.serviceObject.duration isEqualToString:@"(null)"]||self.serviceObject.duration.length<=0||durationSap < numberOfhrs){
            if(numberofDays>0){
            self.durationHours.text=[NSString stringWithFormat:@"%ddays %dhrs %dmins",numberofDays, numberOfhrs,numberofmin];
    }
            else
                self.durationHours.text=[NSString stringWithFormat:@"%dhrs %dmins",numberOfhrs,numberofmin];
        }
        else{
            self.durationHours.text=self.serviceObject.duration;
        }
    */
   
}

- (IBAction)timeZoneButtonClicked:(id)sender
{
    
    UIButton * timeZoneButton = (UIButton*)sender;
    
    GSPTimeZoneSelector * timeZoneSelector      = [[GSPTimeZoneSelector alloc]initWithStyle:UITableViewStyleGrouped currentTimeZoneOffset:self.serviceObject.timeZoneFrom];
    timeZoneSelector.timeZoneSelectorDelegate   = self;
    
    if (IS_IPAD) {
        popoverController = [[UIPopoverController alloc] initWithContentViewController:timeZoneSelector];
        
        
        popoverController.popoverContentSize    = CGSizeMake(300, 300);
        
        [popoverController presentPopoverFromRect:timeZoneButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    else
        [self.navigationController pushViewController:timeZoneSelector animated:YES];
}


#pragma mark Time Zone selector delegate

- (void) selectedTimeZoneIs:(id)timezone
{
    NSTimeZone *timeZoneSelected    = (NSTimeZone*)timezone;
    
    self.timeZoneFrom                    = [NSString stringWithFormat:@"%@",timeZoneSelected];
    
    [self.timeZoneSelectionButton setTitle:self.timeZoneFrom forState:UIControlStateNormal];
    
}

- (IBAction)saveButtonClick:(id)sender
{
  
    ServiceConfirmation *serviceDataObj = [ServiceConfirmation new];
    
    NSString *sqlQuery;
    
    //selvan added this code
    self.serviceItem =self.serviceButton.titleLabel.text;
    self.timeZoneFrom =self.serviceObject.timeZoneFrom;
    self.duration=self.durationHours.text;
    self.serviceNote=self.serviceNoteTextView.text;
//    self.startDate= self.startDateButton.titleLabel.text;
//    self.endDate = self.endDateButton.titleLabel.text;

    //end
    
    if([self.serviceItem isEqualToString:@""]||self.serviceItem == nil){
        [[GSPUtility sharedInstance]showAlertWithTitle:@"Alert" message:@"Service should not be empty" otherButton:nil tag:0 andDelegate:self];
        return;
    }

// ***** Added by Harshitha to show popup when end date is earlier to start date *****
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[NSLocale currentLocale]];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss '+0000'"];
    
    NSDate *start_date = [dateFormat dateFromString:self.startDate];
    NSDate *end_date = [dateFormat dateFromString:self.endDate];

    if ([end_date compare:start_date] == NSOrderedAscending) {
    
        [[GSPUtility sharedInstance]showAlertWithTitle:@"" message:@"End date shouldn't be earlier to start date" otherButton:nil tag:0 andDelegate:self];
        return;
    }
// ***** Added by Harshitha ends here *****
    
    float duration=[self.durationHours.text floatValue];
    if(duration>_calculatedTime){
        [[GSPUtility sharedInstance]showAlertWithTitle:@"" message:@"Entered time exceeds the elapsed time" otherButton:nil tag:0 andDelegate:self];
        return;

    }
    objServiceMngtCls = [[GssMobileConsoleiOS alloc]init];
    
    if (isEdit)
    {
        sqlQuery    = [NSString stringWithFormat:@"UPDATE ZGSXSMST_SRVCACTVTY10_TEMP SET PRODUCT_ID = '%@',QUANTITY = '%@',PROCESS_QTY_UNIT = '%@',ZZITEM_DESCRIPTION = '%@',ZZITEM_TEXT = '%@', DATETIME_FROM = '%@',DATETIME_TO = '%@', DATE_FROM = '%@',DATE_TO = '%@',TIME_FROM = '%@',TIME_TO = '%@' WHERE NUMBER_EXT = %@",
                              
							  self.serviceID,
							  self.duration,
							  @"",
							  self.serviceItem,
							  self.serviceNote,
							  self.startDate,
                              self.endDate,
                              [[GSPDateUtility sharedInstance] getDateFromString: self.startDate],
                              [[GSPDateUtility sharedInstance] getDateFromString: self.endDate],
                              [[GSPDateUtility sharedInstance] getTimeFromString: self.startDate],
                              [[GSPDateUtility sharedInstance] getTimeFromString: self.endDate],
                              self.numberExt];
    }
    else
    {
        NSString *sqlQryStr     = [NSString stringWithFormat:@"SELECT * FROM ZGSXSMST_SRVCACTVTY10_TEMP WHERE 1"];
        
        
        
        NSMutableArray *tempArray    = [serviceDataObj getTempServiceConfirmationDataArrayWithQueryStr:sqlQryStr];
        
        if((tempArray.count)<=1){
            _serviceOrderIncerementd=_serviceOrderIncerementd+5001;

        }
        else
            _serviceOrderIncerementd=_serviceOrderIncerementd+1;

//        int mSRCDOC_NUMBER_EXT = [self.numberExt intValue] + 5000;
        
        
         int mSRCDOC_NUMBER_EXT = [self.numberExt intValue] + 1;
        
        NSString * tempValueStr = [NSString stringWithFormat:@"'%@',%d,%d,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@'",
                                   self.serviceID,mSRCDOC_NUMBER_EXT, _serviceOrderIncerementd, self.serviceItem, self.duration, @"",self.serviceItem,self.serviceNote,
                                   self.startDate,
                                   self.endDate,
                                   [[GSPDateUtility sharedInstance] getDateFromString: self.startDate],
                                   [[GSPDateUtility sharedInstance] getDateFromString: self.endDate],
                                   [[GSPDateUtility sharedInstance] getTimeFromString: self.startDate],
                                   [[GSPDateUtility sharedInstance] getTimeFromString: self.endDate],
                                   self.timeZoneFrom
                                   ];
        
        sqlQuery        = [NSString stringWithFormat:@"INSERT INTO  ZGSXSMST_SRVCACTVTY10_TEMP (%@) VALUES (%@)",@"OBJECT_ID,SRCDOC_NUMBER_EXT,NUMBER_EXT,PRODUCT_ID,QUANTITY,PROCESS_QTY_UNIT,ZZITEM_DESCRIPTION,ZZITEM_TEXT,DATETIME_FROM,DATETIME_TO,DATE_FROM,DATE_TO,TIME_FROM,TIME_TO,TIMEZONE_FROM",tempValueStr];
        
    }
 
// ***** Original code *****
//    if ([serviceDataObj updateFaultData:sqlQuery]) {
    
// ***** Modified by Harshitha *****
    if ([serviceDataObj updateServicesConfirmationData:sqlQuery]) {
    
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (IBAction)cancelButtonClick:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark Texview Delegates

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSString * inputString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
	if ([text isEqualToString:@"\n"])
    {
		[textView resignFirstResponder];
		return FALSE;
	}
    
    self.serviceNote = inputString;
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    IsdurationEntered = TRUE;
    NSString * inputString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.duration                = inputString;
    return  YES;
    
}


@end
