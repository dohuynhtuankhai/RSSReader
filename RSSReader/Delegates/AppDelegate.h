//
//  AppDelegate.h
//  RSSReader
//
//  Created by Do Huynh Tuan Khai on 4/2/20.
//  Copyright © 2020 Do Huynh Tuan Khai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentCloudKitContainer *persistentContainer;

- (void)saveContext;


@property (strong, nonatomic) UIWindow *window;
@end

