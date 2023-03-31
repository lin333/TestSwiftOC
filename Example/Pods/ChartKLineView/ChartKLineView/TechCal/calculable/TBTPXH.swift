//
//  TBTPXH.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/12/8.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBTPXH: NSObject, TBCalculable {
    let code: String = "VAR1:=HHV(HIGH,N);\n" +
        "VAR2:=LLV(LOW,N);\n" +
        "阻力线:EMA((CLOSE-VAR2)/(VAR1-VAR2),21)-0.5;\n" +
        "操作线:EMA((CLOSE-VAR2)/(VAR1-VAR2),5)-0.5;" +
    "红绿棒:(操作线-阻力线),COLORSTICK;"
    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
        data["N"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "TPXH"))
        return TBCalcUtils.run(code: code, data: &data)
    }
    
}
