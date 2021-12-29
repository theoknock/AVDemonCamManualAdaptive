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

static double rescale(double old_value, double old_min, double old_max, double new_min, double new_max) {
    return (new_max - new_min) * /*(fmax(old_min, fmin(old_value, old_max))*/ (old_value - old_min) / (old_max - old_min) + new_min;
};

static CGPoint center;
static double radius;
static double touch_point_angle;
static double property_value_angle;

static CaptureDeviceConfigurationControlProperty touch_point_property;
static double (^CaptureDeviceConfigurationPropertyButtonAngle)(CaptureDeviceConfigurationControlProperty) = ^ double (CaptureDeviceConfigurationControlProperty property) {
    static double button_angle;
    button_angle = (double)(180.0 + (90.0 * ((double)property / 4.0)));
    return button_angle;
};
static double (^CaptureDeviceConfigurationPropertyValueAngle)(double[3]) = ^ double (double capture_device_configuration_property_value_angle_arguments[3]) {
    double rescaled_angle = rescale(capture_device_configuration_property_value_angle_arguments[0], capture_device_configuration_property_value_angle_arguments[1], capture_device_configuration_property_value_angle_arguments[2], CaptureDeviceConfigurationPropertyButtonAngle(CaptureDeviceConfigurationControlPropertyTorchLevel), CaptureDeviceConfigurationPropertyButtonAngle(CaptureDeviceConfigurationControlPropertyZoomFactor));
    rescaled_angle = fmax(CaptureDeviceConfigurationPropertyButtonAngle(CaptureDeviceConfigurationControlPropertyTorchLevel), fmin(rescaled_angle, CaptureDeviceConfigurationPropertyButtonAngle(CaptureDeviceConfigurationControlPropertyZoomFactor)));
    
    return rescaled_angle;
};
static void (^(^control_renderer[2])(void))(AVCaptureDevice *, dispatch_block_t) = {^{
    return ^ (double * touch_point_angle, double * radius, CaptureDeviceConfigurationControlProperty * tpp) {
        return ^ (AVCaptureDevice * capture_device, dispatch_block_t draw_view) {
            for (CaptureDeviceConfigurationControlProperty property = CaptureDeviceConfigurationControlPropertyTorchLevel; property < CaptureDeviceConfigurationControlPropertySelected; property++) {
                [CaptureDeviceConfigurationPropertyButton(property) setCenter:[[UIBezierPath bezierPathWithArcCenter:center radius:*radius startAngle:degreesToRadians(CaptureDeviceConfigurationPropertyButtonAngle(property)) endAngle:degreesToRadians(CaptureDeviceConfigurationPropertyButtonAngle(property)) clockwise:FALSE]
                                                                               currentPoint]];
                [CaptureDeviceConfigurationPropertyButton(property) setSelected:(property == touch_point_property)];
            }
            draw_view();
        };
    }(&touch_point_angle, &radius, &touch_point_property);
},
    ^{
        return ^ (double * touch_point_angle, double * radius, CaptureDeviceConfigurationControlProperty * touch_point_property) {
            return ^ (AVCaptureDevice * capture_device, dispatch_block_t draw_view) {
                double property_value_radians = degreesToRadians(CaptureDeviceConfigurationPropertyValueAngle((*touch_point_property == CaptureDeviceConfigurationControlPropertyTorchLevel)
                                                                                                              ? (double[3]){[capture_device torchLevel], 0.0, 1.0}
                                                                                                              : (*touch_point_property == CaptureDeviceConfigurationControlPropertyLensPosition)
                                                                                                              ? (double[3]){[capture_device lensPosition], 0.0, 1.0}
                                                                                                              : (*touch_point_property == CaptureDeviceConfigurationControlPropertyExposureDuration)
                                                                                                              ? (double[3]){CMTimeGetSeconds([capture_device exposureDuration]), CMTimeGetSeconds(capture_device.activeFormat.minExposureDuration), 1.0/3.0}
                                                                                                              : (*touch_point_property == CaptureDeviceConfigurationControlPropertyISO)
                                                                                                              ? (double[3]){capture_device.ISO, capture_device.activeFormat.minISO, capture_device.activeFormat.maxISO}
                                                                                                              : (*touch_point_property == CaptureDeviceConfigurationControlPropertyZoomFactor)
                                                                                                              ? (double[3]){capture_device.videoZoomFactor, capture_device.minAvailableVideoZoomFactor, capture_device.maxAvailableVideoZoomFactor}
                                                                                                              : (double[3]){CaptureDeviceConfigurationPropertyButtonAngle(CaptureDeviceConfigurationControlPropertyTorchLevel), CaptureDeviceConfigurationPropertyButtonAngle(CaptureDeviceConfigurationControlPropertyTorchLevel), CaptureDeviceConfigurationPropertyButtonAngle(CaptureDeviceConfigurationControlPropertyZoomFactor)}));
                [CaptureDeviceConfigurationPropertyButton(*touch_point_property) setCenter:[[UIBezierPath bezierPathWithArcCenter:center radius:*radius startAngle:property_value_radians endAngle:property_value_radians clockwise:FALSE]
                                                                                                                        currentPoint]];
                draw_view();
            };
        }(&touch_point_angle, &radius, &touch_point_property);
    }
};

