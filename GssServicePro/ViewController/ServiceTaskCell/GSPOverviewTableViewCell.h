//
//  GSPOverviewTableViewCell.h
//  GssServicePro
//
//  Created by Harshitha on 26/02/16.
//  Copyright (c) 2016 Harshitha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSPOverviewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orgNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *serviceLocationLabel1;

@property (weak, nonatomic) IBOutlet UILabel *serviceLocationLabel2;

@property (weak, nonatomic) IBOutlet UILabel *serviceLocationLabel3;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel2;

@property (weak, nonatomic) IBOutlet UIImageView *priorityImageView;

@property (weak, nonatomic) IBOutlet UIButton *mapButton;

@property (weak, nonatomic) IBOutlet UILabel *priorityLabelText;

@end
