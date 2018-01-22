//
//  GSPDetailTableCell.h
//  GssServicePro
//
//  Created by Harshitha on 03/03/16.
//  Copyright (c) 2016 Harshitha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSPDetailTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;

@property (weak, nonatomic) IBOutlet UIButton *pickerButton;

@property (weak, nonatomic) IBOutlet UIImageView *pickerArrow;

@property (weak, nonatomic) IBOutlet UILabel *descriptionTextLabel;

@property (weak, nonatomic) IBOutlet UILabel *telNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *altTelNumLabel;

@property (weak, nonatomic) IBOutlet UIButton *telNumButton;

@property (weak, nonatomic) IBOutlet UIButton *altTelNumButton;

@property (weak, nonatomic) IBOutlet UITextView *noteTextView;

@property (weak, nonatomic) IBOutlet UIImageView *editPencilImage;

@property (weak, nonatomic) IBOutlet UILabel *notesLabel;

@property (weak, nonatomic) IBOutlet UIImageView *telNumIcon;

@property (weak, nonatomic) IBOutlet UIImageView *altTelNumIcon;



@end
