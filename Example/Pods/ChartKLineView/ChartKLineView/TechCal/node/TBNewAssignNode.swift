//
//  TBNewAssignNode.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/11/24.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBNewAssignNode: TBExproNode {
    var lhs: TBExproNode?
    var rhs: TBExproNode?
    
    public init(_ lhs: TBExproNode,_ rhs: TBExproNode) {
        super.init()
        self.lhs = lhs
        self.rhs = rhs
    }
    
    public override func visit(data: inout [String: Entry]) -> Entry {
        let value: Entry = (rhs?.visit(data: &data))!
        let key: String = lhs?.visit(data: &data).getEntry() as! String
        data[key] = value
        return value
    }
    
    public func evalE(data: inout [String: Entry], i: Int) -> Entry {
        
        var valL: [Double] = lhs?.visit(data: &data).getEntry() as! [Double]
        let entry = rhs?.visit(data: &data)
        valL[i] = getValueByIndex(index: i, t2Entry: entry!)
        return entry!
    }
}
