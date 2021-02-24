//
//  Utility.m
//  FoodSpot
//
//  Created by alisons on 7/8/15.
//  Copyright (c) 2015 alisons. All rights reserved.
//

#import "Utility.h"
#import "constants.pch"
#import "Reachability.h"
#import "UIImageView+WebCache.h"
#import <Twitter/Twitter.h>

@interface Utility ()


@end

@implementation Utility

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = FALSE; // HIDE_BACK_BTN ;
    [self.navigationController setNavigationBarHidden:FALSE animated:YES];
    // Do any additional setup after loading the view.
}

+(void)guestUserAlert:(UIViewController *)vc
{
    
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Wait"
                                 message:@"Please login to continue"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Login"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    
//                                    LoginViewController *view = [vc.storyboard instantiateViewControllerWithIdentifier:@"login"];
//                                    [vc.navigationController pushViewController:view animated:YES];
                                    LoginViewController *view = [vc.storyboard instantiateViewControllerWithIdentifier:@"login"];
                                    [vc.navigationController popToRootViewControllerAnimated:NO];
                                    
                                    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                                    appDelegate.window.rootViewController =  [mainStoryBoard instantiateViewControllerWithIdentifier:@"login"];
                                    
                                    //G+ signout
                                    GIDSignIn *signin = [GIDSignIn sharedInstance];
                                    [signin signOut];
                                    
//                                    TWTRSessionStore *store = [[Twitter sharedInstance] sessionStore];
//                                    NSString *userID = store.session.userID;
//                                    [store logOutUserID:userID];
                                    
                                    //Logout plist clear
                                    [Utility addtoplist:@"" key:@"login" plist:@"iq"];
                                    
                                    //Resetting 'skipped user' value
                                    [Utility addtoplist:@"NO"key:@"skippedUser" plist:@"iq"];
                                    
                                    [vc.navigationController presentViewController:view animated:NO completion:nil];
                                    
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"Cancel"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   
                               }];
    
    //Add your buttons to alert controller
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [vc presentViewController:alert animated:YES completion:nil];
    
    
}

+(void)exitAlert:(UIViewController *)vc
{
    
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Wait"
                                 message:@"Are you sure want to exit"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    
                                    exit(0);
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"Cancel"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   
                               }];
    
    //Add your buttons to alert controller
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [vc presentViewController:alert animated:YES completion:nil];
    
    
}


//------------------------- checking for internet connection -------------------------------
#pragma mark rechability
+(BOOL)reachable
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if(internetStatus == NotReachable) {
        return NO;
    }
    return YES;
}

// Animate the change frame of view from old position to new position.
+ (void)animateUIViewWhenFrameChanged:(UIView *)imageView newFrame:(CGRect)frame
                    animationDuration:(float)animationDurationValue animationDelay:(float)animationDelayValue{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:animationDelayValue];
    [UIView setAnimationDuration:animationDurationValue];
    imageView.alpha=1;
    imageView.frame = frame;
    [UIView commitAnimations];
}

//+(void) getFromUrl:(NSString*)url parametersPassed:(NSDictionary*)parameters completion:(void (^) (NSMutableDictionary *values))completion;
//{
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
////    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    __block NSMutableDictionary *resultarray;
//   // resultarray = [[NSMutableDictionary alloc]init];
//    
//    [manager GET:url parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
//     {
//         NSLog(@"JSON: %@", responseObject);
//         NSMutableDictionary *resultarrayTwo = (NSMutableDictionary *)responseObject;
//         resultarray = resultarrayTwo;
//         completion(resultarray);
//     }
//      failure:^(NSURLSessionTask *task, NSError *error)
//    {
////         NSLog(@"Error: %@, %@", error, task.responseString);
//        NSLog(@"Error: %@", error);
////         UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Message" message:@"Try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
////         [alertView show];
////         completion(nil);
//        UIAlertController * alert = [UIAlertController
//                        alertControllerWithTitle:@"Message"
//                                         message:@"Try again"
//                                  preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction* ok = [UIAlertAction
//                            actionWithTitle:@"OK"
//                                      style:UIAlertActionStyleDefault
//                                    handler:^(UIAlertAction * action) {
//                                        //Handle your yes please button action here
//                                    }];
//        [alert addAction:ok];
////        [self presentViewController:alert animated:YES completion:nil];
//        
//     }];
//}
//
//+(void)postToUrl:(NSString*)url parametersPassed:(NSDictionary*)parameters completion:(void (^) (NSMutableDictionary *values))completion;
//{
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
////    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//     __block NSMutableDictionary *resultarray;
//    
//    [manager POST:url parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
//        
//        NSLog(@"JSON: %@", responseObject);
//        NSMutableDictionary *resultarrayTwo=(NSMutableDictionary *)responseObject;
//        resultarray = resultarrayTwo;
//        completion(resultarray);
//    } failure:^(NSURLSessionTask *task, NSError *error) {
//        
////        NSLog(@"Error: %@, %@", error, operation.responseString);
//        NSLog(@"Error: %@", error);
////        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Invalid Details" message:@"Try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
////        [alertView show];
//        UIAlertController * alert = [UIAlertController
//                        alertControllerWithTitle:@"Invalid Details"
//                                         message:@"Try again"
//                                  preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction* ok = [UIAlertAction
//                            actionWithTitle:@"OK"
//                                      style:UIAlertActionStyleDefault
//                                    handler:^(UIAlertAction * action) {
//                                        //Handle your yes please button action here
//                                    }];
//        [alert addAction:ok];
////        [self presentViewController:alert animated:YES completion:nil];
//    }];
//}



+(NSString *)getfromplist:(NSString *)key plist:(NSString *)plist
{
    NSArray *path1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [path1 objectAtIndex:0];
    NSString *finalPath1 = [documentsDirectoryPath stringByAppendingPathComponent:[plist stringByAppendingString:@".plist"]];
    
    NSMutableDictionary* plistDict1 = [[NSMutableDictionary alloc] initWithContentsOfFile:finalPath1];
    NSString *value;
    value = [plistDict1 valueForKey:key];
    
    path1                   = nil;
    documentsDirectoryPath  = nil;
    finalPath1              = nil;
    plistDict1              = nil;
    
    return value;
    value                   = nil;
    
}

+(void)addtoplist:(id)Value key:(NSString *)key plist:(NSString *)plist{
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [path objectAtIndex:0];
    NSString *finalPath = [documentsDirectoryPath stringByAppendingPathComponent:[plist stringByAppendingString:@".plist"] ];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath: finalPath])
    {
        NSString *bundle = [[NSBundle mainBundle]pathForResource:plist ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath: finalPath error:nil];
        bundle = nil;
    }
    
    NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:finalPath];
    [plistDict setValue:Value forKey:key];
    [plistDict writeToFile:finalPath atomically: YES];
    
    path                    = nil;
    documentsDirectoryPath  = nil;
    finalPath               = nil;
    fileManager             = nil;
    plistDict               = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//kolamazz
+(void)setImage:(UIImageView *)image url:(NSString *)imageUrl{
    
    __block UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = image.center;
    activityIndicator.hidesWhenStopped = YES;
    [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",parentURL,imageUrl]]
                    completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [activityIndicator removeFromSuperview];
    }];
    [image addSubview:activityIndicator];
    [activityIndicator startAnimating];
}



@end



