//
//  TBResultEntry.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/11/22.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

open class TBResultEntry: Entry {
    public var name: String?
    public init(name: String, object: [Double], decorations: [TBDecoration]) {
        super.init(object: object)
        self.isResult = true
        self.name = name
        self.decorations = decorations
    }
    
    public func getName() -> String {
        return name!
    }
    
    override public func getEntry() -> Any {
        return self.object as Any
    }
    
    public func getDecorations() -> [TBDecoration] {
        return self.decorations
    }
    
    
}
