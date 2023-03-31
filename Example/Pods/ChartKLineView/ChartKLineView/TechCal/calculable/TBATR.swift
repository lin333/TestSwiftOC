//
//  TBATR.swift
//  Stock
//
//  Created by luopengfei on 2018/6/29.
//  Copyright © 2018年 com.tigerbrokers. All rights reserved.
//

import UIKit
// https://jingyan.baidu.com/article/eae07827babda51fec54853c.html
class TBATR: NSObject, TBCalculable {
    
    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
        data["N"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "ATR"))
        return TBCalcUtils.run(code: code, data: &data)
    }
    
    let code: String = "TR:MAX(MAX((HIGH-LOW),ABS(REF(CLOSE,1)-HIGH)),ABS(REF(CLOSE,1)-LOW));\n" +
    "ATR:MA(TR,N);"
    
}
