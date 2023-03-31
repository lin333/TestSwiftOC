//
//  BarLineBaseChartViewBase+CustomDraw.swift
//  TBMixedChartView
//
//  Created by JustLee on 2020/3/30.
//  Copyright © 2020 luopengfei. All rights reserved.
//

import UIKit
import CoreGraphics

extension BarLineChartViewBase {
    
    /// 添加新画线
    /// - Parameter dataSet: dataSet description
    @objc open func appendNewDrawing(dataSet: CustomChartDataSet) {
        ///如果已经再画线，中途要重新去
        if let drawingDataSet = drawingDataSet {
            editingCustomLine = false
            if !drawingDataSet.completeCurrentCustomDrawing() {
                customLineData.removeDataSet(drawingDataSet)
            }
        }
        drawingCustomLine = true
        drawingDataSet = dataSet
        customLineData.addDataSet(drawingDataSet)
        removeCustomChartDataUndoState()
    }
    
    ///当前是否需要拦截手势，当前触摸点是否在自定义画图上
    @objc open var touchInCustomLine: Bool {
        get {
            return (drawingCustomLine || editingCustomLine) && (drawingEntry !== nil || drawingDataSet !== nil)
        }
    }
    
    /// 获取当前触摸点的自定义画线数据
    /// - Parameter touchPoint: 触摸点
    private func getEditEntryDataSetByTouchPoint(_ pt: CGPoint) -> (CustomChartDataSet?, CustomChartDataEntry?) {
        guard
            let chart = self as? CombinedChartDataProvider,
            let dataObjects = chart.combinedData?.customDrawData,
            let dataSets = dataObjects.dataSets as? [CustomChartDataSet]
            else { return (nil, nil) }
        
        
        for dataSetIndex in stride(from: 0, to: dataSets.count, by: +1) {
            let dataSet = dataSets[dataSetIndex]
            let valuePoint = valueForTouchPoint(point: pt, axis: dataSet.axisDependency)
            let leftPoint = valueForTouchPoint(point: CGPoint(x: 0, y: 0), axis: dataSet.axisDependency)
            let rightPoint = valueForTouchPoint(point: CGPoint(x: viewPortHandler.contentWidth, y: 0), axis: dataSet.axisDependency)
            
            let entry = dataSet.getEntryBy(touchPoint: valuePoint, maxXDiffValue: CGFloat(rightPoint.x - leftPoint.x), maxYDiffValue: CGFloat(chart.chartYMax - chart.chartYMin))
            ///如果提前命中了entry，就直接返回entry
            ///有可能点击到了视图外部，但是命中了某个entry
            if entry !== nil {
                return (dataSet, entry)
            }
            
            ///如果在范围内，entry其实无关紧要，因为需要点亮整个视图
            if dataSet.calculatePositionInGraphicsBy(touchPoint: pt) {
                return (dataSet, entry)
            }
            
        }
        return (nil, nil)
    }
    
    /// 获取当前entry映射的candleEntry
    /// - Parameter pt: 触摸点
    //TODO: 需要优化，不能通过label来确定，需要把主要数据和额外指标区分开
    private func resetEditEntryMapedCandleEntryByTouchPoint(_ entry: CustomChartDataEntry?) {
        guard
            let chart = self as? CombinedChartDataProvider,
            let chartData = chart.data,
            let dataSet = drawingDataSet,
            let editEntry = entry
            else { return }
        
        let selectedPoint = editEntry.valuePoint
        
        var mapedEntry: ChartDataEntry? = nil
        var firstEntry: ChartDataEntry? = nil
        var lastEntry: ChartDataEntry? = nil
        
        if let candleDataSet = chart.combinedData?.getDataSetByLabel("Candle", ignorecase: true) as? CandleChartDataSet {
            if Double(selectedPoint.x) <= chartData.xMax && Double(selectedPoint.x) >= chartData.xMin {
                mapedEntry = candleDataSet[Int(round(selectedPoint.x))] as? CandleChartDataEntry
            }
            firstEntry = candleDataSet.first
            lastEntry = candleDataSet.last
        } else {
            var targetDataSets = data?.dataSets.filter { return $0.label?.caseInsensitiveCompare("price") == .orderedSame } as? [ChartDataSet]
            ///兼容一下趋势线
            if targetDataSets?.count == 0 {
                targetDataSets = data?.dataSets.filter { return $0.label?.caseInsensitiveCompare("close") == .orderedSame } as? [ChartDataSet]
            }
            for dataSetIndex in stride(from: 0, to: targetDataSets?.count ?? 0, by: +1) {
                if let targetDataSet = targetDataSets?[dataSetIndex] {
                    for index in stride(from: 0, to: targetDataSet.count, by: +1) {
                        let entry = targetDataSet[index]
                        
                        if entry.x == 0.0 {
                            firstEntry = entry
                        }
                        if entry.x == round(chartData.xMax) {
                            lastEntry = entry
                        }
                        
                        if entry.x == Double(round(selectedPoint.x)) {
                            mapedEntry = entry
                        }
                    }
                }
            }
        }
        
        editEntry.combinedEntry = mapedEntry
        if mapedEntry !== nil {
            editEntry.timestamp = mapedEntry!.timestamp
        } else {
            if Double(selectedPoint.x) > chartData.xMax && lastEntry !== nil {
                editEntry.timestamp = lastEntry!.timestamp + dataSet.displayKlineTypeTimeDistance * floor((Double(selectedPoint.x) - lastEntry!.x))
            }
            
            if Double(selectedPoint.x) < chartData.xMin && firstEntry !== nil {
                editEntry.timestamp = firstEntry!.timestamp - dataSet.displayKlineTypeTimeDistance * floor((firstEntry!.x - Double(selectedPoint.x)))
            }
        }
    }
    
