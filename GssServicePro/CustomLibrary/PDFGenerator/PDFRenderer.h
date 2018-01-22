//
//  PDFRenderer.h


#import <Foundation/Foundation.h>
#import "ServiceTask.h"

@interface PDFRenderer : NSObject
{
    CGFloat pdfTableHeight;
    NSInteger   yaxis;
   
}

+ (id)sharedInstance;

- (void)drawPDFFromTableForServicOrder:(NSString*)serviceOrder  WithTableViewView:(UITableView*)tableView withAttacments:(NSMutableArray*)attachments andSignature:(UIImage*)signatureImage;

//Method for generating PDF of any view
- (void)drawPDFOfViewForServicOrder:(NSString *)serviceOrder WithView:(UIView *)sView withAttacments:(NSMutableArray *)attachments andSignature:(UIImage *)signatureImage;
-(NSString*) getPdfFileName:(NSString*)serviceOrder;

- (void) drawImage:(UIImage*)image inRect:(CGRect)rect;
-(NSData *)pdfDataOfScrollView:(NSString *)serviceOrder andOneTableView :(UIScrollView *)scrollView andTableView :(UIScrollView *)scrollView1 withAttacments:(NSMutableArray*)attachments andSignature:(UIImage*)signatureImage;



-(void)drawPDFofTableForServicOrder:(NSString*)serviceOrder withObject :(ServiceTask*)serviceObject  WithArray:(NSMutableArray*)serviceArray withAttacments:(NSMutableArray*)attachments andSignature:(UIImage*)signatureImage withTranslatedDictionary:(NSDictionary*)translatedDic;

+(void)drawText:(NSString*)textToDraw inFrame:(CGRect)frameRect;

- (CGRect)addText:(NSString*)text withFrame:(CGRect)frame withFontName:(NSString*)fontName fontSize:(float)fontSize;

-   (CGRect)addLineWithFrame:(CGRect)frame withColor:(UIColor*)color ;

@end
