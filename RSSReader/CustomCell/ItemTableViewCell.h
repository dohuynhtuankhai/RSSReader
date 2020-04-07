//
//  ItemTableViewCell.h
//  RSSReader
//
//  Created by Do Huynh Tuan Khai on 4/6/20.
//  Copyright © 2020 Do Huynh Tuan Khai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *itemImg;
@property (weak, nonatomic) IBOutlet UITextView *txtTitle;

@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@end

NS_ASSUME_NONNULL_END
