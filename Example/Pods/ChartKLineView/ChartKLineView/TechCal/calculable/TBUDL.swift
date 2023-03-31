//
//  TBUDL.swift
//  TBMixedChartView
//
//  Created by 骆鹏飞 on 2019/11/18.
//  Copyright © 2019 luopengfei. All rights reserved.
//

import UIKit
//import TBSwiftComponent

class TBUDL: NSObject, TBCalculable {
    let code: String = "UDL:(MA(CLOSE,N1)+MA(CLOSE,N2)+MA(CLOSE,N3)+MA(CLOSE,N4))/4;\n" + "MAUDL:MA(UDL,M);\n"
        
    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
    //        let param: [Int] = <#value#>
            /// TODO: 指标范围添加
        data["N1"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "UDL"))
        data["N2"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 1, key: "UDL"))
        data["N3"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 2, key: "UDL"))
        data["N4"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 3, key: "UDL"))

        data["M"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 4, key: "UDL"))

        return TBCalcUtils.run(code: code, data: &data)
    }
}
