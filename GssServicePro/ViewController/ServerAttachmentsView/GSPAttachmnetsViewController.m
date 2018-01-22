 //
//  GSPAttachmnetsViewController.m
//  GssServicePro
//
//  Created by Riyas Hassan on 18/07/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPAttachmnetsViewController.h"
#import "GSPCommonTableView.h"
#import "ServerAttachment.h"
#import "CheckedNetwork.h"
#import "GSPImagePreviewController.h"
#import "ServerAttachment.h"
#import "GSPDocViewerViewController.h"


@interface GSPAttachmnetsViewController ()
{
    int selectedIndex;
    ServerAttachment *selectedAttachment;
}

@property (nonatomic, strong) ServiceTask * serviceTask;

@property (nonatomic, strong) NSMutableArray *dataSourceArray;


@property (weak, nonatomic) IBOutlet GSPCommonTableView *attachmentsTableView;
@end


@implementation GSPAttachmnetsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withServiceOrder:(ServiceTask*)task
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
//   Original code
//        self.title          = @"Server Attachments";
//   Modified by Harshitha
        [self setNavigationTitleWithBrandImage:[NSString stringWithFormat:@"Attachments for Service Order#%@",task.serviceOrder]];
        self.serviceTask    = task;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
// Original code.....Moved to viewWillAppear() by Harshitha
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sapResponseHandler:) name:@"DownloadingServerAttachment" object:nil];
  
    [self getServerAttachments];
}

// Added by Harshitha starts here
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sapResponseHandler:) name:@"DownloadingServerAttachment" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
// Added by Harshitha ends here

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView Delegates and datasources

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (self.dataSourceArray.count <= 0)

        return 1;
    
    else
        
        return [self.dataSourceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"CellIdentifier";
    
    int nodeCount = [self.dataSourceArray count];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    if(IS_IPHONE) {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:12.0];
    }
    
    if (nodeCount == 0 && indexPath.row == 0)
    {
        cell.textLabel.text = @"Loading…";
    }
    else
    {
        ServerAttachment *attachment    = [self.dataSourceArray objectAtIndex:indexPath.row];
        cell.textLabel.text             = attachment.attachmentID;
        if (attachment.orderTaskNumExtension.length > 0) {
            cell.detailTextLabel.text       = [NSString stringWithFormat:@"%@ / %@",attachment.orderId,attachment.orderTaskNumExtension];
        }
		[self configurePlaceHolderImageInView:cell.imageView withAttachmentId:attachment.attachmentID];
    }
    
    return cell;
}

- (void) configurePlaceHolderImageInView:(UIImageView*)imageView withAttachmentId:(NSString*)attachmentID
{
    if ([[self checkAttachmentType:attachmentID] isEqualToString:@"pdf"] || [[self checkAttachmentType:attachmentID] isEqualToString:@"PDF"])
    {
        imageView.image = [UIImage imageNamed:@"pdf.png"];
    }
    else
    {
        imageView.image = [UIImage imageNamed:@"imageHolder.png"];
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSourceArray.count > 0) {
//        [self loadImageFromSAP:indexPath];
    }
    
    
}

-(void) getServerAttachments
{


    ServerAttachment * serverAttachment = [ServerAttachment new];
    
//    self.dataSourceArray = [serverAttachment getServerAttachmnetsForOrder:self.serviceTask.serviceOrder andExtNum:self.serviceTask.numberExtension];
    self.dataSourceArray = [serverAttachment getServerAttachmnetsForOrder:self.serviceTask.serviceOrder andExtNum:self.serviceTask.firstServiceItem];
    [self.attachmentsTableView reloadData];
    
    
}

- (void)sapResponseHandler:(NSNotification*)notification
{
    NSDictionary* userInfo          = notification.userInfo;
    NSString        * message       = [userInfo objectForKey:@"responseMsg"];
    NSMutableArray  * reponseArray  = [userInfo objectForKey:@"FLD_VC"];
    
    NSString * statusMessage;
    
    if ([notification.name isEqualToString:@"DownloadingServerAttachment"]) {
        
        statusMessage = @"Fetching attachment...";
    }
    
    
    if ([message isEqualToString:@"Loading Activity Indicator"])
    {
//        [SVProgressHUD showWithStatus:statusMessage];
        [SVProgressHUD showWithStatus:nil];
    }
    else if ([message isEqualToString:@"Stop Loading Activity Indicator"])
    {
        [self parseServerAttachmentContentData:reponseArray];
        
        [SVProgressHUD dismiss];
    }
    else
    {
        [SVProgressHUD dismiss];
    }

}



