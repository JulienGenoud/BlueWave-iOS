//
//  HistoryDetailsViewController.m
//  BlueWave
//
//  Created by Rémi Hillairet on 15/12/14.
//  Copyright (c) 2014 Rémi Hillairet. All rights reserved.
//

#import "HistoryDetailsViewController.h"
#import "Define.h"

@interface HistoryDetailsViewController() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *historyTableView;

@end

@implementation HistoryDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _historyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT - 64.0)];
    [_historyTableView setDelegate:self];
    [_historyTableView setDataSource:self];
    [_historyTableView setRowHeight:60.0f];
    [_historyTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_historyTableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
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
        [historyCell.textLabel setText:@"Promotion sur les cravates"];
    }
    
    return historyCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *nextView = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    [self.navigationController pushViewController:nextView animated:YES];
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
