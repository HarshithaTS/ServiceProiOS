//
//  ServerAttachment.m
//  GssServicePro
//
//  Created by Riyas Hassan on 18/07/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "ServerAttachment.h"


@implementation ServerAttachment

@synthesize attachmentContent;
@synthesize attachmentID;
@synthesize attachmentObjectSSRID;
@synthesize attachmentObjectType;
@synthesize orderId;
@synthesize orderTaskNumExtension;
@synthesize searchString;

@synthesize tableName;

- (void) downloadServerAttachmentContentFromSAP:(NSMutableArray*)inputArray
{
    
    objServiceMngtCls = [[GssMobileConsoleiOS alloc] init];
    objServiceMngtCls.CRMdelegate = self;
    
    
    objServiceMngtCls.ApplicationName           = @"SERVICEPRO";
    objServiceMngtCls.ApplicationVersion        = @"0";
    objServiceMngtCls.ApplicationResponseType   = @"";//@"FULL-SETS";
    objServiceMngtCls.ApplicationEventAPI       = @"DOCUMENT-ATTACHMENT-GET";
    objServiceMngtCls.InputDataArray            = inputArray;

    objServiceMngtCls.DatabaseCreateFlag        = @"2";
    objServiceMngtCls.Options                   = @"GETDATA";
    objServiceMngtCls.OtherString               = @"";
    
    objServiceMngtCls.objectType                = @"DocAttch";
    
    objGCDThreads = [GCDThreads sharedInstance];
    
    [objServiceMngtCls callSOAPWebMethod];
 
    
}

-(void)GssMobileConsoleiOS_Response_Message:(NSString*)msg_type andMsgDesc :(NSString*)message andFLD:(NSMutableArray *) FLD_VC{
    
    
    NSLog(@"SAPCRMMobileAppConsole Return Message Type: %@",msg_type);
    
    
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    
    [userInfo setObject:msg_type    forKey:@"action"];
    [userInfo setObject:message     forKey:@"responseMsg"];
    
    if (FLD_VC)
    {
        [userInfo setObject:FLD_VC      forKey:@"FLD_VC"];
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadingServerAttachment" object:nil userInfo:userInfo];
    
    
}

- (NSMutableArray*) getServerAttachmnetsForOrder:(NSString*)serviceOrder andExtNum:(NSString*)num
{
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    
    objServiceMngtCls.TargetDatabase    = serviceRepotsDB;

//  Original code
//    objServiceMngtCls.qryString         = [NSString stringWithFormat:@"SELECT * FROM ZGSXCAST_ATTCHMNT01 WHERE OBJECT_ID = '%@' AND (NUMBER_EXT=%@ OR NUMBER_EXT='')",serviceOrder,num];
    
//  Modified by Harshitha
    tableName = [SERVICEORDER_OBJTYPE stringByAppendingString:@"ZGSXCAST_ATTCHMNT01"];
    objServiceMngtCls.qryString         = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE OBJECT_ID = '%@' AND (NUMBER_EXT='%@' OR NUMBER_EXT='')",tableName,serviceOrder,num];
    
    NSMutableArray  *attachmentsArray = [objServiceMngtCls fetchDataFrmSqlite];
    
    NSMutableArray * serverAttachmentsArray = [NSMutableArray new];
    
    for (NSDictionary *serverAttchmentDic in attachmentsArray)
    {
        ServerAttachment * attachment   = [ServerAttachment new];
        attachment.attachmentContent    = [serverAttchmentDic valueForKey:@"ATTCHMNT_CNTNT"];
        attachment.attachmentID         = [serverAttchmentDic valueForKey:@"ATTCHMNT_ID"];
        attachment.attachmentObjectSSRID= [serverAttchmentDic valueForKey:@"OBJECT_ZZSSRID"];
        attachment.attachmentObjectType = [serverAttchmentDic valueForKey:@"OBJECT_TYPE"];
        attachment.orderId              = [serverAttchmentDic valueForKey:@"OBJECT_ID"];
        attachment.orderTaskNumExtension= [serverAttchmentDic valueForKey:@"NUMBER_EXT"];
        attachment.searchString         = [serverAttchmentDic valueForKey:@"SEARCH_STRING"];
        [serverAttachmentsArray addObject:attachment];
    }

    
    return serverAttachmentsArray;
}

- (void)saveDownloadedAttachmentInDbForOrder:(NSString*)serviceOrder attachmentId:(NSString*)attachemntId andContent:(NSString*)contenetStr
{
    objServiceMngtCls                   = [[GssMobileConsoleiOS alloc] init];
    
    objServiceMngtCls.TargetDatabase    = serviceRepotsDB;

// Original code
//    objServiceMngtCls.qryString         = [NSString stringWithFormat:@"UPDATE ZGSXCAST_ATTCHMNT01 set ATTCHMNT_CNTNT = '%@' WHERE OBJECT_ID = '%@' AND ATTCHMNT_ID = '%@'",contenetStr,serviceOrder,attachemntId];
    
//  Modified by Harshitha
    tableName = [SERVICEORDER_OBJTYPE stringByAppendingString:@"ZGSXCAST_ATTCHMNT01"];
    objServiceMngtCls.qryString         = [NSString stringWithFormat:@"UPDATE '%@' set ATTCHMNT_CNTNT = '%@' WHERE OBJECT_ID = '%@' AND ATTCHMNT_ID = '%@'",tableName,contenetStr,serviceOrder,attachemntId];

    BOOL updated = [objServiceMngtCls excuteSqliteQryString];

    NSLog(@"Success:? : %d",updated);

}




@end
