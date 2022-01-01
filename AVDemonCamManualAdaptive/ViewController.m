//
//  ViewController.m
//  AVDemonCamManualAdaptive
//
//  Created by Xcode Developer on 12/18/21.
//

#import "ViewController.h"
#import "ControlConfiguration.h"

#import <objc/runtime.h>


#define k_whole_round_time (2.0)

extern AVCaptureDevice * _Nonnull capture_device;
extern ControlView * _Nonnull control_view;

@interface ControlView ()

@end


@implementation ControlView

static double rescale(double old_value, double old_min, double old_max, double new_min, double new_max) {
    return (new_max - new_min) * /*(fmax(old_min, fmin(old_value, old_max))*/ (old_value - old_min) / (old_max - old_min) + new_min;
};

void validateRadius(int a, int b)
{
    // test (test a and b) and c
    int c = a - b;
    int k = (c >> 31) & 0x1;
    int max = a - k * c;
    int min = b + k * c;
    printf("max = %d\nmin = %d",max,min);
}

static double (^CaptureDeviceConfigurationPropertyButtonAngle)(CaptureDeviceConfigurationControlProperty) = ^ double (CaptureDeviceConfigurationControlProperty property) {
    static double button_angle;
    button_angle = (double)(180.0 + (90.0 * ((double)property / 4.0)));
    
    return button_angle;
};
//static double (^CaptureDeviceConfigurationPropertyValueAngle)(double[3]) = ^ double (double capture_device_configuration_property_value_angle_arguments[3]) {
//    double rescaled_angle = rescale(capture_device_configuration_property_value_angle_arguments[0], capture_device_configuration_property_value_angle_arguments[1], capture_device_configuration_property_value_angle_arguments[2], CaptureDeviceConfigurationPropertyButtonAngle(CaptureDeviceConfigurationControlPropertyTorchLevel), CaptureDeviceConfigurationPropertyButtonAngle(CaptureDeviceConfigurationControlPropertyZoomFactor));
//    rescaled_angle = fmax(CaptureDeviceConfigurationPropertyButtonAngle(CaptureDeviceConfigurationControlPropertyTorchLevel), fmin(rescaled_angle, CaptureDeviceConfigurationPropertyButtonAngle(CaptureDeviceConfigurationControlPropertyZoomFactor)));
//    
//    return rescaled_angle;
//};

static void (^(^(^button_component_renderer)(ControlRendererState))(void))(void);
static void (^(^render_button_component_init)(void))(void);
static void (^render_button_component)(void);
static void (^(^(^(^button_component_renderer_init)(void))(ControlRendererState))(void))(void) = ^{
    id objects[] = {
        ^{
            return ^ {
                for (CaptureDeviceConfigurationControlProperty property = CaptureDeviceConfigurationControlPropertyTorchLevel; property < CaptureDeviceConfigurationControlPropertySelected; property++) {
                    [CaptureDeviceConfigurationPropertyButton(property) setHidden:!([CaptureDeviceConfigurationPropertyButton(property) isHidden])];
                    [CaptureDeviceConfigurationPropertyButton(property) setSelected:FALSE];
                }
            };
        },
        ^{
            return ^ {
                for (CaptureDeviceConfigurationControlProperty property = CaptureDeviceConfigurationControlPropertyTorchLevel; property < CaptureDeviceConfigurationControlPropertySelected; property++) {
                    static CGFloat angle;
                    angle = CaptureDeviceConfigurationPropertyButtonAngle(property);
                    [CaptureDeviceConfigurationPropertyButton(property) setCenter:[[UIBezierPath bezierPathWithArcCenter:center_point radius:radius startAngle:degreesToRadians(angle) endAngle:degreesToRadians(angle) clockwise:FALSE]
                                                                                   currentPoint]];
                    [CaptureDeviceConfigurationPropertyButton(property) setSelected:(property == touch_property)];
                    [CaptureDeviceConfigurationPropertyButton(property) setHidden:FALSE];
                }
            };
        },
        ^{
            return ^ {
                for (CaptureDeviceConfigurationControlProperty property = CaptureDeviceConfigurationControlPropertyTorchLevel; property < CaptureDeviceConfigurationControlPropertySelected; property++) {
                    [CaptureDeviceConfigurationPropertyButton(property) setHidden:!([CaptureDeviceConfigurationPropertyButton(property) isSelected])];
                }
            };
        },
        ^{
            CaptureDeviceConfigurationControlProperty touch_property_fixed = touch_property;
            CGFloat radius_fixed = radius;
            return ^{
                printf("radius_fixed\t== %f\nradius\t\t== %f\ntouch_property_fixed == %lu\n", radius_fixed, radius, touch_property_fixed);
                
                [CaptureDeviceConfigurationPropertyButton(touch_property_fixed) setCenter:[[UIBezierPath bezierPathWithArcCenter:center_point radius:radius_fixed startAngle:degreesToRadians(touch_angle) endAngle:degreesToRadians(touch_angle) clockwise:FALSE]
                                                                                           currentPoint]];
            };
        }
    };
    
    NSUInteger count = sizeof(objects) / sizeof(id);
    __block NSArray<void(^(^)(void))(void)> * button_component_renderers = [NSArray arrayWithObjects:objects count:count];
    
    return ^ (ControlRendererState button_component_renderer_state) {
        return [button_component_renderers objectAtIndex:(button_component_renderer_state % 4)];
    };
};




