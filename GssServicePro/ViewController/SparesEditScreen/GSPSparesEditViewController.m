//
//  GSPSparesEditViewController.m
//  GssServicePro
//
//  Created by Riyas Hassan on 29/09/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPSparesEditViewController.h"
#import "ServiceConfirmation.h"
#import "GSPPickerController.h"
#import "ServiceTask.h"
#import "GSPSparesViewController.h"
#import "ZBarSDK.h"
#import "GSPOfflineViewConfiguration.h"


@interface GSPSparesEditViewController ()<CustomPickerDelegate,UIActionSheetDelegate,ZBarReaderDelegate>
{
    GSPPickerController     * pickerController;
    ServiceConfirmation     * serviceDataObj;
    BOOL isEditing;
}

- (IBAction)materialIDSelectionClick:(id)sender;
- (IBAction)unitSelectionClick:(id)sender;

@property (nonatomic, strong) NSMutableDictionary *spareDict;

@property (weak, nonatomic) IBOutlet UIButton *materialIDButton;
@property (weak, nonatomic) IBOutlet UILabel *materialDescTextLabel;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;
@property (weak, nonatomic) IBOutlet UIButton *unitSelectionButton;
@property (weak, nonatomic) IBOutlet UITextField *serialNumTextField;
@property (weak, nonatomic) IBOutlet UITextView *materialDescTextView;

@property (strong, nonatomic) ServiceTask *serviceTask;
@property (strong, nonatomic) NSMutableArray * materialIdArray;
//Added by Harshitha on 10th Aug 2015
@property (strong, nonatomic) NSMutableArray * unitArray;

- (IBAction)barCodeScanButtonClick:(UIButton *)sender;

@end

@implementation GSPSparesEditViewController

@synthesize tableName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil WithObjectID:(ServiceTask*)servicetask andSpareObject:(NSMutableDictionary*)sparesDict
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.serviceTask   = servicetask;
        self.spareDict     = sparesDict;
//        self.title         = @"Spares";
        [self setNavigationTitleWithBrandImage:@"Spares"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupView];
    
    [[GSPOfflineViewConfiguration sharedInstance] checkReachabilityAndCofigureView:self];

    
    [self initialsizeVariables];
}

-(void) initialsizeVariables
{

    if (!self.spareDict)
    {
        self.spareDict    = [NSMutableDictionary new];
    }
    else
    {
        isEditing = YES;
        
        [self.materialIDButton setTitle:[self.spareDict valueForKey:@"PRODUCT_ID"] forState:UIControlStateNormal];
        [self.unitSelectionButton setTitle:[self.spareDict valueForKey:@"PROCESS_QTY_UNIT"] forState:UIControlStateNormal];
        [self.quantityTextField setText:[self.spareDict valueForKey:@"QUANTITY"]];
        [self.serialNumTextField setText:[self.spareDict valueForKey:@"SERIAL_NUMBER"]];
        [self.materialDescTextView setText:[self.spareDict valueForKey:@"ZZITEM_DESCRIPTION"]];
        [self.materialDescTextLabel setText:[self.spareDict valueForKey:@"ZZITEM_DESCRIPTION"]];
    }
    
    
    serviceDataObj = [ServiceConfirmation new];
    
    self.materialIdArray = [serviceDataObj getSparesIdArray];
    
}

-(void) setupView
{
//    [self setRightNavigationBarButtonItemsWithMenu:NO andOtherBarButtonWithImageNamed:@"Save.png" andSelector:@selector(saveSparesInTempDb:)];
    [self setRightNavigationBarButtonItemsWithMenu:NO andOtherBarButtonWithImageNamed:@"SaveIcon.png" andSelector:@selector(saveSparesInTempDb:)];

    [self.materialDescTextView setHidden:YES];
    
    self.quantityTextField.layer.cornerRadius   = 3.0;
    self.quantityTextField.layer.borderColor    = [[UIColor lightGrayColor]CGColor];
    self.quantityTextField.layer.borderWidth    = 1.0f;
    
    self.serialNumTextField.layer.cornerRadius   = 3.0;
    self.serialNumTextField.layer.borderColor    = [[UIColor lightGrayColor]CGColor];
    self.serialNumTextField.layer.borderWidth    = 1.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)materialIDSelectionClick:(id)sender
{
    pickerController = [GSPPickerController new];
    pickerController.pickerDelegate = self;
    [pickerController showPickerViewInView:self.view fromRectOfView:(UIButton*)sender withPickerArray:self.materialIdArray andPickerTag:1];
}

