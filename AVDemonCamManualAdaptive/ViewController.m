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





@interface ControlView ()

@end


@implementation ControlView

static double rescale(double old_value, double old_min, double old_max, double new_min, double new_max) {
    return (new_max - new_min) * /*(fmax(old_min, fmin(old_value, old_max))*/ (old_value - old_min) / (old_max - old_min) + new_min;
};

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

static void (^(^(^touch_handler_init)(void))(UITouch * _Nonnull))(void)  = ^ (void) {
    return ^ (UITouch * _Nonnull touch) {
        touch_ptr_ref = touch;
        return ^{
            static CGPoint touch_point;
            touch_point = [touch preciseLocationInView:(touch).view];
        
            static double radian;
            radian = atan2((touch_point).y - (center_point).y,
                                   (touch_point).x - (center_point).x);
            
            static CGFloat touch_angle;
            touch_angle = radian * (180.0 / M_PI);
            if (touch_angle < 0.0) touch_angle += 360.0;
            touch_angle = fmaxf(CaptureDeviceConfigurationPropertyButtonAngle(CaptureDeviceConfigurationControlPropertyTorchLevel), fminf(touch_angle, CaptureDeviceConfigurationPropertyButtonAngle(CaptureDeviceConfigurationControlPropertyZoomFactor)));
           
            static CaptureDeviceConfigurationControlProperty touch_property;
            touch_property = (CaptureDeviceConfigurationControlProperty)round(rescale(touch_angle, CaptureDeviceConfigurationPropertyButtonAngle(CaptureDeviceConfigurationControlPropertyTorchLevel), CaptureDeviceConfigurationPropertyButtonAngle(CaptureDeviceConfigurationControlPropertyZoomFactor), CaptureDeviceConfigurationControlPropertyTorchLevel, CaptureDeviceConfigurationControlPropertyZoomFactor));
            
            if (touch.phase == UITouchPhaseEnded) {
                state++;
                state = state % 4;
                NSLog(@"state = %lu", state);
            };
            
            
            CGFloat x_radius     = (touch_point).x - (center_point).x;
            CGFloat y_radius     = (touch_point).y - (center_point).y;
            CGFloat r            = sqrt(pow(x_radius, 2.0) + pow(y_radius, 2.0));
            static CGFloat radius;
            radius = fmaxf(fminf((center_point).x - CGRectGetMidX(CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertyTorchLevel).bounds), r), CGRectGetMidX(control_view.bounds) - CGRectGetMaxX(CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertyTorchLevel).bounds));
            
            for (CaptureDeviceConfigurationControlProperty property = CaptureDeviceConfigurationControlPropertyTorchLevel; property < CaptureDeviceConfigurationControlPropertySelected; property++) {
                static CGFloat angle;
                angle = (double)(180.0 + (90.0 * ((double)property / 4.0)));
                [CaptureDeviceConfigurationPropertyButton(property) setCenter:[[UIBezierPath bezierPathWithArcCenter:center_point radius:radius startAngle:degreesToRadians(angle) endAngle:degreesToRadians(angle) clockwise:FALSE]
                                                                               currentPoint]];
                [CaptureDeviceConfigurationPropertyButton(property) setSelected:(property == touch_property)];
            }
        };
    };
};




