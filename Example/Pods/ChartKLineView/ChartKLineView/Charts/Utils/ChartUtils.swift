//
//  Utils.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import CoreGraphics

#if canImport(UIKit)
    import UIKit
#endif

#if canImport(Cocoa)
import Cocoa
#endif

extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        if self > range.upperBound {
            return range.upperBound
        } else if self < range.lowerBound {
            return range.lowerBound
        } else {
            return self
        }
    }
}

extension FloatingPoint
{
    public var DEG2RAD: Self
    {
        return self * .pi / 180
    }

    public var RAD2DEG: Self
    {
        return self * 180 / .pi
    }

    /// - Note: Value must be in degrees
    /// - Returns: An angle between 0.0 < 360.0 (not less than zero, less than 360)
    var normalizedAngle: Self
    {
        let angle = truncatingRemainder(dividingBy: 360)
        return (sign == .minus) ? angle + 360 : angle
    }
}

extension CGSize
{
    func rotatedBy(degrees: CGFloat) -> CGSize
    {
        let radians = degrees.DEG2RAD
        return rotatedBy(radians: radians)
    }

    func rotatedBy(radians: CGFloat) -> CGSize
    {
        return CGSize(
            width: abs(width * cos(radians)) + abs(height * sin(radians)),
            height: abs(width * sin(radians)) + abs(height * cos(radians))
        )
    }
}

extension Double
{
    /// Rounds the number to the nearest multiple of it's order of magnitude, rounding away from zero if halfway.
    public func roundedToNextSignficant() -> Double
    {
        guard
            !isInfinite,
            !isNaN,
            self != 0
            else { return self }

        let d = ceil(log10(self < 0 ? -self : self))
        let pw = 1 - Int(d)
        let magnitude = pow(10.0, Double(pw))
        let shifted = (self * magnitude).rounded()
        return shifted / magnitude
    }

    public var decimalPlaces: Int
    {
        guard
            !isNaN,
            !isInfinite,
            self != 0.0
            else { return 0 }

        let i = self.roundedToNextSignficant()

        guard
            !i.isInfinite,
            !i.isNaN
            else { return 0 }

        return Int(ceil(-log10(i))) + 2
    }
    
    public func clamped(to range: Range) -> Double {
        if self > range.to {
            return range.to
        } else if self < range.from {
            return range.from
        } else {
            return self
        }
    }
    
    static func middleMagnitude(_ x: Double, _ y: Double) -> Double {
        return min(x, y) + (max(x, y) - min(x, y)) / 2
    }
}

extension CGPoint
{
    /// Calculates the position around a center point, depending on the distance from the center, and the angle of the position around the center.
    public func moving(distance: CGFloat, atAngle angle: CGFloat) -> CGPoint
    {
        return CGPoint(x: x + distance * cos(angle.DEG2RAD),
                       y: y + distance * sin(angle.DEG2RAD))
    }
    
    public func distance(with point: CGPoint) -> CGFloat {
        return  sqrt(pow(self.x - point.x, 2) + pow(self.y - point.y, 2))
    }
    
    public func getExtendPointBy(_ anotherPoint: CGPoint, xRange: Range, yRange: Range) -> CGPoint {
        ///判断特殊情况，如果是垂直的线，x相同
        if self.x == anotherPoint.x {
            ///向上延伸
            if self.y > anotherPoint.y {
                return CGPoint(x: self.x, y: CGFloat(yRange.from))
            }
            ///向下延伸
            return CGPoint(x: self.x, y: CGFloat(yRange.to))
        }
        ///利用y = kx +b进行解方程
        let k = (self.y - anotherPoint.y) / (self.x - anotherPoint.x)
        let b = self.y - k * self.x
        ///范围在 -π/2 - π/2
        let arctanK = Double(atanhf(Float(k))) * Double.pi
  
        if (arctanK < 0 && arctanK > -(Double.pi / 4.0)) || (arctanK > 0 && arctanK > (Double.pi / 4.0)) {
            let target = self.y > anotherPoint.y ? yRange.from : yRange.to
            let newPointX = (target - Double(b)) / Double(k)
            return CGPoint(x: newPointX, y: target)
        } else {
            let target = self.y > anotherPoint.y ? xRange.to : xRange.from
            let newPointY = Double(k) * target + Double(b)
            return CGPoint(x: target, y: newPointY)
        }
    }
    
