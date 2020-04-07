//
//  InitialViewController.m
//  RSSReader
//
//  Created by Do Huynh Tuan Khai on 4/2/20.
//  Copyright © 2020 Do Huynh Tuan Khai. All rights reserved.
//

#import "InitialViewController.h"
#import "Helper.h"

#import "AppDelegate.h"
#import "Item+CoreDataProperties.h"
#import "Channel+CoreDataProperties.h"
#import "DetailViewController.h"
#import <NSString+HTML.h> ///<--- Contain support classes to support MWFeedparser 's fetching result
///Not used anymore
//#import <AFNetworking/AFNetworking.h>
//#import <RaptureXML-umbrella.h>
//#import <TBXML/TBXML.h>

@interface InitialViewController (){
    
    //Create essential objects
    AppDelegate *appDelegate;
    NSArray *dictionaries;
    NSManagedObjectContext *context;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSMutableArray *channelTitles;
    NSMutableArray *channelLinks;
    NSMutableArray *itemTitles;
    NSArray *items;
    Channel *cdChannel;
    Item *cdItem;
    NSString *passData;
    NSString *rssURL;
    Helper *helper;
    BOOL isAddViewHidden;
    //NSXMLParser *parser;
    MWFeedParser *feedParser;
    NSMutableArray *parsedItems;
}
@end

@implementation InitialViewController

#pragma mark Initial functions
- (void)viewDidLoad {
    [super viewDidLoad];
    //Initialize helper class
    helper = [[Helper alloc] init]; /// <----Helper class contain support functions
    
    //Setup for Core Data use
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    context = appDelegate.persistentContainer.viewContext;
    persistentStoreCoordinator = appDelegate.persistentContainer.persistentStoreCoordinator;
        
    isAddViewHidden = YES; ///<-Adding URL View's hidden property flag


    [self loadEssentialDatas]; ///<- Get data from CoreData

    
    //Reload tableview Delegate and Datasource after getting datas
    self.channelTableView.delegate = self;
    self.channelTableView.dataSource = self;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:nil];
    
    //Set Hidden state for Adding URL view
    if (isAddViewHidden == YES) {
        [self.viewAddRSS setHidden:YES];
    }else{
        [self.viewAddRSS setHidden:NO];
    }
    
    [helper addLeftIndentToTextfield:self.txtURLInput]; ///<--- Add a left view on uitextfield to create indent for text indicator
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:nil];
    [feedParser stopParsing]; ///<-- Additional stop parsing when switch vc or close app
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        DetailViewController *vc = [segue destinationViewController];
        vc.channelLink = passData;    ///<---Setup data to pass before perfroming segue
    }
}

-(void)loadEssentialDatas{
    //Get data to put into table view
    channelTitles = [NSMutableArray arrayWithArray:[helper getValuesOfAttributeFromEntity:@"title" :@"Channel"]];
    channelLinks = [NSMutableArray arrayWithArray:[helper getValuesOfAttributeFromEntity:@"link" :@"Channel"]];
}




#pragma mark    Set actions for objects
- (IBAction)FeedRSS:(id)sender {
    [self handleRSSInput]; ///<---- Handle user's input
}
//FeedRss on "Done" button

- (IBAction)FeedRSSonTextfieldTap:(id)sender {
    [self handleRSSInput];
}
- (IBAction)toggleAddRSSView:(id)sender {
    [helper toggleHideViewAnimation:self.viewAddRSS :!isAddViewHidden];
    isAddViewHidden = !isAddViewHidden;
}
- (IBAction)deleteAllRecord:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure to delete all Data ?" preferredStyle:UIAlertControllerStyleAlert]; ///<--- Create an alert for delete action

    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self->helper deleteAllRecord:@"Channel"]; ///<---Delete all channel records,  items record related to these channes also be deleted
        [self->helper deleteAllRecord:@"Item"];
        [self->channelTitles removeAllObjects];
        [self loadEssentialDatas];
        [self reloadChannelTableView];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil]; ///<--- Present the alert viewcontroller on the screen

}

#pragma mark    Additional helper setup
-(void)dismissKeyboard{
    [self.view endEditing:true];
    //[helper dismissKeyboard:self];
}
-(void)handleRSSInput{
    [helper dismissKeyboard:self];
    NSString * const urlInput = self.txtURLInput.text;
    if ([helper isValidURL:urlInput] == true) {
        [self fetchData:urlInput];
    }else{
        [helper raiseAlert:@"Invalid URL" :self];
    }
}






