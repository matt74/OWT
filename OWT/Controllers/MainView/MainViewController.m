//
//  ViewController.m
//  OWT
//
//  Created by Matthias BUREL on 01.03.19.
//  Copyright © 2019 OWT. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "MainHeaderViewController.h"
#import "NotificationConstants.h"
#import "URLTableViewCell.h"

@interface MainViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MainHeaderViewController *headerViewController;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"OWT";
    
    [self refreshUI];
    _tableView.delegate=self;
    
    // Remove empty lines
    _tableView.tableFooterView = [[UIView alloc] init];
    
    // TableView inset
    _tableView.contentInset = UIEdgeInsetsMake(_tableView.contentInset.top,
                                               _tableView.contentInset.left,
                                               40.0f,
                                               _tableView.contentInset.right);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshUI)
                                                 name:URL_DATA_UPDATED_NOTIFICATION
                                               object:nil];
    
    [APP_DELEGATE importDemoData];
}

- (void)refreshUI {
    [self refreshData];
    [_tableView reloadData];
    [self highlightCell];
}

#pragma mark - Refresh methods
- (void)refreshData {
    NSFetchRequest *request = [URL fetchRequest];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    request.fetchLimit = 365;
    self.dataArray = [PERSISTENT_CONTAINER.viewContext executeFetchRequest:request error:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    URLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:URLTableViewCell_ID];

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [(URLTableViewCell *)cell configWithURL:[_dataArray objectAtIndex:indexPath.row]];
}

#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    URL *url = [_dataArray objectAtIndex:indexPath.row];
    
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:[NSURL URLWithString:url.url] options:@{} completionHandler:nil];
}

-(void)highlightCell{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    URLTableViewCell *cell = (URLTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
    [UIView animateWithDuration:0.1 animations:^{
        // hide
        cell.alpha = 0.0;
    } completion:^(BOOL finished) {
        // show after hiding
        [UIView animateWithDuration:2.0 animations:^{
            cell.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

@end
