//
//  GSPDetailTableViewCell.h
//  GssServicePro
//
//  Created by Harshitha on 03/03/16.
//  Copyright (c) 2016 Harshitha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSPDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *TitleLabelText;

@property (weak, nonatomic) IBOutlet UIButton *showContentsButton;

@property (weak, nonatomic) IBOutlet UIButton *showContentsButtonForLandscape;

@end
