//
//  MainHeaderViewController.m
//  OWT
//
//  Created by Matthias BUREL on 01.03.19.
//  Copyright © 2019 OWT. All rights reserved.
//

#import "MainHeaderViewController.h"
#import "AppDelegate.h"
#import "NotificationConstants.h"
#import "ServerConstants.h"
#import "AFNetworking.h"

typedef NS_ENUM(NSUInteger, URLValidationStatus) {
    URL_EMPTY,
    URL_BAD_FORMAT,
    SERVER_ERROR,
};

@interface MainHeaderViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *URLTextField;
@property (nonatomic, weak) IBOutlet UIButton *SendUrlButton;
@property (nonatomic, strong) NSString *authorizationToken;

@end

@implementation MainHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self SetTextFieldBorder:_URLTextField];
    _URLTextField.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)SendUrlAction:(id)sender {
    
    if ([self URLHasBeenValidate:_URLTextField.text]) {
        
        //************ Method 1 - Generate fake token ****************//
        // Method to generate fake TinyUrl with random Token.
        
        [self createFakeTinyUrl:_URLTextField.text];
        //************************************************************//
        
        //************ Method 2 - Generate real token from server ****************//
        // Method to generate Token from server (REST API).
        // The Api should return a Token for a given url
        
        //[self sendDNSAndCreateTokenRequest:_URLTextField.text];
        //************************************************************************//
        
        
        _URLTextField.text=nil;
    }
}

- (BOOL)URLHasBeenValidate:(NSString *)url{
    
    if (_URLTextField.text.length <= 0 ) {
        
        [self popErrorMessage:URL_EMPTY];
        
        return false;
    }else if (![self URLIsValid:_URLTextField.text]) {
        
        [self popErrorMessage:URL_BAD_FORMAT];
        
        return false;
    }else {
        return true;
    }
}

- (BOOL)URLIsValid:(NSString *)candidate {
    
    NSString *urlRegEx = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
    
}

-(void)SetTextFieldBorder :(UITextField *)textField{
    
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1;
    border.borderColor = [UIColor grayColor].CGColor;
    border.frame = CGRectMake(0, textField.frame.size.height - borderWidth, textField.frame.size.width, textField.frame.size.height);
    border.borderWidth = borderWidth;
    [textField.layer addSublayer:border];
    textField.layer.masksToBounds = YES;
}

- (void)popErrorMessage:(URLValidationStatus)error {
    
    NSString *ErrorMessage;
    
    switch (error)
    {
        case URL_EMPTY:
            ErrorMessage = @"Please complete the textfield to generate a tiny URL.";
            break;
        case URL_BAD_FORMAT:
            ErrorMessage = @"URL appear not to be in a valid format. URL should be in this format:\nhttp(s)://xxx.com";
            break;
        case SERVER_ERROR:
            ErrorMessage = @"Server error";
            break;
        default:
            break;
            
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info"
                                                                             message:ErrorMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    // Add Action
    [alertController addAction:[UIAlertAction actionWithTitle:@"ok"
                                                        style:UIAlertActionStyleDefault
                                                      handler:nil]];
    
    // Show Alert
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}



- (void)createFakeTinyUrl:(NSString*)url{
    NSString *fakeToken =  [APP_DELEGATE  randomStringWithLength:6];
    
    self.url = [NSEntityDescription insertNewObjectForEntityForName:@"URL" inManagedObjectContext:PERSISTENT_CONTAINER.viewContext];
    
    _url.uid = [NSUUID UUID].UUIDString;
    _url.date = [NSDate date];
    _url.url = url;
    _url.dns = TINY_URL_DNS;
    _url.token = fakeToken;
    _url.isDemo = NO;
    
    [self.persistentContainer.viewContext save:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:URL_DATA_UPDATED_NOTIFICATION object:nil];
}

#pragma mark - Network methods
- (void)sendDNSAndCreateTokenRequest:(NSString*)url {
    // URL
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", APP_BASE_URL, CREATE_URL_TOKEN_REQUEST_PATH];
    
    // Parameters
    NSDictionary *parameters = @{ @"client_id" : APP_CLIENT_ID,
                                  @"client_secret" : APP_CLIENT_SECRET,
                                  @"url" : url};
    
    // Request
    NSMutableURLRequest *urlRequest = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST"
                                                                                    URLString:urlString
                                                                                   parameters:parameters
                                                                                        error:nil];
    
    
    NSURLSessionDataTask *dataTask = [[AFHTTPSessionManager manager] dataTaskWithRequest:urlRequest
                                                                          uploadProgress:nil
                                                                        downloadProgress:nil
                                                                       completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                                           
                                                                           if (error) {
                                                                               // Manage Error
                                                                               [self popErrorMessage:SERVER_ERROR];
                                                                           }
                                                                           else {
                                                                               NSLog(@"SUCCESS");
                                                                               
                                                                               // Create url and save locally
                                                                               URL *url = [NSEntityDescription insertNewObjectForEntityForName:@"URL" inManagedObjectContext:PERSISTENT_CONTAINER.viewContext];
                                                                               
                                                                               url.uid =    [[NSUUID UUID] UUIDString];
                                                                               url.date =   [responseObject objectForKey:@"Date"];
                                                                               url.url =    [responseObject objectForKey:@"Url"];
                                                                               url.dns =    [responseObject objectForKey:@"Dns"];
                                                                               url.token =  [responseObject objectForKey:@"Token"];
                                                                               url.isDemo = [responseObject objectForKey:@"IsDemo"];
                                                                               
                                                                               // Save context
                                                                               [APP_DELEGATE saveContext];
                                                                               
                                                                               [[NSNotificationCenter defaultCenter] postNotificationName:URL_DATA_UPDATED_NOTIFICATION object:nil];
                                                                           }
                                                                       }];
    
    [dataTask resume];
}

@end
