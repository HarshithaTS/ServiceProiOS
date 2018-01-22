//
//  GSPBaseViewController.h
//  GssServicePro
//
//  Created by Riyas Hassan on 25/06/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSPBaseViewController : UIViewController <UIDocumentInteractionControllerDelegate>

- (void) setCustomRightBarButtonItem:(SEL)selector withImageNamed:(NSString*)imageName;

- (void) setNavigationTitleWithBrandImage:(NSString*)title;

- (void) setBottomMenuBarWithArrayOfBarButtons:(NSArray*)barButtonArray;

- (void) setLeftNavigationBarButtonWithImage:(NSString*)imageName;

- (void) setRightNavigationBarButtonItemsWithMenu:(BOOL)isMenu andOtherBarButtonWithImageNamed:(NSString*)imageName andSelector:(SEL)selector;

@end
