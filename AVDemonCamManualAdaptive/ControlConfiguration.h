//
//  ControlConfiguration.h
//  AVDemonCamManualAdaptive
//
//  Created by Xcode Developer on 12/21/21.
//

#import <objc/runtime.h>

#ifndef ControlConfiguration_h
#define ControlConfiguration_h


#define degreesToRadians(angleDegrees) (angleDegrees * M_PI / 180.0)

typedef enum : NSUInteger {
    CaptureDeviceConfigurationControlPropertyTorchLevel,
    CaptureDeviceConfigurationControlPropertyLensPosition,
    CaptureDeviceConfigurationControlPropertyExposureDuration,
    CaptureDeviceConfigurationControlPropertyISO,
    CaptureDeviceConfigurationControlPropertyZoomFactor,
    CaptureDeviceConfigurationControlPropertyDefault
} CaptureDeviceConfigurationControlProperty;

static NSArray<NSArray<NSString *> *> * const CaptureDeviceConfigurationControlPropertyImageValues = @[@[@"bolt.circle",
                                                                                                         @"viewfinder.circle",
                                                                                                         @"timer",
                                                                                                         @"camera.aperture",
                                                                                                         @"magnifyingglass.circle"],@[@"bolt.circle.fill",
                                                                                                                                      @"viewfinder.circle.fill",
                                                                                                                                      @"timer",
                                                                                                                                      @"camera.aperture",
                                                                                                                                      @"magnifyingglass.circle.fill"]];

static NSArray<NSString *> * const CaptureDeviceConfigurationControlPropertyImageKeys = @[@"CaptureDeviceConfigurationControlPropertyTorchLevel",
                                                                                          @"CaptureDeviceConfigurationControlPropertyLensPosition",
                                                                                          @"CaptureDeviceConfigurationControlPropertyExposureDuration",
                                                                                          @"CaptureDeviceConfigurationControlPropertyISO",
                                                                                          @"CaptureDeviceConfigurationControlPropertyZoomFactor"];

typedef enum : NSUInteger {
    CaptureDeviceConfigurationControlStateDeselected,
    CaptureDeviceConfigurationControlStateSelected,
    CaptureDeviceConfigurationControlStateHighlighted // also selected, but centered in the arc area and enlarged to fill
} CaptureDeviceConfigurationControlState;

static NSString * (^CaptureDeviceConfigurationControlPropertySymbol)(CaptureDeviceConfigurationControlProperty, CaptureDeviceConfigurationControlState) = ^ NSString * (CaptureDeviceConfigurationControlProperty property, CaptureDeviceConfigurationControlState state) {
    return CaptureDeviceConfigurationControlPropertyImageValues[state][property];
};

static NSString * (^CaptureDeviceConfigurationControlPropertyString)(CaptureDeviceConfigurationControlProperty) = ^ NSString * (CaptureDeviceConfigurationControlProperty property) {
    return CaptureDeviceConfigurationControlPropertyImageKeys[property];
};

