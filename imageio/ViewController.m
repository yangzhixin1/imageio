#import "ViewController.h"
#import <ImageIO/ImageIO.h>
#import "SViewController.h"
#import "YZURLCache.h"
#import "UIImage+List.h"
#import "UIImage+GIF.h"
#import "UIImageView+CacheImage.h"
#import "EGOImageView.h"
#import "UIImageView+WebCache.h"
#import "ImageCellTableViewCell.h"


@interface ViewController () <NSURLSessionDelegate,YZURLCacheDelegate,UITableViewDataSource,UITableViewDelegate>
{
    CGImageSourceRef _incrementallyImgSource;
    
    NSMutableData   *_recieveData;
    long long       _expectedLeght;
    bool            _isLoadFinished;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSArray *imageArr;
@end

@implementation ViewController
- (void)viewWillAppear:(BOOL)animated {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
#pragma ::MARK 立体感展示
    //    [_bg.layer setShadowColor:[UIColor blackColor].CGColor];
    //    //[_bg setBackgroundColor:[UIColor clearColor]];
    //    _bg.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    //    _bg.layer.shadowOpacity = 1;//阴影透明度，默认0
    //    _bg.layer.shadowRadius = 4;//阴影半径，默认3
//    _bg = [[YZXImageView alloc] init];
//    [self.view addSubview:_bg];
//       _bg.frame = CGRectMake(100, 100, 50, 100);
//    [_bg setBackgroundColor:[UIColor clearColor]];
//    [self.bg YZXCacheImaheFromURL:@"http://b.zol-img.com.cn/desk/bizhi/image/1/1920x1200/1348810232493.jpg"];
////    [_bg sd_setImageWithURL:[NSURL URLWithString:@"http://b.zol-img.com.cn/desk/bizhi/image/1/1920x1200/1348810232493.jpg"]];
//    
//    _bg1 = [[YZXImageView alloc] init];
//    [self.view addSubview:_bg1];
//    _bg1.frame = CGRectMake(200, 100, 50, 100);
//    [_bg1 setBackgroundColor:[UIColor clearColor]];
//    //[self.bg1 YZXCacheImaheFromURL:@"http://ww1.sinaimg.cn/mw690/730d3ca2gw1f57iw46933g209g0e0qv9.gif"];
//    [self.bg1 YZXCacheImaheFromURL:@"http://ww1.sinaimg.cn/mw690/730d3ca2gw1f57iw46933g209g0e0qv9.gif"];
////    [_bg1 sd_setImageWithURL:[NSURL URLWithString:@"http://ww1.sinaimg.cn/mw690/730d3ca2gw1f57iw46933g209g0e0qv9.gif"]];
//    _bg2 = [[YZXImageView alloc] init];
//    [self.view addSubview:_bg2];
//    _bg2.frame = CGRectMake(300, 100, 50, 100);
//    _bg2.layer.borderWidth = 1;
//    _bg.layer.borderWidth = 1;
//    [_bg2 setBackgroundColor:[UIColor clearColor]];
//    
//    [self.bg2 YZXCacheImaheFromURL:@"http://pic19.nipic.com/20120222/8072717_124734762000_2.gif"];
////    [_bg2 sd_setImageWithURL:[NSURL URLWithString:@"http://pic19.nipic.com/20120222/8072717_124734762000_2.gif"]];
//    

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 300, 100, 100);
    btn.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:btn];
    _bg.alpha = 1;
    [btn addTarget:self action:@selector(initWithURL:) forControlEvents:UIControlEventTouchUpInside];
