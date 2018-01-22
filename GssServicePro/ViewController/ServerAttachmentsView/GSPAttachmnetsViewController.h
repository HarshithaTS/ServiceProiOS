//
//  GSPAttachmnetsViewController.h
//  GssServicePro
//
//  Created by Riyas Hassan on 18/07/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPBaseViewController.h"
#import "ServiceTask.h"

@interface GSPAttachmnetsViewController : GSPBaseViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withServiceOrder:(ServiceTask*)task;

-(void) getServerAttachments;

- (void) configurePlaceHolderImageInView:(UIImageView*)imageView withAttachmentId:(NSString*)attachmentID;

-(void) loadImageFromSAP:(NSIndexPath *)indexPath serverAttachmentArray:(NSMutableArray *)serverAttachmentArray;

- (void) parseServerAttachmentContentData:(NSMutableArray*)contentArray;

@end
