//
//  CustomDrawChartData.swift
//  TBMixedChartView
//
//  Created by JustLee on 2020/3/20.
//  Copyright © 2020 luopengfei. All rights reserved.
//

import Foundation

/// Data object that encapsulates all data associated with a CustomChart.
open class CustomDrawChartData: ChartData
{
    private var undoManager = UndoManager()

    public var saveDataSets: [IChartDataSet] = []
    
    public override init()
    {
        super.init()
    }
    
    public override init(dataSets: [IChartDataSet]?)
    {
        super.init(dataSets: dataSets)
    }
    
    open override func addDataSet(_ dataSet: IChartDataSet!) {
        super.addDataSet(dataSet)
        generateDispalyDataSets()
    }
    
    @objc public var customDrawData: [[String: Any]] {
        var temp = [[String: Any]]()
        if let customDataSets = _dataSets as? [CustomChartDataSet] {
            customDataSets.forEach {
                temp.append($0.customDrawTranslateMap)
            }
        }
        return temp
    }
    
    @objc public func generateDispalyDataSets() {
        saveDataSets = [CustomChartDataSet]()
        if let customDataSets = _dataSets as? [CustomChartDataSet] {
            customDataSets.forEach {
                saveDataSets.append($0.copy() as! CustomChartDataSet)
            }
        }
    }
    
    public func removeDataSetsUndoState() {
        undoManager.removeAllActions(withTarget: self)
    }
    
    @objc public func updateDataSets(customDataSets: [IChartDataSet]) {
        undoManager.registerUndo(withTarget: self, selector: #selector(updateDataSets(customDataSets:)), object: saveDataSets)
        _dataSets = customDataSets
        generateDispalyDataSets()
    }
    
    public func undo() {
        undoManager.undo()
    }
    
    public func redo() {
        undoManager.redo()
    }
    
    public var undoEnable: Bool {
        return undoManager.canUndo
    }
    
    public var redoEnable: Bool {
        return undoManager.canRedo
    }
}
