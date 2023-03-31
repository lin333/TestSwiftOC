//
//  CustomChartRenderer+CustomDraw.swift
//  TBMixedChartView
//
//  Created by JustLee on 2020/3/31.
//  Copyright © 2020 luopengfei. All rights reserved.
//

import UIKit
import CoreGraphics


extension CustomChartRenderer {
    open func drawDataSetLineSegment(context: CGContext, dataSet: ICustomChartDataSet) {
        guard let dataSet = dataSet as? CustomChartDataSet else { return }
        
        if dataSet.count == 2 {
            drawBaseLineSegment(context: context, dataSet: dataSet, beginEntry: dataSet.entries[0], endEntry: dataSet.entries[1])
        }
    }
    
    open func drawStraightLine(context: CGContext, dataSet: ICustomChartDataSet) {
        guard let dataSet = dataSet as? CustomChartDataSet else { return }
        
        if dataSet.count == 2 {
            drawBaseLineStraight(context: context, dataSet: dataSet, beginEntry: dataSet.entries[0], endEntry: dataSet.entries[1])
        }
    }
    
    open func drawVerticalLine(context: CGContext, dataSet: ICustomChartDataSet) {
        guard let chart = self.dataProvider, let dataSet = dataSet as? CustomChartDataSet else { return }

        if dataSet.count == 1 {
            let entry = dataSet.first!
            entry.y = Double.middleMagnitude(chart.chartYMax, chart.chartYMin)
            
            drawBaseLineVertical(context: context, dataSet: dataSet, beginEntry: entry)
            drawBaseLineDate(context: context, dataSet: dataSet, beginEntry: entry)
        }
    }
    
    open func drawClosedGraphics(context: CGContext, dataSet: ICustomChartDataSet) {
        guard let dataSet = dataSet as? CustomChartDataSet else { return }
        
        drawBaseClosedGraphics(context: context, dataSet: dataSet, entries: dataSet.entries)
    }
    
    open func drawRgressionLine(context: CGContext, dataSet: ICustomChartDataSet) {
        guard let dataSet = dataSet as? CustomChartDataSet else { return }
        
        if dataSet.count == 2 {
            drawBaseLineStraight(context: context, dataSet: dataSet, beginEntry: dataSet.entries[0], endEntry: dataSet.entries[1])
        } else if dataSet.count == 3 {
            ///画第一条线
            drawBaseLineStraight(context: context, dataSet: dataSet, beginEntry:dataSet.entries[0], endEntry: dataSet.entries[1])

            ///获取第一条线的斜率和位移
            let k = (dataSet.entries[0].y - dataSet.entries[1].y) / (dataSet.entries[0].x - dataSet.entries[1].x)
            let b = dataSet.entries[0].y - k * dataSet.entries[0].x
            
            ///求出第二条线的b值
            let bottomB = dataSet.entries[2].y - k * dataSet.entries[2].x
            ///求出第二条线的第二个点
            let bottomPoint = CGPoint(x: dataSet.entries[1].x, y: k * dataSet.entries[1].x + bottomB)
            ///绘制第二条实线
            drawBaseLineStraight(context: context, dataSet: dataSet, beginEntry: dataSet.entries[2], endEntry: bottomPoint.chartDataEntry)

            ///求出第三条虚线的b值，这里为b  bottomB 的中间值
            let dottedLineB = Double.middleMagnitude(b, bottomB)
            ///求出两个绘制虚线的点
            let dottedPointA = CGPoint(x: dataSet.entries[1].x, y: dataSet.entries[1].x * k + dottedLineB)
            let dottedPointB = CGPoint(x: dataSet.entries[2].x, y: dataSet.entries[2].x * k + dottedLineB)
            ///绘制虚线-------改成实线了
            drawBaseLineStraight(context: context, dataSet: dataSet, beginEntry: dottedPointA.chartDataEntry, endEntry: dottedPointB.chartDataEntry)
        }
    }
    
    open func drawFibonacciPeriodLine(context: CGContext, dataSet: ICustomChartDataSet) {
        guard let chart = self.dataProvider, let dataSet = dataSet as? CustomChartDataSet else { return }

        dataSet.forEach {
            $0.y = Double.middleMagnitude(chart.chartYMax, chart.chartYMin)
        }
        
        if dataSet.count == 1 {
            drawBaseLineVertical(context: context, dataSet: dataSet, beginEntry: dataSet.first!)
        } else if dataSet.count == 2 {
            drawBaseLineSegment(context: context, dataSet: dataSet, beginEntry: dataSet[0], endEntry: dataSet[1])
            FibonacciPeriod.getFibonacciSequenceBy(begin: round(dataSet.first!.x), next: round(dataSet.last!.x), count: 11).map {
                return CustomChartDataEntry(x: $0, y: dataSet.first!.y)
            }.forEach {
                drawBaseLineVertical(context: context, dataSet: dataSet, beginEntry: $0)
            }
        }
    }
    
    open func drawHorizontalLine(context: CGContext, dataSet: ICustomChartDataSet) {
        guard let dataSet = dataSet as? CustomChartDataSet else { return }

        if dataSet.count == 1 {
            let entry = dataSet.first!
            let xRange = xRangeForCurrentChart(dataSet: dataSet)
            entry.x = Double.middleMagnitude(xRange.from, xRange.to)
            
            drawBaseLineHorizontal(context: context, dataSet: dataSet, beginEntry: entry)
            drawBaseLinePrice(context: context, dataSet: dataSet, beginEntry: entry)
        }
    }
    
    open func drawRangeStatisticLine(context: CGContext, dataSet: ICustomChartDataSet) {
        guard let chart = self.dataProvider, let dataSet = dataSet as? CustomChartDataSet else { return }

        dataSet.forEach {
            $0.y = Double.middleMagnitude(chart.chartYMax, chart.chartYMin)
        }
        
        if dataSet.count == 1 {
            drawBaseLineVertical(context: context, dataSet: dataSet, beginEntry: dataSet[0])
            drawBaseLineDate(context: context, dataSet: dataSet, beginEntry: dataSet[0])
        } else if dataSet.count == 2 {
            drawBaseLineVertical(context: context, dataSet: dataSet, beginEntry: dataSet[0])
            drawBaseLineDate(context: context, dataSet: dataSet, beginEntry: dataSet[0])

            drawBaseLineVertical(context: context, dataSet: dataSet, beginEntry: dataSet[1])
            drawBaseLineDate(context: context, dataSet: dataSet, beginEntry: dataSet[1])

            drawBaseLineSegment(context: context, dataSet: dataSet, beginEntry: dataSet[0], endEntry: dataSet[1])
        }
    }
    
}

