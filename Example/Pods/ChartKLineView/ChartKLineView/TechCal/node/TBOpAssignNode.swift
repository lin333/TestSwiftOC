//
//  TBOpAssignNode.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/11/24.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBOpAssignNode: TBExproNode {
    var l: TBExproNode?
    var r: TBExproNode?
    var op: String = ""
    
    public init(_ l: TBExproNode,_ r: TBExproNode,_ op: String) {
        super.init()
        self.l = l
        self.r = r
        self.op = op
    }
    
    override func visit(data: inout [String: Entry]) -> Entry {

        let eval: [Double] = l?.visit(data: &data).getEntry() as! [Double]
        let eval2: [Double] = r?.visit(data: &data).getEntry() as! [Double]
        let entry: Entry = buildEntry(data: data)
        var res: [Double] = entry.object!
        var i = 0
        let opt = operation(op)
        if opt != nil {
            while i < res.count {
                res[i] = opt!(eval[i], eval2[i])
                i += 1
            }
        }

        
        entry.object = res
        return entry
    }
}
