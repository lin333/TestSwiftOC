//
//  TBALLIGAT.swift
//  TBMixedChartView
//
//  Created by 骆鹏飞 on 2019/12/2.
//  Copyright © 2019 luopengfei. All rights reserved.
//

import UIKit

class TBALLIGAT: NSObject, TBCalculable {
    
    let code: String = "NN:=(HIGH+LOW)/2;Lips:REF(MA(NN,5),3),COLOR40FF40;Teeth:REF(MA(NN,8),5),COLOR0000C0;Jaw:REF(MA(NN,13),8),COLORFF4040;"

    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
//        data["N"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "BBIBOLL"))
        return TBCalcUtils.run(code: code, data: &data)
    }
}
