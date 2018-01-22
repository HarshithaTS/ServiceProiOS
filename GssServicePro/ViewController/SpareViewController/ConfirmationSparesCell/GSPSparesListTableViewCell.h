//
//  GSPSparesListTableViewCell.h
//  GssServicePro
//
//  Created by Riyas Hassan on 08/10/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSPSparesListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *materialIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *materialDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *qtyLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
