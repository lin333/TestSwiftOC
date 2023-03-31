//
//  TBEMA.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/12/8.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBEMA:  NSObject, TBCalculable {
    static var code: String = "EMA$1:EMA(CLOSE,N1);" + "EMA$2:EMA(CLOSE,N2);" + "EMA$3:EMA(CLOSE,N3);" + "EMA$4:EMA(CLOSE,N4);"
    static let base: NSString = "EMANNUM:EMA(CLOSE,NNUM);"
    public static var PARAMS_STATE: [Int] = [Int]()
    
    
    
    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
        TBEMA.updateCode()
        return TBCalcUtils.run(code: TBEMA.code, data: &data)
    }
    
    public static func updateCode() {
        let array = TBStockTechParams.indicatorValues(forKey: "EMA")

        if (PARAMS_STATE.isEmpty) || PARAMS_STATE.count != array.count {
            let count = array.count
            PARAMS_STATE = [Int](repeating: 0, count: count)
        }
        var s = String()
        var i = 0
        while i < array.count {
            let j = array[i]
            s.append(base.replacingOccurrences(of: "NNUM", with: "\(j ?? 0)"))
            i += 1
        }
        code = s
    }
    
}
