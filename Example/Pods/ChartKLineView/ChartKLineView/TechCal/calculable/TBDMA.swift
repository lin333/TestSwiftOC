//
//  TBDMA.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/12/8.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBDMA:  NSObject, TBCalculable {
    
    let code: String = "DDD:MA(CLOSE,M1) - MA(CLOSE,M2);\n" + "AMA:MA(DDD,M1);"
    
    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
        data["M1"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "DMA"))
        data["M2"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 1, key: "DMA"))
        return TBCalcUtils.run(code: code, data: &data)
        
    }
}
