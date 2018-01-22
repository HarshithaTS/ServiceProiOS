//
//  GSPTableLabel.h
//  GssServicePro
//
//  Created by Riyas Hassan on 26/06/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSPTableLabel : UILabel


- (void) setLabelColor:(UIColor*)color;

- (void) setLabelFont:(UIFont*)font;

- (void) setLabelColor:(UIColor *)color withFont:(UIFont*)font;

- (void) boldLabelsForDetailTableTitles;

- (void) setLabelsForDetailTableValues;

- (void) setOverViewTableLabel;

@end
