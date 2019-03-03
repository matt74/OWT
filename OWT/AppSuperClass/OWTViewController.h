//
//  OWTViewController.h
//  OWT
//
//  Created by Matthias BUREL on 01.03.19.
//  Copyright © 2019 OWT. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@interface OWTViewController : UIViewController

- (void)saveContext;
- (void)saveContext:(NSManagedObjectContext *)context;

@property (nonatomic, strong) NSPersistentContainer *persistentContainer;

@end

NS_ASSUME_NONNULL_END
