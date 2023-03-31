//
//  TBHMA.swift
//  TBMixedChartView
//
//  Created by 骆鹏飞 on 2019/12/2.
//  Copyright © 2019 luopengfei. All rights reserved.
//

import UIKit

class TBHMA: NSObject, TBCalculable {

    let code: String = "HMA1:MA(HIGH,M1);HMA2:MA(HIGH,M2);HMA3:MA(HIGH,M3);HMA4:MA(HIGH,M4);HMA5:MA(HIGH,M5);"
    
    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
        data["M1"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "HMA"))
        data["M2"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 1, key: "HMA"))
        data["M3"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 2, key: "HMA"))
        data["M4"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 3, key: "HMA"))
        data["M5"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 4, key: "HMA"))

        return TBCalcUtils.run(code: code, data: &data)
    }
}
