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

// To-Do: Write a new touch event handler for aligning buttons to thumb range/swipe

static void (^(^handle_touch_event_init)(__kindof __weak UIView *))(UITouch * _Nullable) = ^ (__kindof __weak UIView * view) {
    CGPoint center = CGPointMake(CGRectGetMaxX(UIScreen.mainScreen.bounds) - [(UIButton *)view.subviews.firstObject intrinsicContentSize].width, CGRectGetMaxY(UIScreen.mainScreen.bounds) - [(UIButton *)view.subviews.firstObject intrinsicContentSize].height);
    return ^ (UITouch * _Nullable touch) {
        static UITouch * touch_glb;
        static CGPoint tp;
        (touch_glb.phase == UITouchPhaseBegan || touch != nil)
        ? ^{
            touch_glb = touch;
            tp = [touch_glb locationInView:touch_glb.view];
            CGFloat radius = sqrt(pow(tp.x - center.x, 2.0) + pow(tp.y - center.y, 2.0));
            [(NSArray<__kindof UIButton *> *)view.subviews enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull button, CaptureDeviceConfigurationControlProperty property, BOOL * _Nonnull stop) {
                [UIView animateWithDuration:0.125 animations:^{
                    [button setHighlighted:FALSE];
                    double angle = 180.0 + (90.0 * ((property) / 4.0));
                    angle = degreesToRadians(angle);
                    UIBezierPath * bezier_quad_curve = [UIBezierPath bezierPathWithArcCenter:center
                                                                                      radius:radius
                                                                                  startAngle:angle endAngle:angle clockwise:FALSE];
                    [button setCenter:[bezier_quad_curve currentPoint]];
                }];
            }];
        }()
        : (touch_glb.phase == UITouchPhaseMoved) ? ^{
            tp = [touch_glb locationInView:touch_glb.view];
            CGFloat radius = sqrt(pow(tp.x - center.x, 2.0) + pow(tp.y - center.y, 2.0));
            [(NSArray<__kindof UIButton *> *)view.subviews enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull button, CaptureDeviceConfigurationControlProperty property, BOOL * _Nonnull stop) {
                [button setHighlighted:(CGRectContainsPoint(button.frame, tp) && button.isHighlighted == FALSE) ? TRUE : FALSE];
                double angle = 180.0 + (90.0 * ((property) / 4.0));
                angle = degreesToRadians(angle);
                UIBezierPath * bezier_quad_curve = [UIBezierPath bezierPathWithArcCenter:center
                                                                                  radius:radius
                                                                              startAngle:angle endAngle:angle clockwise:FALSE];
                [button setCenter:[bezier_quad_curve currentPoint]];
            }];
        }()
        : ^{
            tp = [touch_glb locationInView:touch_glb.view];
            CGFloat radius = sqrt(pow(tp.x - center.x, 2.0) + pow(tp.y - center.y, 2.0));
            [(NSArray<__kindof UIButton *> *)view.subviews enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull button, CaptureDeviceConfigurationControlProperty property, BOOL * _Nonnull stop) {
                [button setHighlighted:(CGRectContainsPoint(button.frame, tp) && button.isHighlighted == FALSE) ? TRUE : FALSE];
                double angle = 180.0 + (90.0 * ((property) / 4.0));
                angle = degreesToRadians(angle);
                UIBezierPath * bezier_quad_curve = [UIBezierPath bezierPathWithArcCenter:center
                                                                                  radius:radius
                                                                              startAngle:angle endAngle:angle clockwise:FALSE];
                [button setCenter:[bezier_quad_curve currentPoint]];
            }];
            // send touch event to selected button
//            [(NSArray<__kindof UIButton *> *)view.subviews enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull button, CaptureDeviceConfigurationControlProperty property, BOOL * _Nonnull stop) {
//                (button.isSelected)
//                ? ^{
//                    // This should be the "event handler" for the button to avoid lag
////                    [button sendActionsForControlEvents:UIControlEventTouchUpInside];
//                    *stop = TRUE;
//                }()
//                : ^{
//                    //
//                }();
//            }];
        }();
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
        
        UIButton * (^CaptureDeviceConfigurationPropertyButton)(CaptureDeviceConfigurationControlProperty) = CaptureDeviceConfigurationPropertyButtons(CaptureDeviceConfigurationControlPropertyImageValues, self);
        for (CaptureDeviceConfigurationControlProperty property = CaptureDeviceConfigurationControlPropertyTorchLevel; property < CaptureDeviceConfigurationControlPropertyDefault; property++) {
            [self addSubview:CaptureDeviceConfigurationPropertyButton(property)];
        }
        
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
