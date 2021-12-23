//
//  ViewController.m
//  AVDemonCamManualAdaptive
//
//  Created by Xcode Developer on 12/18/21.
//

#import "ViewController.h"
#import "ControlConfiguration.h"

@interface ControlView ()

@end

static UIBezierPath * tick_line;

@implementation ControlView

static const int (^bitwiseSubtract)(int, int) = ^ int (int x, int y) {
    while (y != 0)
    {
        int borrow = (~x) & y;
        x = x ^ y;
        y = borrow << 1;
    }
    
    return x;
};

static float rescale(float old_value, float old_min, float old_max, float new_min, float new_max) {
    return (new_max - new_min) * /*(fmax(old_min, fmin(old_value, old_max))*/ (old_value - old_min) / (old_max - old_min) + new_min;
};

static void (^(^handle_touch_event_init)(__kindof __weak UIView *))(UITouch * _Nullable) = ^ (__kindof __weak UIView * view) {
    CaptureDeviceConfigurationPropertyButton = CaptureDeviceConfigurationPropertyButtons(CaptureDeviceConfigurationControlPropertyImageValues, view);
    for (CaptureDeviceConfigurationControlProperty property = CaptureDeviceConfigurationControlPropertyTorchLevel; property < CaptureDeviceConfigurationControlPropertyDefault; property++) {
        [view addSubview:CaptureDeviceConfigurationPropertyButton(property)];
    }
    
    const CGFloat min_angle = 180.0 + (90.0 * ((CaptureDeviceConfigurationControlPropertyTorchLevel) / 4.0));
    const CGFloat max_angle = 180.0 + (90.0 * ((CaptureDeviceConfigurationControlPropertyZoomFactor) / 4.0));
    
    __block UITouch * touch_glb;
    const CGPoint center = CGPointMake(CGRectGetMaxX(UIScreen.mainScreen.bounds) - [CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertyTorchLevel) intrinsicContentSize].width, CGRectGetMaxY(UIScreen.mainScreen.bounds) - [CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertyZoomFactor) intrinsicContentSize].height);
    
    const CGFloat min_radius = sqrt(pow((CGRectGetWidth(view.bounds) * 0.8) - center.x, 2.0) + pow((CGRectGetHeight(view.bounds) * 0.8) - center.y, 2.0));
    const CGFloat max_radius = sqrt(pow((CGRectGetWidth(view.bounds) * 0.6) - center.x, 2.0) + pow((CGRectGetHeight(view.bounds) * 0.6) - center.y, 2.0));
    __block CGFloat radius = max_radius;
    
    return ^ (UITouch * _Nullable touch) {
        
        __block CGPoint touch_point;
        (touch != nil)
        ? ^{
            touch_glb = touch;
            touch_point = [touch_glb preciseLocationInView:touch_glb.view];
        }()
        : ^{
            touch_point = [touch_glb preciseLocationInView:touch_glb.view];
        }();
        radius = fmaxf(min_radius, fminf(sqrt(pow(touch_point.x - center.x, 2.0) + pow(touch_point.y - center.y, 2.0)), max_radius));
        //        radius = rescale(radius, min_radius, max_radius, min_radius, max_radius * 1.1875);
        
        for (CaptureDeviceConfigurationControlProperty property = CaptureDeviceConfigurationControlPropertyTorchLevel; property < CaptureDeviceConfigurationControlPropertyDefault; property++) {
            double angle = 180.0 + (90.0 * ((property) / 4.0));
            
            static UIBezierPath * bezier_quad_curve;
            bezier_quad_curve = [UIBezierPath bezierPathWithArcCenter:center
                                                               radius:radius
                                                        startAngle:degreesToRadians(angle) endAngle:degreesToRadians(angle) clockwise:FALSE];
            
            CGPoint button_center = [bezier_quad_curve currentPoint];
            [CaptureDeviceConfigurationPropertyButton(property) setCenter:button_center];
            
            CGFloat touch_point_angle = ^ CGFloat (CGPoint intersection_point, CGPoint center_point) {
                CGFloat radian  = atan2(intersection_point.y - center_point.y, intersection_point.x - center_point.x);
                CGFloat degrees = radian * (180.0 / M_PI);
                if (degrees < 0.0) degrees += 360.0;
                degrees = fmaxf(min_angle, fminf(degrees, max_angle));
                
                return degrees;
            }(touch_point, center);
            
            CaptureDeviceConfigurationControlProperty nearest_neighbor_property = (touch_point_angle > angle)
            ? (property != CaptureDeviceConfigurationControlPropertyZoomFactor)
            ? property + 1
            : CaptureDeviceConfigurationControlPropertyZoomFactor
            : (property != CaptureDeviceConfigurationControlPropertyTorchLevel)
            ? property - 1
            : CaptureDeviceConfigurationControlPropertyTorchLevel;
            CGFloat nearest_neighbor_angle = 180.0 + (90.0 * ((nearest_neighbor_property) / 4.0));
            
            ((touch_point_angle >= angle && touch_point_angle <= nearest_neighbor_angle) || (touch_point_angle <= angle && touch_point_angle >= nearest_neighbor_angle)) ?
            ^{
                BOOL selectButton = (fabs(touch_point_angle - angle) < fabs(touch_point_angle - nearest_neighbor_angle));
                [CaptureDeviceConfigurationPropertyButton(property) setSelected:selectButton];
                [CaptureDeviceConfigurationPropertyButton(nearest_neighbor_property) setSelected:!selectButton];
                
                ((touch_glb.phase == UITouchPhaseEnded) && (selectButton)) ?
                ^{
                    [CaptureDeviceConfigurationPropertyButton(property) sendActionsForControlEvents:UIControlEventTouchUpInside];
                }() :
                ^{
                    
                }();
            }()
            : ^{
                [CaptureDeviceConfigurationPropertyButton(property) setSelected:FALSE];
            }();
        };
    };
    
};

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    handle_touch_event(touches.anyObject);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    handle_touch_event(nil);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    handle_touch_event(nil);
}

