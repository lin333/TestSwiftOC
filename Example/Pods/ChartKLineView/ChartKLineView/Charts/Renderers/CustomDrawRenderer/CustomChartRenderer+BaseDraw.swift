//
//  CustomChartRenderer+BaseDraw.swift
//  TBMixedChartView
//
//  Created by JustLee on 2020/4/2.
//  Copyright © 2020 luopengfei. All rights reserved.
//

import UIKit
import CoreGraphics

extension CustomChartRenderer {
    
    /// 转换当前的entry至真实绘制点
    /// - Parameters:
    ///   - entry: entry description
    ///   - axisDependency: axisDependency description
    open func transEntryToValuePoint(entry: ChartDataEntry?, axisDependency: YAxis.AxisDependency = .left) -> CGPoint {
        guard let dataProvider = dataProvider, let entry = entry else { return .zero }
        let trans = dataProvider.getTransformer(forAxis: axisDependency)
        let valueToPixelMatrix = trans.valueToPixelMatrix
        let phaseY = animator.phaseY
        return CGPoint(x: round(entry.x), y: entry.y * phaseY).applying(valueToPixelMatrix)
    }
    
    /// 获取当前图表的x轴范围
    /// - Parameter dataSet: dataSet description
    open func xRangeForCurrentChart(dataSet: CustomChartDataSet) -> Range {
        guard let dataProvider = dataProvider as? BarLineChartViewBase else {
            return Range(from: 0, to: 0)
        }
        
        let leftPoint = dataProvider.valueForTouchPoint(point: CGPoint(x: 0, y: 0), axis: dataSet.axisDependency)
        let rightPoint = dataProvider.valueForTouchPoint(point: CGPoint(x: viewPortHandler.contentWidth, y: 0), axis: dataSet.axisDependency)
        
        return Range(from: Double(leftPoint.x), to: Double(rightPoint.x))
    }
    
    /// 获取当前图表的y轴范围
    /// - Parameter dataSet: dataSet description
    open func yRangeForCurrentChart(dataSet: CustomChartDataSet) -> Range {
        guard let dataProvider = dataProvider as? BarLineChartViewBase else {
            return Range(from: 0, to: 0)
        }
        
        let topPoint = dataProvider.valueForTouchPoint(point: CGPoint(x: 0, y: dataProvider.extraTopOffset), axis: dataSet.axisDependency)
        let bottomPoint = dataProvider.valueForTouchPoint(point: CGPoint(x: 0, y: dataProvider.contentRect.height - dataProvider.extraBottomOffset), axis: dataSet.axisDependency)
        
        return Range(from: Double(bottomPoint.y), to: Double(topPoint.y))
    }
    
    
    /// 绘制拖动点位置的圆形标志
    /// - Parameters:
    ///   - context: context description
    ///   - dataSet: dataSet description
    ///   - beginEntry: 点的位置
    open func drawBaseCircel(context: CGContext, dataSet: CustomChartDataSet, beginEntry: ChartDataEntry) {
        ///先画底色，先设置透明度为20%，然后画点
        let holdRadius = max(dataSet.circleHoleRadius, dataSet.lineWidth + 2)
        let circelRadius = dataSet.circleRadius
        
        let point = transEntryToValuePoint(entry: beginEntry, axisDependency: dataSet.axisDependency)
        let pointRect = CGRect(x: point.x - holdRadius, y: point.y - holdRadius, width: holdRadius * 2, height: holdRadius * 2)
        let circelRect = CGRect(x: point.x - circelRadius, y: point.y - circelRadius, width: circelRadius * 2, height: circelRadius * 2)

        context.setFillColor(dataSet.customDrawColor.withAlphaComponent(0.25).cgColor)
        context.fillEllipse(in: circelRect)
        
        context.setFillColor(dataSet.customDrawColor.cgColor)
        context.fillEllipse(in: pointRect)
    }
    
