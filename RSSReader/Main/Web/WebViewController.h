//
//  WebViewController.h
//  RSSReader
//
//  Created by Do Huynh Tuan Khai on 4/7/20.
//  Copyright © 2020 Do Huynh Tuan Khai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : UIViewController <WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnOpenSafari;
- (IBAction)openSafari:(id)sender;
@property (nonatomic, retain) NSString *itemLink; ///<---- Use to pass data to load website on webview
@end

NS_ASSUME_NONNULL_END
