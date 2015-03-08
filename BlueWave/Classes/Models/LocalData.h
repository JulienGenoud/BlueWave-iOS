//
//  LocalData.h
//  BlueWave
//
//  Created by Rémi Hillairet on 29/10/14.
//  Copyright (c) 2014 Rémi Hillairet. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "BeaconItem.h"

extern NSString * const kBaseURLString;

@interface LocalData : AFHTTPSessionManager

@property (nonatomic, strong) NSMutableArray *allBeaconsSeen;
@property (nonatomic, strong) NSMutableArray *notSeenBeacons;
@property (nonatomic, strong) NSMutableArray *favoriteBeacons;

+ (LocalData*)sharedClient;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)getNewBeaconsWithLocationManager:(CLLocationManager*)locationManager completion:(void (^)(BOOL finished))completion;
- (NSArray*)getAllBeacons;
- (void)displayDataBase;
- (BeaconItem*)findBeaconWithUUID:(NSUUID*)uuid major:(NSNumber*)major minor:(NSNumber*)minor;
- (void)getContentWithSerial:(NSString*)serial completion:(void (^)(BOOL success, NSArray *content))completion;

@end
