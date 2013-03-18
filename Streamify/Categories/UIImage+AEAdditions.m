//
//  UIImage+AEAdditions.m
//  Aelo
//
//  Created by Xu Xiaojiang on 30/8/12.
//  Copyright (c) 2012 2359 Media Pte Ltd. All rights reserved.
//

#import "UIImage+AEAdditions.h"

@implementation UIImage (AEAdditions)

- (UIImage*)scaleToSize:(CGSize)size
{
  // Create a bitmap graphics context
  // This will also set it as the current context
  UIGraphicsBeginImageContext(size);
  
  // Draw the scaled image in the current context
  [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
  
  // Create a new image from current context
  UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
  
  // Pop the current context from the stack
  UIGraphicsEndImageContext();
  
  // Return our new scaled image
  return scaledImage;
}

- (UIImage *)crop:(CGRect)rect
{  
  rect = CGRectMake(rect.origin.x*self.scale,
                    rect.origin.y*self.scale,
                    rect.size.width*self.scale,
                    rect.size.height*self.scale);
  
  CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
  UIImage *result = [UIImage imageWithCGImage:imageRef
                                        scale:self.scale
                                  orientation:self.imageOrientation];
  CGImageRelease(imageRef);
  return result;
}

- (UIImage *)squareCrop
{
  CGFloat size = MIN(self.size.width, self.size.height);
  CGRect rect = CGRectMake(self.size.width/2 - size/2,
                           self.size.height/2 - size/2,
                           size, size);
  
  rect = CGRectMake(rect.origin.x*self.scale,
                    rect.origin.y*self.scale,
                    rect.size.width*self.scale,
                    rect.size.height*self.scale);
  
  CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
  UIImage *result = [UIImage imageWithCGImage:imageRef
                                        scale:self.scale
                                  orientation:self.imageOrientation];
  CGImageRelease(imageRef);
  return result;
}

@end
