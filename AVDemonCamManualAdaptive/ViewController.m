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

static const void (^(^handle_touch_event_init)(__kindof __weak UIView *))(UITouch * _Nullable) = ^ (__kindof __weak UIView * view) {
    static CGSize button_group_size;
    button_group_size = CGSizeZero;
    CaptureDeviceConfigurationPropertyButton = CaptureDeviceConfigurationPropertyButtons(CaptureDeviceConfigurationControlPropertyImageValues, view);
    for (CaptureDeviceConfigurationControlProperty property = CaptureDeviceConfigurationControlPropertyTorchLevel; property < CaptureDeviceConfigurationControlPropertySelected; property++) {
        [view addSubview:CaptureDeviceConfigurationPropertyButton(property)];
    }
    
    //    CGRect view_frame = CGRectMake(CGRectGetMinX(view.bounds),
    //                                   CGRectGetMinY(view.bounds),
    //                                   CGRectGetMaxX(view.bounds),
    //                                   CGRectGetMaxX(view.bounds));
    //    [view setBounds:view_frame];
    
    static const CGFloat min_angle = 180.0 + (90.0 * ((CaptureDeviceConfigurationControlPropertyTorchLevel) / 4.0));
    static const CGFloat max_angle = 180.0 + (90.0 * ((CaptureDeviceConfigurationControlPropertyZoomFactor) / 4.0));
    
    static double angle[5] = {
        (double)(180.0 + (90.0 * ((double)CaptureDeviceConfigurationControlPropertyTorchLevel / 4.0))),
        (double)(180.0 + (90.0 * ((double)CaptureDeviceConfigurationControlPropertyLensPosition / 4.0))),
        (double)(180.0 + (90.0 * ((double)CaptureDeviceConfigurationControlPropertyExposureDuration / 4.0))),
        (double)(180.0 + (90.0 * ((double)CaptureDeviceConfigurationControlPropertyISO / 4.0))),
        (double)(180.0 + (90.0 * ((double)CaptureDeviceConfigurationControlPropertyZoomFactor / 4.0)))
    };
    
    const CGPoint center = CGPointMake(CGRectGetMaxX(view.bounds) - CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertyTorchLevel).center.x, CGRectGetMaxY(view.bounds) - CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertyTorchLevel).center.y);
    
    void (^(^button_arc_renderer_init)(double *, CaptureDeviceConfigurationControlProperty *))(void) = ^ (CGFloat * radius, CaptureDeviceConfigurationControlProperty * touch_point_property){
        return ^ {
            for (CaptureDeviceConfigurationControlProperty property = CaptureDeviceConfigurationControlPropertyTorchLevel; property < CaptureDeviceConfigurationControlPropertySelected; property++) {
                
                [CaptureDeviceConfigurationPropertyButton(property) setCenter:[[UIBezierPath bezierPathWithArcCenter:center
                                                                                                              radius:*radius
                                                                                                          startAngle:degreesToRadians(((double *)(&angle))[property]) endAngle:degreesToRadians(((double *)(&angle))[property]) clockwise:FALSE] currentPoint]];
                [CaptureDeviceConfigurationPropertyButton(property) setSelected:(property == *touch_point_property)];
            };
        };
    };
    
    void (^(^tick_wheel_renderer_init)(double *, CaptureDeviceConfigurationControlProperty *, double *))(void) = ^ (CGFloat * radius, CaptureDeviceConfigurationControlProperty * touch_point_property, double * touch_point_angle){
        return ^{
            [(CAShapeLayer *)view.layer setPath:
             ^ CGPathRef (void) {
                tick_line = [UIBezierPath bezierPath];
//                CGFloat arc_radius = sqrt(pow(CGRectGetMinX(CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertySelected).frame) - center.x, 2.0) + pow(CGRectGetMinY(CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertySelected).frame) - center.y, 2.0));
                for (int degrees = 180; degrees < 270; degrees = degrees + 2) { // change degree interval based on radius
                    [tick_line moveToPoint:[[UIBezierPath bezierPathWithArcCenter:center
                                                                           radius:*radius
                                                                       startAngle:degreesToRadians(degrees)
                                                                         endAngle:degreesToRadians(degrees)
                                                                        clockwise:FALSE] currentPoint]];
                    
                    [tick_line addLineToPoint:[[UIBezierPath bezierPathWithArcCenter:center
                                                                              radius:*radius * ((degrees == (int)*touch_point_angle)  ? .5 : .975)
                                                                          startAngle:degreesToRadians(degrees)
                                                                            endAngle:degreesToRadians(degrees)
                                                                           clockwise:FALSE] currentPoint]];
                }
                return tick_line.CGPath;
            }()];
        };
    };
    
    static double radius;
    static CaptureDeviceConfigurationControlProperty touch_point_property;
    static CGFloat touch_point_angle;
    static void (^control_renderer)(void);
    control_renderer = button_arc_renderer_init(&radius, &touch_point_property);
    
    return ^ (UITouch * _Nullable touch) {
        static UITouch * touch_glb;
        static CGPoint touch_point;
        (touch != nil)
        ? ^{
            touch_glb = touch;
        }()
        : ^{
            
        }();
        touch_point = [touch_glb preciseLocationInView:touch_glb.view];
        
        
        touch_point_angle = ^ CGFloat (void) {
            CGFloat radian  = atan2(touch_point.y - center.y, touch_point.x - center.x);
            CGFloat degrees = radian * (180.0 / M_PI);
            if (degrees < 0.0) degrees += 360.0;
            degrees = fmaxf(min_angle, fminf(degrees, max_angle));
            return degrees;
        }();
        
        touch_point_property = round(rescale(touch_point_angle, 180.0, 270.0, 0.0, 4.0));
        
        
        radius = ^ CGFloat (void) {
            CGFloat x_radius     = touch_point.x - center.x;
            CGFloat y_radius     = touch_point.y - center.y;
            CGFloat r     = sqrt(pow(x_radius, 2.0) +
                                 pow(y_radius, 2.0));
            return fmaxf(fminf(center.x - CGRectGetMidX(CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertyTorchLevel).bounds), r), CGRectGetMidX(view.bounds) - CGRectGetMaxX(CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertyTorchLevel).bounds));
        }();
        
        control_renderer();
        
        if (touch_glb.phase == UITouchPhaseEnded) {
            if (!CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertySelected).isHidden && [(CAShapeLayer *)view.layer path] == nil) {
                [CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertySelected) sendActionsForControlEvents:UIControlEventTouchUpInside];
                (control_renderer = tick_wheel_renderer_init(&radius, &touch_point_property, &touch_point_angle))();
            } else {
                [CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertySelected) sendActionsForControlEvents:UIControlEventTouchUpInside];
                [(CAShapeLayer *)view.layer setPath:nil];
                (control_renderer = button_arc_renderer_init(&radius, &touch_point_property))();
            }
        }
        
        // TO-DO: if UITouchPhaseEnded, switch between button arc and tick wheel
