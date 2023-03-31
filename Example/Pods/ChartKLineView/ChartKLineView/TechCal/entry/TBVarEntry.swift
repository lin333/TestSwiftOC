//
//  TBVarEntry.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/11/22.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBVarEntry: Entry {
    private var name: String?
    public init(name: String) {
        super.init(object: [Double]())
        self.name = name
    }
    
    override func isVarName() -> Bool {
         return true
    }
    
    override func getEntry() -> Any {
        return name!
    }
}
