//
//  TBBOLL.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/12/8.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBBOLL:  NSObject, TBCalculable {
    let code: String = "MID:MA(CLOSE,N);\n" +
        "UPPER:MID + P*STD(CLOSE,N);\n" +
    "LOWER:MID - P*STD(CLOSE,N);"
    
    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
        data["N"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "BOLL"))
        data["P"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 1, key: "BOLL"))
        return TBCalcUtils.run(code: code, data: &data)
        
    }
}
