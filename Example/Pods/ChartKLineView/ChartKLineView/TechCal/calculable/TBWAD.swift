//
//  TBWAD.swift
//  TBMixedChartView
//
//  Created by 骆鹏飞 on 2019/11/18.
//  Copyright © 2019 luopengfei. All rights reserved.
//

import UIKit

class TBWAD: NSObject, TBCalculable {
    let code: String =  "MIDA:=CLOSE-MIN(REF(CLOSE,1),LOW);\n" + "MIDB:=IF(CLOSE<REF(CLOSE,1),CLOSE-MAX(REF(CLOSE,1),HIGH),0);\n" +
             "WAD:SUM(IF(CLOSE>REF(CLOSE,1),MIDA,MIDB),0);\n" + "MAWAD:MA(WAD,M);\n"
        
    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
        /// TODO: 指标范围添加
        data["M"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "WAD"))
        return TBCalcUtils.run(code: code, data: &data)
    }
}