//    static const int (^bitwiseSubtract)(int, int) = ^ int (int x, int y) {
//        while (y != 0)
//        {
//            int borrow = (~x) & y;
//            x = x ^ y;
//            y = borrow << 1;
//    }
//
//    return x;
//};
//
//
//
//
//// instead of blocks that return double, rewrite to take a pointer to a double that is updated
//// A given double is updated by only one block, even if its value is used by other blocks
//// A block reference that executes that one block can be used by other blocks to update its value
//// No pointer to a double sits any higher in the block chain than the first block to use it
//
//
//
//
//
//static CaptureDeviceConfigurationControlProperty (^touch_point_property)(void) = ^ CaptureDeviceConfigurationControlProperty (void) {
//    CaptureDeviceConfigurationControlProperty property = (CaptureDeviceConfigurationControlProperty)round(rescale(touch_point_angle(), CaptureDeviceConfigurationPropertyButtonAngle(CaptureDeviceConfigurationControlPropertyTorchLevel), CaptureDeviceConfigurationPropertyButtonAngle(CaptureDeviceConfigurationControlPropertyZoomFactor), CaptureDeviceConfigurationControlPropertyTorchLevel, CaptureDeviceConfigurationControlPropertyZoomFactor));
//
//    return property;
//};
//
//static void (^(^ControlRenderer[2])(__kindof __weak UIView *))(AVCaptureDevice *, dispatch_block_t) = { ^ (__kindof __weak UIView * view) {
//        return ^ (AVCaptureDevice * capture_device, dispatch_block_t draw_view) {
//            for (CaptureDeviceConfigurationControlProperty property = CaptureDeviceConfigurationControlPropertyTorchLevel; property < CaptureDeviceConfigurationControlPropertySelected; property++) {
//                [CaptureDeviceConfigurationPropertyButton(property) setCenter:[[UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:degreesToRadians(CaptureDeviceConfigurationPropertyButtonAngle(property)) endAngle:degreesToRadians(CaptureDeviceConfigurationPropertyButtonAngle(property)) clockwise:FALSE]
//                                                                               currentPoint]];
//                [CaptureDeviceConfigurationPropertyButton(property) setSelected:(property == (CaptureDeviceConfigurationControlProperty)[CaptureDeviceConfigurationPropertyButton(touch_point_property()) tag])];
//            }
//            draw_view();
//        };
//},
//    ^ (__kindof __weak UIView * view) {
//        return ^ (AVCaptureDevice * capture_device, dispatch_block_t draw_view) {
////                CaptureDeviceConfigurationControlProperty selected_property = (CaptureDeviceConfigurationControlProperty)[CaptureDeviceConfigurationPropertyButton(touch_point_property()) tag];
//                double property_value_radians = degreesToRadians(touch_point_angle()); /*CaptureDeviceConfigurationPropertyValueAngle((selected_property == CaptureDeviceConfigurationControlPropertyTorchLevel)
//                                                                                                              ? (double[3]){[capture_device torchLevel], 0.0, 1.0}
//                                                                                                              : (selected_property == CaptureDeviceConfigurationControlPropertyLensPosition)
//                                                                                                              ? (double[3]){[capture_device lensPosition], 0.0, 1.0}
//                                                                                                              : (selected_property == CaptureDeviceConfigurationControlPropertyExposureDuration)
//                                                                                                              ? (double[3]){CMTimeGetSeconds([capture_device exposureDuration]), CMTimeGetSeconds(capture_device.activeFormat.minExposureDuration), 1.0/3.0}
//                                                                                                              : (selected_property == CaptureDeviceConfigurationControlPropertyISO)
//                                                                                                              ? (double[3]){capture_device.ISO, capture_device.activeFormat.minISO, capture_device.activeFormat.maxISO}
//                                                                                                              : (selected_property == CaptureDeviceConfigurationControlPropertyZoomFactor)
//                                                                                                              ? (double[3]){capture_device.videoZoomFactor, capture_device.minAvailableVideoZoomFactor, capture_device.maxAvailableVideoZoomFactor}
//                                                                                                              : (double[3]){CaptureDeviceConfigurationPropertyButtonAngle(CaptureDeviceConfigurationControlPropertyTorchLevel), CaptureDeviceConfigurationPropertyButtonAngle(CaptureDeviceConfigurationControlPropertyTorchLevel), CaptureDeviceConfigurationPropertyButtonAngle(CaptureDeviceConfigurationControlPropertyZoomFactor)}));*/
//
//                [CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertySelected) setCenter:[[UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:property_value_radians endAngle:property_value_radians clockwise:FALSE]
//                                                                                                                        currentPoint]];
//                draw_view();
//            };
//    }
//};
//
//extern void const * (^render_control_ptr)(dispatch_block_t _Nullable);
//static void (^render_control)(dispatch_block_t _Nullable);
//
//void (^(^touch_event_handler)(void))(UITouch * _Nullable) = ^ (void) {
//    return ^ (UITouch * _Nullable touch_ptr_ref) {
//        static CGPoint touch_point;
//        static UITouchPhase touch_phase;
//        (touch_ptr_ref != nil)
//        ? ^{
//            touch_ptr = touch_ptr_ref;
//        }()
//        : ^{
//
//        }();
//        touch_point = [touch_ptr preciseLocationInView:touch_ptr.view];
//        touch_phase = [touch_ptr phase];
//
//        radius = ^ CGFloat (void) {
//            CGFloat x_radius     = touch_point.x - center.x;
//            CGFloat y_radius     = touch_point.y - center.y;
//            CGFloat r            = sqrt(pow(x_radius, 2.0) +
//                                        pow(y_radius, 2.0));
//            return fmaxf(fminf(center.x - CGRectGetMidX(CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertyTorchLevel).bounds), r), CGRectGetMidX(control_view.bounds) - CGRectGetMaxX(CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertyTorchLevel).bounds));
//        }();
//
//        render_control(capture_device, ^{ [control_view setNeedsDisplay]; });
//
//        if (touch_ptr.phase == UITouchPhaseEnded) {
////            [CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertySelected) setCenter:touch_point];
////            [CaptureDeviceConfigurationPropertyButton(touch_point_property()) sendActionsForControlEvents:UIControlEventTouchUpInside];
////            CaptureDeviceConfigurationControlProperty next_property = (touch_point_property() + 1) % 4;
////            if ([CaptureDeviceConfigurationPropertyButton(next_property) isHidden]) {
////                (render_control = ControlRenderer[0](view))(capture_device, ^{ [view setNeedsDisplay]; });
////            } else {
////                render_control = ControlRenderer[1](view);
////            }
//        }
//    };
//};
//static void (^handle_touch_event)(UITouch * _Nullable);
//
//
//// Why do this? In a method in which block is executed, there may be a property that is only available from within that method, but which is used by other blocks in the chain.
//// Take touchesBegan and UITouch, for example, where block is the event handler executed in that method; in that case, block_init could be passed the UITouch object,
////
//static int (^block)(int *); // block
////static int (^(^)(int *))(int *); // global to block
////static int (^(^(^)(int *))(int *))(int *); // global to block
//static int (^(^(^(^block_init)(void))(int *))(int *))(int *) = ^ { // init
//        return (^ (int * _Nonnull const * _Nonnull a) {
//            return (^ (int * b) {
//                return (^ int (int * c) {
//                    return *********a + *b + *c;
//                });
//            });
//        });
//};
//
//static int a_int = 1;
//static int * a_ptr;
//static int b_int = 2;
//static const int * b_ptr = &b_int;
//static int c_int = 3;
//static const int * c_ptr = &c_int;
//
//
//- (void)test {
//    a_ptr = &a_int;
//    block = block_init()(&a_ptr)(b_ptr);
//    NSLog(@"First result  == %d", block(c_ptr));
//    a_int = 2;
//    NSLog(@"Second result == %d", block(c_ptr));
//}

