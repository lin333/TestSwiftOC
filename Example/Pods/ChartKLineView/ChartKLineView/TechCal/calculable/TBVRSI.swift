//
//  TBVRSI.swift
//  TBMixedChartView
//
//  Created by 骆鹏飞 on 2019/11/18.
//  Copyright © 2019 luopengfei. All rights reserved.
//

import UIKit

class TBVRSI: NSObject, TBCalculable {
    let code: String = "LC:=REF(VOL,1);\n" + "RSI$1:SMA(MAX(VOL-LC,0),N1,1)/SMA(ABS(VOL-LC),N1,1)*100;\n" +
    "RSI$2:SMA(MAX(VOL-LC,0),N2,1)/SMA(ABS(VOL-LC),N2,1)*100;\n" +
    "RSI$3:SMA(MAX(VOL-LC,0),N3,1)/SMA(ABS(VOL-LC),N3,1)*100;\n"

        
    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
    //        let param: [Int] = <#value#>
            /// TODO: 指标范围添加
        data["N1"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "VRSI"))
        data["N2"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 1, key: "VRSI"))
        data["N3"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 2, key: "VRSI"))
        return TBCalcUtils.run(code: code, data: &data)
    }
}
