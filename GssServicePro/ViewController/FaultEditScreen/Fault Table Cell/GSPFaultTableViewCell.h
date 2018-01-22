//
//  GSPFaultTableViewCell.h
//  GssServicePro
//
//  Created by Riyas Hassan on 07/10/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSPFaultTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *symptomGroupLabel;
@property (weak, nonatomic) IBOutlet UILabel *symptomCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *symptomDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *problemGroupLabel;
@property (weak, nonatomic) IBOutlet UILabel *problemCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *problemDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *causeGroupLabel;
@property (weak, nonatomic) IBOutlet UILabel *causeCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *causeDesclabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
