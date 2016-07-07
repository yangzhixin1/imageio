#import "ViewController.h"
#import <ImageIO/ImageIO.h>

@interface ViewController ()
{
    NSURLRequest    *_request;
    NSURLConnection *_conn;
    
    CGImageSourceRef _incrementallyImgSource;
    
    NSMutableData   *_recieveData;
    long long       _expectedLeght;
    bool            _isLoadFinished;
}

@property (nonatomic, retain) UIImage *image;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSURL *imageURL = [NSURL URLWithString:@"http://f.hiphotos.baidu.com/album/w%3D2048/sign=fff8be7163d0f703e6b292dc3cc2503d/6159252dd42a28344170de6d5ab5c9ea14cebf86.jpg"];
    [self performSelector:@selector(initWithURL:) withObject:imageURL afterDelay:2];
}

- (void)initWithURL:(NSURL *)imageURL
{
    
    _request = [[NSURLRequest alloc] initWithURL:imageURL];
    _conn    = [[NSURLConnection alloc] initWithRequest:_request delegate:self];
    
    _incrementallyImgSource = CGImageSourceCreateIncremental(NULL);
    
    _recieveData = [[NSMutableData alloc] init];
    _isLoadFinished = false;
    
}

#pragma mark -
#pragma mark NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _expectedLeght = response.expectedContentLength;
    NSLog(@"expected Length: %lld", _expectedLeght);
    
    NSString *mimeType = response.MIMEType;
    NSLog(@"MIME TYPE %@", mimeType);
    
    NSArray *arr = [mimeType componentsSeparatedByString:@"/"];
    if (arr.count < 1 || ![[arr objectAtIndex:0] isEqual:@"image"]) {
        NSLog(@"not a image url");
        [connection cancel];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection %@ error, error info: %@", connection, error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Connection Loading Finished!!!");
    
    // if download image data not complete, create final image
    if (!_isLoadFinished) {
        CGImageSourceUpdateData(_incrementallyImgSource, (CFDataRef)CFBridgingRetain(_recieveData), _isLoadFinished);
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(_incrementallyImgSource, 0, NULL);
        self.bg.image = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_recieveData appendData:data];
    
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
@end
