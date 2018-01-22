//
//  PDFRenderer.m

#import "PDFRenderer.h"
#import "CoreText/CoreText.h"
#import "ServiceTask.h"
#import "GSPUtility.h"
#import "GSPDateUtility.h"


#define kDefaultPageHeight 792
#define kDefaultPageWidth  612
#define kMargin 50
#define kPadding 20

@implementation PDFRenderer


+ (id)sharedInstance
{
    static PDFRenderer *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}
/*
- (void)drawPDFFromTableForServicOrder:(NSString*)serviceOrder  WithTableViewView:(UITableView*)tableView withAttacments:(NSMutableArray*)attachments andSignature:(UIImage*)signatureImage
{
    // Create the PDF context
    
   NSString * fileName =  [self getPdfFileName:serviceOrder];
    
    UIGraphicsBeginPDFContextToFile(fileName, CGRectZero, nil);

    pdfTableHeight = 1000;

    pdfTableHeight              = tableView.frame.size.height + 200;
    
    CGFloat pdfHeight = pdfTableHeight;
    
    if (signatureImage)
    {
        pdfHeight       = pdfHeight + signatureImage.size.height + 5;
    }
    
    if (attachments.count > 0) {
        for (NSString *imagesFilePath in attachments)
        {
            //NSString    * folderPath       = [[GSPUtility sharedInstance] getMediaLocalPathForFileName:serviceOrder forPathComponent:@"AttchedImages"];
            //UIImage     * image            = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",folderPath,imagesFilePath]];
           
            pdfHeight   = pdfHeight + 700 + 10 ;
            
        }

    }
    
    
    
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 20, 700, pdfHeight), nil);
    
    [self drawLabelsOfTable:tableView];
   //  UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 20, 700, pdfHeight), nil);
   // [self drawLabelsOfTable:tableView1];
    [self drawAttacmentImagesInPdf:attachments andSignatureImage:signatureImage forServiceOrder:serviceOrder];
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
}


//Another Method Generating pdf of a view

- (void)drawPDFOfViewForServicOrder:(NSString *)serviceOrder WithView:(UIView *)sView withAttacments:(NSMutableArray *)attachments andSignature:(UIImage *)signatureImage
{
    
//    NSString * fileName =  [self getPdfFileName:serviceOrder];
    if (! UIGraphicsBeginPDFContextToFile(fileName, CGRectZero, nil)) {
        NSLog(@"error creating PDF context");
        return;
    }
    
    UIGraphicsBeginPDFPage();
    
    [sView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIGraphicsEndPDFContext();
}
*/
-(NSString*)getPdfFileName:(NSString*)serviceOrder
{
    NSString* fileName = [NSString stringWithFormat:@"%@.PDF", serviceOrder];
    
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];
//    CGPDFDocumentRef document = CGPDFDocumentCreateWithURL((CFURLRef)pdfFileName);
//    size_t pageCount = CGPDFDocumentGetNumberOfPages(document);
//    NSLog(@"page count %zu",pageCount);
    return pdfFileName;
    
}

- (void)drawImage:(UIImage*)image inRect:(CGRect)rect
{

    [image drawInRect:rect];

}

- (void)drawLabelsOfTable:(UITableView*)tableView
{

    for (int section = 0; section < [tableView numberOfSections]; section++)
    {
        for (int row = 0; row < [tableView numberOfRowsInSection:section]; row++)
        {
            NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:section];
            UITableViewCell* cell = [tableView cellForRowAtIndexPath:cellPath];
            
            
            if (cell.frame.size.height != 0)
            {
                for (UIView * cellSubviews in [cell subviews])
                {
                    for (UIView *contentViewSubviews in [cellSubviews subviews])
                    {
                       
                        
                        if ([SYSTEM_VERSION floatValue] >= 8.0)
                        {
                            [self plotLabelsInPDFWithLabel:contentViewSubviews andCell:cell];
                        }
                        else
                        {
                            
                            for (id labelView  in [contentViewSubviews subviews])
                            {
                                [self plotLabelsInPDFWithLabel:labelView andCell:cell];
                            }
                        }
                        
                        

                    }
                    
                }
            }
        }
    }
    
    
}

