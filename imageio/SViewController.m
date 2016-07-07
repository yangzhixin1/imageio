//
//  SViewController.m
//  imageio
//
//  Created by 杨志新 on 16/6/22.
//  Copyright © 2016年 杨志新. All rights reserved.
//

#import "SViewController.h"

@interface SViewController ()<NSURLConnectionDelegate,NSURLSessionDelegate>
@property (nonatomic ,strong) NSURLConnection *connection;
@end

@implementation SViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *bbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bbtn.backgroundColor = [UIColor yellowColor];
    bbtn.frame = CGRectMake(0, 0, 100, 100);
    [self.view addSubview:bbtn];
    [bbtn addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
 
}
-(void) buttonPress:(id) sender

{
    
    NSString *paramURLAsString= @"http://www.baidu.com";
    
    if ([paramURLAsString length] == 0){
        
        NSLog(@"Nil or empty URL is given");
        
        return;
        
    }
    
    NSURLCache *urlCache = [NSURLCache sharedURLCache];
    
    /* 设置缓存的大小为1M*/
    
    [urlCache setMemoryCapacity:1*1024*1024];
    
    //创建一个nsurl
    
    NSURL *url = [NSURL URLWithString:paramURLAsString];
    
    //创建一个请求
    
    NSMutableURLRequest *request =
    
    [NSMutableURLRequest
     
     requestWithURL:url
     
     cachePolicy:NSURLRequestUseProtocolCachePolicy
     
     timeoutInterval:60.0f];
    
    //从请求中获取缓存输出
    
    NSCachedURLResponse *response =
    
    [urlCache cachedResponseForRequest:request];
    
    //判断是否有缓存
    
    if (response != nil){
        
        NSLog(@"如果有缓存输出，从缓存中获取数据");
        
        [request setCachePolicy:NSURLRequestReturnCacheDataDontLoad];
        
    }
    
    self.connection = nil;
    
    /* 创建NSURLConnection*/
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    //4.根据会话对象创建一个Task(发送请求）
    NSURLSessionDataTask   *dataTask = [session dataTaskWithRequest:request];
    
    //5.执行任务
    [dataTask resume];
    
    
    
}
- (void)  connection:(NSURLConnection *)connection

  didReceiveResponse:(NSURLResponse *)response{
    
    NSLog(@"将接收输出");
    
}

- (NSURLRequest *)connection:(NSURLConnection *)connection

             willSendRequest:(NSURLRequest *)request

            redirectResponse:(NSURLResponse *)redirectResponse{
    
    
    
    return(request);
    
}

- (void)connection:(NSURLConnection *)connection

    didReceiveData:(NSData *)data{
    
    NSLog(@"接受数据");
    
    NSLog(@"数据长度为 = %lu", (unsigned long)[data length]);
    
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection

                  willCacheResponse:(NSCachedURLResponse *)cachedResponse{
    
    NSLog(@"将缓存输出");
    
    return(cachedResponse);
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSLog(@"请求完成");
    
}

- (void)connection:(NSURLConnection *)connection

  didFailWithError:(NSError *)error{
    
    NSLog(@"请求失败");
    
}
//2.接收到服务器返回数据的时候会调用该方法，如果数据较大那么该方法可能会调用多次
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    //[_recieveData appendData:data];
    NSLog(@"__________获得数据");
    NSLog(@"%luld",(unsigned long)data.length);
    //    //_isLoadFinished = false;
//    
//    if (_expectedLeght == _recieveData.length) {
//        _isLoadFinished = true;
//    }
//    
//    CGImageSourceUpdateData(_incrementallyImgSource, (CFDataRef)CFBridgingRetain(_recieveData), _isLoadFinished);
//    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(_incrementallyImgSource, 0, NULL);
//    CGImageRetain(imageRef);
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.bg.image = [UIImage imageWithCGImage:imageRef];
//    });
//    
//    CGImageRelease(imageRef);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
