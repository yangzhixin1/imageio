//
//  UIImage+List.m
//  imageio
//
//  Created by 杨志新 on 16/6/29.
//  Copyright © 2016年 杨志新. All rights reserved.
//

#import "UIImage+List.h"
#import "YZURLCache.h"
#import <ImageIO/ImageIO.h>

static inline NSPUIImageType NSPUIImageTypeFromData(NSData *imageData) {
  if (imageData.length > 4) {
    const unsigned char *bytes = [imageData bytes];
    if (bytes[0] == 0xff && bytes[1] == 0xd8 && bytes[2] == 0xff) {
      return NSPUIImageType_JPEG;
    }
    if (bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4e &&
        bytes[3] == 0x47) {
      return NSPUIImageType_PNG;
    }
  }
  return NSPUIImageType_Unknown;
}

@implementation UIImage (List)
+ (UIImage *)backImage:(NSData *)data {
  @autoreleasepool {
    UIImage *backImage = [UIImage new];
    CGImageSourceRef _incrementallyImgSource =
        CGImageSourceCreateIncremental(NULL);
    NSPUIImageType type = NSPUIImageTypeFromData(data);
    CGImageSourceUpdateData(_incrementallyImgSource,
                            (CFDataRef)CFBridgingRetain(data), YES);
    CGImageRef imageRef =
        CGImageSourceCreateImageAtIndex(_incrementallyImgSource, 0, NULL);

    backImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);

    [self imageChangeJPGFromOtherImage:backImage typeImage:type];
    CFRelease(_incrementallyImgSource);
    return backImage;
  }
}
+ (NSData *)imageChangeJPGFromOtherImage:(UIImage *)image
                               typeImage:(NSPUIImageType)type {
  NSData *data = [NSData new];
  switch (type) {
  case NSPUIImageType_PNG:
    data = UIImageJPEGRepresentation(image, 1);
    break;

  default:
    break;
  }

  UIImage *backImage;
  CGImageSourceRef _incrementallyImgSource =
      CGImageSourceCreateIncremental(NULL);
  NSPUIImageType type1 = NSPUIImageTypeFromData(data);
  CGImageSourceUpdateData(_incrementallyImgSource,
                          (CFDataRef)CFBridgingRetain(data), YES);
  CGImageRef imageRef =
      CGImageSourceCreateImageAtIndex(_incrementallyImgSource, 0, NULL);
  NSLog(@"图片中磊%ld", (long)type1);
  backImage = [UIImage imageWithCGImage:imageRef];
  CGImageRelease(imageRef);

  return data;
}
//等比缩放
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize {
  UIGraphicsBeginImageContext(
      CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
  [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize,
                               image.size.height * scaleSize)];
  UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return scaledImage;
}
// 自定义大小
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize {
  UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
  [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
  UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return reSizeImage;
}
+ (void)YZ_animatedGIFWithData:(NSData *)data success:(BackImageBlock)back {
  
        if (!data) {
          back(nil);
        }
      dispatch_queue_t serialQueue = dispatch_queue_create("Down_TabBar_Pic", DISPATCH_QUEUE_SERIAL);
    dispatch_async(
                   serialQueue, ^{
        CGImageSourceRef source =
            CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);

        size_t count = CGImageSourceGetCount(source);

        UIImage *animatedImage;

        if (count <= 1) {
           
            
            CGImageSourceRef _incrementallyImgSource =
            CGImageSourceCreateIncremental(NULL);
            
            CGImageSourceUpdateData(_incrementallyImgSource,
                                    (CFDataRef)CFBridgingRetain(data), YES);
            CGImageRef imageRef =
            CGImageSourceCreateImageAtIndex(_incrementallyImgSource, 0, NULL);
            
            animatedImage = [UIImage imageWithCGImage:imageRef];
            CGImageRelease(imageRef);
            
            
            CFRelease(_incrementallyImgSource);
            

        } else {
          NSMutableArray *images = [NSMutableArray array];

          NSTimeInterval duration = 0.0f;

          for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            if (!image) {
              continue;
            }

            duration += [self frameDurationAtIndex:i source:source];

            [images
                addObject:[UIImage imageWithCGImage:image
                                              scale:[UIScreen mainScreen].scale
                                        orientation:UIImageOrientationUp]];

            CGImageRelease(image);
          }

          if (!duration) {
            duration = (1.0f / 10.0f) * count;
          }

          animatedImage =
              [UIImage animatedImageWithImages:images duration:duration];
        }

        CFRelease(source);
        animatedImage = [animatedImage
            imageWithRenderingMode:UIImageRenderingModeAutomatic];
        dispatch_async(dispatch_get_main_queue(), ^{
          back(animatedImage);
        });

      });
}

