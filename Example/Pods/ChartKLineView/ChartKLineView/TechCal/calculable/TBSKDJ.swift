//
//  TBSKDJ.swift
//  TBMixedChartView
//
//  Created by 骆鹏飞 on 2019/11/18.
//  Copyright © 2019 luopengfei. All rights reserved.
//

import UIKit

class TBSKDJ: NSObject, TBCalculable {
    let code: String = "LOWV:=LLV(LOW,N);\n" + "HIGHV:=HHV(HIGH,N);\n" + "RSV:=EMA((CLOSE-LOWV)/(HIGHV-LOWV)*100,M);\n" +
             "K:EMA(RSV,M);\n" + "D:MA(K,M);\n" +
        "a:N1;\n" + "b:N2;\n" + "c:N3;"
        
        func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
    //        let param: [Int] = <#value#>
            /// TODO: 指标范围添加
            data["M"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 1, key: "SKDJ"))
            data["N"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "SKDJ"))
            data["N1"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 2, key: "SKDJ"))
            data["N2"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 3, key: "SKDJ"))
            data["N3"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 4, key: "SKDJ"))
            return TBCalcUtils.run(code: code, data: &data)
        }
}