- (void)plotLabelsInPDFWithLabel:(UIView*)labelView andCell:(UITableViewCell*)cell
{
    
    
    
    //UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
    
    
    
    if([labelView isKindOfClass:[UILabel class]])
    {
        UILabel* label = (UILabel*)labelView;
        
        NSDictionary *attrsDictionary =[NSDictionary dictionaryWithObjectsAndKeys:label.font, NSFontAttributeName,[NSNumber numberWithFloat:1.0], NSBaselineOffsetAttributeName, nil];
        
        CGRect newRect ;
        
        if (label.numberOfLines > 3)
        {
            newRect = CGRectMake(label.frame.origin.x, cell.frame.origin.y+30 , label.frame.size.width, 60);
        }
        else if (label.tag == 501)
            
            newRect = CGRectMake(label.frame.origin.x, cell.frame.origin.y+30 , label.frame.size.width, 60);
        
        else if (label.tag == 502)
            
            newRect = CGRectMake(label.frame.origin.x, cell.frame.origin.y+60 , label.frame.size.width, 60);
        
        else if (label.tag == 503)
            
            newRect = CGRectMake(label.frame.origin.x, cell.frame.origin.y+90 , label.frame.size.width, 60);
        
        else if (label.tag == 504)
            
            newRect = CGRectMake(label.frame.origin.x, cell.frame.origin.y+120 , label.frame.size.width, 60);
        
        else if (label.tag == 505)
            
            newRect = CGRectMake(label.frame.origin.x, cell.frame.origin.y+150 , label.frame.size.width, 60);
        
        else if (label.tag == 506)
            
            newRect = CGRectMake(label.frame.origin.x, cell.frame.origin.y+180 , label.frame.size.width, 60);
        
        else if (label.tag == 507)
            
            newRect = CGRectMake(label.frame.origin.x, cell.frame.origin.y+210 , label.frame.size.width - 30, 60);
        else if(label.tag==333)
            newRect=CGRectMake(300, cell.frame.origin.y, label.frame.size.width, 20);
        else if(label.tag==444)
            newRect=CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, 20);
        else
            newRect = CGRectMake(label.frame.origin.x, cell.frame.origin.y , label.frame.size.width, 20);
        
        if (!label.hidden)
        {
            [label.text drawInRect:newRect withAttributes:attrsDictionary];
            
        }
        
    }
    else if ([labelView isKindOfClass:[UITextView class]])
    {
        UITextView* textView = (UITextView*)labelView;
        
        NSDictionary *attrsDictionary =[NSDictionary dictionaryWithObjectsAndKeys:textView.font, NSFontAttributeName,[NSNumber numberWithFloat:1.0], NSBaselineOffsetAttributeName, nil];
        
        CGRect newRect = CGRectMake(textView.frame.origin.x, cell.frame.origin.y , textView.frame.size.width, 60);
        
        [textView.text drawInRect:newRect withAttributes:attrsDictionary];
    }

    else if ([labelView isKindOfClass:[UIButton class]])
    {
        UIButton* dropDownBtn = (UIButton*)labelView;
        CGRect newRect = CGRectMake(dropDownBtn.frame.origin.x, cell.frame.origin.y , dropDownBtn.frame.size.width, 40);
        
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
        
        NSDictionary *attrsDictionary =[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,[NSNumber numberWithFloat:1.0], NSBaselineOffsetAttributeName, nil];
        
        NSString *statusString  = dropDownBtn.currentTitle;
        
        if (!dropDownBtn.hidden && statusString != nil)
        {
            [statusString drawInRect:newRect withAttributes:attrsDictionary];
        }
        
        
        
    }
    
}

