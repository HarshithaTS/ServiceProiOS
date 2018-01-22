//
//  GalleryViewController.h
//  Photos
//
//  Created by Andrey Syvrachev on 21.05.13.
//  Copyright (c) 2013 Andrey Syvrachev. All rights reserved.
//

#import "ASGalleryViewController.h"

@interface GalleryViewController : ASGalleryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil serviceOrder:(NSString*)serviceOrder;

@property (nonatomic,strong) NSMutableArray * assets;

@end
