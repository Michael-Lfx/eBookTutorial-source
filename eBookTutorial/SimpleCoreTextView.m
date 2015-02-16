//
//  SimpleCoreTextView.m
//  eBookTutorial
//
//  Created by Michael on 2/16/15.
//  Copyright (c) 2015 Michael-LFX. All rights reserved.
//

#import "SimpleCoreTextView.h"
#import <CoreText/CoreText.h>

@implementation SimpleCoreTextView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // 1 带属性的字符串，由此开始Core Text后续操作
    NSAttributedString *contentString = [[NSAttributedString alloc] initWithString:@"你好，Core Text！"];
    // 2 由1创建CTFramesetter，在Core Text中用CTFramesetterRef类型表示
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge void*)contentString);
    // 3 创建用于Core Text绘制的图形上下文可变路径并添加整个屏幕范围作为其绘制区域，由CGMutablePathRef类型表示
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    // 4 获取图形上下文，由CGContextRef类型表示
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 5 添加路径到图形上下文中
    CGContextAddPath(ctx, path);
    // 6 由CTFramesetter创建CTFrame，由CTFrameRef类型表示
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, contentString.length), path, NULL);
    // 7 设置每个字形（Glyph）不参与当前变换矩阵（Current Transformation Matrix）
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    // 8 将Core Text绘图原点从左下角上升至左上角，与UIView一致，即是把y轴平移一个屏幕高度，因为当前绘制的区域为整个屏幕
    CGContextTranslateCTM(ctx, 0, self.bounds.size.height + 40);
    // 9 倒转y轴方向，1.0表示不变，-1.0表示反方向
    CGContextScaleCTM(ctx, 1.0, -1.0);
    // 10 绘制内容
    CTFrameDraw(frame, ctx);
    // 11 释放资源
    CFRelease(framesetter);
    CFRelease(frame);
    CFRelease(path);
}

@end
