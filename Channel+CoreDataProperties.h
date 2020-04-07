//
//  Channel+CoreDataProperties.h
//  RSSReader
//
//  Created by Do Huynh Tuan Khai on 4/6/20.
//  Copyright © 2020 Do Huynh Tuan Khai. All rights reserved.
//
//

#import "Channel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Channel (CoreDataProperties)

+ (NSFetchRequest<Channel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *link;
@property (nullable, nonatomic, copy) NSString *des;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, retain) NSSet<Item *> *items;

@end

@interface Channel (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet<Item *> *)values;
- (void)removeItems:(NSSet<Item *> *)values;

@end

NS_ASSUME_NONNULL_END