//    // Do any additional setup after loading the view, typically from a nib.
//    NSURL *imageURL = [NSURL URLWithString:@"http://b.zol-img.com.cn/desk/bizhi/image/1/1920x1200/1348810232493.jpg"];
    //[self performSelector:@selector(initWithURL:) withObject:imageURL afterDelay:2];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    _imageArr = [NSArray arrayWithObjects:@"http://fdfs.xmcdn.com/group16/M0B/3E/79/wKgDbFcHWmzTzRMbAATlah3fEd8005_mobile_small.jpg",@"http://fdfs.xmcdn.com/group16/M03/3E/7A/wKgDalcHWm-hFjLNAATlah3fEd8435_mobile_medium.jpg",@"http://fdfs.xmcdn.com/group14/M09/3E/4B/wKgDZFWfd_uAoko2AAGi5gra7BE552_mobile_medium.jpg",@"http://fdfs.xmcdn.com/group13/M0A/3E/4B/wKgDXVWfd-LCCB70AAGi5gra7BE421_mobile_small.jpg",@"http://fdfs.xmcdn.com/group12/M02/42/87/wKgDXFWjfJLyfyOXAAGe32Y5ogc427_mobile_medium.jpg",@"http://fdfs.xmcdn.com/group12/M02/42/87/wKgDXFWjfIvxnQ8uAAGe32Y5ogc979_mobile_small.jpg",@"http://pic19.nipic.com/20120222/8072717_124734762000_2.gif",@"http://ww1.sinaimg.cn/mw690/730d3ca2gw1f57iw46933g209g0e0qv9.gif",@"http://b.zol-img.com.cn/desk/bizhi/image/1/1920x1200/1348810232493.jpg", nil];
    UITableView *table = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:table];
    table.tag = 100;
    table.delegate = self;
    table.dataSource = self;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 300, 100, 100);
    btn.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:btn];
    _bg.alpha = 1;
    [btn addTarget:self action:@selector(initWithURL:) forControlEvents:UIControlEventTouchUpInside];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuse = @"Imagetest";
    ImageCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ImageCellTableViewCell" owner:self options:nil] firstObject];
    }
    [cell.testImage YZXCacheImaheFromURL:_imageArr[indexPath.row%9]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (void)initWithURL:(id)imageURL
{
    UITableView *table = (UITableView *)[self.view viewWithTag:100];
    [table reloadData];
//    [self.bg YZXCacheImaheFromURL:@"http://pic19.nipic.com/20120222/8072717_124734762000_2.gif"];
//    [self.bg1 YZXCacheImaheFromURL:@"http://pic19.nipic.com/20120222/8072717_124734762000_2.gif"];
//    [self.bg2 YZXCacheImaheFromURL:@"http://b.zol-img.com.cn/desk/bizhi/image/1/1920x1200/1348810232493.jpg"];
    
//    [_bg sd_setImageWithURL:[NSURL URLWithString:@"http://pic19.nipic.com/20120222/8072717_124734762000_2.gif"]];
//    [_bg1 sd_setImageWithURL:[NSURL URLWithString:@"http://ww1.sinaimg.cn/mw690/730d3ca2gw1f57iw46933g209g0e0qv9.gif"]];
//    [_bg2 sd_setImageWithURL:[NSURL URLWithString:@"http://b.zol-img.com.cn/desk/bizhi/image/1/1920x1200/1348810232493.jpg"]];
    _incrementallyImgSource = CGImageSourceCreateIncremental(NULL);
//    _recieveData = [[NSMutableData alloc] init];
//   _isLoadFinished = false;
//    
//   // NSURL *url = [NSURL URLWithString:@"http://pic19.nipic.com/20120222/8072717_124734762000_2.gif"];
//    //NSURL *url = [NSURL URLWithString:@"http://www.gifs.net/Animation11/Food_and_Drinks/Fruits/Apple_jumps.gif"];
//    NSURL *url = [NSURL URLWithString:@"http://ww1.sinaimg.cn/mw690/730d3ca2gw1f57iw46933g209g0e0qv9.gif"];
//    
//    NSURLCache *urlCache = [NSURLCache sharedURLCache];
//    
//    /* 设置缓存的大小为1M*/
//    
//    
//    [urlCache setMemoryCapacity:10*1024*1024];
//         //2.创建请求对象
//         //请求对象内部默认已经包含了请求头和请求方法（GET）
//         NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:30.f];
//                              request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
//    
//    
//    NSCachedURLResponse *response =
//    
//    [urlCache cachedResponseForRequest:request];
////    if ([[YZURLCache shareCache] isCachHad:@"http://b.zol-img.com.cn/desk/bizhi/image/1/1920x1200/1348810232493.jpg"]){
////        //[[YZURLCache shareCache] getDiskStoreDate:@"http://b.zol-img.com.cn/desk/bizhi/image/1/1920x1200/1348810232493.jpg"];
////        NSData *date = (NSData *)[[YZURLCache shareCache] getDiskStoreDate:@"http://b.zol-img.com.cn/desk/bizhi/image/1/1920x1200/1348810232493.jpg"];
////        NSLog(@"如果有缓存输出，从缓存中获取数据");
////        CGImageSourceUpdateData(_incrementallyImgSource, (CFDataRef)CFBridgingRetain(date), _isLoadFinished);
////        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(_incrementallyImgSource, 0, NULL);
////        self.bg.image = [UIImage imageWithCGImage:imageRef];
////        CGImageRelease(imageRef);
////        
////        //[request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
////        
////    } else {
//            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
//        
//        //4.根据会话对象创建一个Task(发送请求）
//        NSURLSessionDataTask   *dataTask = [session dataTaskWithRequest:request];
//        
//        //5.执行任务
//        [dataTask resume];
//        
////    }//
//        //3.获得会话对象,并设置代理
//        /*
//         35      第一个参数：会话对象的配置信息defaultSessionConfiguration 表示默认配置
//         36      第二个参数：谁成为代理，此处为控制器本身即self
//         37      第三个参数：队列，该队列决定代理方法在哪个线程中调用，可以传主队列|非主队列
//         38      [NSOperationQueue mainQueue]   主队列：   代理方法在主线程中调用
//         39      [[NSOperationQueue alloc]init] 非主队列： 代理方法在子线程中调用
//         40      */
//    
//        
//
//    NSLog(@"*************************");
    
    
}
- (void)sendImage:(UIImage *)image {
    
    
    
    self.bg.image = image;
}
#pragma mark --------------------
#pragma mark Methods
//发送请求，代理方法
-(void)delegateTest
{
    _recieveData = [[NSMutableData alloc]init];
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:@" http://b.zol-img.com.cn/desk/bizhi/image/1/1920x1200/1348810232493.jpg"];
    
    //2.创建请求对象
    //请求对象内部默认已经包含了请求头和请求方法（GET）
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.获得会话对象,并设置代理
    /*
     第一个参数：会话对象的配置信息defaultSessionConfiguration 表示默认配置
     第二个参数：谁成为代理，此处为控制器本身即self
     第三个参数：队列，该队列决定代理方法在哪个线程中调用，可以传主队列|非主队列
     [NSOperationQueue mainQueue]   主队列：   代理方法在主线程中调用
     [[NSOperationQueue alloc]init] 非主队列： 代理方法在子线程中调用
     */
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    //4.根据会话对象创建一个Task(发送请求）
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    
    //5.执行任务
    [dataTask resume];
}

