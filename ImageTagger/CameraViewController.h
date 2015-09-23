#import <UIKit/UIKit.h>
#import <FastttCamera.h>

@protocol CameraViewDelegate;

@interface CameraViewController : UIViewController
@property (nonatomic, weak) id<CameraViewDelegate> delegate;
@end

@protocol CameraViewDelegate <NSObject>
- (void)DidTakePhoto:(FastttCapturedImage *)capturedImage;
@end
