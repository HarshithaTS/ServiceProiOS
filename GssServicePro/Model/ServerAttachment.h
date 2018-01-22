//
//  ServerAttachment.h
//  GssServicePro
//
//  Created by Riyas Hassan on 18/07/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GssMobileConsoleiOS.h"

@interface ServerAttachment : NSObject<GssMobileConsoleiOSDelegate>

{
    GssMobileConsoleiOS *objServiceMngtCls;
    GCDThreads *objGCDThreads;
}
@property (nonatomic, strong) NSString * orderId;
@property (nonatomic, strong) NSString * attachmentObjectType;
@property (nonatomic, strong) NSString * attachmentObjectSSRID;
@property (nonatomic, strong) NSString * orderTaskNumExtension;
@property (nonatomic, strong) NSString * attachmentID;
@property (nonatomic, strong) NSString * attachmentContent;
@property (nonatomic, strong) NSString * searchString;

@property (nonatomic, strong) NSString *tableName;

- (void) downloadServerAttachmentContentFromSAP:(NSMutableArray*)inputArray;

- (NSMutableArray*) getServerAttachmnetsForOrder:(NSString*)serviceOrder andExtNum:(NSString*)num;

- (void)saveDownloadedAttachmentInDbForOrder:(NSString*)serviceOrder attachmentId:(NSString*)attachemntId andContent:(NSString*)contenetStr;

@end
