//
//  TBCalculator.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/12/8.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

private let shareCalculator: TBCalculator = TBCalculator()
open class TBCalculator: NSObject {

    @objc public class var shareInstance: TBCalculator {
        return shareCalculator
    }
    
    private var _calculable: [TBIndexType: TBCalculable] =  [TBIndexType.MACD: TBMACD(),
                                                             TBIndexType.EMA: TBEMA(),
                                                             TBIndexType.BOLL: TBBOLL(),
                                                             TBIndexType.BBI: TBBBI(),
                                                             TBIndexType.HMA: TBHMA(),
                                                             TBIndexType.LMA: TBLMA(),
                                                             TBIndexType.VMA: TBVMA(),
                                                             TBIndexType.BBIBOLL: TBBBIBOLL(),
                                                             TBIndexType.ALLIGAT: TBALLIGAT(),
                                                             TBIndexType.PBX: TBPBX(),
                                                             TBIndexType.ENE: TBENE(),
                                                             TBIndexType.MIKE: TBMIKE(),
                                                             TBIndexType.XT: TBXT(),
                                                             TBIndexType.JAX: TBJAX(),
                                                             TBIndexType.KDJ: TBKDJ(),
                                                             TBIndexType.RSI: TBRSI(),
                                                             TBIndexType.OBV: TBOBV(),
                                                             TBIndexType.WR: TBWR(),
                                                             TBIndexType.ARBR: TBARBR(),
                                                             TBIndexType.EMV: TBEMV(),
                                                             TBIndexType.DMA: TBDMA(),
                                                             TBIndexType.DMI: TBDMI(),
                                                             TBIndexType.MA: TBMA(),
                                                             TBIndexType.VR: TBVR(),
                                                             TBIndexType.TPXH: TBTPXH(),
                                                             TBIndexType.SAR: TBSAR(),
                                                             TBIndexType.MFI: TBMFI(),
                                                             TBIndexType.CCI: TBCCI(),
                                                             TBIndexType.ATR: TBATR(),
                                                             TBIndexType.TRIX: TBTRIX(),
                                                             
                                                             TBIndexType.BIAS : TBBIAS(),
                                                             TBIndexType.DKX : TBDKX(),
                                                             TBIndexType.PCNT : TBPCNT(),
                                                             TBIndexType.ROC : TBROC(),
                                                             TBIndexType.SKDJ : TBSKDJ(),
                                                             TBIndexType.UDL : TBUDL(),
                                                             TBIndexType.VRSI : TBVRSI(),
                                                             TBIndexType.WAD : TBWAD(),
                                                             TBIndexType.XS : TBXS(),
                                                             TBIndexType.ZigZag: TBZigZag(),
                                                             TBIndexType.MTM: TBMTM(),
                                                             TBIndexType.ADTM: TBADTM(),
                                                             TBIndexType.CR: TBCR(),
                                                             TBIndexType.WVAD: TBWVAD()
                                                             
    ]
    
    private var _cache: [TBIndexType: TBResultCache] = [TBIndexType: TBResultCache]()
    
    
    public override init() {
        super.init()
    }
    
    public func clearCache() {
        _cache.removeAll()
    }
    
    public func getMAParamState() -> [Int] {
        return TBMA.PARAMS_STATE
    }
    
    
    
    public func calculateWithCode(type: TBIndexType, entries: [CandleChartDataEntry]) -> [TBResultEntry] {
        if entries.isEmpty {
            return [TBResultEntry]()
        }
        let other = getCacheCode(type: type, entries: entries)
        let resultCache = _cache[type]
        if (resultCache != nil) && resultCache?.validCode == other {
            guard let res = (resultCache?.res) else {
                return [TBResultEntry]()
            }
            return res
        } else {
            var res = prepareData(entries: entries)
            guard let res = (_calculable[type]?.calculate(data: &res)) else { return [TBResultEntry]() }
            _cache[type] = TBResultCache(res: res, validCode: other)
            return res
        }
    }
    
    public func getCacheCode(type: TBIndexType, entries: [ChartDataEntry]) -> String {
        var hasCode: Int = Int(1)
        if (entries.count > 10) {
            for i in (entries.count)..<entries.count {
                let e: ChartDataEntry = entries[i]
                hasCode = 31 * hasCode +  e.hashValue
            }
        } else {
            /// entries hashvalue
            hasCode = entries.count
        }
        return TBIndexType.getType(type: type) + "\(entries.count)" + "\(hasCode)"
    }
    
    @discardableResult private func prepareData(entries: [CandleChartDataEntry]) -> [String: Entry] {
        var data: [String: Entry] = [String: Entry]()
        var high: [Double] = [Double](repeating: 0, count: entries.count)
        var open: [Double] = [Double](repeating: 0, count: entries.count)
        var low:  [Double] = [Double](repeating: 0, count: entries.count)
        var vol:  [Double] = [Double](repeating: 0, count: entries.count)
        var close: [Double] = [Double](repeating: 0, count: entries.count)
        
         var i = 0
        while i < entries.count {
            let candleEntry: CandleChartDataEntry = entries[i]
            high[i] = candleEntry.high
            open[i] = candleEntry.open
            low[i]  = candleEntry.low
            vol[i]  = candleEntry.volume
            close[i] = candleEntry.close
            
            i += 1
        }
        
        data["high"] = Entry(object: high)
        data["open"] = Entry(object: open)
        data["low"]  = Entry(object: low)
        data["vol"]  = Entry(object: vol)
        data["close"] = Entry(object: close)
        data["DRAWNULL"] = Entry(object: close)
        return data
        
    }
    
    public func calculate(type: TBIndexType, entries: [CandleChartDataEntry], start: Int, end: Int) {
        if (_calculable.keys.contains(type)) {
            var res = prepareData(entries: entries)
            _calculable[type]?.calculate(data: &res)
        }
    }
    
}


protocol TBCalculable {
    @discardableResult func calculate(data: inout [String: Entry]) -> [TBResultEntry]
}


/// 用于指标计算算法中回调接口，如 RSI,EMA 等
protocol TBIndexCallable {
    func setValue(index: Int, val: Double)
}

private class TBResultCache: NSObject {
    public var res: [TBResultEntry]?
    public var validCode: String?
    
    public init(res: [TBResultEntry], validCode: String) {
        super.init()
        self.res = res
        self.validCode = validCode
    }
}