//CGPoint center = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
//return ^ (UITouch * touch) {
//    CGPoint tp = [touch preciseLocationInView:touch.view];
////    CGFloat radius = sqrt(pow(tp.x - center.x, 2.0) + pow(tp.y - center.y, 2.0));
//double angle = 180.0 + (90.0 * ((property) / 4.0));
//UIBezierPath * bezier_quad_curve = [UIBezierPath bezierPathWithArcCenter:center
//                                                                  radius:(CGRectGetMaxX(UIScreen.mainScreen.bounds) * 0.75)
//                                                              startAngle:degreesToRadians(angle) endAngle:degreesToRadians(angle) clockwise:FALSE];
//[button setCenter:[bezier_quad_curve currentPoint]];

//static void (^(^handle_touch_event_init)(__kindof __weak UIView *))(UITouch * _Nullable) = ^ (__kindof __weak UIView * view) {
//    [(CAShapeLayer *)view.layer setPath:
//     ^ CGPathRef (void) {
//        tick_line = [UIBezierPath bezierPath];
//        static UIBezierPath * outer_arc;
//        static UIBezierPath * inner_arc;
//        CGPoint default_center = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds));
//        CGFloat default_radius = ((view.bounds.size.width <= view.bounds.size.height) ? view.bounds.size.width : view.bounds.size.height) * 0.55;
//        for (int degrees = 0; degrees < 360; degrees = degrees + 10) {
//            outer_arc = [UIBezierPath bezierPathWithArcCenter:default_center
//                                                       radius:default_radius
//                                                   startAngle:degreesToRadians(degrees)
//                                                     endAngle:degreesToRadians(degrees)
//                                                    clockwise:FALSE];
//            inner_arc = [UIBezierPath bezierPathWithArcCenter:default_center
//                                                       radius:default_radius * 0.85
//                                                   startAngle:degreesToRadians(degrees)
//                                                     endAngle:degreesToRadians(degrees)
//                                                    clockwise:FALSE];
//
//            [tick_line moveToPoint:[outer_arc currentPoint]];
//            [tick_line addLineToPoint:[inner_arc currentPoint]];
//        }
//        return tick_line.CGPath;
//    }()];
//
//    return ^ (UITouch * _Nullable touch) {
//        static UITouch * touch_glb;
//        (touch != nil)
//        ? ^{
//            touch_glb = touch;
//        }()
//        : ^{
//            static CGPoint tp;
//            tp = [touch_glb locationInView:touch_glb.view];
//            static CGPoint prev_tp;
//            prev_tp = [touch_glb previousLocationInView:touch_glb.view];
//
////            [(CAShapeLayer *)touch_glb.view.layer setPath:^ CGPathRef (void) {
//                (CGRectContainsPoint(CGPathGetPathBoundingBox(((CAShapeLayer *)touch_glb.view.layer).path), tp))
//                ? ^{
//                    [(CAShapeLayer *)touch_glb.view.layer setTransform:CATransform3DTranslate(touch_glb.view.layer.transform, bitwiseSubtract(tp.x, prev_tp.x), bitwiseSubtract(tp.y, prev_tp.y), 0.0)];
//                }()
//                : ^{
////                    [(CAShapeLayer *)touch_glb.view.layer setTransform:CATransform3DScale(touch_glb.view.layer.transform, bitwiseSubtract(tp.x, prev_tp.x), bitwiseSubtract(tp.y, prev_tp.y), 0.0)];
//                    //            CGFloat new_radius = sqrt(pow(tp.x - center.x, 2.0) + pow(tp.y - center.y, 2.0));
//                    //            CGFloat scale = radius / new_radius;
//                    //            [tick_line applyTransform:CGAffineTransformMakeScale(scale, scale)];
//                    //            radius = new_radius;
////                    printf("\tRadius\n");
//                }();
////                return tick_line.CGPath;
////            }()];
//        }();
//    };
//};

