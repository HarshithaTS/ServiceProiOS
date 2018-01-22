//
//  GSPCommonTableView.m
//  GssServicePro
//
//  Created by Riyas Hassan on 25/06/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPCommonTableView.h"

@implementation GSPCommonTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];//colorWithRed:225.0/255 green:241.0/255 blue:255.0/255 alpha:1.0];
    
}


@end