    public var chartDataEntry: ChartDataEntry {
        return ChartDataEntry(x: Double(self.x), y: Double(self.y))
    }

    public func getArrowPointsWith(_ endPoint: CGPoint) -> (CGPoint, CGPoint) {
        var extendPoint = CGPoint.zero
        var arrowPoint1 = CGPoint.zero
        var arrowPoint2 = CGPoint.zero
        
        //这里假设以上三个点为等边三角形
        //箭头的宽度
        let arrowWidth: CGFloat = 15.0
        //起始点和水平线的夹角，这里是弧度值
        let angle = fabs(Double(atan((self.y - endPoint.y) / (self.x - endPoint.x))))
        
        /// x方向的距离
        let distanceX = CGFloat(fabs(sin(angle))) * arrowWidth / 2.0
        let distanceY = CGFloat(fabs(cos(angle))) * arrowWidth / 2.0
        
        //箭头朝向右上方
        if endPoint.x >= self.x && endPoint.y <= self.y {
            arrowPoint1 = CGPoint(x: endPoint.x - distanceX, y: endPoint.y - distanceY)
            arrowPoint2 = CGPoint(x: endPoint.x + distanceX, y: endPoint.y + distanceY)
            extendPoint = CGPoint(x: endPoint.x + distanceY * 2, y: endPoint.y - distanceX * 2)
        }
            //箭头朝向右下方
        else if endPoint.x > self.x && endPoint.y > self.y {
            arrowPoint1 = CGPoint(x: endPoint.x + distanceX, y: endPoint.y - distanceY)
            arrowPoint2 = CGPoint(x: endPoint.x - distanceX, y: endPoint.y + distanceY)
            extendPoint = CGPoint(x: endPoint.x + distanceY * 2, y: endPoint.y + distanceX * 2)
        }
            //左上方
        else if endPoint.x < self.x && endPoint.y < self.y {
            arrowPoint1 = CGPoint(x: endPoint.x - distanceX, y: endPoint.y + distanceY)
            arrowPoint2 = CGPoint(x: endPoint.x + distanceX, y: endPoint.y - distanceY)
            extendPoint = CGPoint(x: endPoint.x - distanceY * 2, y: endPoint.y - distanceX * 2)
        }
            //左下
        else if endPoint.x < self.x && endPoint.y >= self.y {
            arrowPoint1 = CGPoint(x: endPoint.x - distanceX, y: endPoint.y - distanceY)
            arrowPoint2 = CGPoint(x: endPoint.x + distanceX, y: endPoint.y + distanceY)
            extendPoint = CGPoint(x: endPoint.x - distanceY * 2, y: endPoint.y + distanceX * 2)
        }
            //竖直线
        else if self.x == endPoint.x {
            arrowPoint1 = CGPoint(x: endPoint.x - arrowWidth / 2.0, y: endPoint.y)
            arrowPoint2 = CGPoint(x: endPoint.x + arrowWidth / 2.0, y: endPoint.y)
            extendPoint = CGPoint(x: endPoint.x, y: endPoint.y > self.y ? endPoint.y + arrowWidth : endPoint.y - arrowWidth)
        }
        ///求出延伸点和结束点的偏移
        let distancePoint = CGPoint(x: endPoint.x - extendPoint.x, y: endPoint.y - extendPoint.y)
        
        //校正箭头两个点的位置
        arrowPoint1 = CGPoint(x: arrowPoint1.x + distancePoint.x, y: arrowPoint1.y + distancePoint.y)
        arrowPoint2 = CGPoint(x: arrowPoint2.x + distancePoint.x, y: arrowPoint2.y + distancePoint.y)

        return (arrowPoint1, arrowPoint2)
    }
    
}

