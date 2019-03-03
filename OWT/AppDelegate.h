//
//  AppDelegate.h
//  OWT
//
//  Created by Matthias BUREL on 01.03.19.
//  Copyright © 2019 OWT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#define APP_DELEGATE               ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define PERSISTENT_CONTAINER       [APP_DELEGATE persistentContainer]

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;
- (void)importDemoData;
- (NSString *)randomStringWithLength:(int)len;


@end