//        dispatch_block_t tick_wheel = ^ {
//            ((touch_glb.phase == UITouchPhaseEnded) && CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertySelected) && [(CAShapeLayer *)view.layer path] == nil)
//            ? ^{
//                for (CaptureDeviceConfigurationControlProperty property = CaptureDeviceConfigurationControlPropertyTorchLevel; property < CaptureDeviceConfigurationControlPropertySelected; property++) {
//                    [CaptureDeviceConfigurationPropertyButton(property) setHidden:TRUE];
//                };
//                [(CAShapeLayer *)view.layer setPath:
//                 ^ CGPathRef (void) {
//                    tick_line = [UIBezierPath bezierPath];
//                    CGFloat arc_radius = sqrt(pow(CGRectGetMinX(CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertySelected).frame) - center.x, 2.0) + pow(CGRectGetMinY(CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertySelected).frame) - center.y, 2.0));
//                    for (int degrees = 180; degrees < 270; degrees = degrees + 2) { // change degree interval based on radius
//                        [tick_line moveToPoint:[[UIBezierPath bezierPathWithArcCenter:center
//                                                                               radius:arc_radius
//                                                                           startAngle:degreesToRadians(degrees)
//                                                                             endAngle:degreesToRadians(degrees)
//                                                                            clockwise:FALSE] currentPoint]];
//
//                        [tick_line addLineToPoint:[[UIBezierPath bezierPathWithArcCenter:center
//                                                                                  radius:arc_radius * .975
//                                                                              startAngle:degreesToRadians(degrees)
//                                                                                endAngle:degreesToRadians(degrees)
//                                                                               clockwise:FALSE] currentPoint]];
//                    }
//                    return tick_line.CGPath;
//                }()];
//                [CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertySelected) sendActionsForControlEvents:UIControlEventTouchUpInside];
//            }()
//            : (touch_glb.phase == UITouchPhaseBegan | UITouchPhaseMoved)
//            ? ^{
//                [(CAShapeLayer *)view.layer setPath:nil];
//                for (CaptureDeviceConfigurationControlProperty property = CaptureDeviceConfigurationControlPropertyTorchLevel; property < CaptureDeviceConfigurationControlPropertySelected; property++) {
//                    [CaptureDeviceConfigurationPropertyButton(property) setHidden:FALSE];
//                    [CaptureDeviceConfigurationPropertyButton(property) setCenter:[[UIBezierPath bezierPathWithArcCenter:center
//                                                                                                                  radius:radius
//                                                                                                              startAngle:degreesToRadians(((double *)(&angle))[property]) endAngle:degreesToRadians(((double *)(&angle))[property]) clockwise:FALSE] currentPoint]];
//                    [CaptureDeviceConfigurationPropertyButton(property) setSelected:(property == touch_point_property)];
//                };
//            }()
//            : ^{}();
//        };
    };
};

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    handle_touch_event(touches.anyObject);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    handle_touch_event(touches.anyObject);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    handle_touch_event(touches.anyObject);
}

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
//                [(CAShapeLayer *)self.layer setBorderWidth:0.5];
//                [(CAShapeLayer *)self.layer setBorderColor:[UIColor redColor].CGColor];
        
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
    CGSize                       videoDimensions;
}

