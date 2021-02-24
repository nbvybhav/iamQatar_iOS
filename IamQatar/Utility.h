//
//  Utility.h
//  FoodSpot
//
//  Created by alisons on 7/8/15.
//  Copyright (c) 2015 alisons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Utility : UIViewController

+(BOOL)reachable;
+(void) getFromUrl:(NSString*)url parametersPassed:(NSDictionary*)parameters completion:(void (^) (NSMutableDictionary *values))completion;
+(void)postToUrl:(NSString*)url parametersPassed:(NSDictionary*)parameters completion:(void (^) (NSMutableDictionary *values))completion;
+(void)addtoplist:(id)Value key:(NSString *)key plist:(NSString *)plist;
+(NSString *)getfromplist:(NSString *)key plist:(NSString *)plist;
+ (void)animateUIViewWhenFrameChanged:(UIView *)imageView newFrame:(CGRect)frame
                    animationDuration:(float)animationDurationValue animationDelay:(float)animationDelayValue;
+(void)setImage:(UIImageView *)image url:(NSString *)imageUrl;
+(NSString *)userId;
+(void)guestUserAlert:(UIViewController *)vc;
+(void)exitAlert:(UIViewController *)vc;

@end
