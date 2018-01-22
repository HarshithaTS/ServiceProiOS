//
//  UIDevice+Extended.h
//  Macros
//
//  
//  Copyright (c) 2011 Mine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/types.h>
#import <sys/sysctl.h>

@interface UIDevice ( UIDevice_Extended ) 

- (NSString *)deviceType;

@end
