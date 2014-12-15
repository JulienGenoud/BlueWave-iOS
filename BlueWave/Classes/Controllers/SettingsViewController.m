//
//  SettingsViewController.m
//  BlueWave
//
//  Created by Rémi Hillairet on 28/10/14.
//  Copyright (c) 2014 Rémi Hillairet. All rights reserved.
//

#import "SettingsViewController.h"
#import "Define.h"

@interface SettingsViewController () {
    NSArray *totoArray;
}

@property (nonatomic, strong) UISwitch *notificationSwitch;
@property (nonatomic, strong) NSUserDefaults *prefs;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0.553 blue:0.576 alpha:1];
    
    UITableView *settingsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT) style:UITableViewStyleGrouped];
    [settingsTableView setDelegate:self];
    [settingsTableView setDataSource:self];
    [settingsTableView setRowHeight:60.0f];
    [settingsTableView setAllowsSelection:NO];
    [settingsTableView setScrollEnabled:NO];
    [settingsTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:settingsTableView];
    
    // Settings Button
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [settingsButton setFrame:CGRectMake(0, 0, 100, 50)];
    [settingsButton setTitle:@"Bluewave settings" forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [settingsButton sizeToFit];
    [settingsButton setCenter:CGPointMake(VIEW_WIDTH / 2, VIEW_HEIGHT / 2)];
    //[self.view addSubview:settingsButton];
    
    _prefs = [NSUserDefaults standardUserDefaults];
    
    totoArray = @[@"Promotions", @"Avantages clients", @"Oeuvres d'art"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 1;
    return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"SettingsCell";
    
    UITableViewCell *settingsCell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (!settingsCell) {
        settingsCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        settingsCell.backgroundColor = [UIColor colorWithRed:0 green:0.553 blue:0.576 alpha:1];
        
        if (indexPath.section == 0) {
            _notificationSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(VIEW_WIDTH - 49 - ((VIEW_WIDTH * 5) / 100), (settingsCell.frame.size.height / 2) - 7, 49, 31)];
            [_notificationSwitch setOn:[[_prefs objectForKey:SETTINGS_NOTIFICATIONS] boolValue]];
            [settingsCell addSubview:_notificationSwitch];
            [_notificationSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
            settingsCell.textLabel.text = @"Recevoir des notifications";
        } else {
            UISwitch *totoSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(VIEW_WIDTH - 49 - ((VIEW_WIDTH * 5) / 100), (settingsCell.frame.size.height / 2) - 7, 49, 31)];
            [totoSwitch setOn:YES];
            [settingsCell addSubview:totoSwitch];
            settingsCell.textLabel.text = [totoArray objectAtIndex:indexPath.row];
        }
    }
    
    return settingsCell;
}

- (void)valueChanged:(UISwitch *)theSwitch {
    if (theSwitch.isOn) {
        [_prefs setObject:[NSNumber numberWithBool:YES] forKey:SETTINGS_NOTIFICATIONS];
        
    } else {
        [_prefs setObject:[NSNumber numberWithBool:NO] forKey:SETTINGS_NOTIFICATIONS];
    }
    [_prefs synchronize];
}

- (void)buttonPressed:(id)sender {
    NSURL *settings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    
    if ([[UIApplication sharedApplication] canOpenURL:settings])
        [[UIApplication sharedApplication] openURL:settings];
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
