//
//  NSString+Additions.m
//  Aurora
//
//  Created by Daud Abas on 24/2/12.
//  Copyright (c) 2012 2359 Media Pte Ltd. All rights reserved.
//

#import "NSString+Additions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Additions)

- (NSString*)trim
{
  return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)isEmail {
  
  NSString *regularExpressionString = @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
                                      @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
                                      @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
                                      @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
                                      @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
                                      @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
                                      @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
  
  NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularExpressionString];
  
  return [regExPredicate evaluateWithObject:self];
}

- (BOOL)isValidName {
  if (self.length < 3) return false;
  
  NSString *regularExpressionString = @"^[a-zA-Z0-9-_' ]+$";    //alphanumberic, dash, underscore, space, apos
  
  NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularExpressionString];
  
  return [regExPredicate evaluateWithObject:self];
}

- (BOOL)isInteger
{
  NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
  NSRange r = [self rangeOfCharacterFromSet: nonNumbers];
  return r.location == NSNotFound;
}

- (NSUInteger)wordCount {
  NSScanner *scanner = [NSScanner scannerWithString: self];
  NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  
  NSUInteger count = 0;
  while ([scanner scanUpToCharactersFromSet: whiteSpace  intoString: nil])
    count++;
  
  return count;
}

- (BOOL)contains:(NSString*)needle {
  NSRange range = [self rangeOfString:needle options: NSCaseInsensitiveSearch];
  return (range.length == needle.length && range.location != NSNotFound);
}

- (BOOL)startsWith:(NSString*)needle {
  NSRange range = [self rangeOfString:needle options: NSCaseInsensitiveSearch];
  return (range.length == needle.length && range.location == 0);
}

- (BOOL)endsWith:(NSString*)needle {
  NSRange range = [self rangeOfString:needle options: NSCaseInsensitiveSearch];
  return (range.length == needle.length && range.location == (self.length-range.length-1));
}

- (BOOL)hasPunctuationSuffix {
  if (![self hasSuffix:@"?"] && 
      ![self hasSuffix:@"!"] && 
      ![self hasSuffix:@"."] && 
      ![self hasSuffix:@","] && 
      ![self hasSuffix:@" "] && 
      ![self hasSuffix:@":"] && 
      ![self hasSuffix:@"`"] &&
      ![self hasSuffix:@"/"] && 
      ![self hasSuffix:@";"])
    return YES;
    
  return NO;
}

- (NSString*)URLEncodedString
{
  __autoreleasing NSString *encodedString;
  
  NSString *originalString = (NSString *)self;    
  encodedString = (__bridge_transfer NSString * )
  CFURLCreateStringByAddingPercentEscapes(NULL,
                                          (__bridge CFStringRef)originalString,
                                          (CFStringRef)@"$-_.+!*'(),&+/:;=?@#",
                                          NULL,
                                          kCFStringEncodingUTF8);
  encodedString = [encodedString stringByReplacingOccurrencesOfString:@"%25" withString:@"\%"];   //revert double escape
  return encodedString;
}

- (NSString*)URLEncodeEverything
{
    __autoreleasing NSString *encodedString;
    
    NSString *originalString = (NSString *)self;    
    encodedString = (__bridge_transfer NSString * )
    CFURLCreateStringByAddingPercentEscapes(NULL,
                                            (__bridge CFStringRef)originalString,
                                            NULL,
                                            (CFStringRef)@"$-_.+!*'(),&+/:;=?@#",
                                            kCFStringEncodingUTF8);
    encodedString = [encodedString stringByReplacingOccurrencesOfString:@"%25" withString:@"\%"];   //revert double escape
    return encodedString;
}


- (NSString *)sha1 {
  const char *cStr = [self UTF8String];
  unsigned char result[CC_SHA1_DIGEST_LENGTH];
  CC_SHA1(cStr, strlen(cStr), result);
  NSString *s = [NSString  stringWithFormat:
                 @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                 result[0], result[1], result[2], result[3], result[4],
                 result[5], result[6], result[7],
                 result[8], result[9], result[10], result[11], result[12],
                 result[13], result[14], result[15],
                 result[16], result[17], result[18], result[19]
                 ];
  
  return s;
}

- (NSString *)md5 {
  const char *cStr = [self UTF8String];
  unsigned char result[CC_MD5_DIGEST_LENGTH];
  CC_MD5(cStr, strlen(cStr), result);
  NSString *s = [NSString  stringWithFormat:
                 @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                 result[0], result[1], result[2], result[3], result[4],
                 result[5], result[6], result[7],
                 result[8], result[9], result[10], result[11], result[12],
                 result[13], result[14], result[15]
                 ];
  
  return s;
}

- (NSString *)friendlyTimeIntervalSinceNow
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  
  NSString *timeString = @"";
  NSDate *date = [dateFormatter dateFromString:self];
  NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
  NSInteger year = [components year];
  if (year < 2000)
    return @"";
  
  NSDate *now = [NSDate date];
  NSTimeInterval secondsDelta = [now timeIntervalSince1970] - [date timeIntervalSince1970];
  
  //Less than 1 minute
  if (secondsDelta/60 <= 1)
    return @"just now";
  
  if (secondsDelta/3600 < 1 && secondsDelta/60 > 1) {
    timeString = [NSString stringWithFormat:@"%f", secondsDelta/60];
    timeString = [timeString substringToIndex:timeString.length-7];
    timeString = [NSString stringWithFormat:@"%@ minute ago", timeString];
  }
  
  if (secondsDelta/3600 > 1 && secondsDelta/86400 < 1) {
    timeString = [NSString stringWithFormat:@"%f", secondsDelta/3600];
    timeString = [timeString substringToIndex:timeString.length-7];
    timeString = [NSString stringWithFormat:@"%@ hour ago", timeString];
  }
  
  if (secondsDelta/86400 > 1) {
    timeString = [NSString stringWithFormat:@"%f", secondsDelta/86400];
    timeString = [timeString substringToIndex:timeString.length-7];
    timeString = [NSString stringWithFormat:@"%@ day ago", timeString];
  }
  
  return timeString;
}

@end
