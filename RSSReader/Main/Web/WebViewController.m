//
//  WebViewController.m
//  RSSReader
//
//  Created by Do Huynh Tuan Khai on 4/7/20.
//  Copyright © 2020 Do Huynh Tuan Khai. All rights reserved.
//

#import "WebViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "Helper.h"
@interface WebViewController (){
    Helper *helper;
}
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    helper = [Helper new];
    // Do any additional setup after loading the view.
    NSURL *url = [NSURL URLWithString:self.itemLink];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [helper showProcessIndicator: self.webView];
    self.webView.navigationDelegate = self;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [helper hideProcessIndicator: self.webView];
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"Finish loadding");
    [helper hideProcessIndicator: self.webView];

}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [helper hideProcessIndicator: self.webView];
    [helper raiseAlert:@"Error connecting to webpage" :self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)openSafari:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure to view this content on Safari ?" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:self.itemLink];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success){
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];

}
@end
