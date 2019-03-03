//
//  URLTableViewCell.h
//  OWT
//
//  Created by Matthias BUREL on 01.03.19.
//  Copyright © 2019 OWT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "URL+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

#define URLTableViewCell_ID  @"URLTableViewCellID"

@interface URLTableViewCell : UITableViewCell

- (void)configWithURL:(URL *)aUrl;

@end

NS_ASSUME_NONNULL_END