-(void)drawAttacmentImagesInPdf:(NSMutableArray*)attachmentImages andSignatureImage:(UIImage*)signatureImage forServiceOrder:(NSString*)serviceOrder withTranslatedDic:(NSDictionary*)translatedDic
{
    int i = 50;
    
 //CGFloat yAxis = pdfTableHeight;
   
    
    //CGFloat yAxis = kDefaultPageHeight;
    if (signatureImage)
    {
       // [self drawUnderlinedText:@"Attached Signature" withFont:[UIFont boldSystemFontOfSize:16.0] andColor:[UIColor blackColor] andLocationX:20 andLocationY:yAxis - 20 andTextAreaWidth:150 andTextAreaHeight:20];
        
        [self drawImage:signatureImage inRect:CGRectMake(500, yaxis + 30, 200, signatureImage.size.height)];
        yaxis = yaxis + 60 + signatureImage.size.height;
        NSString *signatureTime=[[NSUserDefaults standardUserDefaults]stringForKey:serviceOrder];
        
        [self addText:[NSString stringWithFormat:@"Signed on    \n%@",signatureTime] withFrame:CGRectMake(450, 550, 200, 80) withFontName:@"Helvetica"fontSize:14.0];

    }
    
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 700, 1000), nil);
    NSString* fileName = [NSString stringWithFormat:@"%@.PDF", serviceOrder];
    
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];
//        CGPDFDocumentRef document = CGPDFDocumentCreateWithURL((CFURLRef)pdfFileName);
//        size_t pageCount = CGPDFDocumentGetNumberOfPages(document);
//        NSLog(@"page count %zu",pageCount);

    if (attachmentImages.count > 0)
    {
        [self drawUnderlinedText:[translatedDic objectForKey:@"Other_Attachments"] withFont:[UIFont boldSystemFontOfSize:16.0] andColor:[UIColor blackColor] andLocationX:20 andLocationY:20 andTextAreaWidth:150 andTextAreaHeight:20];
    }
    
    for (NSString *imagesFilePath in attachmentImages)
    {
        
        yaxis=0;
        NSString    * folderPath       = [[GSPUtility sharedInstance] getMediaLocalPathForFileName:serviceOrder forPathComponent:@"AttchedImages"];
        UIImage     * image            = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",folderPath,imagesFilePath]];
        
        [self drawImage:image inRect:CGRectMake(30, yaxis + i, 650, 600)];
      UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 700, 1000), nil);

        i = 10;
    }

}

- (void)drawUnderlinedText:(NSString *)text withFont:(UIFont *)font andColor:(UIColor *)color andLocationX:(int)locationX andLocationY:(int)locationY andTextAreaWidth:(int)textWidth andTextAreaHeight:(int)textHeight{
    
    NSDictionary *attributesDict;
    NSMutableAttributedString *attString;
    
    // Commented out until iOS bug is resolved:
    //attributesDict = @{NSUnderlineStyleAttributeName : [NSNumber numberWithInt:NSUnderlineStyleSingle], NSForegroundColorAttributeName : color, NSFontAttributeName : font};
    attributesDict = @{NSForegroundColorAttributeName : color, NSFontAttributeName : font};
    attString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributesDict];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGRect rect = CGRectMake(locationX, locationY, textWidth, textHeight);
    
    // Temporary Solution to NSUnderlineStyleAttributeName - Bug:
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 1.0f);
    
    CGSize tmpSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(200, 9999)];
    
    CGContextMoveToPoint(context, locationX, locationY + tmpSize.height - 1);
    CGContextAddLineToPoint(context, locationX + tmpSize.width, locationY + tmpSize.height - 1);
    
    CGContextStrokePath(context);
    // End Temporary Solution
    
    [attString drawInRect:rect];
}

