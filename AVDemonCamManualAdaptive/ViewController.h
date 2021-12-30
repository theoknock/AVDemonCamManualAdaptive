//
//  ViewController.h
//  AVDemonCamManualAdaptive
//
//  Created by Xcode Developer on 12/18/21.
//

@import UIKit;
@import AVFoundation;

#import "ControlConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

static AVCaptureDevice * _Nonnull capture_device;
static __kindof UIView * _Nonnull control_view;

static void (^(^touch_handler)(UITouch * _Nonnull))(void);


// Rx-block global properties

//static double * _Nonnull const * _Nonnull touch_point_ptr; // static double touch_point[2];
static double * _Nonnull const * _Nonnull touch_angle_ptr;
static double * _Nonnull const * _Nonnull touch_property_ptr;

static double * _Nonnull const * _Nonnull center_ptr; // static double center[2];
static double * _Nonnull const * _Nonnull radius_ptr;

static UIButton * (^CaptureDeviceConfigurationPropertyButton)(CaptureDeviceConfigurationControlProperty);
static double * const button_angle_ptr;

// Equal to (x1 + 1) % 3, for values 0, 1, 2.
//x2 = (1 << x1) & 3;
//ControlRendererState = (1 << ControlRendererState) & 4;
typedef NS_ENUM(NSUInteger, ControlRendererState) {
    ControlRendererStatePropertyTransition, // button arc setup (after touchesEnded on tick wheel or initialization)
    ControlRendererStateProperty,           // button arc behavior and event handling
    ControlRendererStateValueTransition,    // tick wheel setup (after touchesEnded on button arc)
    ControlRendererStateValue               // tick wheel behavior and event handling
};

static ControlRendererState * _Nonnull const * _Nonnull control_renderer_state; // control_renderer_state & 1
static void const * _Nonnull (^(^control_renderer_ptr)(UITouchPhase))(dispatch_block_t _Nullable); // establishes context and state to
static void const * _Nonnull (^render_control_ptr)(dispatch_block_t _Nullable); // dynamically dispatch control-rendering operations (button arc, tick_wheel, animations)

static void const * _Nonnull (^(^touch_handler_ptr)(UITouch *))(void); // this goes at the "top" since both the touch event and touch object are integral to every operation thereafter (executed in touchesBegan)
static void const * _Nonnull (^handle_touch_ptr)(void); // this is the "bottom" block, the one that gets assigned first and over the other possible blocks (reinitialized by preceding block in touchesBegan and executed in touchesBegan/Moved/Ended)


@interface ControlView: UIView

@end

NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN

@interface CameraView : UIView

@end

NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN


@interface ViewController : UIViewController <UIGestureRecognizerDelegate>

@property(nonatomic, strong) CameraView * view;

@end

NS_ASSUME_NONNULL_END
