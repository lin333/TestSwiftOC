//
//  TBDMI.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/12/8.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBDMI:  NSObject, TBCalculable {
    let code: String = "TR := SUM(MAX(MAX(HIGH-LOW,ABS(HIGH-REF(CLOSE,1))),ABS(LOW-REF(CLOSE,1))),N);\n" +
        "HD := HIGH-REF(HIGH,1);\n" +
        "LD := REF(LOW,1)-LOW;\n" +
        "DMP:= SUM(IF(HD>0 AND HD>LD,HD,0),N);\n" +
        "DMM:= SUM(IF(LD>0 AND LD>HD,LD,0),N);\n" +
        "PDI:DMP*100/TR;\n" +
        "MDI:DMM*100/TR;\n" +
        "ADX:MA(ABS(MDI-PDI)/(MDI+PDI)*100,M);\n" +
    "ADXR:(ADX+REF(ADX,M))/2;"
    
    
    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {

        data["N"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "DMI"))
        data["M"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 1, key: "DMI"))
        return TBCalcUtils.run(code: code, data: &data)
    }
}
