//
//  ViewController.h
//  AVDemonCamManualAdaptive
//
//  Created by Xcode Developer on 12/18/21.
//

@import UIKit;
@import AVFoundation;

#import "ControlConfiguration.h"
#import "ControlView.h"

NS_ASSUME_NONNULL_BEGIN

static AVCaptureDevice * _Nonnull capture_device;
static ControlView * _Nonnull control_view;
// Control CGRect
static CGPoint center_point;
static int radius_min;
static int radius_max;
//

static CGPoint touch_point;
static CGFloat touch_angle;
static CaptureDeviceConfigurationControlProperty touch_property;
static CaptureDeviceConfigurationControlProperty * touch_property_ptr = &touch_property;
static CGFloat radius;

//static UITouch * _Nonnull touch_ptr_ref;
static void (^(^touch_handler)(UITouch * _Nonnull))(void);
static void (^handle_touch)(void);
static UIButton * (^CaptureDeviceConfigurationPropertyButton)(CaptureDeviceConfigurationControlProperty);
//typedef NS_OPTIONS(NSUInteger, ControlRendererState) {
//    ControlRendererStateProperty = 1 << 0,
//    ControlRendererStateValue = 1 << 1,
//    ControlRendererStatePropertyTransition = 1 << 2,
//    ControlRendererStateValueTransition = 1 << 3
//};
typedef NS_ENUM(NSUInteger, ControlRendererState) {
    ControlRendererStatePropertyTransition, // button arc setup (after touchesEnded on tick wheel or initialization)
    ControlRendererStateProperty,           // button arc behavior and event handling
    ControlRendererStateValueTransition,    // tick wheel setup (after touchesEnded on button arc)
    ControlRendererStateValue               // tick wheel behavior and event handling
};

static ControlRendererState control_renderer_state;
static void (^(^control_renderer)(void))(void);
static void (^render_control)(void);

//@interface ControlView: UIView
//
//@end
//
//NS_ASSUME_NONNULL_END

//NS_ASSUME_NONNULL_BEGIN

@interface CameraView : UIView

@end

NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN


@interface ViewController : UIViewController <UIGestureRecognizerDelegate>

@property(nonatomic, strong) CameraView * view;

@end

NS_ASSUME_NONNULL_END