static const void (^handle_touch_event)(UITouch * _Nullable);

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setTranslatesAutoresizingMaskIntoConstraints:FALSE];
        
        [(CAShapeLayer *)self.layer setLineWidth:2.25];
        [(CAShapeLayer *)self.layer setStrokeColor:[UIColor colorWithRed:4/255 green:51/255 blue:255/255 alpha:1.0].CGColor];
        [(CAShapeLayer *)self.layer setFillColor:[UIColor clearColor].CGColor];
        [(CAShapeLayer *)self.layer setBackgroundColor:[UIColor clearColor].CGColor];
        
        handle_touch_event = handle_touch_event_init(self);
        [self.layer setNeedsDisplay];
    }
    
    return self;
}


@end

@interface CameraView ()

@end

@implementation CameraView

+ (Class)layerClass {
    return  [AVCaptureVideoPreviewLayer class];
}

@end

@interface ViewController ()
{
    AVCaptureSession           * captureSession;
    AVCaptureDevice            * captureDevice;
    AVCaptureDeviceInput       * captureInput;
    AVCaptureConnection        * captureConnection;
    AVCaptureVideoPreviewLayer * capturePreview;
}

@end

@implementation ViewController

@dynamic view;

- (void)loadView {
    self.view = (CameraView *)[[CameraView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [self.view addSubview:^ ControlView * (void) {
        ControlView * cv = [[ControlView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        return cv;
    }()];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [captureSession = [[AVCaptureSession alloc] init] setSessionPreset:([captureSession canSetSessionPreset:AVCaptureSessionPreset3840x2160]) ? AVCaptureSessionPreset3840x2160 : AVCaptureSessionPreset1920x1080];
    [captureSession beginConfiguration];
    {
        [captureInput  = [AVCaptureDeviceInput deviceInputWithDevice:[captureDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInDualCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack] self] error:nil] setUnifiedAutoExposureDefaultsEnabled:TRUE];
        [captureSession addInput:([captureSession canAddInput:captureInput]) ? captureInput : nil];
        
        [capturePreview = (AVCaptureVideoPreviewLayer *)[(CameraView *)self.view layer] setSessionWithNoConnection:captureSession];
        [capturePreview setSessionWithNoConnection:captureSession];
        
        [captureConnection   = [[AVCaptureConnection alloc] initWithInputPort:captureInput.ports.firstObject videoPreviewLayer:capturePreview] setVideoOrientation:AVCaptureVideoOrientationPortrait];
        [captureSession addConnection:([captureSession canAddConnection:captureConnection]) ? captureConnection : nil];
    }
    [captureSession commitConfiguration];
    [captureSession startRunning];
    [captureDevice lockForConfiguration:nil];
}

@end