+ (float)frameDurationAtIndex:(NSUInteger)index
                       source:(CGImageSourceRef)source {
  float frameDuration = 0.1f;
  CFDictionaryRef cfFrameProperties =
      CGImageSourceCopyPropertiesAtIndex(source, index, nil);
  NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
  NSDictionary *gifProperties =
      frameProperties[(NSString *)kCGImagePropertyGIFDictionary];

  NSNumber *delayTimeUnclampedProp =
      gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
  if (delayTimeUnclampedProp) {
    frameDuration = [delayTimeUnclampedProp floatValue];
  } else {

    NSNumber *delayTimeProp =
        gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
    if (delayTimeProp) {
      frameDuration = [delayTimeProp floatValue];
    }
  }

  // Many annoying ads specify a 0 duration to make an image flash as quickly as
  // possible.
  // We follow Firefox's behavior and use a duration of 100 ms for any frames
  // that specify
  // a duration of <= 10 ms. See <rdar://problem/7689300> and
  // <http://webkit.org/b/36082>
  // for more information.

  if (frameDuration < 0.011f) {
    frameDuration = 0.100f;
  }

  CFRelease(cfFrameProperties);
  return frameDuration;
}
+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha
                            image:(UIImage *)image

{

  UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);

  CGContextRef ctx = UIGraphicsGetCurrentContext();

  CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);

  CGContextScaleCTM(ctx, 1, -1);

  CGContextTranslateCTM(ctx, 0, -area.size.height);

  CGContextSetBlendMode(ctx, kCGBlendModeMultiply);

  CGContextSetAlpha(ctx, alpha);

  CGContextDrawImage(ctx, area, image.CGImage);

  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

  UIGraphicsEndImageContext();

  return newImage;
}
+ (NSPUIImageType)contentTypeForImageData:(NSData *)data {
  uint8_t c;
  [data getBytes:&c length:1];
  switch (c) {
  case 0xFF:
    return NSPUIImageType_JPG;
  case 0x89:
    return NSPUIImageType_PNG;
  case 0x47:
    return NSPUIImageType_GIF;
  case 0x49:
  case 0x4D:
    return NSPUIImageType_TIFF;
  case 0x52:
    // R as RIFF for WEBP
    if ([data length] < 12) {
      return NSPUIImageType_Unknown;
    }

    NSString *testString = [[NSString alloc]
        initWithData:[data subdataWithRange:NSMakeRange(0, 12)]
            encoding:NSASCIIStringEncoding];
    if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
      return NSPUIImageType_WEBP;
    }

    return NSPUIImageType_Unknown;
  }
  return NSPUIImageType_Unknown;
}

+ (UIImage *)judgeImageTypeHandle:(NSData *)data success:(BackImageBlock)back {

  NSPUIImageType type = [self contentTypeForImageData:data];
  if (type == NSPUIImageType_GIF) {
    [self YZ_animatedGIFWithData:data
                         success:^(UIImage *image) {
                           back(image);
                         }];
    return nil;
  } else {
    return nil;
  }
  //        case NSPUIImageType_GIF:
  //
  //
  //
  //            break;
  //        case NSPUIImageType_JPG:
  //             return [self backImage:data];
  //            break;
  //
  //        default:
  //            return nil;
  //            break;
  //    }
}
@end
