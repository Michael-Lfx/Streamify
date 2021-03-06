//
//  NSDate+RelativeDate.m
//  NSDate+RelativeDate (Released under MIT License)
//
//  Created by digdog on 9/23/09.
//  Copyright (c) 2009 Ching-Lan 'digdog' HUANG. http://digdog.tumblr.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//  

#import "NSDate+Additions.h"


@implementation NSDate (RelativeDate)

- (NSString *)relativeDate {

	NSCalendar *calendar = [NSCalendar sharedCalendar];

	NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;

	NSDateComponents *components = [calendar components:unitFlags fromDate:self toDate:[NSDate date] options:0];

	NSArray *selectorNames = [NSArray arrayWithObjects:@"year", @"month", @"week", @"day", @"hour", @"minute", @"second", nil];

	for (NSString *selectorName in selectorNames) {
		SEL currentSelector = NSSelectorFromString(selectorName);
		NSMethodSignature *currentSignature = [NSDateComponents instanceMethodSignatureForSelector:currentSelector];
		NSInvocation *currentInvocation = [NSInvocation invocationWithMethodSignature:currentSignature];

		[currentInvocation setTarget:components];
		[currentInvocation setSelector:currentSelector];
		[currentInvocation invoke];

		NSInteger relativeNumber;
		[currentInvocation getReturnValue:&relativeNumber];

    NSString *pluralisation = @"";
    if (relativeNumber > 1)
      pluralisation = @"s";
    if (relativeNumber && relativeNumber != INT32_MAX && relativeNumber < 0)
      return [NSString stringWithFormat:@"%d %@%@", -relativeNumber, selectorName, pluralisation, nil];     //future
		if (relativeNumber && relativeNumber != INT32_MAX)
			return [NSString stringWithFormat:@"%d %@%@ ago", relativeNumber, selectorName, pluralisation, nil];
	}
	return @"now";
}

/*
 * Returns format defined in BIRTHDAY_FORMAT_SERVER
 */
- (NSString*)serverDateFormat
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  return [dateFormatter stringFromDate:self];
}

/*
 * Returns -ve number if date is in the past
 */
- (CGFloat)numberOfDaysSinceNow
{
  NSTimeInterval diffSeconds = [self timeIntervalSinceNow];
  return diffSeconds / (60*60*24);
}

/*
 * Returns YES if date is in the past
 */
- (BOOL)isPast
{
  return [self numberOfDaysSinceNow] <= 0;
}

/*
 * Returns YES if date is in the future
 */
- (BOOL)isFuture
{
  return [self numberOfDaysSinceNow] > 0;
}

@end
