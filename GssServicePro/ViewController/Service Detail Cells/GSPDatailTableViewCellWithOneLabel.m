//
//  GSPDatailTableViewCellWithOneLabel.m
//  GssServicePro
//
//  Created by Harshitha on 06/03/16.
//  Copyright © 2016 Harshitha. All rights reserved.
//

#import "GSPDatailTableViewCellWithOneLabel.h"

@implementation GSPDatailTableViewCellWithOneLabel

- (void)awakeFromNib {
    // Initialization code
    [self.descriptionLabelText sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
