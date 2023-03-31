//
//  TBMTM.swift
//  TBCharts
//
//  Created by JustLee on 2021/2/22.
//

import UIKit

class TBMTM: NSObject, TBCalculable {
    let code = "MTM:CLOSE-REF(CLOSE,N);" +
        "MTMMA:MA(MTM,M);"

    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
        data["N"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "MTM"))
        data["M"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 1, key: "MTM"))
        return TBCalcUtils.run(code: code, data: &data)
    }
    
}
