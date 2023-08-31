////
////  UIView+ShapeGradient.m
////  FCCategoryOCKit
////
////  Created by yjy on 2021/2/23.
////
//
//#import "UIView+ShapeGradient.h"
//#import <objc/runtime.h>
//
//@interface UIView ()
//
//@property(nonatomic, strong)CAShapeLayer *shapeLayer;
//
//@end
//
//@implementation UIView (ShapeGradient)
//
//+ (void)load{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Class class = [self class];
//        
//        SEL originalSelector = @selector(layerClass);
//        SEL swizzledSelector = @selector(fc_layerClass);
//
//        Method originalMethod = class_getClassMethod(class, originalSelector);
//        Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
//        method_exchangeImplementations(originalMethod, swizzledMethod);
//        
////        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
////        if (success) {
////            IMP imp = class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
////            NSLog(@"%@",imp);
////        } else {
////            method_exchangeImplementations(originalMethod, swizzledMethod);
////        }
//        
//        //
//        SEL originalLayoutSubviewsSelector = @selector(layoutSubviews);
//        SEL swizzledLayoutSubviewsSelector = @selector(fc_layoutSubviews);
//        Method originalLayoutSubviewsMethod = class_getInstanceMethod(class, originalLayoutSubviewsSelector);
//        Method swizzledLayoutSubviewsMethod = class_getInstanceMethod(class, swizzledLayoutSubviewsSelector);
//        BOOL layoutSubviewsSuccess = class_addMethod(class, originalLayoutSubviewsSelector, method_getImplementation(swizzledLayoutSubviewsMethod), method_getTypeEncoding(swizzledLayoutSubviewsMethod));
//        if (layoutSubviewsSuccess) {
//            class_replaceMethod(class, swizzledLayoutSubviewsSelector, method_getImplementation(originalLayoutSubviewsMethod), method_getTypeEncoding(originalLayoutSubviewsMethod));
//        } else {
//            method_exchangeImplementations(originalLayoutSubviewsMethod, swizzledLayoutSubviewsMethod);
//        }
//        
//    });
//}
//
//+ (Class)fc_layerClass{
//    [self fc_layerClass];
//    return CAGradientLayer.class;
//}
//- (void)setFc_gradientModel:(FCGradientModel *)fc_gradientModel{
//    objc_setAssociatedObject(self, _cmd, fc_gradientModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    //
//    if (![self.layer isKindOfClass:CAGradientLayer.class]) return;
//    //
//    CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
//    gradientLayer.startPoint = fc_gradientModel.startPoint;
//    gradientLayer.endPoint = fc_gradientModel.endPoint;
//    NSMutableArray *colors = NSMutableArray.array;
//    for (FCGradientContentModel *contentM in fc_gradientModel.gradientContents) {
//        [colors addObject:(__bridge id)contentM.color.CGColor];
//    }
//    NSMutableArray *locations = [NSMutableArray arrayWithArray:[fc_gradientModel.gradientContents valueForKey:@"location"]];
//    if (colors.count == 1) {
//        [colors addObjectsFromArray:colors];
//        [locations addObject:@1];
//    }
//    gradientLayer.colors = colors;
//    gradientLayer.locations = locations;
//}
//- (FCGradientModel *)fc_gradientModel{
//    return objc_getAssociatedObject(self, _cmd);
//}
//
//- (void)setFc_cornerRadii:(CGSize)fc_cornerRadii{
//    objc_setAssociatedObject(self, "fc_cornerRadii", [NSValue valueWithCGSize:fc_cornerRadii], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    //
//    [self fc_layoutSubviews];
//}
//- (CGSize)fc_cornerRadii{
//    return [objc_getAssociatedObject(self, "fc_cornerRadii") CGSizeValue];
//}
//
//- (void)setFc_rectCorner:(UIRectCorner)fc_rectCorner{
//    objc_setAssociatedObject(self, "fc_rectCorner", @(fc_rectCorner), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    //
//    [self fc_layoutSubviews];
//}
//- (UIRectCorner)fc_rectCorner{
//    return [objc_getAssociatedObject(self, "fc_rectCorner") integerValue];
//}
//
//- (void)fc_layoutSubviews{
//    [self fc_layoutSubviews];
//    self.layer.mask = self.shapeLayer;
//    CGRect rect = self.bounds;
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:self.fc_rectCorner cornerRadii:self.fc_cornerRadii];
//    self.shapeLayer.frame = rect;
//    self.shapeLayer.path = path.CGPath;
//}
//
////MARK: getter 方法
//- (CAShapeLayer *)shapeLayer{
//    CAShapeLayer *shapeLayer = objc_getAssociatedObject(self, _cmd);
//    if (!shapeLayer) {
//        shapeLayer = CAShapeLayer.layer;
//        shapeLayer.contentsScale = UIScreen.mainScreen.scale;
//        shapeLayer.fillColor = UIColor.whiteColor.CGColor;
//        shapeLayer.masksToBounds = YES;
//        objc_setAssociatedObject(self, _cmd, shapeLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
//    return shapeLayer;
//}
//
//@end
