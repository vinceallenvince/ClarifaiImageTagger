#import "StartViewController.h"
#import "CameraViewController.h"
#import "Tag.h"
#import "TagsViewController.h"
#import <FastttCamera.h>
#import "ImageStore.h"

@interface StartViewController() <CameraViewDelegate>
@property NSTimeInterval cameraPresentationDelay;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@property (strong, nonatomic) NSString *itemKey;
@property (strong, nonatomic) NSString *lastItemKey;
@property (strong, nonatomic) NSURL *postURL;
@end

@implementation StartViewController

- (instancetype)initWithPostURLString:(NSString *)postUrl
{
    self = [super init];
    if (self) {
        _postURL = [NSURL URLWithString:postUrl];
        _cameraPresentationDelay = 1;
        _lastItemKey = @"";
        _itemKey = @"";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationItem.title = @"Image Tagger";
}

- (void)viewDidAppear:(BOOL)animated
{

    if ([self.lastItemKey isEqualToString:self.itemKey]) {
        CameraViewController *cameraViewController = [[CameraViewController alloc] init];
        cameraViewController.delegate = self;
        [self performSelector:@selector(presentCamera:)
                   withObject:cameraViewController
                   afterDelay:self.cameraPresentationDelay];
    }
}

- (void)presentCamera:(CameraViewController *) cameraViewController
{
    [self presentViewController:cameraViewController animated:YES completion:nil];
}

- (void)prepareUploadImage:(FastttCapturedImage *)capturedImage
{
    self.activityView = [[UIActivityIndicatorView alloc]
                                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    self.activityView.center=self.view.center;
    [self.activityView startAnimating];
    [self.view addSubview:self.activityView];

    self.lastItemKey = self.itemKey;
    self.cameraPresentationDelay = 0.25;
    [self performSelector:@selector(uploadImage:) withObject:capturedImage afterDelay:0.5];
}

-(void)uploadImage:(FastttCapturedImage *)capturedImage
 {

     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.postURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];

     [request setHTTPMethod:@"POST"];

     NSString *boundary = @"----WebKitFormBoundarycC4YiaUFwM44F6rT";
     NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
     [request setValue:contentType forHTTPHeaderField:@"Content-Type"];

     NSMutableData *body = [NSMutableData data];

     double ratio = capturedImage.scaledImage.size.width / capturedImage.scaledImage.size.height;

     CGSize resize = CGSizeMake(800 * ratio, 800);
     UIImage *imgResized = [self imageWithImage:capturedImage.scaledImage convertToSize:resize];
     NSData *imageData = UIImageJPEGRepresentation(imgResized, 0.8);


     [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[@"Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

     // Now we append the actual image data
     [body appendData:[NSData dataWithData:imageData]];

     // and again the delimiting boundary
     [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];

     // NSDictionary *dict;

     //NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:NULL];
     //[body appendData:jsonData];

     [request setHTTPBody:body];

     // set URL
    // NSURL *requestURL = [[NSURL alloc] initWithString:self.postURL];
     //[request setURL:requestURL];

     [NSURLConnection sendAsynchronousRequest:request
                                        queue:[NSOperationQueue mainQueue]
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                NSArray *myData;
                                if (data) {

                                    //NSError *jsonParsingError = nil;
                                    myData = [NSJSONSerialization JSONObjectWithData:data
                                                                             options:0 error:nil];
                                    NSLog(@"%@", myData);
                                } else {
                                    myData = @[@"Error"];
                                }

                                NSMutableArray *tags = [[NSMutableArray alloc] init];

                                for (NSString *n in myData) {
                                    Tag *t = [[Tag alloc] initWithName:n];
                                    [tags addObject:t];
                                }

                                TagsViewController *tvc = [[TagsViewController alloc] init];
                                tvc.tags = [tags copy];
                                tvc.itemKey = self.itemKey;

                                [self.navigationController pushViewController:tvc animated:YES];

                                [self.activityView removeFromSuperview];
                            }];
 }

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

- (void)mockResult
{

    NSArray *myData = @[
        @"train",
        @"subway",
        @"railroad",
        @"railway",
        @"station",
        @"rail",
        @"transportation",
        @"urban",
        @"underground",
        @"night",
        @"traffic",
        @"commuter",
        @"bridge",
        @"city",
        @"road",
        @"national park",
        @"public",
        @"platform",
        @"street",
        @"blur"
    ];

    NSMutableArray *tags = [[NSMutableArray alloc] init];

    for (NSString *n in myData) {
        Tag *t = [[Tag alloc] initWithName:n];
        [tags addObject:t];
    }

    TagsViewController *tvc = [[TagsViewController alloc] init];
    tvc.tags = [tags copy];
    tvc.itemKey = self.itemKey;

    [self.navigationController pushViewController:tvc animated:YES];

    [self.activityView removeFromSuperview];
}


#pragma mark - CameraViewDelegate protocol

- (void)DidTakePhoto:(FastttCapturedImage *)capturedImage
{

    // Create an NSUUID object - and get its string representation
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *key = [uuid UUIDString];
    _itemKey = key;

    // Store the image in the ImageStore for this key
    [[ImageStore sharedStore] setImage:capturedImage.scaledImage
                                   forKey:self.itemKey];

    [self dismissViewControllerAnimated:YES completion: ^(void) {
        [self prepareUploadImage:capturedImage];
    }];
}



@end
