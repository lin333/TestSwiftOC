//
//  CustomChartRenderer.swift
//  TBMixedChartView
//
//  Created by JustLee on 2020/3/20.
//  Copyright © 2020 luopengfei. All rights reserved.
//

import Foundation
import CoreGraphics

open class CustomChartRenderer: LineRadarRenderer {
    
    @objc open weak var dataProvider: CustomDrawChartDataProvider?
    
    @objc public init(dataProvider: CustomDrawChartDataProvider, animator: Animator, viewPortHandler: ViewPortHandler)
    {
        super.init(animator: animator, viewPortHandler: viewPortHandler)
        
        self.dataProvider = dataProvider
    }

    open override func drawData(context: CGContext)
    {
        guard let customDrawData = dataProvider?.customDrawData else { return }
        
        for i in 0 ..< customDrawData.dataSetCount
        {
            guard let set = customDrawData.getDataSetByIndex(i) else { continue }
            
            if set.isVisible
            {
                if !(set is ICustomChartDataSet)
                {
                    fatalError("Datasets for CustomChartRenderer must conform to ICustomChartDataSet")
                }
                
                drawCustomeDataSet(context: context, dataSet: set as! ICustomChartDataSet)
            }
        }
    }
    
    open func drawCustomeDataSet(context: CGContext, dataSet: ICustomChartDataSet) {
        ///清楚命中位置路径
        dataSet.clearPathLocation()
        ///处理绘制的样式
        switch dataSet.customDrawLineType {
        case .lineSegment:
            drawDataSetLineSegment(context: context, dataSet: dataSet)
            break
        case .rectangle:
            drawClosedGraphics(context: context, dataSet: dataSet)
            break
        case .lineStraight:
            drawStraightLine(context: context, dataSet: dataSet)
            break
        case .lineVertical:
            drawVerticalLine(context: context, dataSet: dataSet)
            break
        case .lineRgression:
            drawRgressionLine(context: context, dataSet: dataSet)
            break
        case .lineFibonacciPeriod:
            drawFibonacciPeriodLine(context: context, dataSet: dataSet)
            break
        case .lineHorizontal:
            drawHorizontalLine(context: context, dataSet: dataSet)
            break
        case .lineRangeStatistic:
            drawRangeStatisticLine(context: context, dataSet: dataSet)
            break
        }
        
        if dataSet.customDrawSelected {
            drawCustomHighlight(context: context, dataSet: dataSet)
        }
    }
   
    open func drawCustomHighlight(context: CGContext, dataSet: ICustomChartDataSet)
    {
        guard let dataSet = dataSet as? CustomChartDataSet else { return }
        
        if dataSet.customDrawLineType.calculatePathType != .closed {
            drawBaseAlphaPath(context: context, dataSet: dataSet)
        }
        
        dataSet.forEach {
            drawBaseCircel(context: context, dataSet: dataSet, beginEntry: $0)
        }
    }
    
    
    open override func drawValues(context: CGContext)
    {
        ///是否需要绘制值，后续实现
    }
    
    open override func drawExtras(context: CGContext)
    {
        ///绘制更多额外信息
    }
    
}
