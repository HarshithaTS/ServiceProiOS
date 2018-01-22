//
//  GSPConstants.h
//  GssServicePro
//
//  Created by Riyas Hassan on 23/06/14.
//  Copyright (c) 2014 Riyas Hassan. All rights reserved.
//

#ifndef GssServicePro_GSPConstants_h
#define GssServicePro_GSPConstants_h


#define BACKGROUND_COLOR [UIColor colorWithRed:225.0/255 green:241.0/255 blue:255.0/255 alpha:1.0];


#define TABLE_LABEL_COLOR       [UIColor colorWithRed:1.0/255 green:150.0/255 blue:255.0/255 alpha:1.0];
#define TABLE_LABEL_FONT        [UIFont systemFontOfSize:14.0]
#define TABLE_BOLD_LABEL_FONT   [UIFont boldSystemFontOfSize:17.0]
#define iPHONE_TABLE_BOLD_LABEL_FONT   [UIFont boldSystemFontOfSize:13.0]

#define TABLE_HEADER_BGCOLOR        [UIColor colorWithRed:75.0/255 green:137.0/255 blue:208.0/255 alpha:1.0]
#define TABLE_HEADER_FONT           [UIFont boldSystemFontOfSize:13.0];
#define TABLE_HEADER_TEXTCOLOR      [UIColor whiteColor]
#define TABLE_HEADER_BORDERCOLOR    [[UIColor blackColor]CGColor]

#define DETAIL_TABLE_LABEL_COLOR    [UIColor blueColor]
#define DETAIL_TABLE_LABEL_FONT     [UIFont systemFontOfSize:15.0]
#define iPHONE_DETAIL_TABLE_LABEL_FONT     [UIFont systemFontOfSize:12.0]

//DataBase names
#define serviceRepotsDB     @"ServiceReportsDB.sqlite"
#define contextDB           @"gssSystemDB.sqlite"
#define qProcessorDB        @"db_queueprocessor"

//Map Selection Key
#define DEFAULT_SELECTED_MAP @"Selected Map"
#define AppleMapSelected  1
#define GoogleMapSelected 2

//Service Order Detail Screen

#define MENU_ACTION_SHEET_TAG       1
#define IMAGEPICKER_ACION_SHEET_TAG 2
#define SIGNATURE_ACTION_SHEET      3

#define CAMERA_SELECTED     1
#define GALLERY_SELECTED    2

//Info Screen

#define MAIL_SUBJECT @"A Message from TCW Servicepro User"
#define MAIL_RECIVER @"Gss.Mobile@globalsoft-solutions.com"

// Added by Harshitha
//Object Names
#define CONTEXT_OBJTYPE @"SOContext"
#define SERVICEORDER_OBJTYPE @"SOList"
#define COLLEAGUE_OBJTYPE @"ColgList"

typedef enum
{
    serviceTaskOverView = 1,
    colleguesServiceTaskView
    
}ScreenType;

typedef enum
{
    prioTag = 100,
    statusTag,
    startDateTag,
    customerLocTag,
    estArrivalTag,
    serviceDocTag,
    contactNameTag,
    
}SortHeaderButtonTags;

typedef enum
{
    ServiceLocationRow = 0,
    ServiceOrderRow ,
    ServiceOrderTypeRow,
    PriorityRow,
    StatusRow,
    ReasonRow,
    EnterReasonRow,
    StartDateRow,
    EstimatedArrivalDateRow,
//    TimeZoneRow,
    FieldNoteRow,
    ContactNameRow,
    TelNumberRow,
    AltrTeleNumRow,
    ServiceOrdrDescriptionRow,
    OtherDetailsRow,
    SerialNumRow,
    IbDescriptionRow,
    IbInstDescriptionRow,
    PartnerRow,
    RefernceObjectIdRow,
    ServiceItemRow,
    ServiceNoteRow,
    
}TaskDetailTableViewRow;

#endif