#pragma mark    RSS Feed Parsing procedures
-(void)fetchData:(NSString*) urlString{
    NSURL *feedURL = [NSURL URLWithString:urlString];
    feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL]; ///<---Init URL to parser
    feedParser.delegate = self;
    feedParser.feedParseType = ParseTypeFull; ///<--- Parse feed info and all items
    feedParser.connectionType = ConnectionTypeAsynchronously;
    [feedParser parse]; ///<--- start parsing
}
- (void)feedParserDidStart:(MWFeedParser *)parser {
  NSLog(@"Started Parsing: %@", parser.url);

}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
    NSString *title = info.title;
    NSString *link = info.link;
    NSString *summary = info.summary;
    NSLog(@"Info %@",link);
    if ([helper checkForDuplicateObject:@"Channel" :@"link" :link]) {
        cdChannel = nil;
        [feedParser stopParsing];
        [helper raiseAlert:@"Record existed" :self];
    }
    else{
        [self toggleAddRSSView:self];
        self.txtURLInput.text = nil;
        cdChannel = [[Channel alloc] initWithContext:context];
        cdChannel.title = title;
        cdChannel.link = link;
        cdChannel.des = summary;
        NSLog(@"result %@", cdChannel.title);
    }
}

- (void)feedParserDidFinish:(MWFeedParser *)parser{
    NSLog(@"Finished Parsing");
    [self reloadChannelTableView];
    [self loadEssentialDatas];
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    NSString *title = item.title;
    NSString *link = item.link;
    NSString *summary = item.summary;
    NSString *imgURL = [helper getSrcAttribute:[summary stringByLinkifyingURLs]];
    NSString *desciption = [summary stringByConvertingHTMLToPlainText];
    NSDate *pubDate = item.date;
    cdItem = [[Item alloc] initWithContext:context];
    cdItem.title = title;
    cdItem.link = link;
    cdItem.des = desciption;
    cdItem.imgURL = imgURL;
    cdItem.channel = cdChannel;
    cdItem.date = pubDate;
    
    ///<---- Uncomment below codes to see the item's data in detail
//    printf("--------------------------------------------\n");
//    printf("Title: %s \n",[title UTF8String]);
//    printf("Link: %s \n",[link UTF8String]);
//    printf("Description: %s \n",[desciption UTF8String]);
//    printf("ImgLink: %s \n",[imgURL UTF8String]);
//    NSLog(@"%@ \n", pubDate);
//    printf("Channel title: %s \n",[cdChannel.title UTF8String]);
//    printf("Channel name: %s \n",[cdChannel.link UTF8String]);
//    printf("Channel description: %s \n",[cdChannel.des UTF8String]);
//    printf("--------------------------------------------\n");
//    printf("\n");
    
    /// didParseFeedItem is run after didParseFeedItem so saving context at this point is common practice
    ///
    [appDelegate saveContext];
}



#pragma mark    Tableview setup
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (channelTitles.count == 0 ) {
        self.channelTableView.backgroundView = self.viewNoData; ///<- Set a view when there is no data on table view
        return 0;
    }
    return channelTitles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChannelTableViewCell *channelCell = (ChannelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"channelCell"]; ///<- Set a cell using cell's identifier (the id was defined in storyboard)
    channelCell.lbChannelTitle.text = [channelTitles objectAtIndex:indexPath.row];
    return channelCell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{   ///<---Setup for table view cell's swipe left action to delete
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Channel"];  ///<--- Create Resquest
        
        ///Add filter to request - from the selected cell, we can get the index of the titles' of the data we want to delete from the titles array (we can use link if we want but in this case i want to use title)
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@", [channelTitles objectAtIndex:indexPath.row]];
        [request setPredicate:predicate];

        NSError *error = nil;
        NSArray *result = [context executeFetchRequest:request error:&error]; ///<----- Get result (the NSManageObject we want to delete)
        
        if (!error && result.count > 0) {
            for(NSManagedObject *managedObject in result){
                [context deleteObject:managedObject];      ///<----Delete object
            }
            [context save:nil];  ///<---- Save context
        }
        [channelTitles removeObjectAtIndex:indexPath.row]; ///<--- remove data from data array
        [channelLinks removeObjectAtIndex:indexPath.row];
        [self reloadChannelTableView]; ///<--- After the data is updated, we must updated the tableview
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{ ///<----We use this function when we want to set action to the selected cell
    [self dismissKeyboard];
    passData = [channelLinks objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}

-(void) reloadChannelTableView{
    [self loadEssentialDatas];
    if (channelTitles.count == 0 ) {    ///<---- if there is no data
        [self.channelTableView reloadData];
        self.channelTableView.backgroundView = self.viewNoData; ///<---Set background image fore table view (Display "No data" on the screen)
    }
    else{ ///<--- if there is data
        [self.channelTableView reloadData];
        self.channelTableView.backgroundView = nil; ///<---- Remove 'no data' view
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{ ///<----Because uitableview has scrollview, so we can implement dismiss keyboard through uiscrollviewdelegate
    [self dismissKeyboard];
}


@end
