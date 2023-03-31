//
//  TBNumberNode.swift
//  Stock
//
//  Created by luopengfei on 2018/4/25.
//  Copyright © 2018年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBNumberNode: TBExproNode {

    var val: Double = Double(0.0)
    
    public init(_ val: Double) {
        super.init()
        self.val = val
    }
    
    
    override func visit(data: inout [String: Entry]) -> Entry {
        return buildConstantEntry(data: val)
    }
    
}