    /// 绘制高亮状态的通道线
    /// - Parameters:
    ///   - context: context description
    ///   - dataSet: dataSet description
    open func drawBaseAlphaPath(context: CGContext, dataSet: CustomChartDataSet) {
        context.setFillColor(dataSet.customDrawColor.withAlphaComponent(0.05).cgColor)
        dataSet.customDrawLinePaths.forEach {
            context.addPath($0.cgPath)
            context.drawPath(using: .fill)
        }
    }
    
    /// 绘制基础的线段
    /// - Parameters:
    ///   - context: context description
    ///   - dataSet: 当前要绘制的dataset
    ///   - beginEntry: 开始entry
    ///   - endEntry: 结束entry
    open func drawBaseLineSegment(context: CGContext, dataSet: CustomChartDataSet, beginEntry: ChartDataEntry, endEntry: ChartDataEntry) {
        
        context.setLineWidth(dataSet.lineWidth)
        context.setLineDash(phase: dataSet.lineDashPhase, lengths: dataSet.lineDashLengths!)
   
        context.setStrokeColor(dataSet.customDrawColor.cgColor)
        
        let beginPoint = transEntryToValuePoint(entry: beginEntry, axisDependency: dataSet.axisDependency)
        let endPoint = transEntryToValuePoint(entry: endEntry, axisDependency: dataSet.axisDependency)
        context.addLines(between: [beginPoint, endPoint])
        
        context.strokePath()
        
        switch dataSet.customDrawLineStyle.lineArrowStyle {
            case .left:
                drawBaseLineArrow(context: context, dataSet: dataSet, beginEntry: endEntry, endEntry: beginEntry)
            case .right:
                drawBaseLineArrow(context: context, dataSet: dataSet, beginEntry: beginEntry, endEntry: endEntry)
            case .both:
                drawBaseLineArrow(context: context, dataSet: dataSet, beginEntry: beginEntry, endEntry: endEntry)
                drawBaseLineArrow(context: context, dataSet: dataSet, beginEntry: endEntry, endEntry: beginEntry)
            default: break
        }
                
        dataSet.appendSinglePathLocation(points: [beginPoint, endPoint], maxDiffValue: dataSet.circleRadius)
    }
    
    /// 绘制基础闭合同性
    /// - Parameters:
    ///   - context: context description
    ///   - dataSet: dataSet description
    ///   - entries: entries description
    open func drawBaseClosedGraphics(context: CGContext, dataSet: CustomChartDataSet, entries: [ChartDataEntry]) {
        
        context.setFillColor(dataSet.customDrawColor.withAlphaComponent(0.4).cgColor)

        let firstPoint = transEntryToValuePoint(entry: entries.first, axisDependency: dataSet.axisDependency)
        context.move(to: firstPoint)
        entries.forEach {
            context.addLine(to: transEntryToValuePoint(entry: $0, axisDependency: dataSet.axisDependency))
        }
        context.closePath()
        context.fillPath()
        
        dataSet.appendClosedGraphicsPathLocation(entries: entries)
    }
    
    /// 绘制基础直线
    /// - Parameters:
    ///   - context: context description
    ///   - dataSet: dataSet description
    ///   - beginEntry: 直线确定的第一个点
    ///   - endEntry: 第二个点
    open func drawBaseLineStraight(context: CGContext, dataSet: CustomChartDataSet, beginEntry: ChartDataEntry, endEntry: ChartDataEntry) {
        context.setLineWidth(dataSet.lineWidth)
        context.setLineDash(phase: dataSet.lineDashPhase, lengths: dataSet.lineDashLengths!)

        context.setStrokeColor(dataSet.customDrawColor.cgColor)

        let xRange = xRangeForCurrentChart(dataSet: dataSet)
        let yRange = yRangeForCurrentChart(dataSet: dataSet)
        
        let point2 = CGPoint(x: beginEntry.x, y: beginEntry.y)
        let point3 = CGPoint(x: endEntry.x, y: endEntry.y)
        
        let point1 = point3.getExtendPointBy(point2, xRange: xRange, yRange: yRange)
        let point4 = point2.getExtendPointBy(point3, xRange: xRange, yRange: yRange)

        context.addLines(between: [transEntryToValuePoint(entry: point1.chartDataEntry), transEntryToValuePoint(entry: point4.chartDataEntry)])

        context.strokePath()
        
        dataSet.appendSinglePathLocation(points: [transEntryToValuePoint(entry: point1.chartDataEntry), transEntryToValuePoint(entry: point4.chartDataEntry)], maxDiffValue: dataSet.circleRadius)

    }
    