extension UIBezierPath {
    /*
    **************************************
    *a.x-1, a.y+diff    b.x+1, b.y + diff*
    *      a--------------------b        *
    *a.x -1, a.y-diff     b.x+1, b.y-diff*
    **************************************
     */
    static func singleLinePath(points: [CGPoint], maxDiffValue: CGFloat) -> UIBezierPath {
        let calculateBezierPath = UIBezierPath()
        
        if points.count >= 2 {
            let firstPoint = points.first!
            let lastPoint = points.last!
            let angle = fabs(Double(atan((firstPoint.y - lastPoint.y) / (firstPoint.x - lastPoint.x))))
            
            let distanceX = CGFloat(fabs(sin(angle))) * maxDiffValue
            let distanceY = CGFloat(fabs(cos(angle))) * maxDiffValue

            var point1 = CGPoint(x: firstPoint.x + distanceX, y: firstPoint.y + distanceY)
            var point2 = CGPoint(x: firstPoint.x - distanceX, y: firstPoint.y - distanceY)
            var point3 = CGPoint(x: lastPoint.x - distanceX, y: lastPoint.y - distanceY)
            var point4 = CGPoint(x: lastPoint.x + distanceX, y: lastPoint.y + distanceY)
                        
            if firstPoint.x < lastPoint.x && firstPoint.y < lastPoint.y {
                point1 = CGPoint(x: firstPoint.x + distanceX, y: firstPoint.y - distanceY)
                point2 = CGPoint(x: firstPoint.x - distanceX, y: firstPoint.y + distanceY)
                point3 = CGPoint(x: lastPoint.x - distanceX, y: lastPoint.y + distanceY)
                point4 = CGPoint(x: lastPoint.x + distanceX, y: lastPoint.y - distanceY)
            } else if (lastPoint.x < firstPoint.x && lastPoint.y < firstPoint.y) {
                point1 = CGPoint(x: firstPoint.x - distanceX, y: firstPoint.y + distanceY)
                point2 = CGPoint(x: firstPoint.x + distanceX, y: firstPoint.y - distanceY)
                point3 = CGPoint(x: lastPoint.x + distanceX, y: lastPoint.y - distanceY)
                point4 = CGPoint(x: lastPoint.x - distanceX, y: lastPoint.y + distanceY)
            } else if (lastPoint.x < firstPoint.x && lastPoint.y > firstPoint.y) {
                point1 = CGPoint(x: firstPoint.x + distanceX, y: firstPoint.y + distanceY)
                point2 = CGPoint(x: firstPoint.x - distanceX, y: firstPoint.y - distanceY)
                point3 = CGPoint(x: lastPoint.x - distanceX, y: lastPoint.y - distanceY)
                point4 = CGPoint(x: lastPoint.x + distanceX, y: lastPoint.y + distanceY)
            }
            
            calculateBezierPath.move(to: point1)
            calculateBezierPath.addLine(to: point2)
            calculateBezierPath.addLine(to: point3)
            calculateBezierPath.addLine(to: point4)
        }
        return calculateBezierPath
    }
    
    
    static func closedGraphicsPath(path: [ChartDataEntry]) -> UIBezierPath {
        let calculateBezierPath = UIBezierPath()
        let points = path.map {
            return CGPoint(x: CGFloat($0.x), y: CGFloat($0.y))
        }
        if points.count > 0 {
            let point = points.first!
            calculateBezierPath.move(to: CGPoint(x: point.x, y: point.y))
            points.forEach {
                calculateBezierPath.addLine(to: CGPoint(x: $0.x, y: $0.y))
            }
            calculateBezierPath.close()
        }
        return calculateBezierPath
    }
}

