//
//  YZXImageURLSession.m
//  imageio
//
//  Created by 杨志新 on 16/7/5.
//  Copyright © 2016年 杨志新. All rights reserved.
//

#import "YZXImageURLSession.h"
#import <ImageIO/ImageIO.h>
#import "UIImage+List.h"

@implementation YZXImageURLSession

- (void)initWithURL:(NSString *)imageURL
{
   
    _recieveData = [[NSMutableData alloc] init];
   
//    @"http://ww1.sinaimg.cn/mw690/730d3ca2gw1f57iw46933g209g0e0qv9.gif"
    // NSURL *url = [NSURL URLWithString:@"http://pic19.nipic.com/20120222/8072717_124734762000_2.gif"];
    //NSURL *url = [NSURL URLWithString:@"http://www.gifs.net/Animation11/Food_and_Drinks/Fruits/Apple_jumps.gif"];
    NSURL *url = [NSURL URLWithString:imageURL];
    
    NSURLCache *urlCache = [NSURLCache sharedURLCache];
    
    /* 设置缓存的大小为1M*/
    
    
    [urlCache setMemoryCapacity:10*1024*1024];
    //2.创建请求对象
    //请求对象内部默认已经包含了请求头和请求方法（GET）
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:30.f];
    request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    
    
    NSCachedURLResponse *response =
    
    [urlCache cachedResponseForRequest:request];
    //    if ([[YZURLCache shareCache] isCachHad:@"http://b.zol-img.com.cn/desk/bizhi/image/1/1920x1200/1348810232493.jpg"]){
    //        //[[YZURLCache shareCache] getDiskStoreDate:@"http://b.zol-img.com.cn/desk/bizhi/image/1/1920x1200/1348810232493.jpg"];
    //        NSData *date = (NSData *)[[YZURLCache shareCache] getDiskStoreDate:@"http://b.zol-img.com.cn/desk/bizhi/image/1/1920x1200/1348810232493.jpg"];
    //        NSLog(@"如果有缓存输出，从缓存中获取数据");
    //        CGImageSourceUpdateData(_incrementallyImgSource, (CFDataRef)CFBridgingRetain(date), _isLoadFinished);
    //        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(_incrementallyImgSource, 0, NULL);
    //        self.bg.image = [UIImage imageWithCGImage:imageRef];
    //        CGImageRelease(imageRef);
    //
    //        //[request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    //
    //    } else {
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    //4.根据会话对象创建一个Task(发送请求）
    NSURLSessionDataTask   *dataTask = [session dataTaskWithRequest:request];
    
    //5.执行任务
    [dataTask resume];
    
    //    }//
    //3.获得会话对象,并设置代理
    /*
     35      第一个参数：会话对象的配置信息defaultSessionConfiguration 表示默认配置
     36      第二个参数：谁成为代理，此处为控制器本身即self
     37      第三个参数：队列，该队列决定代理方法在哪个线程中调用，可以传主队列|非主队列
     38      [NSOperationQueue mainQueue]   主队列：   代理方法在主线程中调用
     39      [[NSOperationQueue alloc]init] 非主队列： 代理方法在子线程中调用
     40      */
    
    
    
    
    
}
#pragma mark NSURLSessionDataDelegate
//1.接收到服务器响应的时候调用该方法
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    
    //NSLog(@"expected Length: %lld", _expectedLeght);
    
    NSString *mimeType = response.MIMEType;
    NSLog(@"MIME TYPE %@", mimeType);
    
    NSArray *arr = [mimeType componentsSeparatedByString:@"/"];
    if (arr.count < 1 || ![[arr objectAtIndex:0] isEqual:@"image"]) {
        NSLog(@"not a image url");
        //  [connection cancel];
    }
    
    //在该方法中可以得到响应头信息，即response
    // NSLog(@"didReceiveResponse--%@",[NSThread currentThread]);
    
    //注意：需要使用completionHandler回调告诉系统应该如何处理服务器返回的数据
    //默认是取消的
    /*
     NSURLSessionResponseCancel = 0,        默认的处理方式，取消
     NSURLSessionResponseAllow = 1,         接收服务器返回的数据
     NSURLSessionResponseBecomeDownload = 2,变成一个下载请求
     NSURLSessionResponseBecomeStream        变成一个流
     */
    
    completionHandler(NSURLSessionResponseAllow);
}

//2.接收到服务器返回数据的时候会调用该方法，如果数据较大那么该方法可能会调用多次
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [_recieveData appendData:data];
   // NSLog(@"1");
}

//3.当请求完成(成功|失败)的时候会调用该方法，如果请求失败，则error有值
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    
    
    [self.delegate sendImageData:_recieveData URL:[NSString stringWithFormat:@"%@",task.response.URL]];
   // NSLog(@"%@",[UIImage contentTypeForImageData:_recieveData]);
    
}
@end
