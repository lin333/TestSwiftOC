//
//  TBSUMNode.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/11/24.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBSUMNode: TBExproNode {
    var t1: TBExproNode?
    var t2: TBExproNode?
    
    public init(_ t1: TBExproNode,_ t2: TBExproNode) {
        super.init()
        self.t1 = t1
        self.t2 = t2
    }
    
    override func visit(data: inout [String: Entry]) -> Entry {
        let eval: [Double] = t1?.visit(data: &data).getEntry() as! [Double]
        let entry : Entry = buildEntry(data: data)
        let entry2: Entry = (t2?.visit(data: &data))!
        let start: Int = locateBadPointIndex(points: eval)
        let timePeriod: Int = Int(getValueByIndex(index: start, t2Entry: entry2))
        
        var res: [Double] = (entry.object)!
        var sum: Double = 0
        var count: Int = 0
        
        for i in 0..<start {
            res[i] = badPoint
        }
        
        var i = start
        while (i < (start + timePeriod) && i < eval.count) {
            sum += eval[i]
            count++
            res[i] = Double(badPoint)
            i += 1
        }
        
        i = start + timePeriod
        while i < eval.count {
            
            sum += eval[i]
            count++
            if (count > timePeriod && timePeriod != 0) {
                count -= 1
                let diff = i - count
                sum -= eval[diff]
            }
            res[i] = sum
            i += 1
            
        }
        entry.object = res
        return entry
        
    }
    
}
