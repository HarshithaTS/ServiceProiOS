//
//  GSPUtility.h
//  GssServicePro
//
//  Created by Riyas Hassan on 24/06/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSPUtility : NSObject

+ (id)sharedInstance;

- (void)showAlertWithTitle:(NSString*)title message:(NSString*)message otherButton:(NSString*)other tag:(int)tag andDelegate:(id)delegate;

- (void) underLineButtonTitle:(UIButton*)button WithTitle:(NSString*)title;

- (NSMutableArray*)sortArray:(NSMutableArray*)array withKey:(NSString*)key ascending:(BOOL)isAscending;

- (NSString*) getDocumentsFilePathWithFileName:(NSString *) fileName;

- (NSString*) encodeStringWithdata:(NSData*)data;

- (NSData*) decodeBase64StringToData:(NSString*)base64String;

- (void) addSwipeGestureRecoganiserForTarget:(UIViewController*)swipeView withSelctor:(SEL)selector forDirection:(UISwipeGestureRecognizerDirection)direction;

- (NSString*) getSignatureFolderPathForFileName:(NSString*)strFileName forPathComponent:(NSString*)pathComponent;

- (NSString *)getMediaLocalPathForFileName:(NSString*)strFileName forPathComponent:(NSString*)pathComponent;

- (NSMutableArray*) getAttachedImagesFromLocalFolder:(NSString*)folderName forPathComponent:(NSString*)pathComponent;

- (void) deleteFilesFromDocumentFolders:(NSString*)filePath;

- (void) deleteServiceConfirmationDocsDirectory:(NSString*)dirPath;

@end
