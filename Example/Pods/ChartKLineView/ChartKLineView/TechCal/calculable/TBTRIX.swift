//
//  TBTRIX.swift
//  Stock
//
//  Created by luopengfei on 2018/6/29.
//  Copyright © 2018年 com.tigerbrokers. All rights reserved.
//

import UIKit
// https://baike.baidu.com/item/TRIX%E6%8C%87%E6%A0%87/8308583?fr=aladdin
class TBTRIX: NSObject, TBCalculable {
    let code: String = "TR:=EMA(EMA(EMA(CLOSE,N),N),N);\n" + "TRIX:(TR-REF(TR,1))/REF(TR,1)*100;\n" +
    "TRMA:MA(TRIX,M);"
    
    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
//        let params = TBStockTechParams.indicatorValues(forKey: "TRIX")
        data["N"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "TRIX"))
        data["M"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 1, key: "TRIX"))
        return TBCalcUtils.run(code: code, data: &data)
    }
}