// To-Do: Find a different blue that works on a gray background like blueColor, but closer to the non-primary blue of systemBlueColor
static UIImageSymbolConfiguration * (^CaptureDeviceConfigurationControlPropertySymbolImageConfiguration)(CaptureDeviceConfigurationControlState) = ^ UIImageSymbolConfiguration * (CaptureDeviceConfigurationControlState state) {
    switch (state) {
        case CaptureDeviceConfigurationControlStateDeselected: {
            UIImageSymbolConfiguration * symbol_palette_colors = [UIImageSymbolConfiguration configurationWithHierarchicalColor:[UIColor colorWithRed:4/255 green:51/255 blue:255/255 alpha:1.0]];
            UIImageSymbolConfiguration * symbol_font_weight    = [UIImageSymbolConfiguration configurationWithWeight:UIImageSymbolWeightLight];
            UIImageSymbolConfiguration * symbol_font_size      = [UIImageSymbolConfiguration configurationWithPointSize:42.0 weight:UIImageSymbolWeightUltraLight];
            UIImageSymbolConfiguration * symbol_configuration  = [symbol_font_size configurationByApplyingConfiguration:[symbol_palette_colors configurationByApplyingConfiguration:symbol_font_weight]];
            return symbol_configuration;
        }
            break;
            
        case CaptureDeviceConfigurationControlStateSelected: {
            UIImageSymbolConfiguration * symbol_palette_colors_selected = [UIImageSymbolConfiguration configurationWithHierarchicalColor:[UIColor colorWithRed:255/255 green:252/255 blue:121/255 alpha:1.0]];// configurationWithPaletteColors:@[[UIColor yellowCollor], [UIColor clearColor], [UIColor yellowCollor]]];
            UIImageSymbolConfiguration * symbol_font_weight_selected    = [UIImageSymbolConfiguration configurationWithWeight:UIImageSymbolWeightRegular];
            UIImageSymbolConfiguration * symbol_font_size_selected      = [UIImageSymbolConfiguration configurationWithPointSize:42.0 weight:UIImageSymbolWeightLight];
            UIImageSymbolConfiguration * symbol_configuration_selected  = [symbol_font_size_selected configurationByApplyingConfiguration:[symbol_palette_colors_selected configurationByApplyingConfiguration:symbol_font_weight_selected]];
            
            return symbol_configuration_selected;
        }
            
        case CaptureDeviceConfigurationControlStateHighlighted: {
            UIImageSymbolConfiguration * symbol_palette_colors_highlighted = [UIImageSymbolConfiguration configurationWithHierarchicalColor:[UIColor colorWithRed:255/255 green:252/255 blue:121/255 alpha:1.0]];// configurationWithPaletteColors:@[[UIColor yellowCollor], [UIColor clearColor], [UIColor yellowCollor]]];
            UIImageSymbolConfiguration * symbol_font_weight_highlighted    = [UIImageSymbolConfiguration configurationWithWeight:UIImageSymbolWeightRegular];
            UIImageSymbolConfiguration * symbol_font_size_highlighted      = [UIImageSymbolConfiguration configurationWithPointSize:84.0 weight:UIImageSymbolWeightLight];
            UIImageSymbolConfiguration * symbol_configuration_highlighted  = [symbol_font_size_highlighted configurationByApplyingConfiguration:[symbol_palette_colors_highlighted configurationByApplyingConfiguration:symbol_font_weight_highlighted]];
            
            return symbol_configuration_highlighted;
        }
            break;
        default:
            return nil;
            break;
    }
};

static UIImage * (^CaptureDeviceConfigurationControlPropertySymbolImage)(CaptureDeviceConfigurationControlProperty, CaptureDeviceConfigurationControlState) = ^ UIImage * (CaptureDeviceConfigurationControlProperty property, CaptureDeviceConfigurationControlState state) {
    return [UIImage systemImageNamed:CaptureDeviceConfigurationControlPropertySymbol(property, state) withConfiguration:CaptureDeviceConfigurationControlPropertySymbolImageConfiguration(state)];
};


