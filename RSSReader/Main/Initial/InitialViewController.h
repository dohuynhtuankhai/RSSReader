//
//  InitialViewController.h
//  RSSReader
//
//  Created by Do Huynh Tuan Khai on 4/2/20.
//  Copyright © 2020 Do Huynh Tuan Khai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"
#import "UICustomView.h"
#import <MWFeedParser/MWFeedParser.h>
#import "ChannelTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface InitialViewController : UIViewController <MWFeedParserDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate> {

    
}
//Create outlet and action
@property (weak, nonatomic) IBOutlet UILabel *lbNoData;
@property (weak, nonatomic) IBOutlet UICustomView *viewAddRSS;

@property (weak, nonatomic) IBOutlet UITextField *txtURLInput;
@property (weak, nonatomic) IBOutlet UIButton *btnFeedRSS;
-(IBAction)FeedRSS:(id)sender;
-(IBAction)FeedRSSonTextfieldTap:(id)sender ;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toggleAddRSSView;
- (IBAction)toggleAddRSSView:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *channelTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnDeleteAllRecord;
- (IBAction)deleteAllRecord:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewNoData;

@end

NS_ASSUME_NONNULL_END
