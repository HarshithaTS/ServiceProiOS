//
//  GSPPickerController.h
//  GssServicePro
//
//  Created by Riyas Hassan on 13/06/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CustomPickerDelegate <NSObject>

@optional
- (void) pickerValueChanged : (NSString *)selectedString forPickerWithTag:(int)tag;
- (void) datePickerValueChanged:(NSDate*)selectedDate fordatePickerWithTag:(int)tag;

@required

@end

@interface GSPPickerController : UIViewController


@property (nonatomic, strong) UIActionSheet *actionSheetPicker;
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) UIPopoverController *popover;
@property (nonatomic, strong) NSMutableArray * pickerContentArray;

@property (nonatomic, strong) UIDatePicker * datePicker;

@property (nonatomic, strong) id <CustomPickerDelegate> pickerDelegate;

- (void)showPickerViewInView:(UIView*)presentingView fromRectOfView:(id)controller withPickerArray:(NSMutableArray*)contentArray andPickerTag:(int)tag;

- (void) showDatePickerInView:(UIView*)presentingView fromRectOfView:(id)controller WithPickerTag:(int)tag;

@end
