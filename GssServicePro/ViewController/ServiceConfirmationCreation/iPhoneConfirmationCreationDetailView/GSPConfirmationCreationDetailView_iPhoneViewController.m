//
//  GSPConfirmationCreationDetailView_iPhoneViewController.m
//  GssServicePro
//
//  Created by Riyas Hassan on 15/12/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#import "GSPConfirmationCreationDetailView_iPhoneViewController.h"
#import "GSPDateUtility.h"

@interface GSPConfirmationCreationDetailView_iPhoneViewController ()

@property (nonatomic, strong) ServiceTask *serviceOrder;
@property (weak, nonatomic) IBOutlet UILabel *serviceDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *notesLabel;

@end

@implementation GSPConfirmationCreationDetailView_iPhoneViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withServiceOrder:(ServiceTask*)serviceOrder
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.serviceOrder = serviceOrder;
        self.title        = @"Service Confirmation Creation";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self populateDetailsInView];
    
}

- (void)populateDetailsInView
{
    
    self.serviceDescriptionLabel.text   = [self checkNullString:self.serviceOrder.serviceItem];
    self.durationLabel.text             = [self checkNullString:self.serviceOrder.duration];
    self.startDateLabel.text            = [self checkNullString:[NSString stringWithFormat:@"%@", [[GSPDateUtility sharedInstance]convertYYYYMMDDHHMMSStoMMMDDYYYYHHMM:self.serviceOrder.startDate]]];
    
// Original code
//    self.endDateLabel.text              = [self checkNullString:[NSString stringWithFormat:@"%@",[NSDate date]]];
    
// Modified by Harshitha
    if ([self.serviceOrder.estimatedArrivalDate length] > 0) {
        self.endDateLabel.text              = [self checkNullString:[NSString stringWithFormat:@"%@",[[GSPDateUtility sharedInstance]convertYYYYMMDDHHMMSStoMMMDDYYYYHHMM:self.serviceOrder.estimatedArrivalDate]]];
    }
    else {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM dd,yyyy HH:MM"];
        self.endDateLabel.text              = [self checkNullString:[NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]]];
    }

    self.serviceLabel.text              = [self checkNullString:self.serviceOrder.numberExtension];
    self.notesLabel.text                = [self checkNullString:self.serviceOrder.serviceNote];
   
}


- (NSString*) checkNullString:(NSString*)objectStr
{
    
    if ([objectStr isEqualToString:@"(null)"] || objectStr.length <= 0)
        
        return @"";
    
    else
        
        return objectStr;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
