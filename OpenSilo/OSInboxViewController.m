//
//  OSInboxViewController.m
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 8/5/14.
//  Copyright (c) 2014 OpenSilo Co. All rights reserved.
//

#import "OSInboxViewController.h"
#import <Firebase/Firebase.h>
#import "OSUIMacro.h"
#import "UIImageView+AFNetworking.h"
#import "OSTranscriptTableViewCell.h"
#import "OSSession.h"
#import "OSDateTimeUtils.h"

@interface OSInboxViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *filteredArray;
@property (nonatomic, strong) NSMutableArray *inboxArray;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) NSMutableDictionary *dict;

@end

@implementation OSInboxViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerCustomCellsFromNibs];
    self.tableView.separatorColor = [UIColor lightGrayColor];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self fetchInbox];
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.selectedArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OSTranscriptTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"OSTranscriptTableViewCell" forIndexPath:indexPath];
    
    NSString *messageId = [self.selectedArray objectAtIndex:indexPath.row];
    NSDictionary *messageDict = self.dict[messageId];
    NSDictionary *userInfoDict = [OSSession getInstance].allUsers[messageDict[@"user_id"]];
    
    cell.fullName.text = [NSString stringWithFormat:@"%@ %@",userInfoDict[@"first_name"],userInfoDict[@"last_name"]];
    cell.fullName.textColor = [UIColor blackColor];
    cell.message.text = messageDict[@"text"];
    NSString *messageTimestamp = messageDict[@"timestamp"];
    NSString *timeDetails = [[OSDateTimeUtils getInstance] convertDateTimeFromUTCtoLocalForDateTime:[messageTimestamp longLongValue]];
    NSArray *foo = [timeDetails componentsSeparatedByString: @"/"];
    NSString *time = [foo objectAtIndex: 0];
    NSString *date = [foo objectAtIndex: 1];
    cell.messageTime.text = time;
    NSURL *url = [NSURL URLWithString:[userInfoDict objectForKey:@"picture"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"imgPlaceholder"];
    __weak OSTranscriptTableViewCell *weakCell = cell;
    [weakCell.thumbProgressView startAnimating];
    [cell.pic setImageWithURLRequest:request
                    placeholderImage:placeholderImage
                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                 weakCell.pic.image = image;
                                 [weakCell.thumbProgressView stopAnimating];
                             } failure:^(NSURLRequest *request,
                                         NSHTTPURLResponse *response, NSError *error) {
                                 [weakCell.thumbProgressView stopAnimating];
                                 weakCell.thumbProgressView.hidden = YES;
                             }];
    cell.thumbProgressView.hidesWhenStopped=YES;
    cell.status.hidden = YES;
    [cell.pic.layer setMasksToBounds:YES];
    [cell.pic.layer setCornerRadius:22.0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.selectedArray = self.inboxArray;
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length>0) {
        [self searchForText:searchText];
    }else{
        self.selectedArray = self.inboxArray;
        [self.tableView reloadData];
        
    }
}

-(void)registerCustomCellsFromNibs
{
    [self.tableView registerNib:[UINib nibWithNibName:@"OSTranscriptTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OSTranscriptTableViewCell"];
}

-(void)fetchInbox{
//    NSString *userId = [OSSession getInstance].user.userId;
#warning need to change back to dynamic
    NSString *userId = @"53c43bbe94e4bf106a0ed35e";
    self.inboxArray = [[NSMutableArray alloc] init];
    Firebase *firebase = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/inbox/%@",fireBaseUrl,userId]];
    [firebase authWithCredential:fireBaseSecret withCompletionBlock:^(NSError* error, id authData) {
        [firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
            self.dict = snapshot.value[@"messages"];
            self.inboxArray = [NSMutableArray arrayWithArray:[self.dict allKeys]];
            self.selectedArray = self.inboxArray;
            [self.tableView reloadData];
        }];
    } withCancelBlock:^(NSError* error) {
        NSLog(@"error:%@",error);
    }];
}

- (void)searchForText:(NSString *)searchText
{
    if (searchText) {
        if (self.filteredArray) {
            [self.filteredArray removeAllObjects];
        }else{
            self.filteredArray = [[NSMutableArray alloc]init];
        }
        NSString *predicateFormat = @"%K CONTAINS[cd] %@";
        NSString *searchAttribute = @"text";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, searchAttribute, searchText];
  
        for (NSString  *messageId in self.inboxArray) {
            if ([predicate evaluateWithObject:self.dict[messageId]]) {
                [self.filteredArray addObject:messageId];
            }
        }
        self.selectedArray = self.filteredArray;
        [self.tableView reloadData];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
