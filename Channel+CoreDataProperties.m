//
//  Channel+CoreDataProperties.m
//  RSSReader
//
//  Created by Do Huynh Tuan Khai on 4/6/20.
//  Copyright © 2020 Do Huynh Tuan Khai. All rights reserved.
//
//

#import "Channel+CoreDataProperties.h"

@implementation Channel (CoreDataProperties)

+ (NSFetchRequest<Channel *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Channel"];
}

@dynamic link;
@dynamic des;
@dynamic title;
@dynamic items;

@end
