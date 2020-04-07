//
//  Item+CoreDataProperties.m
//  RSSReader
//
//  Created by Do Huynh Tuan Khai on 4/6/20.
//  Copyright © 2020 Do Huynh Tuan Khai. All rights reserved.
//
//

#import "Item+CoreDataProperties.h"

@implementation Item (CoreDataProperties)

+ (NSFetchRequest<Item *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Item"];
}

@dynamic link;
@dynamic des;
@dynamic date;
@dynamic title;
@dynamic imgURL;
@dynamic channel;

@end