- (IBAction)unitSelectionClick:(id)sender
{

    pickerController = [GSPPickerController new];
    pickerController.pickerDelegate = self;
// Original code
//    [pickerController showPickerViewInView:self.view fromRectOfView:(UIButton*)sender withPickerArray:self.materialIdArray andPickerTag:1];

// Modified by Harshitha on 10th aug 2015
    self.unitArray = [serviceDataObj getUnitsIdArray];
    [pickerController showPickerViewInView:self.view fromRectOfView:(UIButton*)sender withPickerArray:self.unitArray andPickerTag:2];
}

- (void) pickerValueChanged:(NSString*)selectedString forPickerWithTag:(int)tag
{
    switch (tag) {
        case 1:
        {
            if ([selectedString isEqualToString:@"Other"]) {
 
                [self.materialDescTextLabel setHidden:YES];
                [self.materialDescTextView setHidden:NO];
                break;
            }

            [self.materialIDButton setTitle:selectedString forState:UIControlStateNormal];
            
            NSRange range                   = [selectedString rangeOfString:@":"];
            
            [self.spareDict setValue:[selectedString substringToIndex:range.location] forKey:@"PRODUCT_ID"];
            
            if (range.length > 0)
            {
                self.materialDescTextLabel.text = [selectedString substringFromIndex:range.location+1];
                
                [self.spareDict setValue:[selectedString substringFromIndex:range.location+1] forKey:@"ZZITEM_TEXT"];
                [self.spareDict setValue:[selectedString substringFromIndex:range.location+1] forKey:@"ZZITEM_DESCRIPTION"];
            }

            NSString * unitStr = [serviceDataObj getSpareUnitForMaterialID:[selectedString substringToIndex:range.location]];
            [self.unitSelectionButton setTitle:unitStr forState:UIControlStateNormal];
            [self.spareDict setValue:unitStr forKey:@"PROCESS_QTY_UNIT"];
    }
            break;
            
// ***** Added by Harshitha on 10th Aug 2015 starts here *****
        case 2:
        {
            if ([selectedString isEqualToString:@"Other"]) {
                
                [self.materialDescTextLabel setHidden:YES];
                [self.materialDescTextView setHidden:NO];
                break;
            }
            
            [self.unitSelectionButton setTitle:selectedString forState:UIControlStateNormal];
            [self.spareDict setValue:selectedString forKey:@"PROCESS_QTY_UNIT"];
            /*
             self.materialIdArray = [serviceDataObj getMaterialIDArrayForSpareUnit:selectedString];
             
             NSRange range  = [[self.materialIdArray objectAtIndex:0] rangeOfString:@":"];
             
             [self.materialIDButton setTitle:[self.materialIdArray objectAtIndex:0] forState:UIControlStateNormal];
             [self.spareDict setValue:[[self.materialIdArray objectAtIndex:0] substringToIndex:range.location] forKey:@"PRODUCT_ID"];
             
             if (range.length > 0)
             {
             self.materialDescTextLabel.text = [[self.materialIdArray objectAtIndex:0] substringFromIndex:range.location+1];
             
             [self.spareDict setValue:[[self.materialIdArray objectAtIndex:0] substringFromIndex:range.location+1] forKey:@"ZZITEM_TEXT"];
             [self.spareDict setValue:[[self.materialIdArray objectAtIndex:0] substringFromIndex:range.location+1] forKey:@"ZZITEM_DESCRIPTION"];
             }
             */
        }
            break;
// ***** Added by Harshitha on 10th Aug 2015 ends here *****
            
        default:
            break;
    }
}


