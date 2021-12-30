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
static CGPoint center_point;
static UITouch * _Nonnull touch_ptr_ref;
static void (^(^touch_handler)(UITouch * _Nonnull))(void);
static void (^handle_touch)(void);
static UIButton * (^CaptureDeviceConfigurationPropertyButton)(CaptureDeviceConfigurationControlProperty);
typedef NS_ENUM(NSUInteger, ControlRendererState) {
    ControlRendererStatePropertyTransition, // button arc setup (after touchesEnded on tick wheel or initialization)
    ControlRendererStateProperty,           // button arc behavior and event handling
    ControlRendererStateValueTransition,    // tick wheel setup (after touchesEnded on button arc)
    ControlRendererStateValue               // tick wheel behavior and event handling
};

static ControlRendererState state;
static ControlRendererState * _Nonnull control_renderer_state_ptr_ref; // control_renderer_state & 1
static void const * _Nonnull (^(^control_renderer_ptr)(UITouchPhase))(dispatch_block_t _Nullable); // establishes context and state to
static void const * _Nonnull (^render_control_ptr)(dispatch_block_t _Nullable); // dynamically dispatch control-rendering operations (button arc, tick_wheel, animations)

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
