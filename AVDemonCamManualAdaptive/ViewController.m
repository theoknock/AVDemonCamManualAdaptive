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
    static double angle[5] = {
        (double)(180.0 + (90.0 * ((double)CaptureDeviceConfigurationControlPropertyTorchLevel / 4.0))),
        (double)(180.0 + (90.0 * ((double)CaptureDeviceConfigurationControlPropertyLensPosition / 4.0))),
        (double)(180.0 + (90.0 * ((double)CaptureDeviceConfigurationControlPropertyExposureDuration / 4.0))),
        (double)(180.0 + (90.0 * ((double)CaptureDeviceConfigurationControlPropertyISO / 4.0))),
        (double)(180.0 + (90.0 * ((double)CaptureDeviceConfigurationControlPropertyZoomFactor / 4.0)))
    };
    CaptureDeviceConfigurationPropertyButton = CaptureDeviceConfigurationPropertyButtons(CaptureDeviceConfigurationControlPropertyImageValues, view);
    const CGPoint center = CGPointMake(CGRectGetMaxX(view.bounds) - CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertyTorchLevel).center.x, CGRectGetMaxY(view.bounds) - CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertyZoomFactor).center.y);
    static double radius;
    radius = CGRectGetMidX(view.bounds) - CGRectGetMaxX(CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertyTorchLevel).bounds);
    void (^(^button_arc_renderer_init)(double *, double *, CaptureDeviceConfigurationControlProperty *))(void) = ^ (double * touch_point_angle, double * radius, CaptureDeviceConfigurationControlProperty * touch_point_property) {
        return ^{
            for (CaptureDeviceConfigurationControlProperty property = CaptureDeviceConfigurationControlPropertyTorchLevel; property < CaptureDeviceConfigurationControlPropertySelected; property++) {
                [CaptureDeviceConfigurationPropertyButton(property) setCenter:[[UIBezierPath bezierPathWithArcCenter:center
                                                                                                              radius:*radius
                                                                                                          startAngle:degreesToRadians(((double *)(&angle))[property])
                                                                                                            endAngle:degreesToRadians(((double *)(&angle))[property])
                                                                                                           clockwise:FALSE] currentPoint]];
                [CaptureDeviceConfigurationPropertyButton(property) setSelected:(property == *touch_point_property)];
            }
        };
    };
    
    for (CaptureDeviceConfigurationControlProperty property = CaptureDeviceConfigurationControlPropertyTorchLevel; property < CaptureDeviceConfigurationControlPropertySelected; property++) {
        
        [UIView animateWithDuration:3.0 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [view addSubview:CaptureDeviceConfigurationPropertyButton(property)];
            [CaptureDeviceConfigurationPropertyButton(property) setCenter:[[UIBezierPath bezierPathWithArcCenter:center
                                                                                                          radius:radius
                                                                                                      startAngle:degreesToRadians(((double *)(&angle))[property])
                                                                                                        endAngle:degreesToRadians(((double *)(&angle))[property])
                                                                                                       clockwise:FALSE] currentPoint]];
        } completion:^(BOOL finished) {
            
        }];
    }
    static UIBezierPath * tick_line;
    
    void (^(^tick_wheel_renderer_init)(double *, double *, double *, CaptureDeviceConfigurationControlProperty *))(void) = ^ (double * touch_point_angle, double * radius, double * previous_radius, CaptureDeviceConfigurationControlProperty * touch_point_property) {
        [(CAShapeLayer *)view.layer setPath:
         ^ CGPathRef (void) {
            tick_line = [UIBezierPath bezierPath];
            for (int degrees = 180; degrees < 270; degrees++) {
                [tick_line moveToPoint:[[UIBezierPath bezierPathWithArcCenter:center
                                                                       radius:*radius
                                                                   startAngle:degreesToRadians(degrees)
                                                                     endAngle:degreesToRadians(degrees)
                                                                    clockwise:FALSE] currentPoint]];
                [tick_line addLineToPoint:[[UIBezierPath bezierPathWithArcCenter:center
                                                                          radius:*radius * 0.975
                                                                      startAngle:degreesToRadians(degrees)
                                                                        endAngle:degreesToRadians(degrees)
                                                                       clockwise:FALSE] currentPoint]];
            }
            return tick_line.CGPath;
        }()];
        return ^{
            [CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertySelected) setCenter:[[UIBezierPath bezierPathWithArcCenter:center
                                                                                                                                                   radius:*radius
                                                                                                                                               startAngle:degreesToRadians(*touch_point_angle)
                                                                                                                                                 endAngle:degreesToRadians(*touch_point_angle)
                                                                                                                                                clockwise:FALSE] currentPoint]];
            [(CAShapeLayer *)view.layer setPath:
             ^ CGPathRef (void) {
                tick_line = [UIBezierPath bezierPath];
                for (int degrees = 180; degrees < 270; degrees++) {
                    [tick_line moveToPoint:[[UIBezierPath bezierPathWithArcCenter:center
                                                                           radius:*radius
                                                                       startAngle:degreesToRadians(degrees)
                                                                         endAngle:degreesToRadians(degrees)
                                                                        clockwise:FALSE] currentPoint]];
                    [tick_line moveToPoint:[tick_line currentPoint]];
                    [tick_line addArcWithCenter:center
                                         radius:*radius * 0.975
                                     startAngle:degreesToRadians(degrees)
                                       endAngle:degreesToRadians(degrees)
                                      clockwise:FALSE];
                    [tick_line addLineToPoint:[tick_line currentPoint]];
                    //                [tick_line moveToPoint:[[UIBezierPath bezierPathWithArcCenter:center
                    //                                                                       radius:*radius
                    //                                                                   startAngle:degreesToRadians(degrees)
                    //                                                                     endAngle:degreesToRadians(degrees)
                    //                                                                    clockwise:FALSE] currentPoint]];
                    //                [tick_line addLineToPoint:[[UIBezierPath bezierPathWithArcCenter:center
                    //                                                                          radius:*radius * 0.975
                    //                                                                      startAngle:degreesToRadians(degrees)
                    //                                                                        endAngle:degreesToRadians(degrees)
                    //                                                                       clockwise:FALSE] currentPoint]];
                }
                return tick_line.CGPath;
            }()];
        };
    };
    
    static CaptureDeviceConfigurationControlProperty touch_point_property;
    static CGFloat touch_point_angle;
    static void (^control_renderer)(void);
    control_renderer = button_arc_renderer_init(&touch_point_angle, &radius, &touch_point_property);
    
    
    
    return ^ (UITouch * _Nullable touch) {
        static UITouch * touch_glb;
        static CGPoint touch_point, previous_touch_point;
        static UITouchPhase touch_phase;
        (touch != nil)
        ? ^{
            touch_glb = touch;
        }()
        : ^{
            
        }();
        touch_point = [touch_glb preciseLocationInView:touch_glb.view];
        previous_touch_point = [touch_glb precisePreviousLocationInView:touch_glb.view];
        touch_phase = [touch_glb phase];
        
        touch_point_angle = ^ CGFloat (void) {
            CGFloat radian  = atan2(touch_point.y - center.y, touch_point.x - center.x);
            CGFloat degrees = radian * (180.0 / M_PI);
            if (degrees < 0.0) degrees += 360.0;
            degrees = fmaxf(angle[0], fminf(degrees, angle[4]));
            return degrees;
        }();
        
        touch_point_property = round(rescale(touch_point_angle, 180.0, 270.0, 0.0, 4.0));
        
        radius = ^ CGFloat (void) {
            CGFloat x_radius     = touch_point.x - center.x;
            CGFloat y_radius     = touch_point.y - center.y;
            CGFloat r            = sqrt(pow(x_radius, 2.0) +
                                        pow(y_radius, 2.0));
            return fmaxf(fminf(center.x - CGRectGetMidX(CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertyTorchLevel).bounds), r), CGRectGetMidX(view.bounds) - CGRectGetMaxX(CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertyTorchLevel).bounds));
        }();
        
        control_renderer();
        
        if (touch_glb.phase == UITouchPhaseEnded) {
            // button role-around-the-arc exit transition animation
            //            [view.layer setFrame:CGRectMake(CGRectGetMinX(UIScreen.mainScreen.bounds) + CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertyTorchLevel).center.x,
            //                                            CGRectGetMidY(UIScreen.mainScreen.bounds) + CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertyZoomFactor).center.y,
            //                                            CGRectGetMinX(UIScreen.mainScreen.bounds) + CGRectGetWidth(UIScreen.mainScreen.bounds),
            //                                            CGRectGetMinX(UIScreen.mainScreen.bounds) + CGRectGetWidth(UIScreen.mainScreen.bounds))];
            //            view.layer.anchorPoint = CGPointMake(1.0, 1.0);
            //            CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_4);
            //            view.layer.affineTransform = transform;
            //            [view.layer setFrame:view_reference_frame];
            
            [CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertySelected) sendActionsForControlEvents:UIControlEventTouchUpInside];
            CaptureDeviceConfigurationControlProperty next_property = (CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertySelected).tag + 1) % 4;
            if ([CaptureDeviceConfigurationPropertyButton(next_property) isHidden]) {
                (control_renderer = tick_wheel_renderer_init(&touch_point_angle, &radius, &previous_radius, &touch_point_property))();
            } else {
                tick_line = nil;
                [(CAShapeLayer *)view.layer setPath:nil];
                (control_renderer = button_arc_renderer_init(&touch_point_angle, &radius, &touch_point_property))();
                [CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertySelected) setSelected:FALSE];
            }
        }
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
        [self setBackgroundColor:[UIColor clearColor]];
        [self setOpaque:FALSE];
        [(CAShapeLayer *)self.layer setLineWidth:2.25];
        [(CAShapeLayer *)self.layer setStrokeColor:[UIColor colorWithRed:4/255 green:51/255 blue:255/255 alpha:1.0].CGColor];
        [(CAShapeLayer *)self.layer setFillColor:[UIColor clearColor].CGColor];
        [(CAShapeLayer *)self.layer setBackgroundColor:[UIColor clearColor].CGColor];
        [(CAShapeLayer *)self.layer setBorderWidth:0.5];
        [(CAShapeLayer *)self.layer setBorderColor:[UIColor redColor].CGColor];
        
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
    [(CameraView *)self.view setContentMode:UIViewContentModeScaleAspectFit];
    [(CameraView *)self.view addSubview:^ ControlView * (void) {
        ControlView * cv = [[ControlView alloc] initWithFrame:CGRectMake(CGRectGetMinX(UIScreen.mainScreen.bounds),
                                                                         CGRectGetMidY(UIScreen.mainScreen.bounds),
                                                                         CGRectGetWidth(UIScreen.mainScreen.bounds),
                                                                         CGRectGetWidth(UIScreen.mainScreen.bounds))];
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
        
        videoDimensions = CMVideoFormatDescriptionGetPresentationDimensions(captureDevice.activeFormat.formatDescription, TRUE, FALSE);
        //        CGFloat video_maxY   = videoDimensions.height;
        //        CGFloat height_scale = (CGRectGetHeight(UIScreen.mainScreen.bounds) / videoDimensions.height); // the screen height is this many times smaller than the video height
        
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
