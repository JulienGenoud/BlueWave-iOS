//
//  ProximityViewController.m
//  BlueWave
//
//  Created by Rémi Hillairet on 28/10/14.
//  Copyright (c) 2014 Rémi Hillairet. All rights reserved.
//

#import "ProximityViewController.h"
#import "DetailsViewController.h"
#import "LocalData.h"
#import "Define.h"
#import "BeaconItem.h"

@import CoreLocation;

@interface ProximityViewController () <CLLocationManagerDelegate> {
    CABasicAnimation *pulseAnimation;
    NSMutableArray *beaconItems;
}

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) UIImageView *loaderView;
@property (strong, nonatomic) UITextView *beaconInfosView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (nonatomic) IBOutletCollection(UIView) NSArray *beaconViews;
@property (nonatomic) IBOutletCollection(UIView) NSArray *beaconContainers;
@property (nonatomic) IBOutletCollection(UILabel) NSArray *distanceLabels;
@property (nonatomic) IBOutletCollection(UILabel) NSArray *serialLabels;
@property (nonatomic) IBOutletCollection(UIButton) NSArray *beaconButtons;


@end

@implementation ProximityViewController

#pragma mark - ViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initBeaconViews];
    
    [self removeBeacons];
    
    beaconItems = [[NSMutableArray alloc] init];
    
    // Location Manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulseAnimation.duration = 0.5;
    pulseAnimation.toValue = [NSNumber numberWithFloat:1.05];;
    pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulseAnimation.autoreverses = YES;
    pulseAnimation.repeatCount = FLT_MAX;
    
    NSLog(@"API -- Call server for new beacon");
    [[LocalData sharedClient] getNewBeaconsWithLocationManager:self.locationManager completion:^(BOOL finished) {
        if (finished) {
            CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"102B84B0-6F03-11E4-9803-0800200C9A66"] identifier:@"beacon"];
            //CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"102B84B0-6F03-11E4-9803-0800200C9A66"] major:87 minor:23 identifier:@"toto"];
            beaconRegion.notifyEntryStateOnDisplay = YES;
            beaconRegion.notifyOnEntry = YES;
            beaconRegion.notifyOnExit = YES;
            [self.locationManager startMonitoringForRegion:beaconRegion];
            [self.locationManager startRangingBeaconsInRegion:beaconRegion];
        }
    }];
    
    for (UIView *view in self.beaconContainers) {
        if (view.layer.animationKeys.count == 0) {
            [view.layer addAnimation:pulseAnimation forKey:@"pulse"];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    for (UIView *view in self.beaconContainers) {
        if (view.layer.animationKeys.count == 0) {
            [view.layer addAnimation:pulseAnimation forKey:@"pulse"];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    for (UIView *view in self.beaconContainers) {
        if (view.layer.animationKeys.count == 0) {
            [view.layer addAnimation:pulseAnimation forKey:@"pulse"];
        }
    }
}

- (void)initBeaconViews {
    for (UIView *view in self.beaconViews) {
        view.layer.cornerRadius = view.frame.size.height / 2;
        view.layer.borderWidth = 1;
        view.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}

- (void)displayBeacons {
    NSUInteger end = 3;
    if (beaconItems.count < 3) {
        end = beaconItems.count;
    }
    for (NSUInteger i = 0; i < end; i++) {
        BeaconItem *item = [beaconItems objectAtIndex:i];
        UIView *containerView = [self.beaconContainers objectAtIndex:i];
        containerView.hidden = false;
        UILabel *serialLabel = [self.serialLabels objectAtIndex:i];
        serialLabel.text = item.name;
        if (item.accuracy > 0) {
            UILabel *distanceLabel = [self.distanceLabels objectAtIndex:i];
            distanceLabel.text = [NSString stringWithFormat:@"(distance %.1f m)", item.accuracy];
        }
    }
}

- (void)removeBeacons {
    for (UIView *view in self.beaconContainers) {
        view.hidden = true;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailsViewController *dest = (DetailsViewController*)[segue destinationViewController];
    UIButton *button = (UIButton*)sender;
    NSUInteger index = [self.beaconButtons indexOfObject:button];
    dest.item = [beaconItems objectAtIndex:index];
}

#pragma mark - Location delegate

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    //NSLog(@"Did range : %@", beacons);
    [beaconItems removeAllObjects];
    [self removeBeacons];
    for (CLBeacon *beacon in beacons) {
        BeaconItem *item = [[LocalData sharedClient] findBeaconWithUUID:beacon.proximityUUID major:beacon.major minor:beacon.minor];
        if (item != nil) {
            item.accuracy = beacon.accuracy;
            [beaconItems addObject:item];
        }
    }
    [self displayBeacons];
}

//-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
//    NSLog(@"AppDelegate ENTER REGION : \n%@", region);
//    CLBeaconRegion *beacon = (CLBeaconRegion*)region;
//    NSLog(@"Beacon detected : %@", beacon);
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    if ([prefs boolForKey:SETTINGS_NOTIFICATIONS]) {
//        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
//        localNotification.fireDate = [NSDate date];
//        localNotification.alertBody = @"Une balise Bluewave a été détectée";
//        localNotification.timeZone = [NSTimeZone defaultTimeZone];
//        localNotification.soundName = UILocalNotificationDefaultSoundName;
//        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
//    }
//}
//
//-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
//    NSLog(@"AppDelegate EXIT REGION : \n%@", region);
//    
//}

#pragma mark - Location Errors

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager failed: %@", error);
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
