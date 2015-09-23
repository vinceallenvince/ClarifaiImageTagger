#import "CameraViewController.h"
#import <FastttCamera.h>

@interface CameraViewController () <FastttCameraDelegate>
@property (nonatomic, strong) FastttCamera *fastCamera;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIColor *btnDefaultColor;
@property (nonatomic, strong) UIColor *btnActiveColor;
@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _fastCamera = [FastttCamera new];
    self.fastCamera.delegate = self;
    
    [self fastttAddChildViewController:self.fastCamera];
    self.fastCamera.view.frame = self.view.frame;
    
    self.btnDefaultColor = [[UIColor alloc] initWithRed:200/255.0f
                                                  green:0/255.0f
                                                   blue:0/255.0f
                                                  alpha:0.25];
    
    self.btnActiveColor = [[UIColor alloc] initWithRed:100/255.0f
                                                  green:0/255.0f
                                                   blue:0/255.0f
                                                  alpha:0.5];
    
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 140, 40)];
    
    [self.btn setTitle:@"Take Photo" forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(handleCamera) forControlEvents:UIControlEventTouchUpInside];
    
    self.btn.backgroundColor = self.btnDefaultColor;
    
    [self.btn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.btn];
    
    // Autolayout
    
    UIButton *btn = self.btn;
    NSDictionary *metrics = @{
                              @"buttonHeight":@44.0
                              };
    NSDictionary *views = NSDictionaryOfVariableBindings(btn);
    
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[btn(buttonHeight)]-30.0-|"
                                                          options: 0
                                                          metrics:metrics
                                                            views:views];
    [self.view addConstraints:constraints];

    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50.0-[btn]-50.0-|"
                                                          options: NSLayoutFormatAlignAllCenterX
                                                          metrics:metrics
                                                            views:views];
    [self.view addConstraints:constraints];
    
    self.btn.enabled = YES;
    self.btn.backgroundColor = self.btnDefaultColor;

}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)handleCamera
{
    self.btn.enabled = NO;
    self.btn.backgroundColor = self.btnActiveColor;
    [self.fastCamera takePicture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IFTTTFastttCameraDelegate

- (void)cameraController:(FastttCamera *)cameraController
 didFinishCapturingImage:(FastttCapturedImage *)capturedImage
{
    /**
     *  Here, capturedImage.fullImage contains the full-resolution captured
     *  image, while capturedImage.rotatedPreviewImage contains the full-resolution
     *  image with its rotation adjusted to match the orientation in which the
     *  image was captured.
     */
}

- (void)cameraController:(FastttCamera *)cameraController
didFinishScalingCapturedImage:(FastttCapturedImage *)capturedImage
{
    /**
     *  Here, capturedImage.scaledImage contains the scaled-down version
     *  of the image.
     */
}

- (void)cameraController:(FastttCamera *)cameraController
didFinishNormalizingCapturedImage:(FastttCapturedImage *)capturedImage
{
    /**
     *  Here, capturedImage.fullImage and capturedImage.scaledImage have
     *  been rotated so that they have image orientations equal to
     *  UIImageOrientationUp. These images are ready for saving and uploading,
     *  as they should be rendered more consistently across different web
     *  services than images with non-standard orientations.
     */
    
    
    [self.delegate DidTakePhoto:capturedImage];
    
    /*UploaderViewController *uvc = [[UploaderViewController alloc] init];
    uvc.capturedImage = capturedImage;
    
    [self.navigationController pushViewController:uvc animated:YES];*/
        
}

@end
