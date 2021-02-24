//
//  NSString+CalendarView.h
//  ios_calendar
//
//  Created by Maxim Bilan on 1/24/14.
//  Copyright (c) 2014 Maxim Bilan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
@interface NSString (CalendarView)

- (void)drawUsingRect:(CGRect)rect withAttributes:(NSDictionary *)attrs;

@end
