//
//  ProximityViewController.m
//  BlueWave
//
//  Created by Rémi Hillairet on 28/10/14.
//  Copyright (c) 2014 Rémi Hillairet. All rights reserved.
//

#import "ProximityViewController.h"
#import "LocalData.h"
#import "Define.h"
#import "BeaconItem.h"

@import CoreLocation;

@interface ProximityViewController () <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) UIImageView *loaderView;
@property (strong, nonatomic) UITableView *beaconsTableView;
@property (strong, nonatomic) NSMutableArray *beaconsTableViewData;
@property (strong, nonatomic) UITextView *beaconInfosView;

@end

@implementation ProximityViewController

#pragma mark - ViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _beaconsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT - 64.0)];
    [_beaconsTableView setDelegate:self];
    [_beaconsTableView setDataSource:self];
    [_beaconsTableView setRowHeight:60.0f];
    [_beaconsTableView setHidden:YES];
    [self.view addSubview:_beaconsTableView];
    
    NSArray *imagesArray = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"loader-scan-1"], [UIImage imageNamed:@"loader-scan-2"], [UIImage imageNamed:@"loader-scan-3"], [UIImage imageNamed:@"loader-scan-4"], [UIImage imageNamed:@"loader-scan-5"], [UIImage imageNamed:@"loader-scan-6"], [UIImage imageNamed:@"loader-scan-7"], nil];
    _loaderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    [_loaderView setCenter:CGPointMake(VIEW_WIDTH / 2, VIEW_HEIGHT / 2)];
    [_loaderView setAnimationImages:imagesArray];
    [_loaderView setAnimationDuration:3.0];
    [_loaderView startAnimating];
    [self.view addSubview:_loaderView];
    
    _beaconsTableViewData = [[NSMutableArray alloc] init];
    
    // Location Manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"API -- Call server for new beacon");
    [[LocalData sharedClient] getNewBeaconsWithLocationManager:self.locationManager completion:^(BOOL finished) {
        if (finished) {
            //NSArray *beacons = [[LocalData sharedClient] getAllBeacons];
            
//            for (NSDictionary *beacon in beacons) {
//                CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:[beacon objectForKey:@"uuid"]]
//                                                                                       major:(long)[[beacon objectForKey:@"major"] integerValue]
//                                                                                       minor:(long)[[beacon objectForKey:@"minor"] integerValue]
//                                                                                  identifier:[NSString stringWithFormat:@"%ld", (long)[[beacon objectForKey:@"beacon_id"] integerValue]]];
//                beaconRegion.notifyEntryStateOnDisplay = YES;
//                beaconRegion.notifyOnEntry = YES;
//                beaconRegion.notifyOnExit = YES;
//                [self.locationManager startMonitoringForRegion:beaconRegion];
//                [self.locationManager startRangingBeaconsInRegion:beaconRegion];
//            }
            CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"102B84B0-6F03-11E4-9803-0800200C9A66"] identifier:@"toto"];
            beaconRegion.notifyEntryStateOnDisplay = YES;
            beaconRegion.notifyOnEntry = YES;
            beaconRegion.notifyOnExit = YES;
            [self.locationManager startMonitoringForRegion:beaconRegion];
            [self.locationManager startRangingBeaconsInRegion:beaconRegion];
        }
    }];
}

- (void)displayBeacon:(BeaconItem*)item {
    [_loaderView stopAnimating];
    [_loaderView removeFromSuperview];
    
    BOOL containsItem = NO;
    for (BeaconItem *testItem in _beaconsTableViewData) {
        if ([testItem.uuid.UUIDString isEqualToString:item.uuid.UUIDString]) {
            containsItem = YES;
        }
    }
    if (!containsItem) {
        [_beaconsTableViewData addObject:item];
        _beaconsTableView.hidden = NO;
        [_beaconsTableView reloadData];
    }
}

#pragma mark - Location delegate

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    for (CLBeacon *beacon in beacons) {
        
        BeaconItem *item = [[LocalData sharedClient] findBeaconWithUUID:beacon.proximityUUID major:beacon.major minor:beacon.minor];
        [self displayBeacon:item];
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"ENTER REGION : \n%@", region);
    CLBeaconRegion *beacon = (CLBeaconRegion*)region;
    BeaconItem *item = [[LocalData sharedClient] findBeaconWithUUID:beacon.proximityUUID major:beacon.major minor:beacon.minor];
    [self displayBeacon:item];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"EXIT REGION : \n%@", region);
    CLBeaconRegion *beacon = (CLBeaconRegion*)region;
    for (BeaconItem *item in _beaconsTableViewData) {
        if ([[item.uuid UUIDString] isEqualToString:[beacon.proximityUUID UUIDString]] && item.majorValue == beacon.major && item.minorValue == beacon.minor) {
            [_beaconsTableViewData removeObject:item];
            break;
        }
    }
    [_beaconsTableView reloadData];
}

#pragma mark - Location Errors

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"Failed monitoring region: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager failed: %@", error);
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_beaconsTableViewData count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    BeaconItem *item = [_beaconsTableViewData objectAtIndex:indexPath.row];
    
    cell.textLabel.text = item.notification;
    cell.detailTextLabel.text = item.uuid.UUIDString;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *nextView = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    [self.navigationController pushViewController:nextView animated:YES];
}

#pragma mark - Memory

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
