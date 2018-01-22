//
//  GSPConfirmationCell.h
//  GssServicePro
//
//  Created by Riyas Hassan on 09/09/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSPTableLabel.h"

@interface GSPConfirmationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet GSPTableLabel *itemLabel;
@property (weak, nonatomic) IBOutlet GSPTableLabel *productLabel;
@property (weak, nonatomic) IBOutlet GSPTableLabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet GSPTableLabel *confirmationIdLabel;



@end