    /// 通过新的触摸点绘制自定义线
    /// - Parameter pt: 触摸点
    open func drawCustomLineByTouchPoint(_ pt: CGPoint) {
        guard let drawingDataSet = drawingDataSet else {
            return
        }
        
        let valuePoint = valueForTouchPoint(point: pt, axis: .left)
        drawingEntry = CustomChartDataEntry(x: Double(valuePoint.x), y: Double(valuePoint.y))
        resetEditEntryMapedCandleEntryByTouchPoint(drawingEntry)
        drawingDataSet.append(drawingEntry!)
        
        if drawingDataSet.completeCurrentCustomDrawing() {
            editingCustomLine = true
        } else {
            setNeedsDisplay()
        }
        performCustomDrawActionEndDelagete()
    }
    
    
    /// 通过触摸点确定新的编辑视图
    /// - Parameter pt: 触摸点
    open func resetCustomHighlightByTouchPoint( _ pt: CGPoint) {
        ///需要处理entry不为空 但是dataset为空
        let locationEditEntryDataSet = getEditEntryDataSetByTouchPoint(pt)
        drawingDataSet = locationEditEntryDataSet.0
        drawingEntry = locationEditEntryDataSet.1
    }
    
    
    /// 当前触摸点是否需要打断后面的点击手势延续
    /// - Parameter pt: 触摸点
    open func customDrawInterruptGestureWithTouchPoint(_ pt: CGPoint) -> Bool {
        ///如果正在画线，肯定打断当前的手势
        if drawingCustomLine {
            drawCustomLineByTouchPoint(pt)
            return true
        }
        ///查看当时的触摸点有没有命中自定义画图
        resetCustomHighlightByTouchPoint(pt)
        return drawingDataSet !== nil || drawingEntry !== nil
    }
    
    
    /// 判断手势的起始点是否跟当前点亮的自定义画线数据一致，如果一致则拦截当前手势操作，进行自定义画线编辑操作，如果不一致，则继续执行手势
    /// - Parameter touchPoint: 触摸点
    open func customDrawInterruptPanGestureWithTouchPoint(_ pt: CGPoint) -> Bool {
        ///如果当前没有点亮数据，返回false
        if !touchInCustomLine {
            return false
        }
        let locationEditEntryDataSet = getEditEntryDataSetByTouchPoint(pt)
        ///判断取得点是否相等，切点亮的dataset不为空，只要拖动的editDataSet没有改变就继续当前的拖动
        return locationEditEntryDataSet.0 == drawingDataSet &&
            drawingDataSet !== nil
    }
    
    private func moveDistancePoint(previousPoint: CGPoint, currentPoint: CGPoint) -> CGPoint {
        let currentPointValue = valueForTouchPoint(point: currentPoint, axis: .left)
        let previousPointValue = valueForTouchPoint(point: previousPoint, axis: .left)
        return CGPoint(x: currentPointValue.x - previousPointValue.x, y: currentPointValue.y - previousPointValue.y)
    }
    