    /// 绘制虚线
    /// - Parameters:
    ///   - context: context description
    ///   - dataSet: dataSet description
    ///   - beginEntry: beginEntry description
    ///   - endEntry: endEntry description
    open func drawBaseLineDotted(context: CGContext, dataSet: CustomChartDataSet, beginEntry: ChartDataEntry, endEntry: ChartDataEntry) {
        context.setLineWidth(dataSet.lineWidth)
        context.setLineDash(phase: 0, lengths: [5, 5])
        context.setStrokeColor(dataSet.customDrawColor.cgColor)
                
        let xRange = xRangeForCurrentChart(dataSet: dataSet)
        let yRange = yRangeForCurrentChart(dataSet: dataSet)
        
        let point2 = CGPoint(x: beginEntry.x, y: beginEntry.y)
        let point3 = CGPoint(x: endEntry.x, y: endEntry.y)
        
        let point1 = point3.getExtendPointBy(point2, xRange: xRange, yRange: yRange)
        let point4 = point2.getExtendPointBy(point3, xRange: xRange, yRange: yRange)
        
        context.addLines(between: [transEntryToValuePoint(entry: point1.chartDataEntry, axisDependency: dataSet.axisDependency), transEntryToValuePoint(entry: point4.chartDataEntry, axisDependency: dataSet.axisDependency)])
        
        context.strokePath()
        
        dataSet.appendSinglePathLocation(points: [transEntryToValuePoint(entry: point1.chartDataEntry, axisDependency: dataSet.axisDependency), transEntryToValuePoint(entry: point4.chartDataEntry, axisDependency: dataSet.axisDependency)], maxDiffValue: dataSet.circleRadius)
    }
    
    /// 绘制基础竖线
    /// - Parameters:
    ///   - context: context description
    ///   - dataSet: dataSet description
    ///   - beginEntry: 起始点
    open func drawBaseLineVertical(context: CGContext, dataSet: CustomChartDataSet, beginEntry: ChartDataEntry) {
        let yRange = yRangeForCurrentChart(dataSet: dataSet)
        
        drawBaseLineSegment(context: context, dataSet: dataSet, beginEntry: ChartDataEntry(x: beginEntry.x, y: yRange.from), endEntry: ChartDataEntry(x: beginEntry.x, y: yRange.to))
    }
    
    /// 绘制基础横线
    /// - Parameters:
    ///   - context: context description
    ///   - dataSet: dataSet description
    ///   - beginEntry: 起始点
    open func drawBaseLineHorizontal(context: CGContext, dataSet: CustomChartDataSet, beginEntry: ChartDataEntry) {
        let xRange = xRangeForCurrentChart(dataSet: dataSet)
        drawBaseLineSegment(context: context, dataSet: dataSet, beginEntry: ChartDataEntry(x: xRange.from, y: beginEntry.y), endEntry: ChartDataEntry(x: xRange.to, y: beginEntry.y))
    }
    
    /// 绘制线端的箭头
    /// - Parameters:
    ///   - context: context description
    ///   - dataSet: dataSet description
    ///   - beginEntry: beginEntry description
    ///   - endEntry: endEntry description
    open func drawBaseLineArrow(context: CGContext, dataSet: CustomChartDataSet, beginEntry: ChartDataEntry, endEntry: ChartDataEntry) {
        context.setLineWidth(dataSet.lineWidth)
        context.setStrokeColor(dataSet.customDrawColor.cgColor)
        context.setLineDash(phase: 0, lengths: [])
        
        let beginPoint = transEntryToValuePoint(entry: beginEntry, axisDependency: dataSet.axisDependency)
        let endPoint = transEntryToValuePoint(entry: endEntry, axisDependency: dataSet.axisDependency)
        let points = beginPoint.getArrowPointsWith(endPoint)
        
        context.addLines(between: [points.0, endPoint, points.1])

        context.strokePath()
    }
    