#pragma mark --------------------
#pragma mark Method

//发送GET请求的第一种方法
-(void)get1
{
    //对请求路径的说明
    //http://120.25.226.186:32812/login?username=520it&pwd=520&type=JSON
    //协议头+主机地址+接口名称+？+参数1&参数2&参数3
    //协议头(http://)+主机地址(120.25.226.186:32812)+接口名称(login)+？+参数1(username=520it)&参数2(pwd=520)&参数3(type=JSON)
    //GET请求，直接把请求参数跟在URL的后面以？隔开，多个参数之间以&符号拼接
    
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login?username=520it&pwd=520it&type=JSON"];
    
    //2.创建请求对象
    //请求对象内部默认已经包含了请求头和请求方法（GET）
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //4.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            //6.解析服务器返回的数据
            //说明：（此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理）
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            NSLog(@"%@",dict);
        }
    }];
    
    //5.执行任务
    [dataTask resume];
}

//发送GET请求的第二种方法
-(void)get2
{
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login?username=520it&pwd=520it&type=JSON"];
    
    //2.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //3.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求路径
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     注意：
     1）该方法内部会自动将请求路径包装成一个请求对象，该请求对象默认包含了请求头信息和请求方法（GET）
     2）如果要发送的是POST请求，则不能使用该方法
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //5.解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"%@",dict);
        
    }];
    
    //4.执行任务
    [dataTask resume];
}

