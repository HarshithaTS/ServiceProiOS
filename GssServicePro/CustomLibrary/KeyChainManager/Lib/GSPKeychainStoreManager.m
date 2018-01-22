//
//  GSPKeychainStoreManager.m
//  GssServicePro
//
//  Created by Riyas Hassan on 08/01/15.
//  Copyright (c) 2015 Riyas Hassan. All rights reserved.
//

#import "GSPKeychainStoreManager.h"
#import "UICKeyChainStore.h"

@implementation GSPKeychainStoreManager


+ (NSString*) stringFromArray:(NSMutableArray*)contentArray
{
    NSData *jsonData        = [NSJSONSerialization dataWithJSONObject:contentArray options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString    = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

+ (NSMutableArray*) arrayFromString:(NSString*)string
{
    NSMutableArray *objectArray = [NSMutableArray arrayWithArray:[NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL]];

    return objectArray;
}



+ (NSMutableArray*) consolitedArrayFromKeyChainAndLocalDB:(NSMutableArray*)arrayFromDB
{
    UICKeyChainStore *store             = [UICKeyChainStore keyChainStoreWithService:@"com.GSSServicePro"];
   
    NSString *stringFromKeychain        = [store stringForKey:@"queueData"];
   
    NSMutableArray *arrayFromKeychain;
    
    if (stringFromKeychain)
    {
        arrayFromKeychain               = [GSPKeychainStoreManager arrayFromString:stringFromKeychain];
        
    }

    for (NSDictionary * qpObject in arrayFromDB) {
        
        for (int i =0; i< arrayFromKeychain.count; i++)
        {
            NSMutableDictionary * taskDic = [arrayFromKeychain objectAtIndex:i];
            
            if ([[taskDic valueForKey:@"referenceid"] isEqualToString:[qpObject valueForKey:@"referenceid"]] && [[taskDic valueForKey:@"applicationname"] isEqualToString:[qpObject valueForKey:@"applicationname"]] && [[taskDic valueForKey:@"ID"] isEqualToString:[qpObject valueForKey:@"ID"]])
            {
                
                [qpObject setValue:[taskDic valueForKey:@"AddedTime"] forKey:@"AddedTime"];
                
                [arrayFromKeychain replaceObjectAtIndex:i withObject:qpObject];
                
            }
            else if([[taskDic valueForKey:@"refID"] isEqualToString:[qpObject valueForKey:@"refID"]])
            {
                [arrayFromKeychain replaceObjectAtIndex:i withObject:qpObject];
                
            }
        }
    }
    
    if (arrayFromKeychain.count <= 0 || arrayFromKeychain == nil) {
       
        return arrayFromDB;
    }
    else {
// Added by Harshitha
        for (NSDictionary * qpObject in arrayFromDB) {
            [arrayFromKeychain addObject:qpObject];
        }
        return arrayFromKeychain;
    }
}

+ (void)saveDataInKeyChain:(NSMutableArray*)array
{
    UICKeyChainStore *store         = [UICKeyChainStore keyChainStoreWithService:@"com.GSSServicePro"];

    
    NSMutableArray * arrayToStore   = [GSPKeychainStoreManager consolitedArrayFromKeyChainAndLocalDB:array];
    
    if (arrayToStore.count > 0) {
        NSString *stringToStore         = [GSPKeychainStoreManager stringFromArray:arrayToStore];
        
        [UICKeyChainStore setString:stringToStore forKey:@"queueData" service:@"com.GSSServicePro"];
        [store synchronize];
    }
    
}

+ (NSMutableArray*) arrayFromKeychain
{
    UICKeyChainStore *store             = [UICKeyChainStore keyChainStoreWithService:@"com.GSSServicePro"];
    
    NSString *stringFromKeychain        = [store stringForKey:@"queueData"];

    NSMutableArray *array;
    
    if (stringFromKeychain)
    {
        array               = [GSPKeychainStoreManager arrayFromString:stringFromKeychain];

    }
    return array;
}

+ (void) deleteItemsFromKeyChain
{
 
    [UICKeyChainStore removeAllItemsForService:@"com.GSSServicePro"];
}

+ (void) deleteErrorItemsFromKeyChain
{
    
    [UICKeyChainStore removeAllItemsForService:@"com.ServiceProError"];
}

+(void) saveErrorItemsInKeychain:(NSMutableArray*)array
{
    UICKeyChainStore *store         = [UICKeyChainStore keyChainStoreWithService:@"com.ServiceProError"];
    
    if (array.count >0)
    {
        NSString *stringToStore         = [GSPKeychainStoreManager stringFromArray:array];
        
        [UICKeyChainStore setString:stringToStore forKey:@"Error" service:@"com.ServiceProError"];
        [store synchronize];
    }
    
   

}


+ (NSMutableArray*)getErrorItemsFromKeyChain
{
    UICKeyChainStore *store             = [UICKeyChainStore keyChainStoreWithService:@"com.ServiceProError"];
    
    NSString *stringFromKeychain        = [store stringForKey:@"Error"];
    
    NSMutableArray *array;
    
    if (stringFromKeychain)
    {
        array               = [GSPKeychainStoreManager arrayFromString:stringFromKeychain];
        
    }
    return array;
}



+ (id)getErrorObjectFromKeychainForID:(NSString*)appRefId
{
    NSMutableArray *errorObjectArray = [GSPKeychainStoreManager getErrorItemsFromKeyChain];
    
    
    for (NSDictionary * dic in errorObjectArray)
    {
        if ([[dic valueForKey:@"referenceID"] isEqualToString:appRefId]) {
            return dic;
        }
        else
            return nil;
    }
    
    return 0;
}

+(NSString*)fetchLocalNotifVariable{
    NSString *variable= [UICKeyChainStore stringForKey:@"notifVariable" service:@"LocalNotifications"];
    
    return variable;
}

+(NSMutableArray*)fetchLocalNotifReferenceID{
    
    NSMutableArray *notificationDataArray = [[NSMutableArray alloc]init];
    NSString *variable= [UICKeyChainStore stringForKey:@"referenceID" service:@"LocalNotifications"];
    NSString *variable2 = [UICKeyChainStore stringForKey:@"firstServiceItem" service:@"LocalNotifications"];
    [notificationDataArray addObject:variable];
    if(variable2 ==nil)
        variable2 = @"";
    else
    [notificationDataArray addObject:variable2];
    
    return notificationDataArray;
}

+(void)setLocalNotifVariable{
    [UICKeyChainStore setString:@"NO" forKey:@"notifVariable" service:@"LocalNotifications"];
}
+(void)setLocalNotifVariabletoYes{
    [UICKeyChainStore setString:@"YES" forKey:@"notifVariable" service:@"LocalNotifications"];
}

+ (NSMutableArray*) allItemsArrayFromKeychain
{
    UICKeyChainStore *store             = [UICKeyChainStore keyChainStoreWithService:@"com.gsm"];
    
    NSString *stringFromKeychain        = [store stringForKey:@"All"];
    
    NSMutableArray *array;
    
    if (stringFromKeychain)
    {
        array               = [GSPKeychainStoreManager arrayFromString:stringFromKeychain];
        
    }
    return array;
}


+ (void)saveAllItemsInKeyChainFromDB:(NSMutableArray*)array
{
    UICKeyChainStore *store         = [UICKeyChainStore keyChainStoreWithService:@"com.gsm"];
    
    
    NSMutableArray * arrayToStore   = [GSPKeychainStoreManager consolitedArrayFromKeyChainAndLocalDB:array];
    
    if (arrayToStore.count > 0) {
        NSString *stringToStore         = [GSPKeychainStoreManager stringFromArray:arrayToStore];
        
        [UICKeyChainStore setString:stringToStore forKey:@"All" service:@"com.gsm"];
        [store synchronize];
    }
    
}


+(void) saveAllItemsInKeychain:(NSMutableArray*)array
{
    UICKeyChainStore *store         = [UICKeyChainStore keyChainStoreWithService:@"com.gsm"];
    
    if (array.count >0)
    {
        NSString *stringToStore         = [GSPKeychainStoreManager stringFromArray:array];
        
        [UICKeyChainStore setString:stringToStore forKey:@"All" service:@"com.gsm"];
        [store synchronize];
    }
    
    
}

+ (void) deleteAllItemsFromGSMKeyChain
{
    
    [UICKeyChainStore removeAllItemsForService:@"com.gsm"];
}

+(void)deleteItemsinGSMKeyChainNotinServer: (NSArray*)objectIDArray {
    
    NSMutableArray * arrayOfTasksFromKeyChain = [GSPKeychainStoreManager allItemsArrayFromKeychain];
            NSLog(@"The fetched items from keychain %@",arrayOfTasksFromKeyChain);
    if([objectIDArray count]>0){
    
                if([arrayOfTasksFromKeyChain count]>0){
                    
                    
                    NSMutableArray *toBeDelete = [[NSMutableArray alloc]init];
    
                    [GSPKeychainStoreManager deleteAllItemsFromGSMKeyChain];
    
                    for(NSDictionary *dic in arrayOfTasksFromKeyChain){
    
                        if(![objectIDArray containsObject:[dic valueForKey:@"referenceID"]]){
                            [toBeDelete addObject:dic];
//                            [arrayOfTasksFromKeyChain removeObject:dic];
    
                        }
                    }
                    
                    [arrayOfTasksFromKeyChain removeObjectsInArray:toBeDelete];
                }
    }
                [GSPKeychainStoreManager saveAllItemsInKeychain:arrayOfTasksFromKeyChain];
    

}

+(void)deleteItemsinErrorKeyChainNotinServer: (NSArray*)objectIDArray {
    
    NSMutableArray * arrayOfTasksFromKeyChain = [GSPKeychainStoreManager getErrorItemsFromKeyChain];
    NSLog(@"The fetched items from keychain %@",arrayOfTasksFromKeyChain);
    if([objectIDArray count]>0){
        
        if([arrayOfTasksFromKeyChain count]>0){
            NSMutableArray *toBeDeletedArray = [[NSMutableArray alloc ]init];
            
            [GSPKeychainStoreManager deleteErrorItemsFromKeyChain];
            
            for(NSDictionary *dic in arrayOfTasksFromKeyChain){
                
                if(![objectIDArray containsObject:[dic valueForKey:@"referenceID"]]){
                    
                    [toBeDeletedArray addObject:dic];
//                    [arrayOfTasksFromKeyChain removeObject:dic];
                    
                }
            }
            [arrayOfTasksFromKeyChain removeObjectsInArray:toBeDeletedArray];
        }
    }
    [GSPKeychainStoreManager saveErrorItemsInKeychain:arrayOfTasksFromKeyChain];
    NSMutableArray * arrayOfTasksFromKeyChain1 = [GSPKeychainStoreManager getErrorItemsFromKeyChain];
    NSLog(@"The fetched items from keychain after deletion %@",arrayOfTasksFromKeyChain1);
    
}
+(void)setLocalNotifVariable: (NSString *)ident andServiceItem: (NSString*)ident2{
    [UICKeyChainStore setString:@"YES" forKey:@"notifVariable" service:@"LocalNotifications"];
    [UICKeyChainStore setString:ident forKey:@"referenceID" service:@"LocalNotifications"];
    [UICKeyChainStore setString:ident2 forKey:@"firstServiceItem" service:@"LocalNotifications"];
    
}


+(NSMutableArray*)fetchApplicationState{
    NSString *variable= [UICKeyChainStore stringForKey:@"background" service:@"ApplicationState"];
    
    
    NSString *variable2 = [UICKeyChainStore stringForKey:@"backgroundTime" service:@"ApplicationState"];
    
    NSMutableArray *applicationStateArray = [[NSMutableArray alloc]init];
    
    [applicationStateArray addObject:variable];
    [applicationStateArray addObject:variable2];
    return applicationStateArray;
}
@end
