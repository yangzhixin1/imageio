//
//  YZXImageView.m
//  imageio
//
//  Created by 杨志新 on 16/7/6.
//  Copyright © 2016年 杨志新. All rights reserved.
//

#import "YZXImageView.h"

@implementation YZXImageView
- (void)YZXCacheImaheFromURL:(NSString *)url {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageLoaderDidLoad:) name:@"CHANGEUI" object:nil];
    WS(WS);
    self.imageUrl = url;
    //if ([[YZURLCache shareCache] isCachHad:url]) {
        
         UIImage *image = [[YZURLCache shareCache] isCachHad:url success:^(UIImage *image) {
            
             WS.image = image;
        }];
        
    //}
//    __block UIImage *fromImage = [UIImage new];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [YZURLCache shareCache].delagete = self;
//        
//        if ([[YZURLCache shareCache] isCachHad:url]) {
//            
//            fromImage = [[YZURLCache shareCache] isCachHad:url];
//            
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            WS.image = fromImage;
//            [self setNeedsLayout];
//        });
//    });
}
- (void)getImage:(NSString *)url {
    
}

- (void)sendImage:(UIImage *)image URL:(NSString *)url {
    
        
}
- (void) imageLoaderDidLoad:(NSNotification *)info {
    if ([[[info userInfo] objectForKey:@"imageURL"] isEqual:self.imageUrl]) {
        
        UIImage* anImage = [[info userInfo] objectForKey:@"image"];
        self.image = anImage;
        
    }
   
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
