//
//  TBMACD.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/12/8.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBMACD: NSObject, TBCalculable {
    let code: String = "DIF:(EMA(CLOSE,N1)-EMA(CLOSE,N2));\n" +
        "DEA:EMA(DIF,N3);\n" +
    "MACD:(DIF-DEA)*2,COLORSTICK;"
    
    public func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
        data["N1"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "MACD"))
        data["N2"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 1, key: "MACD"))
        data["N3"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 2, key: "MACD"))
        return TBCalcUtils.run(code: code, data: &data)
    }

}
