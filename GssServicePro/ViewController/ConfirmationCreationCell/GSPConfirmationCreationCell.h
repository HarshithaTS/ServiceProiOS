//
//  GSPConfirmationCreationCell.h
//  GssServicePro
//
//  Created by Riyas Hassan on 12/09/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSPTableLabel.h"

@interface GSPConfirmationCreationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet GSPTableLabel *serviceDescriptionLabel;
@property (weak, nonatomic) IBOutlet GSPTableLabel *durationLabel;
@property (weak, nonatomic) IBOutlet GSPTableLabel *startDateLabel;
@property (weak, nonatomic) IBOutlet GSPTableLabel *endDateLabel;
@property (weak, nonatomic) IBOutlet GSPTableLabel *serviceLabel;
@property (weak, nonatomic) IBOutlet GSPTableLabel *notesLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *checkBoxButton;

@end
