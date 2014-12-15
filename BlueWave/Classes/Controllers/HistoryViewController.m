//
//  HistoryViewController.m
//  BlueWave
//
//  Created by Rémi Hillairet on 28/10/14.
//  Copyright (c) 2014 Rémi Hillairet. All rights reserved.
//

#import "HistoryViewController.h"
#import "Define.h"

@interface HistoryViewController ()

@property (nonatomic, strong) UITableView *historyTableView;
@property (nonatomic, strong) NSArray *historyCategoriesTitles;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0.553 blue:0.576 alpha:1];
    
    _historyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT - 64.0)];
    [_historyTableView setDelegate:self];
    [_historyTableView setDataSource:self];
    [_historyTableView setRowHeight:60.0f];
    [_historyTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_historyTableView];
    
    _historyCategoriesTitles = [NSArray arrayWithObjects:@"Tous", @"Non vus", @"Favoris", @"Promotions", nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_historyCategoriesTitles count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifierCell = @"HistoryCell";
    
    UITableViewCell *historyCell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    if (!historyCell) {
        historyCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
        historyCell.backgroundColor = [UIColor clearColor];
        historyCell.textLabel.textColor = [UIColor whiteColor];
        historyCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        historyCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [historyCell.textLabel setText:[_historyCategoriesTitles objectAtIndex:indexPath.row]];
    }
    
    return historyCell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