- (void)drawRect:(CGRect)rect {
    UIBezierPath * path[2] = {[UIBezierPath bezierPath], [UIBezierPath bezierPath]};
    int degrees[2] = {180, (int)round(touch_angle)};
    int end[2] = {(int)round(touch_angle), 270};
    UIColor * color[2] = {[UIColor colorWithRed:255/255 green:252/255 blue:121/255 alpha:1.0], [UIColor colorWithRed:4/255 green:51/255 blue:255/255 alpha:1.0]};
    for (int i = 0; i < 2; i++) {
        for (; degrees[i] < end[i]; degrees[i]++) {
            [path[i] moveToPoint:[[UIBezierPath bezierPathWithArcCenter:center_point
                                                                 radius:radius
                                                             startAngle:degreesToRadians(degrees[i])
                                                               endAngle:degreesToRadians(degrees[i])
                                                              clockwise:FALSE] currentPoint]];
            [path[i] addLineToPoint:[[UIBezierPath bezierPathWithArcCenter:center_point
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

static void (^(^(^touch_handler_init)(void))(UITouch * _Nonnull))(void) = ^{
    CaptureDeviceConfigurationPropertyButton = CaptureDeviceConfigurationPropertyButtons();
    center_point = CGPointMake(CGRectGetMaxX(UIScreen.mainScreen.bounds) - CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertyTorchLevel).center.x,
                               (CGRectGetMaxY(UIScreen.mainScreen.bounds) - CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertyZoomFactor).center.y) / 2.0);
    radius_min = center_point.x - CGRectGetMidX(CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertyTorchLevel).bounds);
    radius_max = CGRectGetMidX(UIScreen.mainScreen.bounds) - CGRectGetMaxX(CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertyTorchLevel).bounds);
    radius = radius_max;
    button_component_renderer_state = ControlRendererStateProperty;
    render_button_component = (render_button_component_init = (button_component_renderer = button_component_renderer_init())(button_component_renderer_state))();
    return ^ (UITouch * _Nonnull touch) {
        return ^{
            touch_point = [touch preciseLocationInView:(touch).view];
            
            touch_angle = (atan2((touch_point).y - (center_point).y,
                                 (touch_point).x - (center_point).x)) * (180.0 / M_PI);
            if (touch_angle < 0.0) touch_angle += 360.0;
            touch_angle = fmaxf(CaptureDeviceConfigurationPropertyButtonAngle(CaptureDeviceConfigurationControlPropertyTorchLevel), fminf(touch_angle, CaptureDeviceConfigurationPropertyButtonAngle(CaptureDeviceConfigurationControlPropertyZoomFactor)));
            
            touch_property = (CaptureDeviceConfigurationControlProperty)round(rescale(touch_angle, CaptureDeviceConfigurationPropertyButtonAngle(CaptureDeviceConfigurationControlPropertyTorchLevel), CaptureDeviceConfigurationPropertyButtonAngle(CaptureDeviceConfigurationControlPropertyZoomFactor), CaptureDeviceConfigurationControlPropertyTorchLevel, CaptureDeviceConfigurationControlPropertyZoomFactor));
            
            radius = (radius != 0.0) ? fmaxf(fminf(center_point.x - CGRectGetMidX(CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertyTorchLevel).bounds), (sqrt(pow((touch_point).x - (center_point).x, 2.0) + pow((touch_point).y - (center_point).y, 2.0)))), CGRectGetMidX(UIScreen.mainScreen.bounds) - CGRectGetMaxX(CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertyTorchLevel).bounds))
            : CGRectGetMidX(UIScreen.mainScreen.bounds) - CGRectGetMaxX(CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertyTorchLevel).bounds);
            
            //            radius = fmaxf(fminf(radius_min, (sqrt(pow((touch_point).x - (center_point).x, 2.0) + pow((touch_point).y - (center_point).y, 2.0)))), radius_max)
            [control_view setNeedsDisplay];
            render_button_component();
            
        };
    };
};

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //    (handle_touch = (touch_handler = touch_handler_init())(touches.anyObject));
    (handle_touch = touch_handler(touches.anyObject))();
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    handle_touch();
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    handle_touch();
    render_button_component = (render_button_component_init = button_component_renderer(++button_component_renderer_state))();
    handle_touch();
    render_button_component = (render_button_component_init = button_component_renderer(++button_component_renderer_state))();
    handle_touch();
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
        
        {
            [self setUserInteractionEnabled:FALSE];
            {
                touch_handler = touch_handler_init();
                [UIView animateWithDuration:2.0 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    for (CaptureDeviceConfigurationControlProperty property = CaptureDeviceConfigurationControlPropertyTorchLevel; property < CaptureDeviceConfigurationControlPropertySelected; property++) {
                        [self addSubview:CaptureDeviceConfigurationPropertyButton(property)];
                        [CaptureDeviceConfigurationPropertyButton(property) setCenter:[[UIBezierPath bezierPathWithArcCenter:center_point
                                                                                                                      radius:radius
                                                                                                                  startAngle:degreesToRadians(CaptureDeviceConfigurationPropertyButtonAngle(property))
                                                                                                                    endAngle:degreesToRadians(CaptureDeviceConfigurationPropertyButtonAngle(property))
                                                                                                                   clockwise:FALSE] currentPoint]];
                    }
                } completion:^(BOOL finished) {
                    [control_view setNeedsDisplay];
                }];
            }
            [self setUserInteractionEnabled:TRUE];
        };
        
        
        
        //            UIBezierPath * button_animation_path = [UIBezierPath bezierPath];
        //            [button_animation_path addArcWithCenter:center
        //                                             radius:radius
        //                                         startAngle:degreesToRadians(0.0)
        //                                           endAngle:degreesToRadians(360.0)
        //                                          clockwise:FALSE];
        //            [(CAShapeLayer *)self.layer setStrokeColor:[[UIColor whiteColor] CGColor]];
        //            [(CAShapeLayer *)self.layer setFillColor:[[UIColor clearColor] CGColor]];
        //            [(CAShapeLayer *)self.layer setLineWidth:1.0];
        //            [(CAShapeLayer *)self.layer setLineCap:kCALineCapRound];
        //            [(CAShapeLayer *)self.layer setBorderColor:[UIColor redColor].CGColor];
        //            [(CAShapeLayer *)self.layer setBorderWidth:0.5];
        //            [(CAShapeLayer *)self.layer setPath:button_animation_path.CGPath];
        //
        //            CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
        //            animation2.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
        //            animation2.beginTime = k_whole_round_time * 0.25;
        //            animation2.duration = k_whole_round_time;
        //            animation2.values = @[@0,@0.999];
        //            animation2.fillMode = kCAFillModeForwards;
        //            animation2.removedOnCompletion = NO;
        //
        //            CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
        //            group.duration = animation2.duration;
        //            group.removedOnCompletion = NO;
        //            group.fillMode = kCAFillModeForwards;
        //            group.repeatCount = MAXFLOAT;
        //            group.animations = @[animation2];
        //
        ////            [(CAShapeLayer *)self.layer addAnimation:group forKey:@"groupAnimation"];
        //
        //            CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        //                rotateAnimation.toValue = @(M_PI * 2);
        //                rotateAnimation.duration = k_whole_round_time;
        //                rotateAnimation.repeatCount = MAXFLOAT;
        //
        //            [(CAShapeLayer *)self.layer setAnchorPoint:CGPointMake(1.0, 1.0)];
        ////            [(CAShapeLayer *)self.layer setPosition:center];
        ////                [(CAShapeLayer *)self.layer addAnimation:rotateAnimation forKey:@"rotate"];
        //
        //
        
        
        
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

