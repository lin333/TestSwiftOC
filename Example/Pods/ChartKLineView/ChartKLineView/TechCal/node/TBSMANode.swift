//
//  TBAMSNode.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/11/24.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBSMANode: TBExproNode {
    var t1: TBExproNode?
    var t2: TBExproNode?
    var t3: TBExproNode?
    
    
    public init(_ t1: TBExproNode,_ t2: TBExproNode,_ t3: TBExproNode) {
        super.init()
        self.t1 = t1
        self.t2 = t2
        self.t3 = t3
    }
    
    override func visit(data: inout [String: Entry]) -> Entry {
        let eval: [Double] = t1?.visit(data: &data).getEntry() as! [Double]
        let t2Entry: Entry = (t2?.visit(data: &data))!
        let t3Entry: Entry = (t3?.visit(data: &data))!
        
        start = locateBadPointIndex(points: eval)
        let N: Int = Int(getValueByIndex(index: start, t2Entry: t2Entry))
        let M: Int = Int(getValueByIndex(index: start, t2Entry: t3Entry))
        
        let res: [Double] = sma(close: eval, timePeriod: N, k: M)
        return Entry(object: res)
        
    }
    
    private func sma(close: [Double], timePeriod: Int, k: Int) -> [Double]{
        var result: [Double] = [Double](repeating: 0.0, count: close.count)
        
        var startIndex: Int = 0
        let endIndex: Int = close.count - 1
        if (startIndex < timePeriod - 1) {
            startIndex = timePeriod - 1
        }
        
        guard startIndex <= endIndex else {
            return [Double]()
        }
        
        
        start = max(start, 1)
        
        var i = start
        while i < close.count {
            result[i] = (result[i-1] * Double(timePeriod - k) + close[i]) / Double(timePeriod)
            i += 1
        }
        return result
    }
    
    
}
