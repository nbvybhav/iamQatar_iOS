//
//  instagramViewController.h
//  IamQatar
//
//  Created by alisons on 4/13/17.
//  Copyright © 2017 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>


@interface instagramViewController : UIViewController <WKNavigationDelegate>
{
    
    __weak IBOutlet WKWebView *loginWebView;
    
    IBOutlet UIActivityIndicatorView* loginIndicator;
    IBOutlet UILabel *loadingLabel;
}
@property(strong,nonatomic)NSString *typeOfAuthentication;

@end
