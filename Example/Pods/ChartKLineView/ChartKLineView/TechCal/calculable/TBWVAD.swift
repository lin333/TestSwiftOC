//
//  TBWVAD.swift
//  TBCharts
//
//  Created by JustLee on 2021/2/22.
//

import UIKit

class TBWVAD: NSObject, TBCalculable {
    let code =
        "WVAD:(CLOSE-OPEN)/(HIGH-LOW)*VOL;"

    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
        return TBCalcUtils.run(code: code, data: &data)
    }
}
