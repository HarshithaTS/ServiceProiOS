//
//  GSPPickerController.m
//  GssServicePro
//
//  Created by Riyas Hassan on 13/06/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPPickerController.h"
#import <CoreGraphics/CoreGraphics.h>

@interface GSPPickerController ()<UIPickerViewDataSource, UIPickerViewDelegate,UIPopoverControllerDelegate, UIActionSheetDelegate>
{
    BOOL isIphoneDoneButtonClicked;
    id picketrViewType;
}

@end

@implementation GSPPickerController
@synthesize pickerContentArray;
@synthesize popover;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) pickerValueChanged:(NSString*)selectedString forPickerWithTag:(int)tag
{
    if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(pickerValueChanged: forPickerWithTag:)])
    {
        [self.pickerDelegate pickerValueChanged:selectedString forPickerWithTag:tag];
    }
}

- (void)showPickerViewInView:(UIView*)presentingView fromRectOfView:(id)controller withPickerArray:(NSMutableArray*)contentArray andPickerTag:(int)tag
{
    UIButton * btn = (UIButton*)controller;
    
    pickerContentArray = contentArray;
    
    CGRect pickerFrame;
    
    if (IS_IPAD)
    {
//        pickerFrame =  CGRectMake(0, 0, 260, 280.0);
        pickerFrame =  CGRectMake(0, 0, 260, 200.0);
        
        if (tag == 1000)
        {
            pickerFrame =  CGRectMake(0, 0, 500.0, 400.0);
        }
        
    }
    else
    {
        pickerFrame =  CGRectMake(0, 0, 320, 200.0);
    }
    self.picker                         = [[UIPickerView alloc] initWithFrame:pickerFrame];
    self.picker.backgroundColor         = [UIColor clearColor];
    self.picker.showsSelectionIndicator = YES;
    self.picker.delegate                = self;
    self.picker.dataSource              = self;
    self.picker.tag                     = tag;
    
    if (IS_IPHONE) {
        
        [self addPickerInActionSheetForIphone:self.picker];

        return;
    }
    
    UIViewController *pickerController = [[UIViewController alloc] init];
    [pickerController.view addSubview:self.picker];
    
    UIPopoverController *pickerPopover  = [[UIPopoverController alloc] initWithContentViewController:pickerController];
    pickerPopover.delegate              = self;
//    pickerPopover.popoverContentSize    = CGSizeMake(260.0, 280.0);
    pickerPopover.popoverContentSize    = CGSizeMake(260.0, 200.0);
    
    if (tag == 1000) {
        pickerPopover.popoverContentSize    = CGSizeMake(500.0, 280.0);
    }
    
    
    self.popover                        = pickerPopover;


    [pickerPopover presentPopoverFromRect:CGRectMake(btn.frame.origin.x, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height) inView:presentingView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
//    [pickerPopover presentPopoverFromRect:CGRectMake(btn.frame.origin.x+60, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height) inView:presentingView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}
//Delegate function of picker view..
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	
    return pickerContentArray.count;
}
//Delegate function of picker view..
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	
	return [pickerContentArray objectAtIndex:row];
}
//Delegate function of picker view..
-(void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	
    NSString * selectedString = [pickerContentArray objectAtIndex:row];
    
    if (IS_IPAD || isIphoneDoneButtonClicked)
    {
        [self pickerValueChanged:selectedString forPickerWithTag:(int)thePickerView.tag];
    }
    

    
	
}

#pragma mark DatePicker methods

