//
//  TBMINNode.swift
//  TBMixedChartView
//
//  Created by 骆鹏飞 on 2019/11/18.
//  Copyright © 2019 luopengfei. All rights reserved.
//

import UIKit

class TBMINNode: TBExproNode {
    var t1: TBExproNode?
    var t2: TBExproNode?
    
    public init(_ t1: TBExproNode,_ t2: TBExproNode) {
        super.init()
        self.t1 = t1
        self.t2 = t2
    }
    
    override func visit(data: inout [String: Entry]) -> Entry {
        let eval1 = t1?.visit(data: &data)
        let eval2 = t2?.visit(data: &data)
        
        let entry: Entry = buildEntry(data: data)
        var res: [Double] = entry.object!
        var i = 0
        while  i < res.count {
            res[i] = min(getValueByIndex(index: i, t2Entry: eval1!), getValueByIndex(index: i, t2Entry: eval2!))
            i+=1
        }
       
        entry.object = res
        return entry
    }
}