open class ChartUtils
{
    private static var _defaultValueFormatter: IValueFormatter = ChartUtils.generateDefaultValueFormatter()
    
    open class func drawImage(
        context: CGContext,
        image: NSUIImage,
        x: CGFloat,
        y: CGFloat,
        size: CGSize)
    {
        var drawOffset = CGPoint()
        drawOffset.x = x - (size.width / 2)
        drawOffset.y = y - (size.height / 2)
        
        NSUIGraphicsPushContext(context)
        
        if image.size.width != size.width && image.size.height != size.height
        {
            let key = "resized_\(size.width)_\(size.height)"
            
            // Try to take scaled image from cache of this image
            var scaledImage = objc_getAssociatedObject(image, key) as? NSUIImage
            if scaledImage == nil
            {
                // Scale the image
                NSUIGraphicsBeginImageContextWithOptions(size, false, 0.0)
                
                image.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
                
                scaledImage = NSUIGraphicsGetImageFromCurrentImageContext()
                NSUIGraphicsEndImageContext()
                
                // Put the scaled image in a cache owned by the original image
                objc_setAssociatedObject(image, key, scaledImage, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            
            scaledImage?.draw(in: CGRect(origin: drawOffset, size: size))
        }
        else
        {
            image.draw(in: CGRect(origin: drawOffset, size: size))
        }
        
        NSUIGraphicsPopContext()
    }
    
    open class func drawText(context: CGContext, text: String, point: CGPoint, align: NSTextAlignment, attributes: [NSAttributedString.Key : Any]?)
    {
        var point = point
        
        if align == .center
        {
            point.x -= text.size(withAttributes: attributes).width / 2.0
        }
        else if align == .right
        {
            point.x -= text.size(withAttributes: attributes).width
        }
        
        NSUIGraphicsPushContext(context)
        
        (text as NSString).draw(at: point, withAttributes: attributes)
        
        NSUIGraphicsPopContext()
    }
    
    open class func drawText(context: CGContext, text: String, point: CGPoint, attributes: [NSAttributedString.Key : Any]?, anchor: CGPoint, angleRadians: CGFloat)
    {
        var drawOffset = CGPoint()
        
        NSUIGraphicsPushContext(context)
        
        if angleRadians != 0.0
        {
            let size = text.size(withAttributes: attributes)
            
            // Move the text drawing rect in a way that it always rotates around its center
            drawOffset.x = -size.width * 0.5
            drawOffset.y = -size.height * 0.5
            
            var translate = point
            
            // Move the "outer" rect relative to the anchor, assuming its centered
            if anchor.x != 0.5 || anchor.y != 0.5
            {
                let rotatedSize = size.rotatedBy(radians: angleRadians)
                
                translate.x -= rotatedSize.width * (anchor.x - 0.5)
                translate.y -= rotatedSize.height * (anchor.y - 0.5)
            }
            
            context.saveGState()
            context.translateBy(x: translate.x, y: translate.y)
            context.rotate(by: angleRadians)
            
            (text as NSString).draw(at: drawOffset, withAttributes: attributes)
            
            context.restoreGState()
        }
        else
        {
            if anchor.x != 0.0 || anchor.y != 0.0
            {
                let size = text.size(withAttributes: attributes)
                
                drawOffset.x = -size.width * anchor.x
                drawOffset.y = -size.height * anchor.y
            }
            
            drawOffset.x += point.x
            drawOffset.y += point.y
            
            (text as NSString).draw(at: drawOffset, withAttributes: attributes)
        }
        
        NSUIGraphicsPopContext()
    }
    
    open class func drawMultilineText(context: CGContext, text: String, knownTextSize: CGSize, point: CGPoint, attributes: [NSAttributedString.Key : Any]?, constrainedToSize: CGSize, anchor: CGPoint, angleRadians: CGFloat)
    {
        var rect = CGRect(origin: CGPoint(), size: knownTextSize)
        
        NSUIGraphicsPushContext(context)
        
        if angleRadians != 0.0
        {
            // Move the text drawing rect in a way that it always rotates around its center
            rect.origin.x = -knownTextSize.width * 0.5
            rect.origin.y = -knownTextSize.height * 0.5
            
            var translate = point
            
            // Move the "outer" rect relative to the anchor, assuming its centered
            if anchor.x != 0.5 || anchor.y != 0.5
            {
                let rotatedSize = knownTextSize.rotatedBy(radians: angleRadians)
                
                translate.x -= rotatedSize.width * (anchor.x - 0.5)
                translate.y -= rotatedSize.height * (anchor.y - 0.5)
            }
            
            context.saveGState()
            context.translateBy(x: translate.x, y: translate.y)
            context.rotate(by: angleRadians)
            
            (text as NSString).draw(with: rect, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            context.restoreGState()
        }
        else
        {
            if anchor.x != 0.0 || anchor.y != 0.0
            {
                rect.origin.x = -knownTextSize.width * anchor.x
                rect.origin.y = -knownTextSize.height * anchor.y
            }
            
            rect.origin.x += point.x
            rect.origin.y += point.y
            
            (text as NSString).draw(with: rect, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        }
        
        NSUIGraphicsPopContext()
    }
    
    internal class func drawMultilineText(context: CGContext, text: String, point: CGPoint, attributes: [NSAttributedString.Key : Any]?, constrainedToSize: CGSize, anchor: CGPoint, angleRadians: CGFloat)
    {
        let rect = text.boundingRect(with: constrainedToSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        drawMultilineText(context: context, text: text, knownTextSize: rect.size, point: point, attributes: attributes, constrainedToSize: constrainedToSize, anchor: anchor, angleRadians: angleRadians)
    }

    private class func generateDefaultValueFormatter() -> IValueFormatter
    {
        let formatter = DefaultValueFormatter(decimals: 1)
        return formatter
    }
    
    /// - Returns: The default value formatter used for all chart components that needs a default
    open class func defaultValueFormatter() -> IValueFormatter
    {
        return _defaultValueFormatter
    }
}

class FibonacciPeriod {
    static public func getFibonacciSequenceBy(begin: Double, next: Double, count: Int) -> [Double] {
        
        let space = max(0, fabs(begin - next))
        let leftDirection = begin - next > 0
        var result = Array(repeating: 0.0, count: count)
        result[0] = 0
        result[1] = 1
        
        for index in stride(from: 2, to: count, by: +1) {
            result[index] = result[index - 1] + result[index - 2]
        }
        
        for index in stride(from: 0, to: count, by: +1) {
            if index == 0 {
                result[index] = begin
            } else {
                if leftDirection {
                    result[index] = result[index - 1] - space * result[index]
                } else {
                    result[index] = result[index - 1] + space * result[index]
                }
            }
        }
                
        return result
    }
}

extension CGContext {
    public func generatePathWithRect(rect: CGRect, radius: CGFloat) {
        let point1 = rect.origin
        let point2 = CGPoint(x: rect.origin.x + rect.size.width, y: point1.y)
        let point3 = CGPoint(x: point2.x, y: rect.origin.y + rect.size.height)
        let point4 = CGPoint(x: point1.x, y: point3.y)

        move(to: CGPoint(x: point1.x + radius, y: point1.y))
        addArc(tangent1End: point2, tangent2End: CGPoint(x: point3.x, y: point3.y - radius), radius: radius)
        addArc(tangent1End: point3, tangent2End: CGPoint(x: point4.x - radius, y: point4.y), radius: radius)
        addArc(tangent1End: point4, tangent2End: CGPoint(x: point1.x, y: point1.y - radius), radius: radius)
        addArc(tangent1End: point1, tangent2End: CGPoint(x: point1.x + radius, y: point1.y), radius: radius)
        
        closePath()
    }
}

