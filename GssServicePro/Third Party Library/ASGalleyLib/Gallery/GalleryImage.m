//
//  MyGalleryView.m
//  Gallery
//
//  Created by Riyas Hassan on 03/07/14.
//  Copyright (c) 2014 GSS Software. All rights reserved.
//

#import "GalleryImage.h"

@implementation GalleryImage

-(CGFloat)duration
{

    return 0;
}

-(UIImage*)imageForType:(ASGalleryImageType)imageType
{
    
    return self.image;
}

-(NSString*)filePath
{
    return self.filePath;
}
-(NSURL*)url
{
    
    return nil;
}

-(BOOL)isVideo
{
    return NO;
}




@end
