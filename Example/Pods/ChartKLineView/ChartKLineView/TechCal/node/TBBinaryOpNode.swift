//
//  TBBinaryOpNode.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/11/24.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBBinaryOpNode: TBExproNode {
    private var l: TBExproNode?
    private var r: TBExproNode?
    private var op: String = ""
    public init(_ l: TBExproNode,_ r: TBExproNode,_ op: String) {
        super.init()
        self.l = l
        self.r = r
        self.op = op
    }
    
    override func visit(data: inout [String: Entry]) -> Entry {        
        let entryL = l?.visit(data: &data)
        let entryR = r?.visit(data: &data)
        
        let eval: [Double] = (entryL?.isConstant())! ? [Double]() : (entryL?.object!)!
        let eval2: [Double] = (entryR?.isConstant())! ? [Double]() : (entryR?.object!)!
        
        let entry = buildEntry(data: data)
        var res = entry.getEntry() as! [Double]
        
        let start: Int = max(locateBadPointIndex(points: eval), locateBadPointIndex(points: eval2))
        
        var i = 0
        
        let opt = operation(op)
        if opt != nil {
            
            while  i < res.count {
                if (i < start) {
                    res[i] = Double(badPoint)
                    i += 1
                    continue
                }
                let leftVal: Double = getValueByIndex(index: i, t2Entry: entryL!)
                let rightVal: Double = getValueByIndex(index: i, t2Entry: entryR!)
                res[i] = opt!(leftVal, rightVal)
                i += 1
            }
        }
        entry.object = res
        return entry
    }
    
}
