//
//  Item+CoreDataProperties.h
//  RSSReader
//
//  Created by Do Huynh Tuan Khai on 4/6/20.
//  Copyright © 2020 Do Huynh Tuan Khai. All rights reserved.
//
//

#import "Item+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Item (CoreDataProperties)

+ (NSFetchRequest<Item *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *link;
@property (nullable, nonatomic, copy) NSString *des;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *imgURL;
@property (nullable, nonatomic, retain) Channel *channel;

@end

NS_ASSUME_NONNULL_END
