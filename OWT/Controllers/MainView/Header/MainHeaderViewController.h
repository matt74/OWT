//
//  MainHeaderViewController.h
//  OWT
//
//  Created by Matthias BUREL on 01.03.19.
//  Copyright © 2019 OWT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OWTViewController.h"
#import "URL+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainHeaderViewController : OWTViewController

@property (nonatomic, strong) URL *url;

@end

NS_ASSUME_NONNULL_END
