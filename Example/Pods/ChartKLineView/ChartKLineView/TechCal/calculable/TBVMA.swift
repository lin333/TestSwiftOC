//
//  TBVMA.swift
//  TBMixedChartView
//
//  Created by 骆鹏飞 on 2019/12/2.
//  Copyright © 2019 luopengfei. All rights reserved.
//

import UIKit

class TBVMA: NSObject, TBCalculable {
    let code: String = "VV:=(HIGH+OPEN+LOW+CLOSE)/4;VMA1:MA(VV,M1);VMA2:MA(VV,M2);VMA3:MA(VV,M3);VMA4:MA(VV,M4);VMA5:MA(VV,M5);"
    
    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
        data["M1"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "VMA"))
        data["M2"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 1, key: "VMA"))
        data["M3"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 2, key: "VMA"))
        data["M4"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 3, key: "VMA"))
        data["M5"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 4, key: "VMA"))
        
        return TBCalcUtils.run(code: code, data: &data)
    }
}
