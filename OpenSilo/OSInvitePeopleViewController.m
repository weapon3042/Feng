//
//  OSInvitePeopleViewController.m
//  OpenSilo
//
//  Created by Peng Wan & Elmir Kouliev on 7/31/14.
//  Copyright (c) 2014 OpenSilo Co. All rights reserved.
//

#import "OSInvitePeopleViewController.h"
#import "OSSession.h"
#import "OSPeopleTableViewCell.h"
#import <Firebase/Firebase.h>
#import "OSUIMacro.h"
#import "UIImageView+AFNetworking.h"
#import "OSGetRequest.h"

@interface OSInvitePeopleViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *filteredArray;
@property (nonatomic, strong) NSMutableArray *peopleArray;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@end

@implementation OSInvitePeopleViewController

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
    self.tableView.separatorColor = [UIColor clearColor];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self fetchPeople];
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
    OSPeopleTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"OSPeopleTableViewCell" forIndexPath:indexPath];
    NSDictionary *userInfoDict = [self.selectedArray objectAtIndex:indexPath.row];
    cell.fullName.text = [NSString stringWithFormat:@"%@ %@",userInfoDict[@"first_name"],userInfoDict[@"last_name"]];
    cell.fullName.textColor = [UIColor blackColor];
    cell.jobTitle.text = userInfoDict[@"knowledge_title"];
    NSURL *url = [NSURL URLWithString:[userInfoDict objectForKey:@"picture"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"imgPlaceholder"];
    __weak OSPeopleTableViewCell *weakCell = cell;
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
    Firebase *firebase = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/presence/%@",fireBaseUrl,userInfoDict[@"user_id"]]];
    //            NSLog(@"userId:%@", userInfoDict[@"user_id"]);
    cell.status.backgroundColor = USER_AWAY;
    [firebase authWithCredential:fireBaseSecret withCompletionBlock:^(NSError* error, id authData) {
        [firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
            //                    NSLog(@"status:%@", snapshot.value);
            //                    online/offline/idle/away/busy
            if ([snapshot.value isEqualToString:@"online"]) {
//                NSLog(@"userId:%@", userInfoDict[@"user_id"]);
                cell.status.backgroundColor = USER_ONLINE;
            }
            if ([snapshot.value isEqualToString:@"busy"]) {
                cell.status.backgroundColor = USER_BUSY;
            }
        }];
    } withCancelBlock:^(NSError* error) {
        NSLog(@"error:%@",error);
    }];
    //            customize cell's style
    [cell.status.layer setMasksToBounds:YES];
    [cell.status.layer setCornerRadius:5.0];
    [cell.pic.layer setMasksToBounds:YES];
    [cell.pic.layer setCornerRadius:22.0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OSPeopleTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.searchBar.text = [self.searchBar.text stringByAppendingString:[NSString stringWithFormat:@"%@, ",cell.fullName.text]];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.selectedArray = self.peopleArray;
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length>0) {
        [self searchForText:searchText];
    }else{
        self.selectedArray = self.peopleArray;
        [self.tableView reloadData];

    }
}

-(void)registerCustomCellsFromNibs
{
    [self.tableView registerNib:[UINib nibWithNibName:@"OSPeopleTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OSPeopleTableViewCell"];
}

-(void)fetchPeople{
    OSGetRequest *request = [[OSGetRequest alloc]init];
    [request getApiRequest:[NSString stringWithFormat:@"api/users"] params:nil setAuthHeader:YES responseBlock:^(id responseObject, NSError *error) {
        if (!error) {
            self.peopleArray = responseObject[@"result"];
            self.selectedArray = self.peopleArray;
            [self.tableView reloadData];
        }
    }];
   
}

- (void)searchForText:(NSString *)searchText
{
    if (searchText) {
        NSString *predicateFormat = @"%K CONTAINS[cd] %@";
        NSString *searchAttribute = @"email";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, searchAttribute, searchText];
        self.filteredArray = [NSMutableArray arrayWithArray:[self.peopleArray filteredArrayUsingPredicate:predicate]];
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
