//
//  Helper.m
//  RSSReader
//
//  Created by Do Huynh Tuan Khai on 4/2/20.
//  Copyright © 2020 Do Huynh Tuan Khai. All rights reserved.
//

#import "Helper.h"
#import <Reachability.h>
#import <MBProgressHUD/MBProgressHUD.h>
@implementation Helper
-(void)dismissKeyboard:(UIViewController*) vc{
    [vc.view endEditing:YES];
}

//Create simple Alert view controller
-(void)raiseAlert:(NSString*) alertMessage :(UIViewController*) vc{
    //Create a UIAlertController to display message on the screen
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    //Create an action for the UIAlertController
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    //Add action to the UIAlertController
    [alert addAction:defaultAction];
    //present(show) the alert on the screen with animation
    [vc presentViewController:alert animated:YES completion:nil];
}

//Check if a url is valid
-(BOOL)isValidURL:(NSString*) urlString{
    //NSURL will return nil if it was invalid
    NSURL *tmp = [NSURL URLWithString:urlString];
    if (tmp == nil || [urlString  isEqual: @""]) {
        return false;
    }
    return true;
}

//Set animation for hidding stackview element
-(void)toggleHideViewAnimation:(UIView*) view :(BOOL) isHidden{
    [UIView animateWithDuration:0.2 animations:^{
        [view setHidden:isHidden];
    }];
}

//Add a view to textfield to create fake indent
-(void)addLeftIndentToTextfield:(UITextField*) textfield{
    UIView *indentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, textfield.frame.size.height)];
    [textfield setLeftView:indentView];
    [textfield setLeftViewMode:UITextFieldViewModeAlways];
}
//Spit imgURL attribute from description tag in xml file
-(NSString *)getSrcAttribute:(NSString*) str{
    NSError *error = NULL;
    NSString * regexContent;
    __block NSString * imgURL;
    if ([str rangeOfString:@"data-original"].location == NSNotFound) {
        regexContent = @"(<img\\s[\\s\\S]*?src\\s*?=\\s*?['\"](.*?)['\"][\\s\\S]*?>)+?";
    } else {
        regexContent = @"(<img\\s[\\s\\S]*?data-original\\s*?=\\s*?['\"](.*?)['\"][\\s\\S]*?>)+?";
    }
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: regexContent options:NSRegularExpressionCaseInsensitive error:&error];
    [regex enumerateMatchesInString:str options:0 range:NSMakeRange(0, [str length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        imgURL = [str substringWithRange:[result rangeAtIndex:2]];
    }];
    return imgURL;
}
//Check if a string contain another string
-(BOOL)isContainAnotherString:(NSString *) mainStr :(NSString *) testStr{
    BOOL result = true;
    if ([mainStr rangeOfString:testStr].location == NSNotFound) {
        result = false;
    }
    return result;
}

//Check if a string is in an array
-(BOOL)isArrayContainString:(NSArray*) arr :(NSString*) str{
    BOOL identicalStringFound = NO;
    for (NSString *s in arr) {
        if (s == str) {
            identicalStringFound = YES;
            break;
        }
    }
    return identicalStringFound;
}


#pragma mark Core Data CRUD
-(NSArray*)getValuesOfAttributeFromEntity:(NSString *) key :(NSString *) entityName{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    context = appDelegate.persistentContainer.viewContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:entityName];
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (results.count == 0) {
        return @[];
    }
    NSString *r = [[results valueForKey:key] componentsJoinedByString:@"!+!"];
    NSArray *rs = [r componentsSeparatedByString:@"!+!"];
    return rs;
}
-(void) deleteAllRecord:(NSString *) entityName{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    persistentStoreCoordinator = appDelegate.persistentContainer.persistentStoreCoordinator;
    context = appDelegate.persistentContainer.viewContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];

    NSError *deleteError = nil;
    [persistentStoreCoordinator executeRequest:delete withContext:context error:&deleteError];
}


-(BOOL) checkForDuplicateObject:(NSString*) entityName :(NSString*) key :(NSString*) value{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    context = appDelegate.persistentContainer.viewContext;
    Boolean isDuplicated = NO;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:entityName];
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    NSString *rStr = [[results valueForKey:key] componentsJoinedByString:@"!+!"];
    if ([self isContainAnotherString:rStr :value]) {
        isDuplicated = YES;
    }
    return isDuplicated;
}
-(NSString*) NSDateToString:(NSDate*) date{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    return [dateFormat stringFromDate:date];
}





#pragma mark Activity Indicator
//Show activity indicator
-(void)showProcessIndicator :(UIView*) view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = @"Loading";
    hud.contentColor = [UIColor blackColor];
}

//Show activity indicator
-(void)hideProcessIndicator :(UIView*) view{
    [MBProgressHUD hideHUDForView:view animated:true];
}
@end
