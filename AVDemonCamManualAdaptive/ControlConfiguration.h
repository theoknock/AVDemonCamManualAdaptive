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
    CaptureDeviceConfigurationControlPropertySelected,
    CaptureDeviceConfigurationControlPropertyHidden
} CaptureDeviceConfigurationControlProperty;

static NSArray<NSArray<NSString *> *> * const CaptureDeviceConfigurationControlPropertyImageNames = @[@[@"bolt.circle",
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
    CaptureDeviceConfigurationControlStateHighlighted,
    CaptureDeviceConfigurationControlStateAny
} CaptureDeviceConfigurationControlState;

static NSString * (^CaptureDeviceConfigurationControlPropertySymbol)(CaptureDeviceConfigurationControlProperty, CaptureDeviceConfigurationControlState) = ^ NSString * (CaptureDeviceConfigurationControlProperty property, CaptureDeviceConfigurationControlState state) {
    return CaptureDeviceConfigurationControlPropertyImageNames[state][property];
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

static UIButton * (^CaptureDeviceConfigurationPropertyButton)(CaptureDeviceConfigurationControlProperty);
static UIButton * (^CaptureDeviceConfigurationPropertySelectedButton)(void);

static const UIButton * (^(^CaptureDeviceConfigurationPropertyButtons)(void))(CaptureDeviceConfigurationControlProperty) = ^ (void) {
    __block NSMutableArray<UIButton *> * buttons;
    buttons = [[NSMutableArray alloc] initWithCapacity:CaptureDeviceConfigurationControlPropertyImageNames[0].count];
    [CaptureDeviceConfigurationControlPropertyImageNames[0] enumerateObjectsUsingBlock:^(NSString * _Nonnull imageName, CaptureDeviceConfigurationControlProperty property_tag, BOOL * _Nonnull stop) {
        [buttons addObject:^ (CaptureDeviceConfigurationControlProperty property) {
            UIButton * button;
            [button = [UIButton new] setTag:property];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setImage:[UIImage systemImageNamed:CaptureDeviceConfigurationControlPropertyImageNames[0][property] withConfiguration:CaptureDeviceConfigurationControlPropertySymbolImageConfiguration(CaptureDeviceConfigurationControlStateDeselected)] forState:UIControlStateNormal];
            [button setImage:[UIImage systemImageNamed:CaptureDeviceConfigurationControlPropertyImageNames[1][property] withConfiguration:CaptureDeviceConfigurationControlPropertySymbolImageConfiguration(CaptureDeviceConfigurationControlStateSelected)] forState:UIControlStateSelected];
            [button sizeToFit];
            
            [button setUserInteractionEnabled:FALSE];
            void (^eventHandlerBlock)(void) = ^{
                CaptureDeviceConfigurationControlProperty next_property = (button.tag + 1) % 4;
                BOOL hideButton = !([CaptureDeviceConfigurationPropertyButton(next_property) isHidden]);
                [buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull b, NSUInteger idx, BOOL * _Nonnull stop) {
                    [b setHidden:hideButton && (b.tag != button.tag)];
                }];
            };

            objc_setAssociatedObject(button, @selector(invoke), eventHandlerBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [button addTarget:eventHandlerBlock action:@selector(invoke) forControlEvents:UIControlEventTouchUpInside];
            
            return ^ UIButton * (void) {
                return button;
            };
        }(property_tag)()];
    }];
    return ^ UIButton * _Nullable (CaptureDeviceConfigurationControlProperty property) {
        return [buttons objectAtIndex:(property != CaptureDeviceConfigurationControlPropertySelected) ? property : [buttons indexOfObjectPassingTest:^BOOL(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return (obj.isSelected) ? ^BOOL{ *stop = TRUE; return TRUE; }() : ^BOOL{ return FALSE; }();
        }]];
    };
};

#endif /* ControlConfiguration_h */
