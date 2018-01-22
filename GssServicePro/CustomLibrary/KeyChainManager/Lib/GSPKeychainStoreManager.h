//
//  GSPKeychainStoreManager.h
//  GssServicePro
//
//  Created by Riyas Hassan on 08/01/15.
//  Copyright (c) 2015 Riyas Hassan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSPKeychainStoreManager : NSObject

+ (void)saveDataInKeyChain:(NSMutableArray*)array;

+ (NSMutableArray*) arrayFromKeychain;

+ (void) deleteItemsFromKeyChain;

+ (void) saveErrorItemsInKeychain:(NSMutableArray*)array;

+ (NSMutableArray*)getErrorItemsFromKeyChain;

+ (id)getErrorObjectFromKeychainForID:(NSString*)appRefId;

+(NSString*)fetchLocalNotifVariable;
+(NSMutableArray*)fetchLocalNotifReferenceID;
+(void)setLocalNotifVariable;

+ (NSMutableArray*) allItemsArrayFromKeychain;
+(void) saveAllItemsInKeychain:(NSMutableArray*)array;
+ (void) deleteAllItemsFromGSMKeyChain;

+ (void)saveAllItemsInKeyChainFromDB:(NSMutableArray*)array;

+(void)deleteItemsinGSMKeyChainNotinServer: (NSArray*)objectIDArray;

+(void)deleteItemsinErrorKeyChainNotinServer: (NSArray*)objectIDArray;

+ (void) deleteErrorItemsFromKeyChain;

+(void)setLocalNotifVariabletoYes;
+(void)setLocalNotifVariable: (NSString *)ident andServiceItem: (NSString*)ident2;

+(NSMutableArray*)fetchApplicationState;
@end