- (NSData *)pdfDataOfScrollView:(NSString *)serviceOrder andOneTableView :(UIScrollView *)scrollView andTableView :(UIScrollView *)scrollView1 withAttacments:(NSMutableArray*)attachments andSignature:(UIImage*)signatureImage
{
    //                                                    andTableViewwithAttacments:(NSMutableArray*)attachments andSignature:(UIImage*)signatureImage{
    CGRect origFrame = scrollView.frame;
    CGRect origFrame1 = scrollView1.frame;
    
    BOOL horizontalScrollIndicator = [scrollView showsHorizontalScrollIndicator];
    BOOL verticalScrollIndicator = [scrollView showsVerticalScrollIndicator];
//    BOOL horizontalScrollIndicator1 = [scrollView1 showsHorizontalScrollIndicator];
//    BOOL verticalScrollIndicator1 = [scrollView1 showsVerticalScrollIndicator];
    NSMutableData *pdfFile = [[NSMutableData alloc] init];
    
    
    //    CGDataConsumerRef pdfConsumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef) pdfFile);
    //    CGRect mediaBox = CGRectZero;
    CGFloat maxHeight = kDefaultPageHeight - 2 * kMargin;
    CGFloat maxWidth = kDefaultPageWidth - 2 * kMargin;
    CGFloat height = scrollView.contentSize.height;
    CGFloat height1 = scrollView1.contentSize.height;
    // Set up we the pdf we're going to be generating is
    [scrollView setFrame:CGRectMake(0.f, 0.f, maxWidth, maxHeight)];
    [scrollView1 setFrame:CGRectMake(0.f, 0.f, maxWidth, maxHeight)];
    
    NSInteger pages = (NSInteger) ceil(height / maxHeight);
    
    NSMutableData *pdfData = [NSMutableData data];
   // [self prepareForCapture:scrollView];
   // [self prepareForCapture:scrollView1];
    UIGraphicsBeginPDFContextToData(pdfData, CGRectZero, nil);
    for (int i = 0 ;i < pages ;i++){
        if (maxHeight * (i + 1) > height){
            // Check to see if page draws more than the height of the UIWebView
            CGRect scrollViewFrame = [scrollView frame];
            CGRect scrollViewFrame1 = [scrollView1 frame];
            scrollViewFrame.size.height -= (((i + 1) * maxHeight) - height);
             scrollViewFrame1.size.height -= (((i + 1) * maxHeight) - height1);
            [scrollView setFrame:scrollViewFrame];
            [scrollView1 setFrame:scrollViewFrame1];
        }
        
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        
        
        //
        //
        // Specify the size of the pdf page
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, kDefaultPageWidth, kDefaultPageHeight), nil);
        
        
        //[self drawPageNumber:(i + 1)];
        // Move the context for the margins
        
        CGContextTranslateCTM(currentContext, kMargin, -(maxHeight * i) + kMargin);
        
        [scrollView setContentOffset:CGPointMake(0, maxHeight * i) animated:NO];
        // draw the layer to the pdf, ignore the "renderInContext not found" warning.
        [scrollView.layer renderInContext:currentContext];
        
        
        
        CGContextRef currentContext1 = UIGraphicsGetCurrentContext();
       
        
        //
        //
        // Specify the size of the pdf page
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, kDefaultPageWidth, kDefaultPageHeight), nil);
        
        
        //[self drawPageNumber:(i + 1)];
        // Move the context for the margins
        
        CGContextTranslateCTM(currentContext1, kMargin, -(maxHeight * i) + kMargin);
        
        [scrollView1 setContentOffset:CGPointMake(0, maxHeight * i) animated:NO];
        // draw the layer to the pdf, ignore the "renderInContext not found" warning.
       [scrollView1.layer renderInContext:currentContext1];
        
         UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, kDefaultPageWidth, kDefaultPageHeight), nil);
//        
//         [self drawAttacmentImagesInPdf:attachments andSignatureImage:signatureImage forServiceOrder:serviceOrder withTranslatedDic:];
//        
        
    }
    // all done with making the pdf
    
    UIGraphicsEndPDFContext();
   //[scrollView1 setFrame:CGRectMake(379, 94, 634, 588)];
    
//
    [scrollView setFrame:origFrame];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    [scrollView setShowsHorizontalScrollIndicator:horizontalScrollIndicator];
   [scrollView setShowsVerticalScrollIndicator:verticalScrollIndicator];
    [scrollView1 setFrame:origFrame1];
    [scrollView1 setContentOffset:CGPointMake(0, 0) animated:NO];
    [scrollView1 setShowsHorizontalScrollIndicator:horizontalScrollIndicator];
    [scrollView1 setShowsVerticalScrollIndicator:verticalScrollIndicator];

//    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
//    if(UIInterfaceOrientationIsLandscape(interfaceOrientation)){
//        [scrollView1 setFrame :CGRectMake(379, 94, 634, 560)];
//    }
//    else if(UIInterfaceOrientationIsPortrait(interfaceOrientation)){
//        [scrollView1 setFrame:CGRectMake(379, 94, 634, 560)];
//    }
   
       return pdfData;
}


+ (void)prepareForCapture:(UIScrollView *)scrollView {
    [scrollView setContentOffset:CGPointZero animated:NO];
    
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
}