- (void) showDatePickerInView:(UIView*)presentingView fromRectOfView:(id)controller WithPickerTag:(int)tag
{
    UIButton * btn = (UIButton*)controller;
    
    self.datePicker                 = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
//  Original code
//    self.datePicker.datePickerMode  = UIDatePickerModeDate;
    self.datePicker.hidden          = NO;
//    self.datePicker.date            = [NSDate date];

//  Modified by Harshitha
    self.datePicker.datePickerMode  = UIDatePickerModeDateAndTime;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd HH:MM:00"];
    NSString *date1                 = [[GSPDateUtility sharedInstance] getTimeZoneNameForTimezoneOffset:[formatter stringFromDate:[NSDate date]]];
    self.datePicker.date            = [formatter dateFromString:date1];
//  Modified by Harshitha ends here

    self.datePicker.tag             = tag;
    
    [self.datePicker addTarget:self
                   action:@selector(datePickerValueChangedFordatePickerWithTag)
         forControlEvents:UIControlEventValueChanged];
    
    
    if (IS_IPHONE)
    {
        [self addPickerInActionSheetForIphone:self.datePicker];
        return;
    }

    UIViewController *pickerController  = [[UIViewController alloc] init];
    [pickerController.view addSubview:self.datePicker];
    
    UIPopoverController *pickerPopover  = [[UIPopoverController alloc] initWithContentViewController:pickerController];
    pickerPopover.delegate              = self;
    pickerPopover.popoverContentSize    = CGSizeMake(300.0, 230.0);
//    pickerPopover.popoverContentSize    = CGSizeMake(300.0, 300.0);
    self.popover                        = pickerPopover;
 
//    [pickerPopover presentPopoverFromRect:CGRectMake(btn.frame.origin.x-50, btn.frame.origin.y , btn.frame.size.width, btn.frame.size.height) inView:presentingView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
//    [pickerPopover presentPopoverFromRect:CGRectMake(btn.frame.origin.x+60, btn.frame.origin.y , btn.frame.size.width, btn.frame.size.height) inView:presentingView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [pickerPopover presentPopoverFromRect:CGRectMake(btn.frame.origin.x, btn.frame.origin.y , btn.frame.size.width, btn.frame.size.height) inView:presentingView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}


- (void)datePickerValueChangedFordatePickerWithTag
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;

    
    NSLog(@"date is: %@",[NSString stringWithFormat:@"%@",[df stringFromDate:self.datePicker.date]]);
    
    if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(datePickerValueChanged: fordatePickerWithTag:)])
    {
        if (IS_IPAD || isIphoneDoneButtonClicked)
            
            [self.pickerDelegate datePickerValueChanged:self.datePicker.date fordatePickerWithTag:(int)self.datePicker.tag];
        
    }

}

- (void)addPickerInActionSheetForIphone:(id)pickerView
{
    picketrViewType                 = pickerView;
    
    self.actionSheetPicker          = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    UIToolbar *pickerDateToolbar    = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerDateToolbar.barStyle      = UIBarStyleBlackOpaque;
    [pickerDateToolbar sizeToFit];
    NSMutableArray *barItems        = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace      = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *doneBtn        = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissActionSheetForDone)];
    
    UIBarButtonItem *cancelButton   = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissActionSheetForCancel)];

    [barItems addObject:cancelButton];
    [barItems addObject:flexSpace];
    [barItems addObject:doneBtn];
    [pickerDateToolbar setItems:barItems animated:YES];
    
    [self.actionSheetPicker addSubview:pickerView];
    [self.actionSheetPicker addSubview:pickerDateToolbar];
    
    [self.actionSheetPicker showInView:[[UIApplication sharedApplication] keyWindow]];
    [UIView beginAnimations:nil context:nil];
    [self.actionSheetPicker setBounds:CGRectMake(0, 0, 320, 480)];
    [UIView commitAnimations];
}


- (void) dismissActionSheetForCancel
{
    [self.actionSheetPicker dismissWithClickedButtonIndex:0 animated:YES];
}

- (void) dismissActionSheetForDone
{
    isIphoneDoneButtonClicked = YES;
    
    int  selectedRow = (int)[self.picker selectedRowInComponent:0];
    
    
    if ([picketrViewType isKindOfClass:[UIPickerView class]])
    {
        [self pickerView:self.picker didSelectRow:selectedRow inComponent:0];
    }
    else if ([picketrViewType isKindOfClass:[UIDatePicker class]])
    {
        [self datePickerValueChangedFordatePickerWithTag];
    }

    isIphoneDoneButtonClicked = NO;
    [self.actionSheetPicker dismissWithClickedButtonIndex:0 animated:YES];
}

@end
