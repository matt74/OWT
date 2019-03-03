//
//  AppDelegate.m
//  OWT
//
//  Created by Matthias BUREL on 01.03.19.
//  Copyright © 2019 OWT. All rights reserved.
//

#import "AppDelegate.h"
#import "URL+CoreDataClass.h"
#import "NotificationConstants.h"
#import "ServerConstants.h"

#define LETTERS @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

@interface AppDelegate ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)importDemoData {
    
    NSFetchRequest *request = [URL fetchRequest];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    request.fetchLimit = 365;
    self.dataArray = [PERSISTENT_CONTAINER.viewContext executeFetchRequest:request error:nil];
    
    if ([_dataArray count] ==0 ) {
        
        // Save context
        [self saveContext];
        //*****************************************************************************************************************//
        
        [self.persistentContainer performBackgroundTask:^(NSManagedObjectContext * _Nonnull backgroundContext) {
            
            URL *url = nil;
            NSDate *date = [NSDate date];
            
            NSArray *sampleURL = @[@"https://openwt.com",
                                   @"https://stackoverflow.com",
                                   @"https://twitter.com",
                                   ];
            
            for (NSInteger i = 0; i < [sampleURL count]; i++) {
                
                NSString *fakeToken =  [self randomStringWithLength:6];
                
                url = [NSEntityDescription insertNewObjectForEntityForName:@"URL" inManagedObjectContext:backgroundContext];
                url.uid = [NSUUID UUID].UUIDString;
                url.date = [date dateByAddingTimeInterval:-i*24*60*60];
                url.url = [sampleURL objectAtIndex:i];
                url.dns = TINY_URL_DNS;
                url.token = fakeToken;
                url.isDemo = YES;
            }
            
            // Save
            NSError *error;
            [backgroundContext save:&error];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:URL_DATA_UPDATED_NOTIFICATION object:nil];
            });
        }];
    }
}

-(NSString *)randomStringWithLength:(int)len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [LETTERS characterAtIndex: arc4random_uniform([LETTERS length])]];
    }
    
    return randomString;
}

#pragma mark - Core Data stack
@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"OWT"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}


@end