- (void)drawPDFofTableForServicOrder:(NSString*)serviceOrder withObject :(ServiceTask*)serviceObject  WithArray:(NSMutableArray*)serviceArray withAttacments:(NSMutableArray*)attachments andSignature:(UIImage*)signatureImage withTranslatedDictionary:translatedDic
{
    // Create the PDF context
    
    
    
    NSString * fileName =  [self getPdfFileName:serviceOrder];
    
    UIGraphicsBeginPDFContextToFile(fileName, CGRectZero, nil);
    
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 700, 1000), nil);
    [self drawPageNumber:1];
    UIImage *anImage = [UIImage imageNamed:@"gss_logo.png"];
    CGRect imageRect = [self addImage:anImage
                              atPoint:CGPointMake(20,10)];
    
    NSDateFormatter *dateformater = [[NSDateFormatter alloc]init];
    [dateformater setDateFormat:@"MMM dd,yyyy"];
    NSString *date_String=[dateformater stringFromDate:[NSDate date]];
    CGRect textRect0 = [self addText:date_String
                           withFrame:CGRectMake(40, 70, 0, 0) withFontName:@"Helvetica"  fontSize:16.0f];
    CGRect textRect1 = [self addText:serviceObject.serviceLocation
                          withFrame:CGRectMake(450, 10, 230, 60) withFontName:@"Helvetica-Bold"  fontSize:18.0f];
    CGRect textRect2 = [self addText:serviceObject.locationAddress1
                          withFrame:CGRectMake(450, 30, 230, 60) withFontName:@"Helvetica" fontSize:16.0f];
    CGRect textRect3 = [self addText:serviceObject.locationAddress2
                           withFrame:CGRectMake(450, 50, 230, 60) withFontName:@"Helvetica"  fontSize:16.0f];
    CGRect textRect4 = [self addText:serviceObject.locationAddress3
                           withFrame:CGRectMake(450, 70, 230, 60) withFontName:@"Helvetica" fontSize:16.0f];
    
    CGRect textRect5 = [self addText:[translatedDic objectForKey:@"Field_Service_Report"]
                           withFrame:CGRectMake(220, 50, 0, 0) withFontName:@"Helvetica-Bold" fontSize:24.0f];
    
    yaxis =150;
        CGRect textRect6 = [self addText:[translatedDic objectForKey:@"Service_Document"]
                           withFrame:CGRectMake(40, yaxis, 0, 0) withFontName:@"Helvetica-Bold" fontSize:16.0f];
    CGRect textRect7 = [self addText:serviceObject.serviceOrder
                           withFrame:CGRectMake(250, yaxis, 0, 0) withFontName:@"Helvetica" fontSize:16.0f];
    CGRect textRect8 = [self addText:[translatedDic objectForKey:@"Priority"]                           withFrame:CGRectMake(450, yaxis, 0, 0) withFontName:@"Helvetica-Bold" fontSize:16.0f];
    CGRect textRect9 = [self addText:serviceObject.priority
                           withFrame:CGRectMake(600, yaxis, 0, 0) withFontName:@"Helvetica" fontSize:16.0f];
    if ([serviceObject.serviceOrderDescription isEqualToString:@""] || [serviceObject.serviceOrderDescription isEqual:[NSNull null]] || serviceObject.serviceOrderDescription == nil)   {
        CGRect blueLineRect = [self addLineWithFrame:CGRectMake(kPadding, textRect9.origin.y + textRect9.size.height + kPadding, 700 - kPadding*2, 4)
                                           withColor:[UIColor blackColor]];

        
    }
    else{
        
        yaxis=yaxis+40;
    CGRect textRect10 = [self addText:[translatedDic objectForKey:@"Service_Description"]
                           withFrame:CGRectMake(40, textRect6.origin.y + textRect6.size.height + kPadding, 0, 0) withFontName:@"Helvetica-Bold" fontSize:16.0f];

    CGRect textRect11 = [self addText:serviceObject.serviceOrderDescription
                           withFrame:CGRectMake(250, textRect6.origin.y + textRect6.size.height + kPadding, 0, 0) withFontName:@"Helvetica"  fontSize:16.0f];
    CGRect blueLineRect = [self addLineWithFrame:CGRectMake(kPadding, textRect10.origin.y + textRect10.size.height + kPadding, 700 - kPadding*2, 4)
                                       withColor:[UIColor blackColor]];
}
    if([serviceObject.partner isEqualToString:@"" ]||[serviceObject.partner isEqual:[NSNull null]]||serviceObject.partner==nil){
        
    }
    else{
        yaxis=yaxis+100;
    CGRect textRect12 = [self addText:[translatedDic objectForKey:@"Other_Details"]
                            withFrame:CGRectMake(40, yaxis-40, 0, 0) withFontName:@"Helvetica-Bold" fontSize:16.0f];
    CGRect textRect13 = [self addText:serviceObject.partner
                            withFrame:CGRectMake(40, yaxis, 0, 0) withFontName:@"Helvetica" fontSize:16.0f];
        CGRect blueLineRect = [self addLineWithFrame:CGRectMake(kPadding, textRect13.origin.y + textRect13.size.height + kPadding, 700 - kPadding*2, 4)
                                           withColor:[UIColor blackColor]];
    }
    if([serviceObject.fieldNote isEqualToString:@""]||[serviceObject.fieldNote isEqual:[NSNull null]]||serviceObject.fieldNote==nil){
        
    }
    else{
        yaxis=yaxis+100;
        CGRect textRect14 = [self addText:[translatedDic objectForKey:@"Field_Note"]                                withFrame:CGRectMake(40, yaxis-40, 0, 0) withFontName:@"Helvetica-Bold" fontSize:16.0f];
        CGRect textRect15 = [self addText:serviceObject.fieldNote
                                withFrame:CGRectMake(40, yaxis, 0, 0) withFontName:@"Helvetica" fontSize:16.0f];
        CGRect blueLineRect = [self addLineWithFrame:CGRectMake(kPadding, textRect15.origin.y + textRect15.size.height + kPadding, 700 - kPadding*2, 4)
                                           withColor:[UIColor blackColor]];

    }
    yaxis=yaxis+60;
    CGRect textRect16=[self addText:[translatedDic objectForKey:@"Start_Time"]   withFrame:CGRectMake(40, yaxis, 0, 0) withFontName:@"Helvetica-Bold" fontSize:16.0f];
     CGRect textRect17=[self addText:[[GSPDateUtility sharedInstance] convertHHMMSStoHHMM:serviceObject.startDateAndTime]  withFrame:CGRectMake(170, yaxis, 0, 0) withFontName:@"Helvetica" fontSize:16.0f];
    
    if([serviceObject.contactName isEqualToString:@""]){
        
    }
    else{
    CGRect textRect18=[self addText:[translatedDic objectForKey:@"Contact"] withFrame:CGRectMake(430, yaxis, 0, 0) withFontName:@"Helvetica-Bold" fontSize:16.0f];
    CGRect textRect21=[self addText:serviceObject.contactName withFrame:CGRectMake(500, yaxis, 0, 0) withFontName:@"Helvetica" fontSize:16.0f];
    }
    if(![serviceObject.telNum isEqualToString:@""]&&![serviceObject.altTelNum isEqualToString:@""]){
        CGRect textRect22=[self addText:serviceObject.telNum withFrame:CGRectMake(500, yaxis+20, 0, 0) withFontName:@"Helvetica" fontSize:16.0f];
        CGRect textRect23=[self addText:serviceObject.altTelNum withFrame:CGRectMake(500, yaxis+40, 0, 0) withFontName:@"Helvetica" fontSize:16.0f];
        
    }
    else if(![serviceObject.telNum isEqualToString:@""]){
        CGRect textRect24=[self addText:serviceObject.telNum withFrame:CGRectMake(500, yaxis+20, 0, 0)withFontName:@"Helvetica"  fontSize:16.0f];
    }
    else if(![serviceObject.altTelNum isEqualToString:@""]){
        CGRect textRect25=[self addText:serviceObject.altTelNum withFrame:CGRectMake(500, yaxis+20, 0, 0) withFontName:@"Helvetica" fontSize:16.0f];
    }
  
    
    yaxis=yaxis+40;
    CGRect textRect19=[self addText:[translatedDic objectForKey:@"End_Time"] withFrame:CGRectMake(40, yaxis, 0, 0) withFontName:@"Helvetica-Bold" fontSize:16.0f];
    CGRect textRect20=[self addText:[[GSPDateUtility sharedInstance]convertHHMMSStoHHMM:[NSString stringWithFormat:@"%@ %@",serviceObject.estimatedArrivalDate,serviceObject.estimatedArrivalTime]] withFrame:CGRectMake(170, yaxis, 0, 0) withFontName:@"Helvetica" fontSize:16.0f];
    [self drawAttacmentImagesInPdf:attachments andSignatureImage:signatureImage forServiceOrder:serviceOrder withTranslatedDic:translatedDic];
 
 // [self drawText:serviceObject.serviceLocation inFrame:CGRectMake(0, 30, 300, 40)];
    //  UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 20, 700, pdfHeight), nil);
    // [self drawLabelsOfTable:tableView1];
 //   [self drawAttacmentImagesInPdf:attachments andSignatureImage:signatureImage forServiceOrder:serviceOrder];
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
}

