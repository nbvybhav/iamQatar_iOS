//
//  instagramViewController.m
//  IamQatar
//
//  Created by alisons on 4/13/17.
//  Copyright © 2017 alisons. All rights reserved.
//

#import "instagramViewController.h"
#import "constants.pch"
#import "AFNetworking/AFNetworking.h"
#import <WebKit/WebKit.h>
@interface instagramViewController ()

@end

@implementation instagramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];
    self.typeOfAuthentication = @"SIGNED";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)prefersStatusBarHidden {

  return NO;
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    
    NSString* authURL = nil;
    
    if ([_typeOfAuthentication isEqualToString:@"UNSIGNED"])
    {
        authURL = [NSString stringWithFormat: @"%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True",
                   INSTAGRAM_AUTHURL,
                   INSTAGRAM_CLIENT_ID,
                   INSTAGRAM_REDIRECT_URI,
                   INSTAGRAM_SCOPE];
    }
    else
    {
        authURL = [NSString stringWithFormat: @"%@?client_id=%@&redirect_uri=%@&response_type=code&scope=%@&DEBUG=True",
                   INSTAGRAM_AUTHURL,
                   INSTAGRAM_CLIENT_ID,
                   INSTAGRAM_REDIRECT_URI,
                   INSTAGRAM_SCOPE];
    }
    
    
    [loginWebView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: authURL]]];
//    [loginWebView setDelegate:self];
//    [loginWebView.navigationDelegate];
    [loginWebView.UIDelegate self];
    [loginWebView.navigationDelegate self];
}



- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
  

    [self checkRequestForCallbackURL: navigationAction.request];
    
  }

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [loginIndicator startAnimating];
    loadingLabel.hidden = NO;
    [loginWebView.layer removeAllAnimations];
    loginWebView.userInteractionEnabled = NO;
    [UIView animateWithDuration: 0.1 animations:^{
        //  loginWebView.alpha = 0.2;
    }];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [loginIndicator stopAnimating];
    loadingLabel.hidden = YES;
    [loginWebView.layer removeAllAnimations];
    loginWebView.userInteractionEnabled = YES;
    [UIView animateWithDuration: 0.1 animations:^{
        //loginWebView.alpha = 1.0;
    }];
}


- (BOOL) checkRequestForCallbackURL: (NSURLRequest*) request
{
    NSString* urlString = [[request URL] absoluteString];
    
    if ([_typeOfAuthentication isEqualToString:@"UNSIGNED"])
    {
        // check, if auth was succesfull (check for redirect URL)
        if([urlString hasPrefix: INSTAGRAM_REDIRECT_URI])
        {
            // extract and handle access token
            NSRange range = [urlString rangeOfString: @"#access_token="];
            [self handleAuth: [urlString substringFromIndex: range.location+range.length]];
            return NO;
        }
    }
    else
    {
        if([urlString hasPrefix: INSTAGRAM_REDIRECT_URI])
        {
            // extract and handle code
            NSRange range = [urlString rangeOfString: @"code="];
            [self makePostRequest:[urlString substringFromIndex: range.location+range.length]];
            return NO;
        }
    }
    
    return YES;
}



-(void)makePostRequest:(NSString *)code
{
  if ([Utility reachable])
  {
    NSString *post = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",INSTAGRAM_CLIENT_ID,INSTAGRAM_CLIENTSERCRET,INSTAGRAM_REDIRECT_URI,code];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:@"https://api.instagram.com/oauth/access_token"]];
    [requestData setHTTPMethod:@"POST"];
    [requestData setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [requestData setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [requestData setHTTPBody:postData];
    
      __block NSURLResponse *response = NULL;
      __block NSError *requestError = NULL;
//    NSData *responseData = [NSURLConnection sendSynchronousRequest:requestData returningResponse:&response error:&requestError];
      __block NSData *responseData = nil;
      [[[NSURLSession sharedSession] dataTaskWithRequest:requestData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable responses, NSError * _Nullable error) {
          responseData = data;
          response = responses;
          requestError = error;
      }]resume];
      
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    [self handleAuth:dict ];
  }else
  {
      [AlertController alertWithMessage:@"No network connection available!" presentingViewController:self];
  }
}

- (void) handleAuth: (NSDictionary*) UserInfo
{
    NSLog(@"%@",UserInfo);
    NSArray *info = [UserInfo valueForKey:@"user"];
    [self SocialLoginRequest:[info valueForKey:@"full_name"] :@"instagram" :@"username"];
}


#pragma mark - Instgram Login

- (void)SocialLoginRequest:(NSString*)UserName :(NSString*)LoginType : (NSString*)KeyForSocial
{
  if ([Utility reachable]) {
     [ProgressHUD show];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:UserName,KeyForSocial,LoginType,@"login_type",nil];
    
    
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//      AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
      AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8"  forHTTPHeaderField:@"Content-Type"];
    
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",parentURL,loginUrl] parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
     
     
     {
//    success:^(AFHTTPRequestOperation *operation, id responseObject)
         NSLog(@"JSON: %@", responseObject);
         NSString *text = [responseObject objectForKey:@"code"];

         if ([text isEqualToString: @"200"])
         {
             AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
             self.tabBarController.selectedIndex = 1;
            [appDelegate.window setRootViewController:appDelegate.tabBarController];
             appDelegate.userProfileDetails = [responseObject objectForKey:@"value"];
         }
         else
         {
             [AlertController alertWithMessage:text presentingViewController:self];
             NSLog(@"User Doesnot Exist");
         }
          [ProgressHUD dismiss];
     }
     failure:^(NSURLSessionTask *task, NSError *error)
     {
//    failure:^(AFHTTPRequestOperation *operation, NSError *error)
         NSLog(@"Error: %@", error);
         [ProgressHUD dismiss];
     }];
  }else
  {
      [AlertController alertWithMessage:@"No network connection available!" presentingViewController:self];
  }
}

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
