//
//  UIImageView+CacheImage.m
//  
//
//  Created by 杨志新 on 16/7/6.
//
//

#import "UIImageView+CacheImage.h"
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;


@implementation UIImageView (CacheImage)


//- (void)YZXCacheImaheFromURL:(NSString *)url {
//    WS(WS);
//    //self.imageUrl = url;
//   __block UIImage *fromImage = [UIImage new];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [YZURLCache shareCache].delagete = self;
//        
//        if ([[YZURLCache shareCache] isCachHad:url]) {
//            fromImage = [[YZURLCache shareCache] isCachHad:url];
//            
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            WS.image = fromImage;
//        });
//    });
//}
//- (void)getImage:(NSString *)url {
//    
//}

- (void)sendImage:(UIImage *)image URL:(NSString *)url {
//    if ([url isEqual:self.imageUrl]) {
//    
//        self.image = image;
//    }
    
}
@end
