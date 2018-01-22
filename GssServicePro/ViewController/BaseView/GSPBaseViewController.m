//
//  GSPBaseViewController.m
//  GssServicePro
//
//  Created by Riyas Hassan on 25/06/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPBaseViewController.h"
#import "CheckedNetwork.h"
#import "GSPLocationManager.h"
#import "GSPAppDelegate.h"

@interface GSPBaseViewController ()

@end

@implementation GSPBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!IS_SIMULATOR) {
        [[GSPLocationManager sharedInstance]initLocationMnager];
    }
    
//    self.view.backgroundColor = BACKGROUND_COLOR;
    self.view.backgroundColor = [UIColor clearColor];
//    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:253.0/255 green:127.0/255 blue:44.0/255 alpha:1.0]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:255.0/255 green:143.0/255 blue:30.0/255 alpha:0.0]];
//    self.navigationController.navigationBar.translucent = NO;
    
    if ([SYSTEM_VERSION floatValue] >= 7.0)
            self.edgesForExtendedLayout = UIRectEdgeNone;
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setNavigationTitleWithBrandImage:(NSString*)title
{
    if (IS_IPAD)
    {
    
/*        GSPAppDelegate *appDelegateObj = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];
        UIImageView *imageView;

        if ([appDelegateObj.activeApp isEqualToString:@"Main"])
        {
            UIImage *image          = [UIImage imageNamed: @"Icon-Small@2x.png"];
            imageView  = [[UIImageView alloc] initWithImage: image];
            imageView.frame         = CGRectMake(0, 5, 30, 30);
        }
*/

//        UILabel *titleLabel     = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 270, 40)];
        UILabel *titleLabel     = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 420, 40)];
        
        if ([CheckedNetwork connectedToNetwork]) {
            titleLabel.text         = title;
        }
        else
        {
            titleLabel.text = [title stringByAppendingString:@" (Offline)"];
        }
        
//        titleLabel.font         = [UIFont boldSystemFontOfSize:17.0];
        titleLabel.font         = [UIFont systemFontOfSize:17.0];
//        titleLabel.backgroundColor = [UIColor clearColor];
//        titleLabel.textColor    = [UIColor blackColor];
        titleLabel.textColor    = [UIColor whiteColor];
        titleLabel. textAlignment = NSTextAlignmentCenter;
        
//        CGRect applicationFrame = CGRectMake(0, 0, 300, 40);
        CGRect applicationFrame = CGRectMake(0, 0, 450, 40);
        
        UIView * newView        = [[UIView alloc] initWithFrame:applicationFrame];
        
//        [newView addSubview:imageView];
        [newView addSubview:titleLabel];
        
//        UIView *redLine         = [[UIView alloc]initWithFrame:CGRectMake(-159, 40, self.view.frame.size.width, 5)];
//        redLine.backgroundColor = [UIColor redColor];
//        [newView addSubview:redLine];
        
/*        UIView *orangeBar;
        if (self.interfaceOrientation == UIDeviceOrientationPortrait || self.interfaceOrientation == UIDeviceOrientationPortraitUpsideDown)
                orangeBar         = [[UIView alloc]initWithFrame:CGRectMake(-159, 40, self.view.frame.size.width, 5)];
        else
                orangeBar         = [[UIView alloc]initWithFrame:CGRectMake(-287, 40, self.view.frame.size.width, 5)];
        orangeBar.backgroundColor = [UIColor colorWithRed:253.0/255 green:127.0/255 blue:44.0/255 alpha:1.0];
        [newView addSubview:orangeBar];
*/
        self.navigationItem.titleView = newView;
    }
    else
    {
//   Added by Harshitha to customize title for iPhone screens
        if (title.length <28) {
            self.navigationItem.title = title;
        }
        else {
            UILabel *titleLabel     = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 40)];
            titleLabel.text         = title;
            titleLabel.font         = [UIFont boldSystemFontOfSize:11.0];
