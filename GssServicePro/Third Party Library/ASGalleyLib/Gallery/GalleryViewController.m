//
//  GalleryViewController.m
//  Photos
//
//  Created by Andrey Syvrachev on 21.05.13.
//  Copyright (c) 2013 Andrey Syvrachev. All rights reserved.
//

#import "GalleryViewController.h"
#import "GalleryImage.h"
#import "GSPServiceTaskDetailViewController.h"

@interface GalleryViewController ()<ASGalleryViewControllerDelegate>

@end

@implementation GalleryViewController

NSString * serviceOrder = @"";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil serviceOrder:(NSString*)service_Order
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        serviceOrder = service_Order;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setWantsFullScreenLayout:YES];
    [self setCustomRightBarButtonItem];
}

-(NSUInteger)numberOfAssetsInGalleryController:(ASGalleryViewController *)controller
{
    return [self.assets count];
}

-(id<ASGalleryAsset>)galleryController:(ASGalleryViewController *)controller assetAtIndex:(NSUInteger)index
{
    return [self.assets objectAtIndex:index];
}

-(void)updateTitle
{
    self.title = [NSString stringWithFormat:NSLocalizedString(@"%u of %u", nil),self.selectedIndex + 1,[self numberOfAssetsInGalleryController:self]];
    
    if (self.assets.count <= 0) {
        [self.navigationController popViewControllerAnimated:YES ];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateTitle];
}

-(void)selectedIndexDidChangedInGalleryController:(ASGalleryViewController*)controller;
{
    [self updateTitle];
}

- (void) setCustomRightBarButtonItem
{
//  Original code
/*    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStyleDone target:self action:@selector(deleteAttachedImage:)];
    
    self.navigationItem.rightBarButtonItem  = rightBarButton;
*/

//  Modified by Harshitha starts here
    NSMutableArray *arrRightBarItems = [[NSMutableArray alloc] init];
    
    UIButton *btnLib = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnLib setTitle:@"Delete" forState:UIControlStateNormal];
    
    btnLib.frame = CGRectMake(0, 0, 60, 40);
    
    btnLib.showsTouchWhenHighlighted=YES;
        
    [btnLib addTarget:self action:@selector(deleteAttachedImage:) forControlEvents:UIControlEventTouchUpInside];
        
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:btnLib];
        
    [arrRightBarItems addObject:barButtonItem2];

    UIButton *otherRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
    [otherRightButton setTitle:@"Add" forState:UIControlStateNormal];
    
    otherRightButton.frame = CGRectMake(0, 0, 40, 40);
        
    otherRightButton.showsTouchWhenHighlighted=YES;
        
    [otherRightButton addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
        
    UIBarButtonItem *OtherRightBarButton = [[UIBarButtonItem alloc] initWithCustomView:otherRightButton];
        
    [arrRightBarItems addObject:OtherRightBarButton];
    
    self.navigationItem.rightBarButtonItems = arrRightBarItems;
//  Modified by Harshitha ends here
   
}

-(void) deleteAttachedImage:(id)sender
{
    
    GalleryImage * imageObject = [self.assets objectAtIndex:self.selectedIndex];
    
    [[GSPUtility sharedInstance] deleteFilesFromDocumentFolders:imageObject.imageFilePath];
    
    [self.assets removeObjectAtIndex:self.selectedIndex];
    
    [self reloadData];
    [self updateTitle];
}

// ***** Modified by Harshitha starts here *****
-(void)addImage:(id)sender
{
    UIActionSheet* menuActionSheet = [[UIActionSheet alloc]
                                      initWithTitle:NSLocalizedString(@"CHOOSE_ACTION", nil)
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"CANCEL", nil)
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"Camera",@"Photo Gallery",nil];
    menuActionSheet.tag           = IMAGEPICKER_ACION_SHEET_TAG;
    [menuActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == IMAGEPICKER_ACION_SHEET_TAG)
        [self ImagePickerActionSheetActionWithIndex:buttonIndex];
}

- (void) ImagePickerActionSheetActionWithIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [self imagePickerActionWithOption:CAMERA_SELECTED];
            break;
        case 1:
            [self imagePickerActionWithOption:GALLERY_SELECTED];
            break;
            
        default:
            break;
    }
    
}

#pragma mark image Picker methods

- (void) imagePickerActionWithOption:(int)selectedOption
{
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    
    if(selectedOption == GALLERY_SELECTED)
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    imagePicker.allowsEditing = YES;
    
    [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void) saveImage:(UIImage*)image
{
    
    NSData *imageData                   = UIImagePNGRepresentation(image);
    
    NSDateFormatter *dateFormat     = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *tmpImgName                = [NSString stringWithFormat:@"%@_%@_img.png",serviceOrder,[dateFormat stringFromDate:[NSDate date]]];
    
    NSString * localFolderPathStr       = [[GSPUtility sharedInstance] getMediaLocalPathForFileName:serviceOrder forPathComponent:@"AttchedImages"];
    
    NSString * imagePath                = [localFolderPathStr stringByAppendingPathComponent:tmpImgName];
    
    [imageData writeToFile:imagePath atomically:YES];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSURL *mediaUrl;
    
    UIImage *image;
    
    mediaUrl = (NSURL *)[info valueForKey:UIImagePickerControllerMediaURL];
    
    
    if (mediaUrl == nil)
    {
        image = (UIImage *) [info valueForKey:UIImagePickerControllerEditedImage];
        
        if (image == nil)
        {
            image = (UIImage *) [info valueForKey:UIImagePickerControllerOriginalImage];
            CGSize objCGSize = CGSizeMake(100, 100);
            image = [self scaledImageForImage:image newSize:objCGSize];
            [self saveImage:image];
            
        }
        else
        {
            [self saveImage:image];
        }
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

-(UIImage *)scaledImageForImage:(UIImage*)mimage newSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [mimage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
// ***** Modified by Harshitha ends here *****

@end
