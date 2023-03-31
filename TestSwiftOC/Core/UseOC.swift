//
//  UseOC.swift
//  TestSwiftOC
//
//  Created by linbingjie on 2022/11/1.
//

import Foundation
import UIKit
import ChartKLineView


public class UseOC {
    public init() {
        
    }
    
    public func useOC() {
        LBJOC.loglog2()
        
    }
}


open class TBCommonChartYAxisRender: YAxisRenderer {
    
    public override func drawYLabels(
        context: CGContext,
        fixedPosition: CGFloat,
        positions: [CGPoint],
        offset: CGFloat,
        textAlign: NSTextAlignment)
    {
        guard
            let yAxis = self.axis as? TBCommonChartYAxis
            else { return }
        
        let labelFont = yAxis.labelFont
        let labelTextColor = yAxis.labelTextColor
        
        let from = yAxis.isDrawBottomYLabelEntryEnabled ? 0 : 1
        let to = yAxis.isDrawTopYLabelEntryEnabled ? yAxis.entryCount : (yAxis.entryCount - 1)
        
        for i in stride(from: from, to: to, by: 1)
        {
            let text = yAxis.getFormattedLabel(i)
            
            if positions[i].y < (viewPortHandler.contentTop - 0.01) {
                continue
            }
            
            if positions[i].y > (viewPortHandler.contentBottom + 0.01) {
                continue
            }
            var pt = positions[i]
            if yAxis.shouldAlignTop {
                if positions[i].y < viewPortHandler.contentTop {
                    pt.y  = viewPortHandler.contentTop
                }
            }
                
            if yAxis.shouldAlignBottom {
                if positions[i].y > (viewPortHandler.contentBottom - yAxis.labelFont.lineHeight) {
                    pt.y = viewPortHandler.contentBottom - yAxis.labelFont.lineHeight
                }
            }
            
            ChartUtils.drawText(
                            context: context,
                            text: text,
                            point: CGPoint(x: fixedPosition, y: pt.y),
                            align: textAlign,
                            attributes: [NSAttributedString.Key.font: labelFont, NSAttributedString.Key.foregroundColor: labelTextColor])
        }
        
        if yAxis.limitLines.count != 0 {
            let trans = self.transformer!.valueToPixelMatrix
            var position = CGPoint(x: 0.0, y: 0.0)

            for limitLine in yAxis.limitLines {
                let text = yAxis.valueFormatter?.stringForValue(limitLine.limit, axis: yAxis)
                 position.x = 0.0
                position.y = CGFloat(limitLine.limit)
                position = position.applying(trans)
                
                ChartUtils.drawText(
                    context: context,
                    text: text!,
                    point: CGPoint(x: fixedPosition, y: position.y),
                    align: textAlign,
                    attributes: [NSAttributedString.Key.font: labelFont, NSAttributedString.Key.foregroundColor: limitLine.lineColor])
                

            }
        }
        
    }
    
    
    @objc open override func computeAxis(min: Double, max: Double, inverted: Bool)
    {
        guard
            let yAxis = self.axis as? TBCommonChartYAxis
            else { return }
        
        if yAxis.customYAxisEntried {
            
            return;
        }
        super.computeAxis(min: min, max: max, inverted: inverted)
    }
    
    open override func renderGridLines(context: CGContext)
    {
        guard let
            yAxis = self.axis as? YAxis
            else { return }
        
        if !yAxis.isEnabled
        {
            return
        }
        
        if yAxis.drawGridLinesEnabled
        {
            let positions = transformedPositions()
            
            context.saveGState()
            defer { context.restoreGState() }
            var rect=self.gridClippingRect
            rect.origin.x=0
            rect.size.width=viewPortHandler.chartWidth
            context.clip(to: rect)
            
            context.setShouldAntialias(yAxis.gridAntialiasEnabled)
            context.setStrokeColor(yAxis.gridColor.cgColor)
            context.setLineWidth(yAxis.gridLineWidth)
            context.setLineCap(yAxis.gridLineCap)
            
            if yAxis.gridLineDashLengths != nil
            {
                context.setLineDash(phase: yAxis.gridLineDashPhase, lengths: yAxis.gridLineDashLengths)
                
            }
            else
            {
                context.setLineDash(phase: 0.0, lengths: [])
            }
            
            // draw the grid
            positions.forEach { drawGridLine(context: context, position: $0) }
        }

        if yAxis.drawZeroLineEnabled
        {
            // draw zero line
            drawZeroLine(context: context)
        }
    }
    @objc open override func drawGridLine(
        context: CGContext,
        position: CGPoint)
    {
        guard
        let yAxis = self.axis as? TBCommonChartYAxis
        else { return }
        
        if yAxis.bigGrideBorder {
            context.beginPath()
            context.move(to: CGPoint(x: 0.0, y: position.y))
            context.addLine(to: CGPoint(x: viewPortHandler.chartWidth, y: position.y))
            context.strokePath()
        }else
        {
            context.beginPath()
            context.move(to: CGPoint(x: viewPortHandler.contentLeft, y: position.y))
            context.addLine(to: CGPoint(x: viewPortHandler.contentRight, y: position.y))
            context.strokePath()
        }
        
    }
    
}

