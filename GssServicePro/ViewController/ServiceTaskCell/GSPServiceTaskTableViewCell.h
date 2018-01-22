//
//  GSPServiceTaskTableViewCell.h
//  GssServicePro
//
//  Created by Riyas Hassan on 04/06/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSPTableLabel.h"

@interface GSPServiceTaskTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet GSPTableLabel *startDateLabel;
@property (weak, nonatomic) IBOutlet GSPTableLabel *cutomerLocationLabel;
@property (weak, nonatomic) IBOutlet GSPTableLabel *estimatedArrivallabel;
@property (weak, nonatomic) IBOutlet GSPTableLabel *serviceDocLabel;
@property (weak, nonatomic) IBOutlet GSPTableLabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet GSPTableLabel *discriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *priorityImageView;
@property (weak, nonatomic) IBOutlet UIImageView *errorImageView;

@property (strong, nonatomic) IBOutlet GSPTableLabel *startTimeLabel;

@end
