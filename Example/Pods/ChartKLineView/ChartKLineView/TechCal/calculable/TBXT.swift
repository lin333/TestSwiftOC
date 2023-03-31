//
//  TBXT.swift
//  TBMixedChartView
//
//  Created by 骆鹏飞 on 2019/12/2.
//  Copyright © 2019 luopengfei. All rights reserved.
//

import UIKit

class TBXT: NSObject, TBCalculable {
    let code: String = "【箱顶】:PEAK(CLOSE,N,1)*0.98;【箱底】:TROUGH(CLOSE,N,1)*1.02;【箱高】:100*(【箱顶】-【箱底】)/【箱底】,NODRAW;"
    
    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
        data["N"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "XT"))
        return TBCalcUtils.run(code: code, data: &data)
    }
}