//- (void)drawRect:(CGRect)rect
//{
//    // TO-DO: Create a block initializer that return a block containing the following code, and execute it here
//    //        Integrate it as part of an Rx-style block structure
////    UIBezierPath * path[2] = {[UIBezierPath bezierPath], [UIBezierPath bezierPath]};
////    int degrees[2] = {180, (int)touch_point_angle()};
////    int end[2] = {(int)touch_point_angle(), 270};
////    UIColor * color[2] = {[UIColor colorWithRed:255/255 green:252/255 blue:121/255 alpha:1.0], [UIColor colorWithRed:4/255 green:51/255 blue:255/255 alpha:1.0]};
////    for (int i = 0; i < 2; i++) {
////        for (; degrees[i] < end[i]; degrees[i]++) {
////            [path[i] moveToPoint:[[UIBezierPath bezierPathWithArcCenter:center
////                                                                 radius:radius
////                                                             startAngle:degreesToRadians(degrees[i])
////                                                               endAngle:degreesToRadians(degrees[i])
////                                                              clockwise:FALSE] currentPoint]];
////            [path[i] addLineToPoint:[[UIBezierPath bezierPathWithArcCenter:center
////                                                                    radius:radius * 0.975
////                                                                startAngle:degreesToRadians(degrees[i])
////                                                                  endAngle:degreesToRadians(degrees[i])
////                                                                 clockwise:FALSE] currentPoint]];
////            [path[i] closePath];
////        }
////        [color[i] setStroke];
////        [path[i] stroke];
////    }
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //    (handle_touch = (touch_handler = touch_handler_init())(touches.anyObject));
    (handle_touch = touch_handler(touches.anyObject))();
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    handle_touch();
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    handle_touch();
}

+ (Class)layerClass {
    return [CAShapeLayer class];
}

//extern UIButton * (^CaptureDeviceConfigurationPropertyButton)(CaptureDeviceConfigurationControlProperty);
extern void (^(^touch_handler)(UITouch * _Nonnull))(void);
extern CGPoint center_point;
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        {
            [self setTranslatesAutoresizingMaskIntoConstraints:FALSE];
            [self setBackgroundColor:[UIColor clearColor]];
            [self setOpaque:FALSE];
        };
        
        [self setUserInteractionEnabled:FALSE];
        //        {
        CaptureDeviceConfigurationPropertyButton = CaptureDeviceConfigurationPropertyButtons();
        center_point = CGPointMake(CGRectGetMaxX(self.bounds) - CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertyTorchLevel).center.x, CGRectGetMaxY(self.bounds) - CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertyZoomFactor).center.y);
        CGFloat radius = CGRectGetMidX(self.bounds) - CGRectGetMaxX(CaptureDeviceConfigurationPropertyButton(CaptureDeviceConfigurationControlPropertyTorchLevel).bounds);
        
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
            [self setNeedsDisplay];
            
        }];
        
        //        }
        [self setUserInteractionEnabled:TRUE];
        touch_handler = touch_handler_init();
        /*CGRectMake(CGRectGetMinX(UIScreen.mainScreen.bounds),
         CGRectGetMidY(UIScreen.mainScreen.bounds),
         CGRectGetWidth(UIScreen.mainScreen.bounds),
         CGRectGetWidth(UIScreen.mainScreen.bounds)));*/
        //        render_control = ControlRenderer[0](self);
        //        handle_touch_event = touch_event_handler();
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
extern __kindof UIView * _Nonnull control_view;

@dynamic view;

- (void)loadView {
    self.view = (CameraView *)[[CameraView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [(CameraView *)self.view setContentMode:UIViewContentModeScaleAspectFit];
    
    control_view = [[ControlView alloc] initWithFrame:CGRectMake(CGRectGetMinX(UIScreen.mainScreen.bounds),
                                                                 CGRectGetMidY(UIScreen.mainScreen.bounds),
                                                                 CGRectGetWidth(UIScreen.mainScreen.bounds),
                                                                 CGRectGetWidth(UIScreen.mainScreen.bounds))];
    
    [(CameraView *)self.view addSubview:control_view];
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
