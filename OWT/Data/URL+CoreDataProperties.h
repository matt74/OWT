//
//  URL+CoreDataProperties.h
//  OWT
//
//  Created by Matthias BUREL on 01.03.19.
//  Copyright © 2019 OWT. All rights reserved.
//

#import "URL+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface URL (CoreDataProperties)

+ (NSFetchRequest<URL *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *uid;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSString *url;
@property (nullable, nonatomic, copy) NSString *token;
@property (nullable, nonatomic, copy) NSString *dns;
@property (nonatomic) BOOL isDemo;

@end

NS_ASSUME_NONNULL_END
