//
//  DetailViewController.h
//  RSSReader
//
//  Created by Do Huynh Tuan Khai on 4/6/20.
//  Copyright © 2020 Do Huynh Tuan Khai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemTableViewCell.h"
#import "Channel+CoreDataProperties.h"
#import "Item+CoreDataProperties.h"
#import "Helper.h"
#import "AppDelegate.h"
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
@property (nonatomic, retain) NSString *channelLink; ///<--- Use to pass data to populate tableview
@property(strong,nonatomic) WKWebView *webView;
@end

NS_ASSUME_NONNULL_END
