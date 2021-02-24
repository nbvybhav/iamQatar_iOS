//
//  AlertController.h
//  foundation
//
//  Created by iOS Developer on 30/10/15.
//  Copyright © 2015 Xperts Infosoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface AlertController : NSObject

@property (strong, nonatomic) UIAlertController *uiAlertController;

+ (void)alertWithMessage:(NSString*)message presentingViewController:(UIViewController*)vc;
+ (void)alertWithMessage:(NSString *)message presentingViewController:(UIViewController *)vc tag:(NSInteger)tag;
+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate cancelButtonTitle:(NSString*)cancelTitle otherButtonTitles:(NSArray*)otherButtonTitles style:(UIAlertControllerStyle)style presentingViewController:(UIViewController*)vc tag:(NSInteger)tag;

//for text field
- (void)showAlertWithTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate cancelButtonTitle:(NSString*)cancelTitle otherButtonTitles:(NSArray*)otherButtonTitles presentingViewController:(UIViewController*)vc tag:(NSInteger)tag;
- (void)addTextFieldWithPlaceholder:(NSString*)placeholder;
- (void)addTextFieldWithPlaceholder:(NSString *)placeholder secureEntry:(BOOL)secure;

@end

@protocol AlertControllerDelegate <NSObject>

@optional

- (void)alertController:(UIAlertController*)alertController clickedButtonAtIndex:(NSInteger)buttonIndex tag:(NSInteger)tag;
- (void)alertControllerDidCancel;

@end

@interface AlertController ()

@property (weak, nonatomic) id<AlertControllerDelegate> delegate;

@end
