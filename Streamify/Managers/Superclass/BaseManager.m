//
//  BaseManager.m
//  AutoDealer
//
//  Created by Torin on 4/12/12.
//  Copyright (c) 2012 MyCompany. All rights reserved.
//

#import "BaseManager.h"

@interface BaseManager()
@property (nonatomic, strong) NSMutableArray * dataArray;
@end


@implementation BaseManager

+ (id)sharedInstance
{
  static id _sharedInstance = nil;
  static dispatch_once_t oncePredicate;
  dispatch_once(&oncePredicate, ^{
    _sharedInstance = [[self alloc] init];
  });
  
  return _sharedInstance;
}


- (NSMutableArray *)getDataArray
{
  return self.dataArray;
}



#pragma mark - Offline files

+ (NSData*)loadJSONDataFromFileName:(NSString *)filename
{
  if ([filename length] <= 0)
    return nil;
  
  if ([filename hasSuffix:@"json"] == YES)
    filename = [filename stringByReplacingOccurrencesOfString:@".json"
                                                   withString:@""
                                                      options:NSCaseInsensitiveSearch
                                                        range:NSRangeFromString(filename)];
  
  //Read JSON file
  NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
  NSData *fileData = [[NSFileManager defaultManager] contentsAtPath:filePath];
  if (fileData == nil)
    return nil;
  
  return fileData;
}

+ (id)loadJSONObjectFromFileName:(NSString*)filename
{
  NSData *fileData = [BaseManager loadJSONDataFromFileName:filename];
  if (fileData == nil)
    return nil;
  
  //iOS5 JSON Framework
  NSError *error;
  NSDictionary* jsonArray = [NSJSONSerialization JSONObjectWithData:fileData
                                                            options:kNilOptions
                                                              error:&error];
  
  //File contains error
  if (error != nil)
    return error;
  
  return jsonArray;
}

@end
