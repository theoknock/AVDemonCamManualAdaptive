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

// calculated once
static CGFloat radius_min;
static CGFloat radius_max;
static CGPoint center_point;

static CGPoint touch_point;  // always needed

// touch angle is independent of touch_property...
static CGFloat touch_angle;
// ...but touch property is dependent on touch_angle, but is not recalculated for every state
static CaptureDeviceConfigurationControlProperty touch_property;


// No dependencies
static CGFloat radius; // not recalculated for every state

static void (^(^touch_handler)(UITouch * _Nonnull))(void);
static void (^handle_touch)(void);

typedef NS_ENUM(NSUInteger, ControlRendererState) {
    ControlRendererStatePropertyTransition, // button arc setup (after touchesEnded on tick wheel or initialization)
    ControlRendererStateProperty,           // button arc behavior and event handling
    ControlRendererStateValueTransition,    // tick wheel setup (after touchesEnded on button arc)
    ControlRendererStateValue,              // tick wheel behavior and event handling
//    ControlRendererStateConfiguration       // non-adaptive control property configuration of the arc center point, arc size and arc origin
};
static ControlRendererState control_renderer_state;
//static void (^(^control_renderer)(void))(ControlRendererState);
//static void (^(^render_control_init)(void))(void);
//static void (^render_control)(void);

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