static void (^render_control)(AVCaptureDevice *, dispatch_block_t);

void (^(^touch_event_handler)(__kindof __weak UIView *, AVCaptureDevice *))(UITouch * _Nullable) = ^ (__kindof __weak UIView * view, AVCaptureDevice * capture_device) {
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
        
        render_control(capture_device, ^{ [view setNeedsDisplay]; });
        
        if (touch_glb.phase == UITouchPhaseEnded) {
            [CaptureDeviceConfigurationPropertyButton(touch_point_property) sendActionsForControlEvents:UIControlEventTouchUpInside];
            CaptureDeviceConfigurationControlProperty next_property = (touch_point_property + 1) % 4;
            if ([CaptureDeviceConfigurationPropertyButton(next_property) isHidden]) {
                (render_control = control_renderer[0]())(capture_device, ^{ [view setNeedsDisplay]; });
            } else {
                render_control = control_renderer[1]();
            }
        }
    };
};

static void (^handle_touch_event)(UITouch * _Nullable);

- (void)drawRect:(CGRect)rect
{
    UIBezierPath * path[2] = {[UIBezierPath bezierPath], [UIBezierPath bezierPath]};
    int degrees[2] = {180, (int)round(touch_point_angle)};
    int end[2] = {(int)round(touch_point_angle), 270};
    UIColor * color[2] = {[UIColor colorWithRed:255/255 green:252/255 blue:121/255 alpha:1.0], [UIColor colorWithRed:4/255 green:51/255 blue:255/255 alpha:1.0]};
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
        
        [self setUserInteractionEnabled:FALSE];
        {
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
            }];
        }
        [self setUserInteractionEnabled:TRUE];
        render_control = control_renderer[0]();
        handle_touch_event = touch_event_handler(self, self.captureDevice);
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
        [captureInput  = [AVCaptureDeviceInput deviceInputWithDevice:[((ControlView *)((CameraView *)self.view).subviews.firstObject).captureDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInDualCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack] self] error:nil] setUnifiedAutoExposureDefaultsEnabled:TRUE];
        [captureSession addInput:([captureSession canAddInput:captureInput]) ? captureInput : nil];
        
        videoDimensions = CMVideoFormatDescriptionGetPresentationDimensions(((ControlView *)((CameraView *)self.view).subviews.firstObject).captureDevice.activeFormat.formatDescription, TRUE, FALSE);
        //        CGFloat video_maxY   = videoDimensions.height;
        //        CGFloat height_scale = (CGRectGetHeight(UIScreen.mainScreen.bounds) / videoDimensions.height); // the screen height is this many times smaller than the video height
        
        [capturePreview = (AVCaptureVideoPreviewLayer *)[(CameraView *)self.view layer] setSessionWithNoConnection:captureSession];
        [capturePreview setSessionWithNoConnection:captureSession];
        
        [captureConnection   = [[AVCaptureConnection alloc] initWithInputPort:captureInput.ports.firstObject videoPreviewLayer:capturePreview] setVideoOrientation:AVCaptureVideoOrientationPortrait];
        [captureSession addConnection:([captureSession canAddConnection:captureConnection]) ? captureConnection : nil];
    }
    [captureSession commitConfiguration];
    [captureSession startRunning];
}

@end
