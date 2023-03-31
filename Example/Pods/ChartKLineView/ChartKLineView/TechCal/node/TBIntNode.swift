//
//  TBIntNode.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/11/24.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBIntNode: TBExproNode {
    var val: Double = Double(0.0)
    public init(name: String) {
        super.init()
        self.val = name.toDouble()!
    }
    
    override func visit(data: inout [String : Entry]) -> Entry {
        let entry: Entry = buildEntry(data: data)
        var res: [Double] = entry.getEntry() as! [Double]
        
        var i = 0
        while  i < res.count {
            res[i] = val
            i += 1
        }

        entry.object = res
        return entry
        
    }
}