@end

@implementation ViewController

@dynamic view;

- (void)loadView {
    self.view = (CameraView *)[[CameraView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [self.view setContentMode:UIViewContentModeScaleAspectFit];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [captureSession = [[AVCaptureSession alloc] init] setSessionPreset:([captureSession canSetSessionPreset:AVCaptureSessionPreset3840x2160]) ? AVCaptureSessionPreset3840x2160 : AVCaptureSessionPreset1920x1080];
    [captureSession beginConfiguration];
    {
        [captureInput  = [AVCaptureDeviceInput deviceInputWithDevice:[captureDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInDualCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack] self] error:nil] setUnifiedAutoExposureDefaultsEnabled:TRUE];
        [captureSession addInput:([captureSession canAddInput:captureInput]) ? captureInput : nil];
        
        videoDimensions = CMVideoFormatDescriptionGetPresentationDimensions(captureDevice.activeFormat.formatDescription, TRUE, FALSE);
        CGFloat video_maxY   = videoDimensions.height;
        CGFloat height_scale = (CGRectGetHeight(UIScreen.mainScreen.bounds) / videoDimensions.height); // the screen height is this many times smaller than the video height
        [self.view addSubview:^ ControlView * (void) {
            ControlView * cv = [[ControlView alloc] initWithFrame:CGRectMake(CGRectGetMinX(UIScreen.mainScreen.bounds),
                                                                             CGRectGetMidY(UIScreen.mainScreen.bounds),
                                                                             CGRectGetWidth(UIScreen.mainScreen.bounds),
                                                                             CGRectGetWidth(UIScreen.mainScreen.bounds))];
            return cv;
        }()];
        
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
