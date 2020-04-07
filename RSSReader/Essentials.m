//
//  Essentials.m
//  RSSReader
//
//  Created by Do Huynh Tuan Khai on 4/2/20.
//  Copyright © 2020 Do Huynh Tuan Khai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import <UIKit/UIKit.h>

@interface Essentials : NSObject{

}
//declare a function to check if a string is a valid URL
-(BOOL)isValidURL:(NSString*) url;
@end

@implementation Essentials
-(BOOL)isValidURL:(NSString*) url{
    NSURL *tmp = [NSURL URLWithString:url];
    if (tmp == nil) {
        return false;
    }
    return true;
}
@end