typedef UIButton * (^(^PrimaryComponents)(NSArray<NSArray<NSString *> *> * const, typeof(UIView *)))(NSUInteger);
static UIButton * (^(^CaptureDeviceConfigurationPropertyButtons)(NSArray<NSArray<NSString *> *> * const, typeof(UIView *)))(CaptureDeviceConfigurationControlProperty) = ^ (NSArray<NSArray<NSString *> *> * const captureDeviceConfigurationControlPropertyImageNames, typeof(UIView *) controlView) {
    CGFloat button_boundary_length = (CGRectGetMaxX(UIScreen.mainScreen.bounds) - CGRectGetMinX(UIScreen.mainScreen.bounds)) / ((CGFloat)captureDeviceConfigurationControlPropertyImageNames[0].count - 1.0);
    __block NSMutableArray<UIButton *> * buttons = [[NSMutableArray alloc] initWithCapacity:captureDeviceConfigurationControlPropertyImageNames[0].count];
    [captureDeviceConfigurationControlPropertyImageNames[0] enumerateObjectsUsingBlock:^(NSString * _Nonnull imageName, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [buttons addObject:^ (CaptureDeviceConfigurationControlProperty property) {
            UIButton * button;
            [button = [UIButton new] setTag:property];
            
            [button setBackgroundColor:[UIColor clearColor]];
//            [button setShowsTouchWhenHighlighted:TRUE];
            
            [button setImage:[UIImage systemImageNamed:captureDeviceConfigurationControlPropertyImageNames[0][property] withConfiguration:CaptureDeviceConfigurationControlPropertySymbolImageConfiguration(CaptureDeviceConfigurationControlStateDeselected)] forState:UIControlStateNormal];
            [button setImage:[UIImage systemImageNamed:captureDeviceConfigurationControlPropertyImageNames[1][idx] withConfiguration:CaptureDeviceConfigurationControlPropertySymbolImageConfiguration(CaptureDeviceConfigurationControlStateSelected)] forState:UIControlStateSelected];
            //            [button setImage:[UIImage systemImageNamed:captureDeviceConfigurationControlPropertyImageNames[1][idx] withConfiguration:CaptureDeviceConfigurationControlPropertySymbolImageConfiguration(CaptureDeviceConfigurationControlStateHighlighted)] forState:UIControlStateHighlighted];
            [button sizeToFit];
            CGSize button_size = [button intrinsicContentSize];
            [button setFrame:CGRectMake(0.0, 0.0,
                                        button_size.width, button_size.height)];
            
            CGPoint center = CGPointMake(CGRectGetMaxX(UIScreen.mainScreen.bounds) - [button intrinsicContentSize].width, CGRectGetMaxY(UIScreen.mainScreen.bounds) - [button intrinsicContentSize].height);
            double angle = 180.0 + (90.0 * ((property) / 4.0));
            UIBezierPath * bezier_quad_curve = [UIBezierPath bezierPathWithArcCenter:center
                                                                              radius:(CGRectGetMaxX(UIScreen.mainScreen.bounds) * 0.75)
                                                                          startAngle:degreesToRadians(angle) endAngle:degreesToRadians(angle) clockwise:FALSE];
            [button setCenter:[bezier_quad_curve currentPoint]];
            
            double below_angle = (property > CaptureDeviceConfigurationControlPropertyTorchLevel) ? 180.0 + (90.0 * ((property - 1) / 4.0)) : angle;
            bezier_quad_curve = [UIBezierPath bezierPathWithArcCenter:center
                                                                              radius:(CGRectGetMaxX(UIScreen.mainScreen.bounds) * 0.75)
                                                                          startAngle:degreesToRadians(below_angle) endAngle:degreesToRadians(below_angle) clockwise:FALSE];
            [button setFrame:CGRectMake([bezier_quad_curve currentPoint].x, CGRectGetMinY(button.frame), fabs(button.center.x - [bezier_quad_curve currentPoint].x), CGRectGetHeight(button.frame))];
            [button.layer setBorderColor:[UIColor redColor].CGColor];
            [button.layer setBorderWidth:1.0];
            void (^eventHandlerBlock)(void) = ^{
//                [button setHighlighted:TRUE];
//                [UIView animateWithDuration:0.3 animations:^ {
//                    [buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull b, NSUInteger idx, BOOL * _Nonnull stop) {
//                        [b setSelected:(b.tag == button.tag) ? TRUE : FALSE];
//                        [b sizeToFit];
//                        CGPoint center = CGPointMake(CGRectGetMaxX(UIScreen.mainScreen.bounds) - [button intrinsicContentSize].width, CGRectGetMaxY(UIScreen.mainScreen.bounds) - [button intrinsicContentSize].height);
//                        double angle =
//                          (button.tag == 0) ? 225.0 + (45.0 * ((b.tag) / 4.0))
//                        : (button.tag == 1) ? 202.5 + (67.5 * ((b.tag) / 4.0))
//                        : (button.tag == 2) ? 180.0 + (90.0 * ((b.tag) / 4.0))
//                        : (button.tag == 3) ? 180.0 + (67.5 * ((b.tag) / 4.0))
//                        : (button.tag == 4) ? 180.0 + (45.0 * ((b.tag) / 4.0))
//                        : 180.0 + (90.0 * ((b.tag) / 4.0));
//
//                        UIBezierPath * bezier_quad_curve = [UIBezierPath bezierPathWithArcCenter:center
//                                                                                          radius:(CGRectGetMaxX(UIScreen.mainScreen.bounds) * 0.75)
//                                                                                      startAngle:degreesToRadians(angle) endAngle:degreesToRadians(angle) clockwise:FALSE];
//                        [b setCenter:[bezier_quad_curve currentPoint]];
//                    }];
//                    // To-Do: Add AVCaptureDevice unlockForConfiguration
//
//                } completion:^(BOOL finished) {
//                    // draw secondary control
////                    UIBezierPath *
//                }];
                
            };
            objc_setAssociatedObject(button, @selector(invoke), eventHandlerBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [button addTarget:eventHandlerBlock action:@selector(invoke) forControlEvents:UIControlEventTouchUpInside];
            
            return ^ UIButton * (void) {
                return button;
            };
        }(idx)()];
    }];
    return ^ UIButton * (CaptureDeviceConfigurationControlProperty property) {
        return [buttons objectAtIndex:property];
    };
};

static UIButton * (^CaptureDeviceConfigurationPropertyButton)(CaptureDeviceConfigurationControlProperty);

#endif /* ControlConfiguration_h */
