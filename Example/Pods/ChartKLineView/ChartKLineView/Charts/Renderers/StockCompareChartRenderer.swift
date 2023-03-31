//
//  StockCompareChartRenderer.swift
//  TBMixedChartView
//
//  Created by JustLee on 2020/11/2.
//  Copyright © 2020 luopengfei. All rights reserved.
//

import UIKit

open class StockCompareChartRenderer: LineRadarRenderer {
    
    @objc open weak var dataProvider: CompareChartDataProvider?
    
    @objc public init(dataProvider: CompareChartDataProvider, animator: Animator, viewPortHandler: ViewPortHandler)
    {
        super.init(animator: animator, viewPortHandler: viewPortHandler)
        
        self.dataProvider = dataProvider
    }
    
    open override func drawData(context: CGContext)
    {
        guard let lineData = dataProvider?.compareData else { return }
        
        for i in 0 ..< lineData.dataSetCount
        {
            guard let set = lineData.getDataSetByIndex(i) else { continue }
            
            if set.isVisible
            {
                if !(set is ILineChartDataSet)
                {
                    fatalError("Datasets for LineChartRenderer must conform to ILineChartDataSet")
                }
                
                drawDataSet(context: context, dataSet: set as! ILineChartDataSet)
            }
        }
    }
    
    @objc open func drawDataSet(context: CGContext, dataSet: ILineChartDataSet)
    {
        if dataSet.entryCount < 1
        {
            return
        }
        
        context.saveGState()
        context.setLineWidth(dataSet.lineWidth)
        context.setLineCap(dataSet.lineCapType)
        
        
        if let compareDataSet = dataSet as? CompareLineChartDataSet {
            //处理缩放逻辑
            let set = compareDataSet.copy() as! CompareLineChartDataSet
            set.forEach {
                $0.y *= compareDataSet.drawScale
            }
            // only linear style
            drawLinear(context: context, dataSet: set)
        }

        context.restoreGState()
    }
    
    private var _lineSegments = [CGPoint](repeating: CGPoint(), count: 2)

    @objc open func drawLinear(context: CGContext, dataSet: ILineChartDataSet)
    {
        guard let dataProvider = dataProvider, let compareDataSet = dataSet as? CompareLineChartDataSet else { return }
        
        let trans = dataProvider.getTransformer(forAxis: compareDataSet.axisDependency)
        
        let valueToPixelMatrix = trans.valueToPixelMatrix
        
        let phaseY = animator.phaseY
        
        _xBounds.set(chart: dataProvider, animator: animator)
        
        context.saveGState()
        for j in _xBounds.dropLast()
        {

            if j < _xBounds.max
            {
                // TODO: remove the check.
                // With the new XBounds iterator, j is always smaller than _xBounds.max
                // Keeping this check for a while, if xBounds have no further breaking changes, it should be safe to remove the check
                let currentEntry = compareDataSet.entryForIndex(j)
                let nextEntry = compareDataSet.entryForIndex(j + 1)
                
                if currentEntry == nil && nextEntry == nil {
                    continue
                }

                if currentEntry == nil {
                    _lineSegments[0] = CGPoint(x: CGFloat(nextEntry!.x - 1), y: CGFloat(nextEntry!.y * compareDataSet.drawScale * phaseY))
                    _lineSegments[1] = CGPoint(x: CGFloat(nextEntry!.x), y: CGFloat(nextEntry!.y * compareDataSet.drawScale * phaseY))
                } else if nextEntry == nil {
                    _lineSegments[0] = CGPoint(x: CGFloat(currentEntry!.x), y: CGFloat(currentEntry!.y * compareDataSet.drawScale * phaseY))
                    _lineSegments[1] = CGPoint(x: CGFloat(currentEntry!.x + 1), y: CGFloat(currentEntry!.y * compareDataSet.drawScale * phaseY))
                } else {
                    _lineSegments[0] = CGPoint(x: CGFloat(currentEntry!.x), y: CGFloat(currentEntry!.y * compareDataSet.drawScale * phaseY))
                    _lineSegments[1] = CGPoint(x: CGFloat(nextEntry!.x), y: CGFloat(nextEntry!.y * compareDataSet.drawScale * phaseY))
                }
            }
            else
            {
                _lineSegments[1] = _lineSegments[0]
            }

            for i in 0..<_lineSegments.count
            {
                _lineSegments[i] = _lineSegments[i].applying(valueToPixelMatrix)
            }
            
            // Determine the start and end coordinates of the line, and make sure they differ.
            guard
                let firstCoordinate = _lineSegments.first,
                let lastCoordinate = _lineSegments.last,
                firstCoordinate != lastCoordinate else { continue }
            
            // If both points lie left of viewport, skip stroking.
            if !viewPortHandler.isInBoundsLeft(lastCoordinate.x) { continue }
            
            // If both points lie right of the viewport, break out early.
            if !viewPortHandler.isInBoundsRight(firstCoordinate.x) { break }
            
            // Only stroke the line if it intersects with the viewport.
            guard viewPortHandler.isIntersectingLine(from: firstCoordinate, to: lastCoordinate) else { continue }
            
            // get the color that is set for this line-segment
            context.setStrokeColor(compareDataSet.color(atIndex: j).cgColor)
            context.strokeLineSegments(between: _lineSegments)
        }
        
        context.restoreGState()
    }
    
    open override func drawValues(context: CGContext)
    {
        //do nothing
    }
    
    open override func drawExtras(context: CGContext)
    {
        //do nothing
    }

    open override func drawHighlighted(context: CGContext, indices: [Highlight])
    {
        //do nothing
    }
}