//-(void) loadImageFromSAP:(NSIndexPath *)indexPath{
-(void) loadImageFromSAP:(NSIndexPath *)indexPath serverAttachmentArray:(NSMutableArray *)serverAttachmentArray{

//     selectedAttachment = [self.dataSourceArray objectAtIndex:indexPath.row];
    selectedAttachment = [serverAttachmentArray objectAtIndex:indexPath.row-5];
    
//    selectedIndex = indexPath.row;
    selectedIndex = indexPath.row-5;
    
    if (selectedAttachment.attachmentContent.length <= 0)
    {
//        [SVProgressHUD showWithStatus:@"Downloading Content..."];
        [SVProgressHUD showWithStatus:nil];
        
        NSMutableArray *_inptArray = [[NSMutableArray alloc] init];
        
        //Creating datatype of service confirmation
        
        NSString *strPar4 = [NSString stringWithFormat:@"%@", @"DATA-TYPE ZGSXCAST_ATTCHMNTKEY01[.]OBJECT_ID[.]OBJECT_TYPE[.]NUMBER_EXT[.]ATTCHMNT_ID"];
        [_inptArray addObject:strPar4];
        
        NSString *strPar5 = [NSString stringWithFormat:@"ZGSXCAST_ATTCHMNTKEY01[.]%@[.]%@[.]%@",selectedAttachment.orderId,selectedAttachment.attachmentObjectType,selectedAttachment.orderTaskNumExtension];
        
        [_inptArray addObject:strPar5];
        
        //If Internet connection is there call do sap updates here
        
        if([CheckedNetwork connectedToNetwork])
        {
            ServerAttachment * serverAttachment = [ServerAttachment new];
            
            [serverAttachment downloadServerAttachmentContentFromSAP:_inptArray];
            
        }
        return;
    }
    
    [self openAttachmentViewWithAttachemnetId:selectedAttachment.attachmentID andContentString:selectedAttachment.attachmentContent];
    
}

- (void) parseServerAttachmentContentData:(NSMutableArray*)contentArray
{
    
    NSString * dataString = @"";
    NSString * extString  = @"";
    
    if (selectedIndex + 3 < contentArray.count ) {
        dataString   = [[contentArray objectAtIndex:selectedIndex + 3] objectAtIndex:6];
        extString    = [[contentArray objectAtIndex:selectedIndex + 3] objectAtIndex:5];
    }
    else
    {
        dataString   = [[contentArray objectAtIndex:3] objectAtIndex:6];
        extString    = [[contentArray objectAtIndex:3] objectAtIndex:5];
        
    }
    
    ServerAttachment *attachment = [ServerAttachment new];
    
    selectedAttachment.attachmentContent = dataString;
    
    [attachment saveDownloadedAttachmentInDbForOrder:selectedAttachment.orderId attachmentId:selectedAttachment.attachmentID andContent:dataString];
    [SVProgressHUD dismiss];
    [self openAttachmentViewWithAttachemnetId:extString andContentString:selectedAttachment.attachmentContent];
    
}

-(void) openAttachmentViewWithAttachemnetId:(NSString*)extString andContentString:(NSString*)dataString
{
    NSData* attachmentData   = [[GSPUtility sharedInstance] decodeBase64StringToData:dataString];
    
    if ([[self checkAttachmentType:extString] isEqualToString:@"pdf"] || [[self checkAttachmentType:extString] isEqualToString:@"PDF"])
    {
        [self showPDF:attachmentData andfileName:extString];
    }
    else if ([[self checkAttachmentType:extString] isEqualToString:@"png"] || [[self checkAttachmentType:extString] isEqualToString:@"BMP"] || [[self checkAttachmentType:extString] isEqualToString:@"tif"] || [[self checkAttachmentType:extString] isEqualToString:@"gif"] || [[self checkAttachmentType:extString] isEqualToString:@"jpg"] || [[self checkAttachmentType:extString] isEqualToString:@"jpeg"])
    {
        UIImage *image      = [UIImage imageWithData:attachmentData];
        [self showImage:image];
    }

}


- (NSString*) checkAttachmentType:(NSString*)attchmentExt
{
    NSRange range                   = [attchmentExt rangeOfString:@"."];
    
    NSString * extensionStr;
    
    if (range.length > 0) {
        extensionStr = [attchmentExt substringFromIndex:range.location+1];
    }
    return extensionStr;
}



-(void)showImage:(UIImage*)aImage
{
    GSPImagePreviewController * imagePreviewVC;
    if (IS_IPAD) {
        imagePreviewVC  = [[GSPImagePreviewController alloc]initWithNibName:@"GSPImagePreviewController_iPad" bundle:nil withImage:aImage];
    }
    else {
        imagePreviewVC  = [[GSPImagePreviewController alloc]initWithNibName:@"GSPImagePreviewController" bundle:nil withImage:aImage];
    }
    [self presentViewController:imagePreviewVC animated:YES completion:nil];
}

- (void)showPDF:(NSData*)pdfData andfileName:(NSString*)fileName
{
    GSPDocViewerViewController * docViewController;
    if (IS_IPAD) {
        docViewController = [[GSPDocViewerViewController alloc]initWithNibName:@"GSPDocViewerViewController_iPad" bundle:nil withData:pdfData andFileName:fileName];
    }
    else {
        docViewController = [[GSPDocViewerViewController alloc]initWithNibName:@"GSPDocViewerViewController" bundle:nil withData:pdfData andFileName:fileName];

    }
    [self.navigationController pushViewController:docViewController animated:YES];
}


@end
