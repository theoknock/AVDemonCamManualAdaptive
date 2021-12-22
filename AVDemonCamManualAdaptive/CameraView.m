//
//  CameraView.m
//  AVDemonCamManualAdaptive
//
//  Created by Xcode Developer on 12/19/21.
//

#import "CameraView.h"

@implementation CameraView

+ (Class)layerClass {
    return [AVCaptureVideoPreviewLayer class];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
