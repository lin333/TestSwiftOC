//
//  TBCR.swift
//  TBCharts
//
//  Created by JustLee on 2021/2/22.
//

import UIKit

class TBCR: NSObject, TBCalculable {
    let code = "MID:=(HIGH+LOW+CLOSE)/3;" +
        "CR:SUM(MAX(0,HIGH-REF(MID,1)),N)/SUM(MAX(0,REF(MID,1)-LOW),N)*100;" +
        "MA1:REF(MA(CR,M1),M1/2.5+1);" +
        "MA2:REF(MA(CR,M2),M2/2.5+1);" +
        "MA3:REF(MA(CR,M3),M3/2.5+1);"
    
    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
        data["N"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "CR"))
        data["M1"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 1, key: "CR"))
        data["M2"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 2, key: "CR"))
        data["M3"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 3, key: "CR"))

        return TBCalcUtils.run(code: code, data: &data)
    }
}
