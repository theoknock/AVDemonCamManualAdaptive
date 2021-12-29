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

static CGPoint center;
static double radius;
static double touch_point_angle;
static double (^CaptureDeviceConfigurationPropertyButtonAngle)(CaptureDeviceConfigurationControlProperty) = ^ double (CaptureDeviceConfigurationControlProperty property) {
    return (double)(180.0 + (90.0 * ((double)property / 4.0)));
};

static float rescale(float old_value, float old_min, float old_max, float new_min, float new_max) {
    return (new_max - new_min) * /*(fmax(old_min, fmin(old_value, old_max))*/ (old_value - old_min) / (old_max - old_min) + new_min;
};

static const void (^(^handle_touch_event_init)(__kindof __weak UIView *))(UITouch * _Nullable) = ^ (__kindof __weak UIView * view) {

    void (^(^button_arc_renderer_init)(double *, double *, CaptureDeviceConfigurationControlProperty *))(void) = ^ (double * touch_point_angle, double * radius, CaptureDeviceConfigurationControlProperty * touch_point_property) {
        return ^{
            for (CaptureDeviceConfigurationControlProperty property = CaptureDeviceConfigurationControlPropertyTorchLevel; property < CaptureDeviceConfigurationControlPropertySelected; property++) {
                [CaptureDeviceConfigurationPropertyButton(property) setCenter:[[UIBezierPath bezierPathWithArcCenter:center
                                                                                                              radius:*radius
                                                                                                          startAngle:degreesToRadians(CaptureDeviceConfigurationPropertyButtonAngle(property))
                                                                                                            endAngle:degreesToRadians(CaptureDeviceConfigurationPropertyButtonAngle(property))
                                                                                                           clockwise:FALSE] currentPoint]];
                [CaptureDeviceConfigurationPropertyButton(property) setSelected:(property == *touch_point_property)];
            }
        };
    };

    void (^(^tick_wheel_renderer_init)(double *, double *, CaptureDeviceConfigurationControlProperty *))(void) = ^ (double * touch_point_angle, double * radius, CaptureDeviceConfigurationControlProperty * touch_point_property) {
        const CGColorRef (^stroke_color)(BOOL) = ^ CGColorRef (BOOL highlight_color) {
            return (highlight_color) ? [UIColor yellowColor].CGColor : [UIColor blueColor].CGColor;
        };
        return ^{
            [CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertySelected) setCenter:[[UIBezierPath bezierPathWithArcCenter:center
                                                                                                                                                   radius:*radius
                                                                                                                                               startAngle:degreesToRadians(*touch_point_angle)
                                                                                                                                                 endAngle:degreesToRadians(*touch_point_angle)
                                                                                                                                                clockwise:FALSE] currentPoint]];
            
            
//            __block CGMutablePathRef path = CGPathCreateMutable();
//            __block UIBezierPath * tick_wheel;
//            tick_wheel = [UIBezierPath bezierPath];
//            CGPathAddPath(tick_wheel, nil, ^ CGPathRef (int start, int end) {
//                for (int degrees = start; degrees < end; degrees++) {
//                    [(CAShapeLayer *)view.layer setStrokeColor:stroke_color(TRUE)];
//
//                    [tick_wheel moveToPoint:[[UIBezierPath bezierPathWithArcCenter:center
//                                                                           radius:*radius
//                                                                       startAngle:degreesToRadians(degrees)
//                                                                         endAngle:degreesToRadians(degrees)
//                                                                        clockwise:FALSE] currentPoint]];
//                    [tick_wheel addLineToPoint:[[UIBezierPath bezierPathWithArcCenter:center
//                                                                              radius:*radius * 0.975
//                                                                          startAngle:degreesToRadians(degrees)
//                                                                            endAngle:degreesToRadians(degrees)
//                                                                           clockwise:FALSE] currentPoint]];
//                    [tick_wheel closePath];
//                }
//                return [tick_wheel CGPath];
//            }(180, (int)round(*touch_point_angle)));
//            CGPathAddPath(path, nil, ^ CGPathRef (int start, int end) {
//                for (int degrees = start; degrees < end; degrees++) {
//                    [(CAShapeLayer *)view.layer setStrokeColor:stroke_color(FALSE)];
//                    tick_wheel = [UIBezierPath bezierPath];
//
//                    [tick_wheel moveToPoint:[[UIBezierPath bezierPathWithArcCenter:center
//                                                                           radius:*radius
//                                                                       startAngle:degreesToRadians(degrees)
//                                                                         endAngle:degreesToRadians(degrees)
//                                                                        clockwise:FALSE] currentPoint]];
//                    [tick_wheel addLineToPoint:[[UIBezierPath bezierPathWithArcCenter:center
//                                                                              radius:*radius * 0.975
//                                                                          startAngle:degreesToRadians(degrees)
//                                                                            endAngle:degreesToRadians(degrees)
//                                                                           clockwise:FALSE] currentPoint]];
//                    [tick_wheel closePath];
//                }
//                return [tick_wheel CGPath];
//            }((int)round(*touch_point_angle), 270));
//            [(CAShapeLayer *)view.layer setPath:tick_wheel.CGPath];
            [view setNeedsDisplay];
        };
    };
    
    static CaptureDeviceConfigurationControlProperty touch_point_property;
    static void (^control_renderer)(void);
    control_renderer = button_arc_renderer_init(&touch_point_angle, &radius, &touch_point_property);
    
    
    
    return ^ (UITouch * _Nullable touch) {
        static UITouch * touch_glb;
        static CGPoint touch_point;
        static UITouchPhase touch_phase;
        (touch != nil)
        ? ^{
            touch_glb = touch;
        }()
        : ^{
            
        }();
        touch_point = [touch_glb preciseLocationInView:touch_glb.view];
        touch_phase = [touch_glb phase];
        
        touch_point_angle = ^ CGFloat (void) {
            CGFloat radian  = atan2(touch_point.y - center.y, touch_point.x - center.x);
            CGFloat degrees = radian * (180.0 / M_PI);
            if (degrees < 0.0) degrees += 360.0;
            degrees = fmaxf(CaptureDeviceConfigurationPropertyButtonAngle(CaptureDeviceConfigurationControlPropertyTorchLevel),
                            fminf(degrees, CaptureDeviceConfigurationPropertyButtonAngle(CaptureDeviceConfigurationControlPropertyZoomFactor)));
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
            [CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertySelected) sendActionsForControlEvents:UIControlEventTouchUpInside];
            CaptureDeviceConfigurationControlProperty next_property = (CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertySelected).tag + 1) % 4;
            if ([CaptureDeviceConfigurationPropertyButton(next_property) isHidden]) {
                (control_renderer = tick_wheel_renderer_init(&touch_point_angle, &radius, &touch_point_property))();
            } else {
                (control_renderer = button_arc_renderer_init(&touch_point_angle, &radius, &touch_point_property))();
                [CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertySelected) setSelected:FALSE];
            }
        }
    };
};

