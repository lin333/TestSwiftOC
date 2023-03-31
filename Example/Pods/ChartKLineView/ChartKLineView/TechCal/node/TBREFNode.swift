//
//  TBREFNode.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/11/24.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBREFNode: TBExproNode {
    var lhs: TBExproNode?
    var num: TBExproNode?
    public init(_ lhs: TBExproNode,_ num: TBExproNode) {
        super.init()
        self.lhs = lhs
        self.num = num
    }
    
    override func visit(data: inout [String: Entry]) -> Entry {
        let varByType: [Double] = lhs?.visit(data: &data).getEntry() as! [Double]
        let entry: Entry = buildEntry(data: data)
        var res: [Double] = entry.getEntry() as! [Double]
        if res.count == 0 {
            res = [Double](repeating: 0.0, count: varByType.count)
        }
        let nums: Entry = (num?.visit(data: &data))!
        start = locateBadPointIndex(points: varByType)
        if nums.isConstant() {
            let value = nums.getEntry()
            if value is Double {
                let tmpValue = value as! Double
                start = Int(tmpValue)
            } else {
                start = nums.getEntry() as! Int
            }
        }
        else {
            let tmp: [Double] = (nums.object)!
            if start < tmp.count {
                start = Int(tmp[start])
            }
        }
        
        let length: Int = varByType.count - start
        if length > 0 {
            var i = start
            while i < varByType.count {
                 res[i] = varByType[i - start]
                i += 1
            }
            
            i = 0
            while i < start && i < res.count {
                res[i] = badPoint
                i += 1
            }
        }
        entry.object = res
        return entry
        
        
    }
}
