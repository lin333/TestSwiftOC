//
//  TBLMA.swift
//  TBMixedChartView
//
//  Created by 骆鹏飞 on 2019/12/2.
//  Copyright © 2019 luopengfei. All rights reserved.
//

import UIKit

class TBLMA: NSObject, TBCalculable {
    let code: String = "LMA1:MA(LOW,M1);LMA2:MA(LOW,M2);LMA3:MA(LOW,M3);LMA4:MA(LOW,M4);LMA5:MA(LOW,M5);"
    
    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
        data["M1"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "LMA"))
        data["M2"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 1, key: "LMA"))
        data["M3"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 2, key: "LMA"))
        data["M4"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 3, key: "LMA"))
        data["M5"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 4, key: "LMA"))

        return TBCalcUtils.run(code: code, data: &data)
    }
}
