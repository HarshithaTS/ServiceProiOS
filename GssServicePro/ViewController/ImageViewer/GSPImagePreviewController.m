//
//  GSPImagePreviewController.m
//  GssServicePro
//
//  Created by Riyas Hassan on 02/07/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPImagePreviewController.h"

@interface GSPImagePreviewController ()
{
    BOOL hasDeleteOption;
}

@property (nonatomic, strong) UIImage * attachedImage;

@property (weak, nonatomic) IBOutlet UIImageView *attachmentImageView;

@property (nonatomic, strong) NSString * signatureFilePath;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteBarButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBarItem;

- (IBAction)doneBarButtonClick:(id)sender;

- (IBAction)deleteBarButtonAction:(id)sender;

@end

@implementation GSPImagePreviewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withImage:(UIImage*)image
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.attachedImage = image;
        hasDeleteOption    = NO;
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withImage:(UIImage*)image withSinaturePath:(NSString*)sigFilePath
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.attachedImage      = image;
        hasDeleteOption         = YES;
        self.signatureFilePath  = sigFilePath;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpView];
    
    [self.attachmentImageView setImage:self.attachedImage];
}

- (void) setUpView
{
    if (!hasDeleteOption)
    {
//  Original code
//        self.navigationBarItem.rightBarButtonItem = nil;
        
//  Modified by Harshitha to hide Delete option
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
        [rightButton setImage:nil forState:UIControlStateNormal];
        self.navigationBarItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark navigation Bar button actions

- (IBAction)doneBarButtonClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deleteBarButtonAction:(id)sender
{
    [[GSPUtility sharedInstance] showAlertWithTitle:@"Delete" message:@"Are you sure you want to delete this item ?" otherButton:@"Cancel" tag:1 andDelegate:self];
}

- (void) deleteImageAndDismissView
{
    [[GSPUtility sharedInstance] deleteFilesFromDocumentFolders:self.signatureFilePath];
    [self dismissViewControllerAnimated:YES completion:nil];
    UIViewController *presentedView = (UIViewController*)self.presentingViewController;
    
    [presentedView viewDidAppear:YES];
}

#pragma mark UIalertView delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag != 0)
    {
        switch (buttonIndex)
        {
            case 0:
                [self deleteImageAndDismissView];
                break;
                
            default:
                break;
        }
        
    }
    
}


@end
