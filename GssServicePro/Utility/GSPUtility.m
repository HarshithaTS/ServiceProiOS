//
//  GSPUtility.m
//  GssServicePro
//
//  Created by Riyas Hassan on 24/06/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPUtility.h"

@implementation GSPUtility

// Get the shared instance and create it if necessary.

+ (id)sharedInstance
{
    static GSPUtility *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (NSMutableArray*)sortArray:(NSMutableArray*)array withKey:(NSString*)key ascending:(BOOL)isAscending
{
    
    NSSortDescriptor*  aSortDescriptor;
    
    aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:isAscending];
    
    return (NSMutableArray*)[array sortedArrayUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
}



- (void)showAlertWithTitle:(NSString*)title message:(NSString*)message otherButton:(NSString*)other tag:(int)tag andDelegate:(id)delegate
{
    
//    dispatch_sync(dispatch_get_main_queue(), ^(void){
    
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"OK" otherButtonTitles:other, nil];
        alertView.tag           = tag;
        [alertView show];
        
//     });
}

- (void) underLineButtonTitle:(UIButton*)button WithTitle:(NSString*)title
{
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:title];
    
    //[titleString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [titleString length])];
    NSDictionary *btnAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                              [UIFont boldSystemFontOfSize:13.0], NSFontAttributeName,
                              [UIColor whiteColor], NSForegroundColorAttributeName,
                              [NSNumber numberWithInteger:NSUnderlineStyleSingle],NSUnderlineStyleAttributeName,
                              nil];
    [titleString setAttributes:btnAttrs
                            range:NSMakeRange(0, titleString.length)];
    [button setAttributedTitle:titleString forState:UIControlStateNormal];
    button.layer.borderColor    = TABLE_HEADER_BORDERCOLOR;
    button.layer.borderWidth    = 0.7;
}

-(NSString *) getDocumentsFilePathWithFileName:(NSString *) fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:fileName];
}

- (NSString*) encodeStringWithdata:(NSData*)data
{
    NSString *base64String = [data base64EncodedStringWithOptions:0];
    return base64String;
}

- (NSData*) decodeBase64StringToData:(NSString*)base64String
{
    NSData *decodedData = [[NSData alloc]initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    return decodedData;
}

- (void) addSwipeGestureRecoganiserForTarget:(UIViewController*)swipeView withSelctor:(SEL)selector forDirection:(UISwipeGestureRecognizerDirection)direction
{
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:swipeView action:selector];
    [recognizer setDirection:(direction)];
    [swipeView.view addGestureRecognizer:recognizer];
    
}

- (NSString*) getSignatureFolderPathForFileName:(NSString*)strFileName forPathComponent:(NSString*)pathComponent
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                        NSUserDomainMask,
                                                                        YES) lastObject];
    NSString *attachedSignatureFolder = [documentsDirectory stringByAppendingPathComponent:pathComponent];
    
    BOOL isDir = NO;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    if (![fileManager fileExistsAtPath:attachedSignatureFolder isDirectory:&isDir] && isDir == NO) {
        
        [fileManager createDirectoryAtPath:attachedSignatureFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
   
    NSString *serviceOrderFolder = [attachedSignatureFolder stringByAppendingPathComponent:strFileName];
    BOOL isDir2 = NO;
    if (![fileManager fileExistsAtPath:serviceOrderFolder isDirectory:&isDir2] && isDir2 == NO) {
        
        [fileManager createDirectoryAtPath:serviceOrderFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }

    NSString *attachedSignature = [serviceOrderFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"Sig_%@.png",strFileName]];

    return attachedSignature;
}


- (NSString *)getMediaLocalPathForFileName:(NSString*)strFileName forPathComponent:(NSString*)pathComponent
{
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                        NSUserDomainMask,
                                                                        YES) lastObject];
    NSString *AttachedImagesFolder = [documentsDirectory stringByAppendingPathComponent:pathComponent];//@"AttchedImages"];

    BOOL isDir = NO;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    if (![fileManager fileExistsAtPath:AttachedImagesFolder isDirectory:&isDir] && isDir == NO) {
        
        [fileManager createDirectoryAtPath:AttachedImagesFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
   
    NSString *serviceOrderFolder = [AttachedImagesFolder stringByAppendingPathComponent:strFileName];
    BOOL isDir2 = NO;
    if (![fileManager fileExistsAtPath:serviceOrderFolder isDirectory:&isDir2] && isDir2 == NO) {
        
        [fileManager createDirectoryAtPath:serviceOrderFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return serviceOrderFolder;
}



- (NSMutableArray*) getAttachedImagesFromLocalFolder:(NSString*)folderName forPathComponent:(NSString*)pathComponent
{
    NSString *documentsDirectory        = [[GSPUtility sharedInstance] getMediaLocalPathForFileName:folderName forPathComponent:pathComponent];
    NSError * error;
    NSMutableArray * directoryContents  =  (NSMutableArray*)[[NSFileManager defaultManager]contentsOfDirectoryAtPath:documentsDirectory error:&error];

    return directoryContents;
}


- (void)deleteFilesFromDocumentFolders:(NSString*)filePath
{

    [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];

}

- (void) deleteServiceConfirmationDocsDirectory:(NSString*)dirPath
{
    NSArray *paths          = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSMutableString *path   = [NSMutableString stringWithString:[paths objectAtIndex:0]];
    [path appendString:[NSString stringWithFormat:@"/%@",dirPath]];
    BOOL deleted            =  [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    NSLog(@"Deleted : %d",deleted);
}

@end