+(void)drawText:(NSString*)textToDraw inFrame:(CGRect)frameRect
{
    
    CFStringRef stringRef = (__bridge CFStringRef)textToDraw;
    // Prepare the text using a Core Text Framesetter
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, NULL);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
    
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get the graphics context.
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    CGContextTranslateCTM(currentContext, 0, frameRect.origin.y*2);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    CGContextTranslateCTM(currentContext, 0, (-1)*frameRect.origin.y*2);
    
    
    CFRelease(frameRef);
    CFRelease(stringRef);
    CFRelease(framesetter);
}

- (CGRect)addText:(NSString*)text withFrame:(CGRect)frame withFontName:(NSString*)fontName fontSize:(float)fontSize {
    //UIFont *font = [UIFont systemFontOfSize:fontSize];
    UIFont *font=[UIFont fontWithName:fontName size:fontSize];
    CGSize stringSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(700- 2*20-2*20, 1000 - 2*20 - 2*20) lineBreakMode:NSLineBreakByWordWrapping  ];
    
    float textWidth = frame.size.width;
    
    if (textWidth < stringSize.width)
        textWidth = stringSize.width;
    if (textWidth > 700)
        textWidth = 1000 - frame.origin.x;
    CGRect renderingRect = CGRectMake(frame.origin.x, frame.origin.y, textWidth, stringSize.height);
    
    
    [text drawInRect:renderingRect
            withFont:font
       lineBreakMode:NSLineBreakByWordWrapping
           alignment:NSTextAlignmentRight];
    
    
    frame = CGRectMake(frame.origin.x, frame.origin.y, textWidth, stringSize.height);
    return frame;
}

