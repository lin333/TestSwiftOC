//
//  TBParamEntry.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/11/22.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBParamEntry: Entry {
    private var value: Int = Int(0)
    
    public init(value: Int) {
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
