//
//  TBRSI.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/12/8.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBRSI: NSObject, TBCalculable {
    let code: String = "LC:=REF(CLOSE,1);\n" +
        "RSI$1:SMA(MAX(CLOSE-LC,0),N1,1)/SMA(ABS(CLOSE-LC),N1,1)*100;\n" +
        "RSI$2:SMA(MAX(CLOSE-LC,0),N2,1)/SMA(ABS(CLOSE-LC),N2,1)*100;\n" +
        "RSI$3:SMA(MAX(CLOSE-LC,0),N3,1)/SMA(ABS(CLOSE-LC),N3,1)*100;" +
        "a:N4;\n" + "b:N5;\n" + "c:N6;"
    
    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
        data["N1"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "RSI"))
        data["N2"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 1, key: "RSI"))
        data["N3"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 2, key: "RSI"))
        data["N4"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 3, key: "RSI"))
        data["N5"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 4, key: "RSI"))
        data["N6"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 5, key: "RSI"))

        return TBCalcUtils.run(code: code, data: &data)
    }
    
}
