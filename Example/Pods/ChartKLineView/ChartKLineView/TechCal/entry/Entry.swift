//
//  Entry.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/11/22.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import Foundation

open class Entry: NSObject{

    
    open var object: [Double]?
    private var _isResult: Bool = false
    
    open var resultDict: [String: Bool] = [String: Bool]()
    private var _decorations: [TBDecoration] = [TBDecoration]()
    open var decorations: [TBDecoration] {
        get {
            return _decorations
        }
        set {
            _decorations = newValue
        }
    }
    
    open func is_result(_ name: String) -> Bool {
        return resultDict[name]!
    }
    
    open func set_is_result(_ name: String) {
        resultDict[name] = true
    }
    
    open var isResult: Bool {
        get {
            return _isResult
        }
        set {
            _isResult = newValue
        }
    }
    
    public init(object: [Double]) {
        self.object = object
    }
    
    public func getEntry() -> Any {
        return self.object as Any
    }
    
    // 是否常量
    public func isConstant() -> Bool {
        return false
    }
    
    // 是否变量名
    public func isVarName() -> Bool {
        return false
    }
    
    // 是否是结果
    public func isResults() -> Bool
    {
        return _isResult
    }
    
    
    
}
