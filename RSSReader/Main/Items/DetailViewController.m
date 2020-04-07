//
//  DetailViewController.m
//  RSSReader
//
//  Created by Do Huynh Tuan Khai on 4/6/20.
//  Copyright © 2020 Do Huynh Tuan Khai. All rights reserved.
//

#import "DetailViewController.h"
#import <WebKit/WebKit.h>
#import "WebViewController.h"
@interface DetailViewController (){
    //Initiate data
    Helper *helper;
    AppDelegate *appDelegate;
    NSMutableArray *titles;
    NSMutableArray *links;
    NSMutableArray *descriptions;
    NSMutableArray *imgURLs;
    NSMutableArray *dates;
    NSManagedObjectContext *context;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSString *passData;
}
    
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    helper = [Helper new];
    NSLog(@"Pass data %@",self.channelLink);
    //Set up array for data
    //The data is determined based on the number of objects included on the cell
    titles = [[NSMutableArray <NSString *> alloc] init];
    links = [[NSMutableArray <NSString *> alloc] init];
    descriptions = [[NSMutableArray <NSString *> alloc] init];
    imgURLs = [[NSMutableArray <NSString *> alloc] init];
    dates = [[NSMutableArray <NSDate *> alloc] init];
    
    //Set up for core data
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    context = appDelegate.persistentContainer.viewContext;
    persistentStoreCoordinator = appDelegate.persistentContainer.persistentStoreCoordinator;
    
    //initiate data after performing segue
    [self initiateData];
}

-(void)initiateData{
    NSLog(@"Initiate data");
    NSFetchRequest *request = [[NSFetchRequest<Item *> alloc] initWithEntityName:@"Item"]; ///<---- Create request
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    NSLog(@"Number or records: %lu",(unsigned long)result.count);
    for(Item *item in result){
          ///<---- Uncomment below codes to see the item's data in detail
//        printf("--------------------------------------------\n");
//        printf("Title: %s \n",[item.title UTF8String]);
//        printf("Link: %s \n",[item.link UTF8String]);
//        printf("Description: %s \n",[item.des UTF8String]);
//        printf("ImgLink: %s \n",[item.imgURL UTF8String]);
//        printf("Channel's link: %s \n",[item.channel.link UTF8String]);
//        NSLog(@"Date %@ \n", item.date);
//        printf("--------------------------------------------\n");
//        printf("\n");
        if ([item.channel.link isEqualToString:self.channelLink] ) { ///<---- Filter out items  that have the same channel 's name. The Channel's name of the item can be retrieved through entity's relationship
              

            if (item.link == nil || item.title == nil || item.date == nil) { ///<--- link, title, date is used to eliminate invalid records - this happened sometimes with the RSS link : https://vnexpress.net/rss/the-thao.rss
                continue;
            }
            [links addObject:item.link];
            [titles addObject:item.title];
            [dates addObject:item.date];
            if (item.imgURL == nil) { ///<--- sometimes Image URL is missing but other attributes is still available - this happened sometimes with the RSS link : https://vnexpress.net/rss/the-thao.rss
                [imgURLs addObject:@"nil"];
            }
            else{
                [imgURLs addObject:item.imgURL];
            }
            if (item.des == nil) { /// <--- The same thing happened with description
                [descriptions addObject:@""];
            }
            else{
                [descriptions addObject:item.des];
            }
            

        }
    }
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ItemTableViewCell *itemCell = (ItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"itemCell"]; ///<--- Access tableview cell using identifier
    itemCell.txtTitle.text = [titles objectAtIndex:indexPath.row];
    itemCell.txtDescription.text = [descriptions objectAtIndex:indexPath.row];
    
    //Convert NSDate to NSString will a specific format
    //Published date of item was save as NSDate in core data
    NSDate *d = [dates objectAtIndex:indexPath.row];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSString *stringFromDate = [dateFormat stringFromDate:d];;
    itemCell.lbDate.text = stringFromDate;
    NSString *imgLink = [imgURLs objectAtIndex:indexPath.row];
    
    //Because some items might not have imgLink so it was saved as 'nil' string instead
    if ([imgLink isEqualToString:@"nil"]) {
        itemCell.itemImg.image = nil;
    }
    else {
        //We used dispatch queue to load image asynchronously
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
                NSURL *url=[NSURL URLWithString:imgLink];
                NSData *data = [NSData dataWithContentsOfURL:url]; ///<--- Download image
                UIImage *image = [UIImage imageWithData:data]; ///<---- transfer download result to uiimage

                dispatch_async(dispatch_get_main_queue(), ^{ ///<--- after dispatch queue finished, this function is called to update UI
                    itemCell.itemImg.image = image;
            });
        });
    }

    return itemCell;
}
#pragma mark    Tableview setup
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Row num: %lu", (unsigned long)titles.count);
    return titles.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 186;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Cell's URL: %@", [links objectAtIndex:indexPath.row]);
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus] == NotReachable){
        [helper raiseAlert:@"Please connect to the internet!" :self];
    }
    else{
        passData = [links objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"showOnWeb" sender:self];
        
    }}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"showOnWeb"]) {
        WebViewController *vc = [segue destinationViewController];
        vc.itemLink = passData;
    }
}
@end