- (void)drawRect:(CGRect)rect
{
    UIBezierPath * path[2] = {[UIBezierPath bezierPath], [UIBezierPath bezierPath]};
    int degrees[2] = {180, (int)round(touch_point_angle)};
    int end[2] = {(int)round(touch_point_angle), 270};
    UIColor * color[2] = {[UIColor redColor], [UIColor blueColor]};
    for (int i = 0; i < 2; i++) {
        for (; degrees[i] < end[i]; degrees[i]++) {
            [path[i] moveToPoint:[[UIBezierPath bezierPathWithArcCenter:center
                                                                 radius:radius
                                                             startAngle:degreesToRadians(degrees[i])
                                                               endAngle:degreesToRadians(degrees[i])
                                                              clockwise:FALSE] currentPoint]];
            [path[i] addLineToPoint:[[UIBezierPath bezierPathWithArcCenter:center
                                                                    radius:radius * 0.975
                                                                startAngle:degreesToRadians(degrees[i])
                                                                  endAngle:degreesToRadians(degrees[i])
                                                                 clockwise:FALSE] currentPoint]];
            [path[i] closePath];
        }
        [color[i] setStroke];
        [path[i] stroke];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    handle_touch_event(touches.anyObject);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    handle_touch_event(touches.anyObject);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    handle_touch_event(touches.anyObject);
}

static const void (^handle_touch_event)(UITouch * _Nullable);

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        {
            [self setTranslatesAutoresizingMaskIntoConstraints:FALSE];
            [self setBackgroundColor:[UIColor clearColor]];
            [self setOpaque:FALSE];
        };
        
        {
            [self setUserInteractionEnabled:FALSE];
            CaptureDeviceConfigurationPropertyButton = CaptureDeviceConfigurationPropertyButtons();
            center = CGPointMake(CGRectGetMaxX(self.bounds) - CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertyTorchLevel).center.x, CGRectGetMaxY(self.bounds) - CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertyZoomFactor).center.y);
            radius = CGRectGetMidX(self.bounds) - CGRectGetMaxX(CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertyTorchLevel).bounds);
            [UIView animateWithDuration:2.0 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                for (CaptureDeviceConfigurationControlProperty property = CaptureDeviceConfigurationControlPropertyTorchLevel; property < CaptureDeviceConfigurationControlPropertySelected; property++) {
                    [self addSubview:CaptureDeviceConfigurationPropertyButton(property)];
                    [CaptureDeviceConfigurationPropertyButton(property) setCenter:[[UIBezierPath bezierPathWithArcCenter:center
                                                                                                                  radius:radius
                                                                                                              startAngle:degreesToRadians(CaptureDeviceConfigurationPropertyButtonAngle(property))
                                                                                                                endAngle:degreesToRadians(CaptureDeviceConfigurationPropertyButtonAngle(property))
                                                                                                               clockwise:FALSE] currentPoint]];
                }
            } completion:^(BOOL finished) {
                [self setNeedsDisplay];
                handle_touch_event = handle_touch_event_init(self);
                [self setUserInteractionEnabled:TRUE];
            }];
        };
        
        
        
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