    /// 根据entry绘制y轴日期
    /// - Parameters:
    ///   - context: context description
    ///   - dataSet: dataSet description
    ///   - beginEntry: beginEntry description
    open func drawBaseLinePrice(context: CGContext, dataSet: CustomChartDataSet, beginEntry: ChartDataEntry) {
        guard let chart = dataProvider as? BarLineChartViewBase else { return }

        let attribute = [NSAttributedString.Key.font : UIFont.tb_numberFont(ofSize: 11), NSAttributedString.Key.foregroundColor : UIColor.white]
        let string = chart.leftAxis.valueFormatter?.stringForValue(beginEntry.y, axis: chart.leftAxis) ?? ""
        let textRect = (string as NSString).boundingRect(with: CGSize(width: 100, height: 15), options: .usesLineFragmentOrigin, attributes: attribute, context: nil)
        let contentRect = CGRect(x: 0, y: transEntryToValuePoint(entry: beginEntry).y - textRect.height / 2, width: textRect.width + 5, height: textRect.height)
        
        context.setFillColor(dataSet.customDrawColor.cgColor)
        context.fill(contentRect)
        
        ChartUtils.drawText(context: context, text: string, point: CGPoint(x: contentRect.midX, y: transEntryToValuePoint(entry: beginEntry).y - textRect.height / 2), align: .center, attributes: attribute)
    }
    
    /// 根据entry绘制x轴位置的日期
    /// - Parameters:
    ///   - context: context description
    ///   - dataSet: dataSet description
    ///   - beginEntry: beginEntry description
    open func drawBaseLineDate(context: CGContext, dataSet: CustomChartDataSet, beginEntry: ChartDataEntry) {
        let yRange = yRangeForCurrentChart(dataSet: dataSet)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dataSet.displayKlineTypeDateFormat
        if let zoneId = dataSet.customDrawDisplayTimeZoneID, let timeZone = TimeZone(identifier: zoneId) {
            dateFormatter.timeZone = timeZone
        }
        
        if let zoneId = dataSet.customDrawDisplayTimeZoneID, let timeZone = TimeZone(abbreviation: zoneId) {
            dateFormatter.timeZone = timeZone
        }
        
        let textPoint = transEntryToValuePoint(entry: ChartDataEntry(x: beginEntry.x, y: yRange.from))
        let contentHeight: CGFloat = 15.0
        let dateString = dateFormatter.string(from: Date(timeIntervalSince1970: beginEntry.timestamp / 1000.0))
        let dateAttributes = [NSAttributedString.Key.font: UIFont.tb_numberFont(ofSize: 11), NSAttributedString.Key.foregroundColor: UIColor.white]
        let textRect = (dateString as NSString).boundingRect(with: CGSize(width: 100, height: contentHeight), options: .usesLineFragmentOrigin, attributes: dateAttributes, context: nil)
        var contentRect = CGRect(x: textPoint.x - textRect.width / 2 - 2.5, y: viewPortHandler.contentBottom - contentHeight, width: textRect.width + 5, height: contentHeight);
        
        if contentRect.origin.x < viewPortHandler.contentLeft && contentRect.midX > viewPortHandler.contentLeft {
            contentRect = CGRect(x: viewPortHandler.contentLeft, y: viewPortHandler.contentBottom - contentHeight, width: textRect.width + 5, height: contentHeight)
        }
        
        if contentRect.origin.x + contentRect.width > viewPortHandler.contentRight && contentRect.midX < viewPortHandler.contentRight {
            contentRect = CGRect(x: viewPortHandler.contentRight - contentRect.width, y: viewPortHandler.contentBottom - contentHeight, width: textRect.width + 5, height: contentHeight)
        }
        
        context.generatePathWithRect(rect: contentRect, radius: 2.0)
        
        context.setFillColor(dataSet.customDrawColor.cgColor)
        context.fillPath()
        
        ChartUtils.drawText(context: context, text: dateString, point: CGPoint(x: contentRect.midX, y: contentRect.origin.y + (contentRect.height - textRect.height) / 2), align: .center, attributes: dateAttributes)
    }
}
