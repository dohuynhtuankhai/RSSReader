//
//  Helper.h
//  RSSReader
//
//  Created by Do Huynh Tuan Khai on 4/2/20.
//  Copyright © 2020 Do Huynh Tuan Khai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <Reachability.h>
NS_ASSUME_NONNULL_BEGIN

@interface Helper : NSObject <UIApplicationDelegate>{
    AppDelegate *appDelegate;
    NSManagedObjectContext *context;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}
-(BOOL)isValidURL:(NSString*) urlString;
-(void)dismissKeyboard:(UIViewController*) vc;
-(void)raiseAlert:(NSString*) alertMessage :(UIViewController*) vc;
-(void)toggleHideViewAnimation:(UIResponder*) object :(BOOL) isHidden;
-(void)addLeftIndentToTextfield:(UITextField*) textfield;
-(NSString *)getSrcAttribute:(NSString*) str;
-(BOOL)isContainAnotherString:(NSString *) mainStr :(NSString *) testStr;
-(NSArray*)getValuesOfAttributeFromEntity:(NSString *) key :(NSString *) entityName;
-(void) deleteAllRecord:(NSString *) entityName;

-(BOOL) checkForDuplicateObject:(NSString*) entityName :(NSString*) key :(NSString*) value;
-(NSString*) NSDateToString:(NSDate*) date;
-(void)showProcessIndicator :(UIView*) view;
-(void)hideProcessIndicator :(UIView*) view;
-(BOOL)isArrayContainString:(NSArray*) arr :(NSString*) str;
@end

NS_ASSUME_NONNULL_END
