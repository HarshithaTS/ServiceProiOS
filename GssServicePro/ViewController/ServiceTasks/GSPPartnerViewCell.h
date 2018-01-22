//
//  GSPPartnerViewCell.h
//  GssServicePro
//
//  Created by Harshitha on 10/1/15.
//  Copyright (c) 2015 Harshitha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSPTableLabel.h"

@interface GSPPartnerViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet GSPTableLabel *partnerTypeLabel;
@property (weak, nonatomic) IBOutlet GSPTableLabel *partnerNameLabel;
@property (weak, nonatomic) IBOutlet GSPTableLabel *telNum1_label;
@property (weak, nonatomic) IBOutlet UIButton *callButton1;
@property (weak, nonatomic) IBOutlet GSPTableLabel *telNum2_label;
@property (weak, nonatomic) IBOutlet UIButton *callButton2;
@property (weak, nonatomic) IBOutlet UIImageView *partnerTelNumIcon;
@property (weak, nonatomic) IBOutlet UIImageView *partnerAltTelNumIcon;
@property (weak, nonatomic) IBOutlet GSPTableLabel *altTelLabelForLandscape;
@property (weak, nonatomic) IBOutlet UIButton *callButton2ForLandscape;
@property (weak, nonatomic) IBOutlet UIImageView *partnerAltTelNumIconForLandscape;

@end