- (IBAction)saveSparesInTempDb:(id)sender
{
    
    NSString *sqlQuery ;
    
    //selvan added this code
    NSString *productid = @"";
    NSString *qty = @"";
    NSString *processqtyunit = @"";
    NSString *zzitemdescpn = @"";
    NSString *zzitemtext = @"";
    NSString *serialno = @"";
    
    NSLog(@"Spare dictionary %@", self.spareDict);
    
    if (![[self.spareDict objectForKey:@"PRODUCT_ID"] isEqualToString:@"(null)"] && ([self.spareDict objectForKey:@"PRODUCT_ID"]))
        productid = [self.spareDict objectForKey:@"PRODUCT_ID"];
    
    if (![[self.spareDict objectForKey:@"QUANTITY"] isEqualToString:@"(null)"] && ([self.spareDict objectForKey:@"QUANTITY"]))
        qty = [self.spareDict objectForKey:@"QUANTITY"];
    
    if (![[self.spareDict objectForKey:@"PROCESS_QTY_UNIT"] isEqualToString:@"(null)"] && ([self.spareDict objectForKey:@"PROCESS_QTY_UNIT"]))
        processqtyunit = [self.spareDict objectForKey:@"PROCESS_QTY_UNIT"];
    
    if (![[self.spareDict objectForKey:@"ZZITEM_DESCRIPTION"] isEqualToString:@"(null)"] && ([self.spareDict objectForKey:@"ZZITEM_DESCRIPTION"]))
        zzitemdescpn = [self.spareDict objectForKey:@"ZZITEM_DESCRIPTION"];
    
    if (![[self.spareDict objectForKey:@"ZZITEM_TEXT"] isEqualToString:@"(null)"] && ([self.spareDict objectForKey:@"ZZITEM_TEXT"]))
        zzitemtext = [self.spareDict objectForKey:@"ZZITEM_TEXT"];
    
    if (![[self.spareDict objectForKey:@"SERIAL_NUMBER"] isEqualToString:@"(null)"] && ([self.spareDict objectForKey:@"SERIAL_NUMBER"]))
        serialno = [self.spareDict objectForKey:@"SERIAL_NUMBER"];
    //end
    
    if([productid isEqualToString:@""]){
        [[GSPUtility sharedInstance]showAlertWithTitle:@"Alert" message:@"Material ID should not be empty" otherButton:nil tag:0 andDelegate:self];
        return;
    }
    if (isEditing)
    {
        sqlQuery = [NSString stringWithFormat:@"UPDATE '%@' SET PRODUCT_ID = '%@',QUANTITY = '%@',PROCESS_QTY_UNIT = '%@',ZZITEM_DESCRIPTION = '%@',ZZITEM_TEXT = '%@',SERIAL_NUMBER ='%@' WHERE NUMBER_EXT = '%@' AND OBJECT_ID=%@",@"ZGSXSMST_SRVCSPARE10_TEMP",
                              productid,
                              qty,
                              processqtyunit,
                              zzitemdescpn,
                              zzitemtext,
                              serialno,
                              self.serviceTask.numberExtension,
                              self.serviceTask.serviceOrder];
    }
    else
    {
        NSString *tempValueStr = [NSString stringWithFormat:@"'%@','%@','%@','%@','%@','%@','%@','%@'",self.serviceTask.serviceOrder,self.serviceTask.numberExtension,productid,qty,processqtyunit,zzitemdescpn,zzitemtext,serialno];
        
        sqlQuery      = [NSString stringWithFormat:@"INSERT INTO  ZGSXSMST_SRVCSPARE10_TEMP (%@) VALUES (%@)",
                                   @"OBJECT_ID,NUMBER_EXT,PRODUCT_ID,QUANTITY,PROCESS_QTY_UNIT,ZZITEM_DESCRIPTION,ZZITEM_TEXT,SERIAL_NUMBER",tempValueStr];
    }
    

    
    if ([serviceDataObj updateSparesDataInDb:sqlQuery]) {
        
        GSPSparesViewController *sparesListVC  ;
        
        if (IS_IPAD) {
            sparesListVC            = [[GSPSparesViewController alloc]initWithNibName:@"GSPSparesViewController_iPad" bundle:nil withObject:self.serviceTask];
        }
        else
        {
            sparesListVC            = [[GSPSparesViewController alloc]initWithNibName:@"GSPSparesViewController" bundle:nil withObject:self.serviceTask];
        }
        
        [self.navigationController pushViewController:sparesListVC animated:YES];
        
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
    
    [self.spareDict setValue:inputString forKey:@"ZZITEM_DESCRIPTION"];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * inputString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.serialNumTextField)
    {
        [self.spareDict setValue:inputString forKey:@"SERIAL_NUMBER"];
    }
    else if (textField == self.quantityTextField)
    {
            [self.spareDict setValue:inputString forKey:@"QUANTITY"];
    }
    
    
    return  YES;
    
}

#pragma mark Barcode Scaning methods

- (IBAction)barCodeScanButtonClick:(UIButton *)sender
{
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    [self presentViewController:reader animated:YES completion:nil];
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    self.serialNumTextField.text = symbol.data;
    [self.spareDict setValue:symbol.data forKey:@"SERIAL_NUMBER"];

    [reader dismissViewControllerAnimated:YES completion:nil];
}

@end