    open func moveCustomDrawDataSet(previousPoint: CGPoint, currentPoint: CGPoint) {
        if touchInCustomLine {
            moveCustomDrawDataSet(translation: moveDistancePoint(previousPoint: previousPoint, currentPoint: currentPoint))
            drawingDataSet?.forEach {
                resetEditEntryMapedCandleEntryByTouchPoint($0 as? CustomChartDataEntry)
            }
            customDrawDelegate?.customDrawLocationChanged?(currentPoint)
        }
    }
    
    ///移动当前编辑的自定义画图，如果触摸点命中了一个entry那就改成移动entry
    open func moveCustomDrawDataSet(translation: CGPoint) {
        guard let dataSet = drawingDataSet else { return }

        if !touchInCustomLine {
            return
        }
        
        if let entry = drawingEntry {
            dataSet.singleEntryMoveBy(editEntry: entry, translation: translation)
            setNeedsDisplay()
            return
        }
        
        dataSet.totalGraphicstMoveBy(with: translation)
        setNeedsDisplay()
    }
    
    /// 响应画线停止代理方法
    open func performCustomDrawActionEndDelagete() {
        if let customDrawDelegate = customDrawDelegate {
            if touchInCustomLine {
                updateCustomChartData()
                customDrawDelegate.customDrawActionCompleted?(customLineData, dataSet: drawingDataSet!)
            }
        }
    }
    
    /// 响应dataset选中
    open func perfromCustomDrawDataSetDidSelectedDelegate() {
        if let customDrawDelegate = customDrawDelegate, let dataSet = drawingDataSet {
            customDrawDelegate.customDrawDataSetDidSelected?(dataSet)
        }
    }
    
    /// 响应dataset取消选中
    open func perfromCustomDrawDataSetDesSelectedDelegate() {
        if let customDrawDelegate = customDrawDelegate {
            customDrawDelegate.customDrawDataSetDesSelected?()
            removeCustomChartDataUndoState()
        }
    }
    
    //撤销操作
    @objc open func customChartDataUndo() {
        updateDrawDataSetWithAction {
            customLineData.undo()
            setNeedsDisplay()
        }
    }
    
    /// 前进操作
    @objc open func customChartDataRedo() {
        updateDrawDataSetWithAction {
            customLineData.redo()
            setNeedsDisplay()
        }
    }
    
    private func updateDrawDataSetWithAction(_ action: () -> Void) {
        guard let dataSet = drawingDataSet else {
            return
        }
        ///在更新数据前获取之前的index
        let dataSetIndex = customLineData.indexOfDataSet(dataSet)
        
        action()
        
        if dataSetIndex != -1 {
            //如果进行了切换，那么就更新下编辑dataset
            drawingDataSet = customLineData.dataSets[dataSetIndex] as? CustomChartDataSet
        }
    }
    
    /// 是否可以撤销
    @objc open var undoEnable: Bool {
        return drawingDataSet?.customDrawLineType == CustomDrawLineType.lineRangeStatistic ? false : customLineData.undoEnable
    }
    
    /// 是否可以前进
    @objc open var redoEnable: Bool {
        return drawingDataSet?.customDrawLineType == CustomDrawLineType.lineRangeStatistic ? false : customLineData.redoEnable
    }
    
    /// 重新保存当前的自定义划线数据
    @objc open func updateCustomChartData() {
        customLineData.updateDataSets(customDataSets: customLineData.dataSets)
    }
    
    /// 删除撤销状态
    @objc open func removeCustomChartDataUndoState() {
        customLineData.removeDataSetsUndoState()
    }
    
     //MARK: -Touches
     override open func nsuiTouchesBegan(_ touches: Set<NSUITouch>, withEvent event: NSUIEvent?) {
        let _ = customDrawInterruptGestureWithTouchPoint(touches.first!.location(in: self))

        super.nsuiTouchesBegan(touches, withEvent: event)
     }
     
    override open func nsuiTouchesMoved(_ touches: Set<NSUITouch>, withEvent event: NSUIEvent?) {
        moveCustomDrawDataSet(previousPoint: touches.first!.previousLocation(in: self), currentPoint: touches.first!.location(in: self))
        
        super.nsuiTouchesMoved(touches, withEvent: event)
    }
    
    open override func nsuiTouchesEnded(_ touches: Set<NSUITouch>, withEvent event: NSUIEvent?) {
        performCustomDrawActionEndDelagete()
        
        super.nsuiTouchesEnded(touches, withEvent: event)
    }
    
    open override func nsuiTouchesCancelled(_ touches: Set<NSUITouch>?, withEvent event: NSUIEvent?) {
        performCustomDrawActionEndDelagete()
        
        super.nsuiTouchesCancelled(touches, withEvent: event)
    }
}
