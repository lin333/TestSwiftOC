//
//  TBConstantEntry.swift
//  Stock
//
//  Created by luopengfei on 2018/4/25.
//  Copyright © 2018年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBConstantEntry: Entry {
    private var value: Double = Double(0)
    
    @objc public init(value: Double) {
        super.init(object: [Double]())
        self.value = value
    }
    
    public override func getEntry() -> Any {
        return value
    }
    
    override func isConstant() -> Bool {
        return true
    }
}
