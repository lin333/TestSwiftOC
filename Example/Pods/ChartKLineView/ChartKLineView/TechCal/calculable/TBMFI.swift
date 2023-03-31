//
//  TBMFI.swift
//  Stock
//
//  Created by luopengfei on 2018/4/26.
//  Copyright © 2018年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBMFI: NSObject, TBCalculable {
    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
        
        data["N"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "MFI"))
        data["N1"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 1, key: "MFI"))
        data["N2"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 2, key: "MFI"))
        return TBCalcUtils.run(code: code, data: &data)
    }
    

    let code: String = "TYP := (HIGH + LOW + CLOSE)/3;\n" +
        "V1:=SUM(IF(TYP>REF(TYP,1),TYP*VOL,0),N)/SUM(IF(TYP<REF(TYP,1),TYP*VOL,0),N);\n" + "MFI:100-(100/(1+V1));\n" +
        "a:N1;\n" + "b:N2;"
}