-(void)post
{
    //对请求路径的说明
    //http://120.25.226.186:32812/login
    //协议头+主机地址+接口名称
    //协议头(http://)+主机地址(120.25.226.186:32812)+接口名称(login)
    //POST请求需要修改请求方法为POST，并把参数转换为二进制数据设置为请求体
    
    //1.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //2.根据会话对象创建task
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login"];
    
    //3.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //4.修改请求方法为POST
    request.HTTPMethod = @"POST";
    
    //5.设置请求体
    request.HTTPBody = [@"username=520it&pwd=520it&type=JSON" dataUsingEncoding:NSUTF8StringEncoding];
    
    //6.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //8.解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"%@",dict);
        
    }];
    
    //7.执行任务
    [dataTask resume];
}

#pragma mark --------------------
#pragma mark NSURLSessionDataDelegate
//1.接收到服务器响应的时候调用该方法
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    _expectedLeght = response.expectedContentLength;
    NSLog(@"expected Length: %lld", _expectedLeght);
    
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
    NSLog(@"__________Connection Loading");
    NSLog(@"%luld",(unsigned long)data.length);
    NSLog(@"**********Connection Loading");
    _isLoadFinished = false;
    
    if (_expectedLeght == _recieveData.length) {
        _isLoadFinished = true;
    }
    
    CGImageSourceUpdateData(_incrementallyImgSource, (CFDataRef)CFBridgingRetain(_recieveData), _isLoadFinished);
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(_incrementallyImgSource, 0, NULL);
    CGImageRetain(imageRef);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.bg.image = [UIImage imageWithCGImage:imageRef];
    });
    
    CGImageRelease(imageRef);
}

//3.当请求完成(成功|失败)的时候会调用该方法，如果请求失败，则error有值
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    
    NSLog(@"%@",task.response.URL);
    self.bg.image = [UIImage YZ_animatedGIFWithData:_recieveData];
    [[YZURLCache shareCache] setDate:_recieveData key:@"http://b.zol-img.com.cn/desk/bizhi/image/1/1920x1200/1348810232493.jpg"];
    [[YZURLCache shareCache] greateDiskStoreDate:_recieveData key:@"http://b.zol-img.com.cn/desk/bizhi/image/1/1920x1200/1348810232493.jpg"];
    //[UIImage backImage:_recieveData];
    if (!_isLoadFinished) {
        CGImageSourceUpdateData(_incrementallyImgSource, (CFDataRef)CFBridgingRetain(_recieveData), _isLoadFinished);
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(_incrementallyImgSource, 0, NULL);
        self.bg.image = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
           }
}


// 可以使用下面的URL作为请求路径发送GET请求
//    http://fuli1024.com/picfun2/weibo_list.php?apiver=10901&category=weibo_jokes&page=0&page_size=30&max_timestamp=-1&latest_viewed_ts=1454037120&appid=picfun&platform=iphone&appver=2.0&buildver=2000004&udid=A4DEB8EC-BF07-4E1A-8B68-9D947F77E248&sysver=7.1.1
@end
