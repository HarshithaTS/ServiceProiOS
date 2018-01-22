//
//  GSPViewController.h
//  GssServicePro
//
//  Created by Riyas Hassan on 04/06/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSPBaseViewController.h"

@interface GSPViewController : GSPBaseViewController{
    NSTimer *timer;
    
    UIDocumentInteractionController *documentInteractionController;
}

@property(nonatomic,assign)BOOL keyChainProcessed;



@property(strong,nonatomic)NSMutableArray *diagnoseArray1;
- (void)SAPResponseHandlerForServiceTask:(NSNotification*)notification;

-(void)initializeServiceTasksApiCall;
- (void) initialiseVariables;
- (void) diagnoseInfo;
@end
