//
//  URL+CoreDataProperties.m
//  OWT
//
//  Created by Matthias BUREL on 01.03.19.
//  Copyright © 2019 OWT. All rights reserved.
//

#import "URL+CoreDataProperties.h"

@implementation URL (CoreDataProperties)

+ (NSFetchRequest<URL *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"URL"];
}

@dynamic uid;
@dynamic date;
@dynamic url;
@dynamic token;
@dynamic dns;
@dynamic isDemo;

@end
