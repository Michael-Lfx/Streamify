//
//  NSString+Additions.h
//  Aurora
//
//  Created by Daud Abas on 24/2/12.
//  Copyright (c) 2012 2359 Media Pte Ltd. All rights reserved.
//



@interface NSString (Additions)
- (NSString*)trim;
- (BOOL)isEmail;
- (BOOL)isValidName;
- (BOOL)isInteger;
- (NSUInteger)wordCount;
- (BOOL)contains:(NSString*)needle;
- (BOOL)startsWith:(NSString*)needle;
- (BOOL)endsWith:(NSString*)needle;
- (BOOL)hasPunctuationSuffix;
- (NSString*)URLEncodedString;
- (NSString*)URLEncodeEverything;
- (NSString *)sha1;
- (NSString *)md5;

- (NSString *)friendlyTimeIntervalSinceNow;

@end
