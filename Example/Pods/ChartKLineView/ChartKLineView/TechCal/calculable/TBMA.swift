//
//  TBMA.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/12/8.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBMA: NSObject, TBCalculable {
    static var code: String = "MA$1:MA(CLOSE,N1);" + "MA$2:MA(CLOSE,N2);" + "MA$3:MA(CLOSE,N3);" + "MA$4:MA(CLOSE,N4);"
    static let base: NSString = "MANNUM:MA(CLOSE,NNUM);"
    public static var PARAMS_STATE: [Int] = [Int]()
    
    
    
    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
        TBMA.updateCode()
        return TBCalcUtils.run(code: TBMA.code, data: &data)
    }
    
    public static func updateCode() {
        let array = TBStockTechParams.indicatorValues(forKey: "MA")

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
