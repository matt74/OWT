//
//  OWTViewController.m
//  OWT
//
//  Created by Matthias BUREL on 01.03.19.
//  Copyright © 2019 OWT. All rights reserved.
//

#import "OWTViewController.h"
#import "AppDelegate.h"

@interface OWTViewController ()

@end

@implementation OWTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Core data
    self.persistentContainer = PERSISTENT_CONTAINER;
}

#pragma mark - Core Data Saving support
- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    [self saveContext:context];
}

- (void)saveContext:(NSManagedObjectContext *)context {
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