open class TBCommonChartYAxis : YAxis {
    
    //边框线是否包含y坐标轴
    @objc open var bigGrideBorder: Bool = false
    // 是否需要将大数进行万、千万等格式化，使用TBUtils.formatVolumeCount方法格式化
    @objc open var shouldLocalFormat: Bool = false
    
    @objc open var customYAxisEntried: Bool = false
    
    // 最大值、最小值是否需要对齐图表顶部和底部
    @objc open var shouldAlignTop: Bool = false
    @objc open var shouldAlignBottom: Bool = false

    
    /// 最长Y轴值，当两个图表共用一个X轴时，需要统一Y轴边距时可以赋给最大值
    @objc open var longestText: String = ""
    
    open override func getLongestLabel() -> String
    {
        var longest = ""
        
        if longestText.count > 0 {
            return longestText
        }
        
        let bussinessSupportService = TBServiceManager.sharedInstance().createService(NSProtocolFromString("TBBusinessSupportService")!) as! TBBusinessSupportService
        for i in 0 ..< entries.count
        {
            let text = shouldLocalFormat ? (bussinessSupportService.tbBusinessSupport_formatVolumeCount(Int64(entries[i]))) : getFormattedLabel(i)
            
            if (longest.count <= text.count)
            {
                longest = text
            }
        }
        
        return longest
    }
    
    @objc open override func getFormattedLabel(_ index: Int) -> String
    {
        if index < 0 || index >= entries.count
        {
            return ""
        }
        
        let bussinessSupportService = TBServiceManager.sharedInstance().createService(NSProtocolFromString("TBBusinessSupportService")!) as! TBBusinessSupportService

        if shouldLocalFormat {
            return bussinessSupportService.tbBusinessSupport_formatVolumeCount(Int64(entries[index]))
        }
        return valueFormatter?.stringForValue(entries[index], axis: self) ?? ""
    }
    
    // MARK: - 下面逻辑是修复两个点（value）相同时，没有画出横线的问题
    open override func calculate(min dataMin: Double, max dataMax: Double)
    {
        // if custom, use value as is, else use data value
        var min = isAxisMinCustom ? _axisMinimum : dataMin
        var max = isAxisMaxCustom ? _axisMaximum : dataMax

        // Make sure max is greater than min
        // Discussion: https://github.com/danielgindi/Charts/pull/3650#discussion_r221409991
        if min > max
        {
            switch(isAxisMaxCustom, isAxisMinCustom)
            {
            case(true, true):
                (min, max) = (max, min)
            case(true, false):
                min = max < 0 ? max * 1.5 : max * 0.5
            case(false, true):
                max = min < 0 ? min * 0.5 : min * 1.5
            case(false, false):
                break
            }
        }

        // temporary range (before calculations)
        let range = abs(max - min)

        // in case all values are equal
        if range <= exp(-11)
        {
            max = max * (1.0 + sameMinMaxMultiplier(max))
            min = min * (1.0 - sameMinMaxMultiplier(min))
            //添加一个极值为0的判断
            if max == min && max == 0 {
                max = 1
                min = -1
            }
        }

        // bottom-space only effects non-custom min
        if !isAxisMinCustom
        {
            let bottomSpace = range * Double(spaceBottom)
            _axisMinimum = (min - bottomSpace)
        }

        // top-space only effects non-custom max
        if !isAxisMaxCustom
        {
            let topSpace = range * Double(spaceTop)
            _axisMaximum = (max + topSpace)
        }

        validYChartMinMax()

        // calc actual range
        axisRange = abs(_axisMaximum - _axisMinimum)
    }
    
    private func validYChartMinMax() {
        var min = _axisMinimum
        var max = _axisMaximum
        
        if min.isNaN || max.isNaN || min.isInfinite || max.isInfinite {
            min = 0
            max = 0.1
        } else if (min == max) {
            var delta = 0.0
            if max == 0  {
                delta = 0.1
            } else {
                delta = max * 0.1
            }

            max += delta/2.0
            min -= delta/2.0
        } else if (min > max) {
            let avg = min/2.0 + max/2.0
            let delta = fabs(max/2 - min/2)
            max = avg + delta
            min = avg - delta
        }
        _axisMaximum = max
        _axisMinimum = min
    }
    
    //如果图表只有一个值会出现最大值最小值相同，造成坐标展示问题
    //以10的三次方为阶段，分别为5 15 20
    private func sameMinMaxMultiplier(_ value: Double) -> Double {
        if value == 0 {
            return 0
        }
        let level = fabs(log10(fabs(value))) / 3
        return 0.05 * level
    }

}
