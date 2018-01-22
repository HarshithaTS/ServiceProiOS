//
//  MyGalleryView.h
//  Gallery
//
//  Created by Riyas Hassan on 03/07/14.
//  Copyright (c) 2014 GSS Software. All rights reserved.
//

#import "ASGalleryAssetBase.h"

@interface GalleryImage : ASGalleryAssetBase

{
    NSString* type;
    NSURL* _url;
    NSNumber* _duration;
}

@property (nonatomic,strong) UIImage    * image;
@property (nonatomic, strong) NSString  * imageFilePath;
@end
