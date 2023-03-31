//
//  TBXS.swift
//  TBMixedChartView
//
//  Created by 骆鹏飞 on 2019/11/18.
//  Copyright © 2019 luopengfei. All rights reserved.
//

import UIKit

class TBXS: NSObject, TBCalculable {
    let code: String = "VAR2:=CLOSE*VOL;\n" + "VAR3:=EMA((EMA(VAR2,3)/EMA(VOL,3)+EMA(VAR2,6)/EMA(VOL,6)+EMA(VAR2,12)/EMA(VOL,12)+EMA(VAR2,24)/EMA(VOL,24))/4,N);\n" + "SUP:1.06*VAR3;\n" + "SDN:VAR3*0.94;\n" + "VAR4:=EMA(CLOSE,9);\n" + "LUP:EMA(VAR4*1.14,5);\n" + "LDN:EMA(VAR4*0.86,5);\n"

        
    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
        data["N"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "XS"))
        return TBCalcUtils.run(code: code, data: &data)
    }
}