//@property (nonatomic, strong) CameraView * view;

@end

@implementation ViewController

//extern AVCaptureDevice * _Nonnull const * _Nonnull capture_device;
//extern __kindof UIView * _Nonnull control_view;

@dynamic view;

- (void)loadView {
    self.view = (CameraView *)[[CameraView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [(CameraView *)self.view setContentMode:UIViewContentModeScaleAspectFit];
    
    CGRect control_view_rect = CGRectMake(CGRectGetMinX(UIScreen.mainScreen.bounds),
                                          CGRectGetMidY(UIScreen.mainScreen.bounds),
                                          CGRectGetWidth(UIScreen.mainScreen.bounds),
                                          CGRectGetWidth(UIScreen.mainScreen.bounds));
    control_view = [[ControlView alloc] initWithFrame:control_view_rect];
    
    [(CameraView *)self.view addSubview:control_view];
    
    //    CaptureDeviceConfigurationPropertyButton = CaptureDeviceConfigurationPropertyButtons();
    //    center_point = CGPointMake(CGRectGetMaxX(UIScreen.mainScreen.bounds) - CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertyTorchLevel).center.x, CGRectGetMaxY(UIScreen.mainScreen.bounds) - CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertyZoomFactor).center.y);
    //    radius = CGRectGetMidX(UIScreen.mainScreen.bounds) - CGRectGetMaxX(CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertyTorchLevel).bounds);
    //    button_component_renderer = button_component_renderers();
    //    render_button_component = button_component_renderer();
    //    [UIView animateWithDuration:2.0 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
    //        for (CaptureDeviceConfigurationControlProperty property = CaptureDeviceConfigurationControlPropertyTorchLevel; property < CaptureDeviceConfigurationControlPropertySelected; property++) {
    //            [control_view addSubview:CaptureDeviceConfigurationPropertyButton(property)];
    //            [CaptureDeviceConfigurationPropertyButton(property) setCenter:[[UIBezierPath bezierPathWithArcCenter:center_point
    //                                                                                                          radius:radius
    //                                                                                                      startAngle:degreesToRadians(CaptureDeviceConfigurationPropertyButtonAngle(property))
    //                                                                                                        endAngle:degreesToRadians(CaptureDeviceConfigurationPropertyButtonAngle(property))
    //                                                                                                       clockwise:FALSE] currentPoint]];
    //        }
    //    } completion:^(BOOL finished) {
    //        [control_view setNeedsDisplay];
    //    }];
    //    touch_handler = touch_handler_init();
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [captureSession = [[AVCaptureSession alloc] init] setSessionPreset:([captureSession canSetSessionPreset:AVCaptureSessionPreset3840x2160]) ? AVCaptureSessionPreset3840x2160 : AVCaptureSessionPreset1920x1080];
    [captureSession beginConfiguration];
    {
        [captureInput  = [AVCaptureDeviceInput deviceInputWithDevice:[capture_device = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInDualCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack] self] error:nil] setUnifiedAutoExposureDefaultsEnabled:TRUE];
        [captureSession addInput:([captureSession canAddInput:captureInput]) ? captureInput : nil];
        
        videoDimensions = CMVideoFormatDescriptionGetPresentationDimensions(capture_device.activeFormat.formatDescription, TRUE, FALSE);
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
