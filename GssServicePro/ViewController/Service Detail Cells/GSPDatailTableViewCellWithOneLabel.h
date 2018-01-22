//
//  GSPDatailTableViewCellWithOneLabel.h
//  GssServicePro
//
//  Created by Harshitha on 06/03/16.
//  Copyright © 2016 Harshitha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSPDatailTableViewCellWithOneLabel : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabelName;

@property (strong, nonatomic) IBOutlet UILabel *descriptionLabelText;

@property (weak, nonatomic) IBOutlet UIButton *expandArrowButton;

@property (weak, nonatomic) IBOutlet UIButton *expandArrowButtonForLandscape;

@end