//            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textColor    = [UIColor blackColor];
            titleLabel. textAlignment = NSTextAlignmentCenter;
            
            CGRect applicationFrame = CGRectMake(0, 0, 250, 40);
            
            UIView * newView        = [[UIView alloc] initWithFrame:applicationFrame];
            
            [newView addSubview:titleLabel];
            
            self.navigationItem.titleView = newView;
//  Added by Harshitha ends here

        }
    }
    
}


//Custom Right navigation bar button

- (void) setCustomRightBarButtonItem:(SEL)selector withImageNamed:(NSString*)imageName
{
    
    UIButton *rightBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightBarBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    rightBarBtn.frame = CGRectMake(0, 0, 40, 40);
    
    rightBarBtn.showsTouchWhenHighlighted=YES;
    
    [rightBarBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    
    self.navigationItem.rightBarButtonItem  = rightBarButton;

}

//Custom navigation bar button


- (void) setBottomMenuBarWithArrayOfBarButtons:(NSArray*)barButtonArray
{
    UIToolbar *bottomToolBar    = [[UIToolbar alloc] init];
    bottomToolBar.frame         = CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);
    bottomToolBar.barStyle      = UIBarStyleBlack;
    NSMutableArray *items       = [[NSMutableArray alloc] init];
    
    items = (NSMutableArray*)barButtonArray;
    
    [bottomToolBar setItems:items animated:NO];
    [self.view addSubview:bottomToolBar];
    [self.view bringSubviewToFront:bottomToolBar];
}

- (void) setLeftNavigationBarButtonWithImage:(NSString*)imageName
{
    NSMutableArray *arrLeftBarItems = [[NSMutableArray alloc] init];

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [backButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    backButton.frame = CGRectMake(0, 0, 40, 40);
    
    GSPAppDelegate *appDelegateObj = (GSPAppDelegate *) [[UIApplication sharedApplication] delegate];

    if (![appDelegateObj.activeApp isEqualToString:@"Main"])
    {
    backButton.showsTouchWhenHighlighted=YES;
    
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIBarButtonItem *barBackButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    
    //UIBarButtonItem *barBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick:)];
    
    [arrLeftBarItems addObject:barBackButton];

    if ([appDelegateObj.activeApp isEqualToString:@"Main"])
    {
        UIButton *appNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
        [appNameButton setTitle:@"ServicePro" forState:UIControlStateNormal];
    
        appNameButton.frame = CGRectMake(0, 0, 100, 40);
    
        UIBarButtonItem *appNameBarButton = [[UIBarButtonItem alloc] initWithCustomView:appNameButton];
    
        [arrLeftBarItems addObject:appNameBarButton];
    }
    
//    self.navigationItem.leftBarButtonItem = barBackButton;
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
}

- (void) backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) setRightNavigationBarButtonItemsWithMenu:(BOOL)isMenu andOtherBarButtonWithImageNamed:(NSString*)imageName andSelector:(SEL)selector
{
    NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
    
    if (isMenu)
    {
        UIButton *btnLib = [UIButton buttonWithType:UIButtonTypeCustom];
        
//        [btnLib setImage:[UIImage imageNamed:@"MenuBarButton.png"] forState:UIControlStateNormal];
//        [btnLib setImage:[UIImage imageNamed:@"MenuButton.png"] forState:UIControlStateNormal];
        [btnLib setImage:[UIImage imageNamed:@"MenuIcon.png"] forState:UIControlStateNormal];
        
        btnLib.frame = CGRectMake(0, 0, 40, 40);
        
        btnLib.showsTouchWhenHighlighted=YES;
        
        [btnLib addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:btnLib];
        
        [arrRightBarItems addObject:barButtonItem2];
    }
    if (imageName)
    {
        UIButton *otherRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [otherRightButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
        otherRightButton.frame = CGRectMake(0, 0, 40, 40);
        
        otherRightButton.showsTouchWhenHighlighted=YES;
        
        [otherRightButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *OtherRightBarButton = [[UIBarButtonItem alloc] initWithCustomView:otherRightButton];
        
        [arrRightBarItems addObject:OtherRightBarButton];
    }

    
    self.navigationItem.rightBarButtonItems = arrRightBarItems;
}


@end
