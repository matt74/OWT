//
//  URLTableViewCell.m
//  OWT
//
//  Created by Matthias BUREL on 01.03.19.
//  Copyright © 2019 OWT. All rights reserved.
//

#import "URLTableViewCell.h"
@import WebKit;

@interface URLTableViewCell ()<WKNavigationDelegate>

@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *urlLabel;
@property (nonatomic, weak) IBOutlet UILabel *tinyLabel;
@property (nonatomic, retain) IBOutlet WKWebView *WebPreview;
@property (nonatomic, weak) IBOutlet UILabel *demoRecordLabel;

@property (nonatomic, strong) NSDateFormatter *formatter;
@end

@implementation URLTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.formatter = [[NSDateFormatter alloc] init];
    _formatter.dateStyle = NSDateFormatterMediumStyle;
    _formatter.timeStyle = NSDateFormatterShortStyle;
}

- (void)configWithURL:(URL *)aUrl {
    _dateLabel.text = [_formatter stringFromDate:aUrl.date];
    _urlLabel.text = [NSString stringWithFormat:@"%@", aUrl.url];
    _tinyLabel.text = [NSString stringWithFormat:@"%@/%@", aUrl.dns,aUrl.token];
    
    
    _WebPreview.navigationDelegate = self;
    NSURL *nsurl=[NSURL URLWithString:aUrl.url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [_WebPreview loadRequest:nsrequest];
    
    if (aUrl.isDemo) {
        _demoRecordLabel.textColor=[UIColor redColor];
        _demoRecordLabel.text=@"#Demo record";
    }else{
        _demoRecordLabel.textColor=[UIColor colorWithRed:48.0f/255.0f
                                                   green:146.0f/255.0f
                                                    blue:0.0f/255.0f
                                                   alpha:1.0f];
        _demoRecordLabel.text=@"#Real record";
    }
    
    [self setNeedsLayout];
    
    
}

@end
