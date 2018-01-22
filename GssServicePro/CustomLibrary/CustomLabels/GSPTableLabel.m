//
//  GSPTableLabel.m
//  GssServicePro
//
//  Created by Riyas Hassan on 26/06/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPTableLabel.h"

@implementation GSPTableLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
    }
    return self;
}

-(void)awakeFromNib
{

}

- (void)setOverViewTableLabel
{
    self.textColor = TABLE_LABEL_COLOR;
    
    if (IS_IPAD)
    {
        self.font      = TABLE_LABEL_FONT;
    }else
        self.font      =iPHONE_DETAIL_TABLE_LABEL_FONT;
    
}

- (void)setLabelColor:(UIColor*)color
{
    self.textColor = color;
}

-(void) setLabelColor:(UIColor *)color withFont:(UIFont*)font
{
    [self setLabelColor:color];
    [self setLabelFont:font];
}


- (void)setLabelFont:(UIFont*)font
{
    self.font      = font;
}

- (void) setLabelsForDetailTableValues
{

    self.textColor = DETAIL_TABLE_LABEL_COLOR;
    if (IS_IPAD)
        
        self.font      = DETAIL_TABLE_LABEL_FONT;
    else
 
        self.font      = iPHONE_DETAIL_TABLE_LABEL_FONT;
    
    
}

- (void) boldLabelsForDetailTableTitles
{
    self.textColor = DETAIL_TABLE_LABEL_COLOR;
    
    if (IS_IPAD)
        
        self.font      = TABLE_BOLD_LABEL_FONT;
    else
        
        self.font      = iPHONE_TABLE_BOLD_LABEL_FONT;
}
@end