-   (CGRect)addLineWithFrame:(CGRect)frame withColor:(UIColor*)color {
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(currentContext, color.CGColor);
    //CGContextSetLineWidth(currentContext, frame.size.height);
    
    CGPoint startPoint = frame.origin;
    CGPoint endPoint = CGPointMake(frame.origin.x + frame.size.width, frame.origin.y);
    CGContextBeginPath(currentContext);
    CGContextMoveToPoint(currentContext, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(currentContext, endPoint.x, endPoint.y);
    
    CGContextClosePath(currentContext);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
return frame;
}

- (CGRect)addImage:(UIImage*)image atPoint:(CGPoint)point {

    CGRect imageFrame = CGRectMake(point.x, point.y, 120, 50);
    [image drawInRect:imageFrame];
    return imageFrame;
}

-(void)drawPageNumber:(NSInteger)pageNum {
    NSString *pageString = [NSString stringWithFormat:@"Page %d", pageNum];
    UIFont *theFont = [UIFont systemFontOfSize:12];
    CGSize maxSize = CGSizeMake(612, 72);
    CGSize pageStringSize = [pageString sizeWithFont:theFont
                                   constrainedToSize:maxSize
                                       lineBreakMode:NSLineBreakByClipping];
   // CGRect stringRect = CGRectMake(((612.0 - pageStringSize.width) / 2.0),
     //                              720.0 + ((72.0 - pageStringSize.height) / 2.0),
  //                                 pageStringSize.width,
   //                                pageStringSize.height);
    
    CGRect stringRect=CGRectMake(350, 0, pageStringSize.width, pageStringSize.height);
    [pageString drawInRect:stringRect withFont:theFont];
}
-(void)dealloc{
    
}
@end
