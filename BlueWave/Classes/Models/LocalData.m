//
//  LocalData.m
//  BlueWave
//
//  Created by Rémi Hillairet on 29/10/14.
//  Copyright (c) 2014 Rémi Hillairet. All rights reserved.
//

#import "LocalData.h"
#import "SQLiteManager.h"
#import "BeaconItem.h"

NSString * const kBaseURLString = @"http://api.notiwave.com";

@interface LocalData()

@property (nonatomic, strong) SQLiteManager *manager;

@end

@implementation LocalData

+ (LocalData*)sharedClient {
    static LocalData *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kBaseURLString]];
    });
    return _sharedClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    
    self.manager = [[SQLiteManager alloc] initWithDatabaseNamed:@"bluewave.db"];
    return self;
}

- (void)displayDataBase {
    NSArray *result = [self.manager getRowsForQuery:@"SELECT * FROM beacons"];
    NSLog(@"Database -- %@", result);
}

- (NSArray*)getAllBeacons {
    NSArray *result = [self.manager getRowsForQuery:@"SELECT * FROM beacons"];
    return result;
}

- (void)getNewBeaconsWithLocationManager:(CLLocationManager*)locationManager completion:(void (^)(BOOL finished))completion {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger lastUpdate = [prefs integerForKey:@"lastUpdate"];
    
    NSString *path = [NSString stringWithFormat:@"%@/?action=getUpdate&date=%ld", kBaseURLString, (long)lastUpdate];
    [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        NSLog(@"Server Response -- %@", responseObject);
        
        NSNumber *lastUpdate = [responseObject objectForKey:@"t"];
        [prefs setInteger:[lastUpdate integerValue] forKey:@"lastUpdate"];
        [prefs synchronize];
        
        NSArray *beacons = [responseObject objectForKey:@"e"];
        
        // Create Table if doesn't exist
        NSError *error = [self.manager doQuery:@"CREATE TABLE IF NOT EXISTS beacons (id INTEGER PRIMARY KEY AUTOINCREMENT, beacon_id INTEGER, uuid VARCHAR, major INTEGER, minor INTEGER, notification TEXT, range INTEGER);"];
        if (error != nil) {
            NSLog(@"Error: %@",[error localizedDescription]);
        }
        
        for (NSArray *beacon in beacons) {
            NSString *dbQuery = [NSString stringWithFormat:@"INSERT INTO beacons (beacon_id, uuid, major, minor, notification, range) values (\"%ld\", \"%@\", \"%ld\", \"%ld\", \"%@\", \"%ld\")", (long)[[beacon objectAtIndex:0] integerValue], [beacon objectAtIndex:1], (long)[[beacon objectAtIndex:2] integerValue], (long)[[beacon objectAtIndex:3] integerValue], [beacon objectAtIndex:4], (long)[[beacon objectAtIndex:5] integerValue]];
            NSError *error;
            error = [self.manager doQuery:dbQuery];
            
            if (error != nil) {
                NSLog(@"Error: %@",[error localizedDescription]);
            }
        }

        [self displayDataBase];
        completion(YES);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Failure -- %@", error);
        completion(YES);
    }];
}

- (BeaconItem*)findBeaconWithUUID:(NSUUID*)uuid major:(NSNumber*)major minor:(NSNumber*)minor {
    NSString *dbQuery = [NSString stringWithFormat:@"SELECT * FROM beacons WHERE uuid = \"%@\" AND major = %ld AND minor = %ld", [uuid UUIDString], (long)[major integerValue], (long)[minor integerValue]];
    NSArray *result = [self.manager getRowsForQuery:dbQuery];
    
    if ([result count] == 0) {
        NSLog(@"FIND BEACON -- No beacon found");
    } else if ([result count] > 1) {
        NSLog(@"FIND BEACON -- %ld results found. It must have just one result !", [result count]);
    } else {
        NSDictionary *dataItem = [result objectAtIndex:0];
        BeaconItem *beaconitem = [[BeaconItem alloc] initWithBeaconID:[dataItem objectForKey:@"beacon_id"]
                                                                 UUID:[[NSUUID alloc] initWithUUIDString:[dataItem objectForKey:@"uuid"]]
                                                                major:[dataItem objectForKey:@"major"]
                                                                minor:[dataItem objectForKey:@"minor"]
                                                         notification:[dataItem objectForKey:@"notification"]
                                                                range:[dataItem objectForKey:@"range"]];
        return beaconitem;
    }
    
    return nil;
}

@end
