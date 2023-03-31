//
//  ADTM.swift
//  TBCharts
//
//  Created by JustLee on 2021/2/22.
//

import UIKit

class TBADTM: NSObject, TBCalculable {
    let code =
        "DTM:=IF(OPEN<=REF(OPEN,1),0,MAX((HIGH-OPEN),(OPEN-REF(OPEN,1))));" +
        "DBM:=IF(OPEN>=REF(OPEN,1),0,MAX((OPEN-LOW),(OPEN-REF(OPEN,1))));" +
        "STM:=SUM(DTM,P);SBM:=SUM(DBM,P);" +
        "ADTM:IF(STM>SBM,(STM-SBM)/STM,IF(STM==SBM,0,(STM-SBM)/SBM));" +
        "MA1:MA(ADTM,N);"
    
    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
        data["P"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "ADTM"))
        data["N"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 1, key: "ADTM"))
        return TBCalcUtils.run(code: code, data: &data)
    }
}
