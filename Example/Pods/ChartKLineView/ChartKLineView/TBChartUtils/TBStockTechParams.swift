//
//  TBStockTechParams.swift
//  TBMixedChartView
//
//  Created by luopengfei on 2018/10/8.
//  Copyright © 2018年 luopengfei. All rights reserved.
//

import UIKit

///UserDefaults
extension UserDefaults {
    class func tb_valueForKey(forKey: String) -> Any? {
        guard let value = UserDefaults.standard.object(forKey: forKey) else {
            return nil
        }
        return value
    }
    
    class func tb_setObject(_ object: Any?, key: String) {
        UserDefaults.standard.set(object, forKey: key)
        UserDefaults.standard.synchronize()
    }
}


extension FileManager {
    class func tb_cachePath(forKey: String) -> String {
         let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as [String]
         var path : String = ""
         if paths.count > 0 {
             path = paths[0]
         }
         let archiverPath = "\(path)/ConfigKeyedArchiverDirector"
         if !FileManager.default.fileExists(atPath: archiverPath) {
             do {
                 try
                     FileManager.default.createDirectory(atPath: archiverPath, withIntermediateDirectories: true, attributes: nil)
             }
             catch let err {
                 print(err)
                 return ""
             }
         }
         return "\(path)/\(forKey)"
     }
     
    class func tb_unarchiveObject(forKey: String) -> Any? {
        let filePath = tb_cachePath(forKey: forKey)
        if let cacheObject = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) {
            return cacheObject
        }

        return nil
     }
     
    class func tb_archive(_ object: Any?, forKey: String) {
        guard let cacheObject = object else {
            return;
        }
        let filePath = tb_cachePath(forKey: forKey)
        NSKeyedArchiver.archiveRootObject(cacheObject, toFile: filePath)
    }
}

///与之前的key保持一致
//private let KEY_CACHE_KLINE_INDICATORS = "userDefaultKeyLineIndicatorParamsDict";

/////////////////////////////////////************************************k线图技术指标缓存**********************************************////////////////////////////////

///缓存k线指标的字典
private let KEY_CACHE_KLINE_INDICATORS = "com.tbChart.cacheKLineIndicatorsKey";
private let KEY_CACHE_KLINE_INDICATORS_SETTING_VALUE = "com.tbChart.cacheKLineIndicatorsSettingValueKey";

private let mainColorArray = ["#FF6825", "#FBCA00", "#9F46F5", "#28A697","#447EFF","#E32B65", "#D53EEA", "#846CFF"]

/// 股票技术指标参数
open class TBStockTechParams: NSObject {
    
    private override init(){}
    
    /// 创建一个单例，将技术指标存在内存中，避免重复从磁盘读取技术指标数据
    static let manager = TBStockTechParams()
    
    ///json文件默认路径
    static let filePath = Bundle.main.path(forResource: "KLineIndicatorsSettings", ofType: "json")!
    
    ///用于缓存每个指标的参数设置
    var cacheKLineIndicatorsValues: [String: [Int]]?
    
    
    ///用于缓存k线的设置参数
    var cacheKLineIndicator: [String: [[String: Any]]]?
    
    ///解析k线的指标参数
    @objc open class var paramsDict: [String: [[String: Any]]] {
        return klineIndicatorParams()
    }
    
    ///获取指标的值设置
    @objc open class func indicatorValues(forKey: String) -> [Int] {
//        if let indicatorValues = paramsDict[forKey] {
//            return indicatorValues.filter {
//                return $0["selected"] as! Bool
//            }
//        }
//        return []
        let indicators: [Int] = TBChartKlineManager.fetchindicators(forKey).map {
            return $0 as! Int
        }
        return indicators
        
    }
    
    ///修改单例属性
    @objc open class func changeStockIndicatorParams(dic: [String: [[String: Any]]]) {
        if dic.count == 0 {
            manager.cacheKLineIndicator = nil
            return
        }
        
        manager.cacheKLineIndicator = dic
    }
    
    ///保存指标更新，顺便更新单例属性
    @objc open class func saveStockIndicatorParams(dic: [String: [[String: Any]]]) {
        FileManager.tb_archive(dic, forKey: KEY_CACHE_KLINE_INDICATORS)
        
        manager.cacheKLineIndicator = dic
    }
    
    ///取出缓存的k线指标
    @objc open class func klineIndicatorParams() -> [String: [[String: Any]]] {
        ///先从单例缓存里取
        if let cacheParameters = manager.cacheKLineIndicator {
            return cacheParameters
        }
 
        ///从文件里取
        if var cacheParameters = FileManager.tb_unarchiveObject(forKey: KEY_CACHE_KLINE_INDICATORS) as? [String: [[String: Any]]] {
            cacheParameters = modifyParameters(&cacheParameters)
            cacheParameters = fillIndicatorTypes(&cacheParameters)
            saveStockIndicatorParams(dic: cacheParameters)
            return cacheParameters
        }
        ///第三步取ud，如果是在ud里取到则存到文件里
        if var cacheObject =  UserDefaults.tb_valueForKey(forKey: KEY_CACHE_KLINE_INDICATORS) as? [String : [[String : Any]]] {
            cacheObject = modifyParameters(&cacheObject)
            cacheObject = fillIndicatorTypes(&cacheObject)
            saveStockIndicatorParams(dic: cacheObject)
            return cacheObject
        }
        saveStockIndicatorParams(dic: getDefaultParameters())
        
        return manager.cacheKLineIndicator!
    }
    

    ///指标设置的默认值
    ///
    open class func paramsCurrentValue(index: Int, key: String) -> Int {
        return TBChartKlineManager.fetchIndicator(at: index, key: key)
//        let params = TBStockTechParams.indicatorValues(forKey: key)
//        if let currentValue = params[index]["currentValue"] as? Int {
//            return currentValue
//        }
//        return 0
    }
//<<<<<<< HEAD
//
//    class func getDefaultParameters() -> [String: [[String: Any]]] {
//        let data = FileManager.default.contents(atPath: filePath)
//        let defaultParameters = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: [[String: Any]]]
//
//        return defaultParameters
//    }
//
//    class func fillIndicatorTypes(_ fillObject: inout [String: [[String: Any]]]) {
//        let defaultParameters = getDefaultParameters()
//
//        defaultParameters.forEach {
//            if fillObject[$0.key] == nil {
//                fillObject[$0.key] = $0.value
//            }
//        }
//    }
//
//=======
    
//    open class func doubleParamsCurrentValue(index: Int, key: String) -> Double {
//        let params = TBStockTechParams.indicatorValues(forKey: key)
//        if (index < params.count) {
//            let dic = params[index]
//            return dic["currentValue"] as! Double
//        }
//        return 0
//    }

    ///指标可变参数的默认值
    private class func techParameterSettingValues() -> [String: [Int]] {
        if let cacheIndicatorValues = manager.cacheKLineIndicatorsValues  {
            return cacheIndicatorValues
        }
        ///以前存在ud里面，做一遍补充
        if var cacheIndicatorValues = UserDefaults.tb_valueForKey(forKey: KEY_CACHE_KLINE_INDICATORS_SETTING_VALUE) as? [String: [Int]] {
            cacheIndicatorValues = fillIndicatorsValues(&cacheIndicatorValues)
            manager.cacheKLineIndicatorsValues = cacheIndicatorValues
            return cacheIndicatorValues
          }
        
        let defaultIndicatorValues = manager.defaultParametersValues
        manager.cacheKLineIndicatorsValues = defaultIndicatorValues
        
        return defaultIndicatorValues
    }
    
    fileprivate static var techMap: [String: Any] = [
        "name": "",
        "defaultValue": 0,
        "currentValue": 0,
        "color": "#ffffff",
        "selected": false,
        "maxValue": 0,
        "minValue": 0,
        "enableSelected": false
    ]
    
    private class func param(name: String, defaultValue: Int, currentValue: Int, color: String, selected: Bool, maxValue: Int, minValue: Int, enableSelected: Bool) -> [String: Any]
    {
        techMap["name"] = name
        techMap["defaultValue"] = defaultValue
        techMap["currentValue"] = currentValue
        techMap["color"] = color
        techMap["selected"] = selected
        techMap["maxValue"] = maxValue
        techMap["minValue"] = minValue
        techMap["enableSelected"] = enableSelected
        return techMap
    }
    
    private class func doubleParam(name: String, defaultValue: Double, currentValue: Double, color: String, selected: Bool, maxValue: Double, minValue: Double, enableSelected: Bool) -> [String: Any]
    {
        techMap["name"] = name
        techMap["defaultValue"] = defaultValue
        techMap["currentValue"] = currentValue
        techMap["color"] = color
        techMap["selected"] = selected
        techMap["maxValue"] = maxValue
        techMap["minValue"] = minValue
        techMap["enableSelected"] = enableSelected
        return techMap
    }
    
    private class func paramName(period: Int) -> String {
        return "移动平均周期\(period)"
    }
    
    let defaultParametersValues: [String: [Int]] = [
        "MA": [5, 10, 20, 30, 60, 120, 240],
        "BOLL": [20, 2],
        "EMA": [5, 10, 20, 30, 60, 120, 240],
        "MACD": [12, 26, 9],
        "KDJ": [9, 3, 3],
        "RSI": [6, 12, 24],
        "ARBR": [26],
        "OBV": [],
        "WR": [10, 6],
        "EMV": [14, 9],
        "DMA": [10, 50],
        "DMI": [14, 6],
        "CCI": [14],
        "MFI": [14, 20, 80],
        "ATR": [20],
        "TRIX": [12, 20],
    ]
    
    class func fillIndicatorsValues(_ fillObject: inout [String: [Int]]) -> [String: [Int]] {
        if (fillObject["MA"] == nil) {
            fillObject["MA"] = [5, 10, 20, 30, 60, 120, 240]
        }
        
        if (fillObject["MA"]?.count != 7) {
            var masArray = fillObject["MA"]
            let defaultArray = [5, 10, 20, 30, 60, 120, 240]
            masArray!.append(contentsOf: defaultArray.suffix(from: masArray!.count))
            fillObject["MA"] = masArray
        }
        
        if (fillObject["BOLL"] == nil) {
            fillObject["BOLL"] = [20, 2]
        }
        
        if (fillObject["EMA"] == nil) {
            fillObject["EMA"] = [5, 10, 20, 30, 60, 120, 240]
        }
        
        if (fillObject["EMA"]?.count != 7) {
            var masArray = fillObject["EMA"]
            let defaultArray = [5, 10, 20, 30, 60, 120, 240]
            masArray!.append(contentsOf: defaultArray.suffix(from: masArray!.count))
            fillObject["EMA"] = masArray
        }
        
        if (fillObject["MACD"] == nil) {
            fillObject["MACD"] = [12, 26, 9]
        }
        if (fillObject["KDJ"] == nil) {
            fillObject["KDJ"] = [9, 3, 3]
        }
        if (fillObject["RSI"] == nil) {
            fillObject["RSI"] = [6, 12, 24]
        }
        if (fillObject["ARBR"] == nil) {
            fillObject["ARBR"] = [26]
        }
        if (fillObject["WR"] == nil) {
            fillObject["WR"] = [10, 6]
        }
        
        if (fillObject["EMV"] == nil) {
            fillObject["EMV"] = [14, 9]
        }
        if (fillObject["DMA"] == nil) {
            fillObject["DMA"] = [10, 50]
        }
        
        if (fillObject["CCI"] == nil) {
            fillObject["CCI"] = [14]
        }
        
        if (fillObject["MFI"] == nil) {
            fillObject["MFI"] = [14, 20, 80]
        }
        if (fillObject["ATR"] == nil) {
            fillObject["ATR"] = [20]
        }
        if (fillObject["TRIX"] == nil) {
            fillObject["TRIX"] = [12, 20]
        }
        
        if (fillObject["BOLL"] == nil) {
            fillObject["BOLL"] = [20, 2]
        }
        
        if (fillObject["MACD"] == nil) {
            fillObject["MACD"] = [12, 26, 9]
        }
        if (fillObject["KDJ"] == nil) {
            fillObject["KDJ"] = [9, 3, 3]
        }
        if (fillObject["RSI"] == nil) {
            fillObject["RSI"] = [6, 12, 24]
        }
        if (fillObject["ARBR"] == nil) {
            fillObject["ARBR"] = [26]
        }
        if (fillObject["WR"] == nil) {
            fillObject["WR"] = [10, 6]
        }
        
        if (fillObject["EMV"] == nil) {
            fillObject["EMV"] = [14, 9]
        }
        if (fillObject["DMA"] == nil) {
            fillObject["DMA"] = [10, 50]
        }
        
        if (fillObject["CCI"] == nil) {
            fillObject["CCI"] = [14]
        }
        
        if (fillObject["MFI"] == nil) {
            fillObject["MFI"] = [14, 20, 80]
        }
        if (fillObject["ATR"] == nil) {
            fillObject["ATR"] = [20]
        }
        if (fillObject["TRIX"] == nil) {
            fillObject["TRIX"] = [12, 20]
        }
        if (fillObject["MTM"] == nil) {
            fillObject["MTM"] = [12, 20]
        }
        if (fillObject["ADTM"] == nil) {
            fillObject["ADTM"] = [23, 8]
        }
        if (fillObject["CR"] == nil) {
            fillObject["CR"] = [23, 5, 10, 30]
        }
        
        return fillObject
    }
    
   @objc open class func getDefaultParameters() -> [String: [[String: Any]]] {
        let preDic = TBStockTechParams.techParameterSettingValues()
        let mas = preDic["MA"]!
        let bolls = preDic["BOLL"]!
        let emas = preDic["EMA"]!
        let macd = preDic["MACD"]!
        let kdj = preDic["KDJ"]!
        let rsi = preDic["RSI"]!
        let arbr = preDic["ARBR"]!
        let wr = preDic["WR"]!
        let emv = preDic["EMV"]!
        let dma = preDic["DMA"]!
        let cci = preDic["CCI"]!
        let mfi = preDic["MFI"]!
        let dmi = preDic["DMI"]!
        let atr = preDic["ATR"]!
        let trix = preDic["TRIX"]!
        
        
        
        let defaultParameters: [String: [[String: Any]]] = [
            "MA": [
                param(name: paramName(period: 1), defaultValue: 5, currentValue: mas[0], color: mainColorArray[0], selected: true, maxValue: 500, minValue: 1, enableSelected: true),
                param(name: paramName(period: 2), defaultValue: 10, currentValue: mas[1], color: mainColorArray[1], selected: true, maxValue: 500, minValue: 1, enableSelected: true),
                param(name: paramName(period: 3), defaultValue: 20, currentValue: mas[2], color: mainColorArray[2], selected: true, maxValue: 500, minValue: 1, enableSelected: true),
                param(name: paramName(period: 4), defaultValue: 30, currentValue: mas[3], color: mainColorArray[3], selected: true, maxValue: 500, minValue: 1, enableSelected: true),
                param(name: paramName(period: 5), defaultValue: 60, currentValue: mas[4], color: mainColorArray[4], selected: false, maxValue: 500, minValue: 1, enableSelected: true),
                param(name: paramName(period: 6), defaultValue: 120, currentValue: mas[5], color: mainColorArray[5], selected: false, maxValue: 500, minValue: 1, enableSelected: true),
                param(name: paramName(period: 7), defaultValue: 240, currentValue: mas[6], color: mainColorArray[6], selected: false, maxValue: 500, minValue: 1, enableSelected: true)
            ],
            "BOLL": [
                param(name: "计算周期", defaultValue: 20, currentValue: bolls[0], color: "common", selected: true, maxValue: 100, minValue: 5, enableSelected: false),
                param(name: "股票特性参数", defaultValue: 2, currentValue: bolls[1], color: "common", selected: true, maxValue: 10, minValue: 1, enableSelected: false)
            ],
            "EMA": [
                param(name: paramName(period: 1), defaultValue: 5, currentValue: emas[0], color: mainColorArray[0], selected: true, maxValue: 500, minValue: 1, enableSelected: true),
                param(name: paramName(period: 2), defaultValue: 10, currentValue: emas[1], color: mainColorArray[1], selected: true, maxValue: 500, minValue: 1, enableSelected: true),
                param(name: paramName(period: 3), defaultValue: 20, currentValue: emas[2], color: mainColorArray[2], selected: true, maxValue: 500, minValue: 1, enableSelected: true),
                param(name: paramName(period: 4), defaultValue: 30, currentValue: emas[3], color: mainColorArray[3], selected: true, maxValue: 500, minValue: 1, enableSelected: true),
                param(name: paramName(period: 5), defaultValue: 60, currentValue: emas[4], color: mainColorArray[4], selected: false, maxValue: 500, minValue: 1, enableSelected: true),
                param(name: paramName(period: 6), defaultValue: 120, currentValue: emas[5], color: mainColorArray[5], selected: false, maxValue: 500, minValue: 1, enableSelected: true),
                param(name: paramName(period: 7), defaultValue: 240, currentValue: emas[6], color: mainColorArray[6], selected: false, maxValue: 500, minValue: 1, enableSelected: true)
            ],
            "MACD": [
                param(name: "短周期", defaultValue: 12, currentValue: macd[0], color: "common", selected: true, maxValue: 60, minValue: 2, enableSelected: false),
                param(name: "长周期", defaultValue: 26, currentValue: macd[1], color: "common", selected: true, maxValue: 100, minValue: 10, enableSelected: false),
                param(name: "移动平均周期", defaultValue: 9, currentValue: macd[2], color: "common", selected: true, maxValue: 60, minValue: 2, enableSelected: false)
            ],
            "DMI": [
                param(name: "移动平均周期", defaultValue: 14, currentValue: dmi[0], color: "#3784B4", selected: true, maxValue: 100, minValue: 5, enableSelected: false),
                param(name: "股票特性参数", defaultValue: 6, currentValue: dmi[1], color: "common", selected: true, maxValue: 10, minValue: 1, enableSelected: false)
            ],
            "KDJ": [
                param(name: "计算周期", defaultValue: 9, currentValue: kdj[0], color: "common", selected: true, maxValue: 40, minValue: 1, enableSelected: false),
                param(name: paramName(period: 1), defaultValue: 3, currentValue: kdj[1], color: "#C43484", selected: true, maxValue: 40, minValue: 1, enableSelected: false),
                param(name: paramName(period: 2), defaultValue: 3, currentValue: kdj[2], color: "#846CFF", selected: true, maxValue: 40, minValue: 1, enableSelected: false),
                param(name: "上参考线", defaultValue: 80, currentValue: 80, color: "#7e829c", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                param(name: "中参考线", defaultValue: 50, currentValue: 50, color: "#7e829c", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                param(name: "下参考线", defaultValue: 20, currentValue: 20, color: "#7e829c", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
            ],
            "RSI": [
                param(name: paramName(period: 1), defaultValue: 6, currentValue: rsi[0], color: "#FBCA00", selected: true, maxValue: 60, minValue: 2, enableSelected: false),
                param(name: paramName(period: 2), defaultValue: 12, currentValue: rsi[1], color: "#846CFF", selected: true, maxValue: 120, minValue: 2, enableSelected: false),
                param(name: paramName(period: 3), defaultValue: 24, currentValue: rsi[2], color: "#28A697", selected: true, maxValue: 250, minValue: 2, enableSelected: false),
                param(name: "上参考线", defaultValue: 80, currentValue: 80, color: "#7e829c", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                param(name: "中参考线", defaultValue: 50, currentValue: 50, color: "#7e829c", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                param(name: "下参考线", defaultValue: 20, currentValue: 20, color: "#7e829c", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
            ],
            "ARBR": [
                param(name: "计算周期", defaultValue: 26, currentValue: arbr[0], color: "common", selected: true, maxValue: 40, minValue: 1, enableSelected: false)
            ],
            "OBV":  [],
            "ALLIGAT":  [],
            "成交量":  [],
            "WR": [
                param(name: "WR1", defaultValue: 10, currentValue: wr[0], color: "#FF6825", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                param(name: "WR2", defaultValue: 6, currentValue: wr[1], color: "#8F3C0A", selected: true, maxValue: 100, minValue: 2, enableSelected: false)
            ],
            "EMV": [
                param(name: paramName(period: 1), defaultValue: 14, currentValue: emv[0], color: "#447EFF", selected: true, maxValue: 60, minValue: 1, enableSelected: false),
                param(name: paramName(period: 2), defaultValue: 9, currentValue: emv[1], color: "#61B21C", selected: true, maxValue: 60, minValue: 1, enableSelected: false)
            ],
            "DMA": [
                param(name: "短周期", defaultValue: 10, currentValue: dma[0], color: "common", selected: true, maxValue: 60, minValue: 1, enableSelected: false),
                param(name: "长周期", defaultValue: 50, currentValue: dma[1], color: "common", selected: true, maxValue: 250, minValue: 1, enableSelected: false)
            ],
            "CCI": [
                param(name: "计算周期", defaultValue: 14, currentValue: cci[0], color: "common", selected: true, maxValue: 300, minValue: 1, enableSelected: false)
            ],
            "MFI": [
                param(name: "计算周期", defaultValue: 14, currentValue: mfi[0], color: "#D53EEA", selected: true, maxValue: 120, minValue: 2, enableSelected: false),
                param(name: "下参考线", defaultValue: 20, currentValue: mfi[1], color: "common", selected: true, maxValue: 100, minValue: 1, enableSelected: false),
                param(name: "上参考线", defaultValue: 80, currentValue: mfi[2], color: "common", selected: true, maxValue: 100, minValue: 1, enableSelected: false),
            ],
            "ATR": [
                param(name: "移动平均周期", defaultValue: 20, currentValue: atr[0], color: "#C43484", selected: true, maxValue: 100, minValue: 5, enableSelected: false)
            ],
            "TRIX": [
                param(name: paramName(period: 1), defaultValue: 12, currentValue: trix[0], color: "#D53EEA", selected: true, maxValue: 100, minValue: 5, enableSelected: false),
                param(name: paramName(period: 2), defaultValue: 20, currentValue: trix[1], color: "#846CFF", selected: true, maxValue: 100, minValue: 5, enableSelected: false)
            ],
            "DKX":  [
                param(name: paramName(period: 1), defaultValue: 10, currentValue: 10, color: "#C43484", selected: true, maxValue: 100, minValue: 5, enableSelected: false),
            ],
            "SKDJ": [
                param(name: "短周期", defaultValue: 9, currentValue: 9, color: "#C43484", selected: true, maxValue: 90, minValue: 2, enableSelected: false),
                param(name: "长周期", defaultValue: 3, currentValue: 3, color: "#846CFF", selected: true, maxValue: 30, minValue: 2, enableSelected: false),
                param(name: "上参考线", defaultValue: 80, currentValue: 80, color: "#7e829c", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                param(name: "中参考线", defaultValue: 50, currentValue: 50, color: "#7e829c", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                param(name: "下参考线", defaultValue: 20, currentValue: 20, color: "#7e829c", selected: true, maxValue: 100, minValue: 2, enableSelected: false),

            ],
            "ROC": [
                param(name: "短周期", defaultValue: 12, currentValue: 12, color: "#FF6825", selected: true, maxValue: 120, minValue: 2, enableSelected: false),
                param(name: "长周期", defaultValue: 6, currentValue: 6, color: "#28A697", selected: true, maxValue: 60, minValue: 2, enableSelected: false),
            ],
            "PCNT": [
                param(name: paramName(period: 1), defaultValue: 5, currentValue: 5, color: "#C43484", selected: true, maxValue: 250, minValue: 2, enableSelected: false),
            ],
            "WAD": [
                param(name: paramName(period: 1), defaultValue: 30, currentValue:30, color: "#C43484", selected: true, maxValue: 250, minValue: 2, enableSelected: false),
            ],
            "XS": [
                param(name: paramName(period: 1), defaultValue: 13, currentValue:13, color: "#C43484", selected: true, maxValue: 120, minValue: 2, enableSelected: false),
            ],
            "BIAS": [
                param(name: paramName(period: 1), defaultValue: 6, currentValue: 6, color: "#E32B65", selected: true, maxValue: 250, minValue: 2, enableSelected: false),
                param(name: paramName(period: 2), defaultValue: 12, currentValue: 12, color: "#846CFF", selected: true, maxValue: 250, minValue: 2, enableSelected: false),
                param(name: paramName(period: 3), defaultValue: 24, currentValue: 24, color: "#8F3C0A", selected: true, maxValue: 250, minValue: 2, enableSelected: false),
                
            ],
            "UDL": [
                param(name: paramName(period: 1), defaultValue: 3, currentValue: 3, color: "#FF6825", selected: true, maxValue: 20, minValue: 2, enableSelected: false),
                param(name: paramName(period: 2), defaultValue: 5, currentValue: 5, color: "#447EFF", selected: true, maxValue: 30, minValue: 2, enableSelected: false),
                param(name: paramName(period: 3), defaultValue: 10, currentValue: 10, color: "#FBCA00", selected: true, maxValue: 60, minValue: 2, enableSelected: false),
                param(name: paramName(period: 4), defaultValue: 20, currentValue: 20, color: "#2F97DA", selected: true, maxValue: 120, minValue: 2, enableSelected: false),
                param(name: paramName(period: 5), defaultValue: 6, currentValue: 6, color: "#19B6B5", selected: true, maxValue: 10, minValue: 2, enableSelected: false),
                
            ],
            "VRSI": [
                param(name: paramName(period: 1), defaultValue: 6, currentValue: 6, color: "#FF6825", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                param(name: paramName(period: 2), defaultValue: 12, currentValue: 12, color: "#28A697", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                param(name: paramName(period: 3), defaultValue: 24, currentValue: 24, color: "#E32B65", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                
            ],
            "BBI": [
                param(name: paramName(period: 1), defaultValue: 3, currentValue: 3, color: mainColorArray[0], selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                param(name: paramName(period: 2), defaultValue: 6, currentValue: 6, color: mainColorArray[1], selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                param(name: paramName(period: 3), defaultValue: 12, currentValue: 12, color: mainColorArray[2], selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                param(name: paramName(period: 4), defaultValue: 24, currentValue: 24, color: mainColorArray[3], selected: true, maxValue: 100, minValue: 2, enableSelected: false),
            ],
            "HMA": [
                param(name: paramName(period: 1), defaultValue: 6, currentValue: 6, color: mainColorArray[0], selected: true, maxValue: 500, minValue: 2, enableSelected: false),
                param(name: paramName(period: 2), defaultValue: 12, currentValue: 12, color: mainColorArray[1], selected: true, maxValue: 500, minValue: 2, enableSelected: false),
                param(name: paramName(period: 3), defaultValue: 30, currentValue: 30, color: mainColorArray[2], selected: true, maxValue: 500, minValue: 2, enableSelected: false),
                param(name: paramName(period: 4), defaultValue: 72, currentValue: 72, color: mainColorArray[3], selected: true, maxValue: 500, minValue: 2, enableSelected: false),
                param(name: paramName(period: 5), defaultValue: 144, currentValue: 144, color: mainColorArray[4], selected: true, maxValue: 500, minValue: 2, enableSelected: false),
            ],
            "LMA": [
                param(name: paramName(period: 1), defaultValue: 6, currentValue: 6, color: mainColorArray[0], selected: true, maxValue: 500, minValue: 2, enableSelected: false),
                param(name: paramName(period: 2), defaultValue: 12, currentValue: 12, color: mainColorArray[1], selected: true, maxValue: 500, minValue: 2, enableSelected: false),
                param(name: paramName(period: 3), defaultValue: 30, currentValue: 30, color: mainColorArray[2], selected: true, maxValue: 500, minValue: 2, enableSelected: false),
                param(name: paramName(period: 4), defaultValue: 72, currentValue: 72, color: mainColorArray[3], selected: true, maxValue: 500, minValue: 2, enableSelected: false),
                param(name: paramName(period: 5), defaultValue: 144, currentValue: 144, color: mainColorArray[4], selected: true, maxValue: 500, minValue: 2, enableSelected: false),
            ],
            "VMA": [
                param(name: paramName(period: 1), defaultValue: 6, currentValue: 6, color: mainColorArray[0], selected: true, maxValue: 500, minValue: 2, enableSelected: false),
                param(name: paramName(period: 2), defaultValue: 12, currentValue: 12, color: mainColorArray[1], selected: true, maxValue: 500, minValue: 2, enableSelected: false),
                param(name: paramName(period: 3), defaultValue: 30, currentValue: 30, color: mainColorArray[2], selected: true, maxValue: 500, minValue: 2, enableSelected: false),
                param(name: paramName(period: 4), defaultValue: 72, currentValue: 72, color: mainColorArray[3], selected: true, maxValue: 500, minValue: 2, enableSelected: false),
                param(name: paramName(period: 5), defaultValue: 144, currentValue: 144, color: mainColorArray[4], selected: true, maxValue: 500, minValue: 2, enableSelected: false),
            ],
            "BBIBOLL": [
                param(name: paramName(period: 1), defaultValue: 11, currentValue: 11, color: mainColorArray[0], selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                param(name: paramName(period: 2), defaultValue: 6, currentValue: 6, color: mainColorArray[0], selected: true, maxValue: 200, minValue: 2, enableSelected: false),
            ],
            "PBX": [
                param(name: paramName(period: 1), defaultValue: 4, currentValue: 4, color: mainColorArray[0], selected: true, maxValue: 10, minValue: 3, enableSelected: false),
                param(name: paramName(period: 2), defaultValue: 6, currentValue: 6, color: mainColorArray[1], selected: true, maxValue: 20, minValue: 3, enableSelected: false),
                param(name: paramName(period: 3), defaultValue: 9, currentValue: 9, color: mainColorArray[2], selected: true, maxValue: 30, minValue: 3, enableSelected: false),
                param(name: paramName(period: 4), defaultValue: 13, currentValue: 13, color: mainColorArray[3], selected: true, maxValue: 40, minValue: 3, enableSelected: false),
                param(name: paramName(period: 5), defaultValue: 18, currentValue: 18, color: mainColorArray[4], selected: true, maxValue: 50, minValue: 3, enableSelected: false),
                param(name: paramName(period: 6), defaultValue: 24, currentValue: 24, color: mainColorArray[5], selected: true, maxValue: 60, minValue: 3, enableSelected: false),
            ],
            "ENE":[
                param(name: paramName(period: 1), defaultValue: 25, currentValue: 25, color: mainColorArray[0], selected: true, maxValue: 120, minValue: 2, enableSelected: false),
                param(name: paramName(period: 2), defaultValue: 6, currentValue:6, color: mainColorArray[1], selected: true, maxValue: 120, minValue: 2, enableSelected: false),
                param(name: paramName(period: 3), defaultValue: 6, currentValue:6, color: mainColorArray[2], selected: true, maxValue: 120, minValue: 2, enableSelected: false),
            ],
            "MIKE": [
                param(name: paramName(period: 1), defaultValue: 10, currentValue:10, color: mainColorArray[0], selected: true, maxValue: 120, minValue: 2, enableSelected: false),
            ],
            "XT": [
                param(name: paramName(period: 1), defaultValue: 10, currentValue:10, color: "#C43484", selected: true, maxValue: 30, minValue: 3, enableSelected: false),
            ],
            "JAX": [
                param(name: paramName(period: 1), defaultValue: 30, currentValue:30, color: "#C43484", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
            ],
            "SAR": [
                param(name: "周期", defaultValue: 4, currentValue:4, color: "common", selected: true, maxValue: 100, minValue: 1, enableSelected: false),
                param(name: "MINAF", defaultValue: 2, currentValue: 2, color: "common", selected: true, maxValue: 100, minValue: 0, enableSelected: false),
                param(name: "MAXAF", defaultValue: 20, currentValue: 20, color: "common", selected: true, maxValue: 100, minValue: 0, enableSelected: false),

            ],
            "MTM": [
                param(name: "计算周期", defaultValue: 12, currentValue: 12, color: "#FBCA00", selected: true, maxValue: 120, minValue: 2, enableSelected: false),
                param(name: "移动平均周期", defaultValue: 6, currentValue: 6, color: "#61B21C", selected: true, maxValue: 60, minValue: 2, enableSelected: false),
            ],
            "ADTM": [
                param(name: "计算周期", defaultValue: 23, currentValue: 23, color: "#FF6825", selected: true, maxValue: 100, minValue: 1, enableSelected: false),
                param(name: "移动平均周期", defaultValue: 8, currentValue: 8, color: "#846CFF", selected: true, maxValue: 100, minValue: 1, enableSelected: false),
            ],
            
            "CR": [
                param(name: "计算周期", defaultValue: 23, currentValue: 23, color: "#D53EEA", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                param(name: paramName(period: 1), defaultValue: 5, currentValue: 5, color: "#FBCA00", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                param(name: paramName(period: 2), defaultValue: 10, currentValue: 10, color: "#FF6825", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                param(name: paramName(period: 3), defaultValue: 30, currentValue: 30, color: "#447EFF", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
            ],
            
            "WVAD": []
        ]
        return defaultParameters
    }
    
    class func fillIndicatorTypes(_ fillObject: inout [String: [[String: Any]]]) -> [String: [[String: Any]]] {
        
        if fillObject["MA"] != nil {
            var masArray = fillObject["MA"]!
            if masArray.count != 7 {
                let defaultMAArray = getDefaultParameters()["MA"]
                masArray.append(contentsOf: defaultMAArray!.suffix(from: masArray.count))
                fillObject["MA"] = masArray
            }
        }
        
        if fillObject["EMA"] != nil {
            let emasArray = fillObject["EMA"]!
            if emasArray.count != 7 {
                let defaultMAArray = getDefaultParameters()["EMA"]
                fillObject["EMA"] = defaultMAArray
            }
        }
        
        ///如果取到了，就做一下补充
        if fillObject["MACD"] == nil {
            let preDic = TBStockTechParams.techParameterSettingValues()
            let macd = preDic["MACD"]!
            fillObject["MACD"] = [
                param(name: "短周期", defaultValue: 12, currentValue: macd[0], color: "common", selected: true, maxValue: 60, minValue: 2, enableSelected: false),
                param(name: "长周期", defaultValue: 26, currentValue: macd[1], color: "common", selected: true, maxValue: 100, minValue: 10, enableSelected: false),
                param(name: "移动平均周期", defaultValue: 9, currentValue: macd[2], color: "common", selected: true, maxValue: 60, minValue: 2, enableSelected: false)
            ]
        }
        
        if fillObject["DMI"] == nil {
            fillObject["DMI"] = [
                param(name: "移动平均周期", defaultValue: 14, currentValue: 14, color: "#C43484", selected: true, maxValue: 100, minValue: 5, enableSelected: false),
                param(name: "股票特性参数", defaultValue: 6, currentValue: 6, color: "common", selected: true, maxValue: 10, minValue: 1, enableSelected: false)
            ]
        }
        
        if fillObject["ATR"] == nil {
            fillObject["ATR"] = [
                param(name: "移动平均周期", defaultValue: 20, currentValue: 20, color: "#C43484", selected: true, maxValue: 100, minValue: 5, enableSelected: false)
            ]
        }
        
        if fillObject["TRIX"] == nil {
            fillObject["TRIX"] = [
                param(name: paramName(period: 1), defaultValue: 12, currentValue: 12, color: "#D53EEA", selected: true, maxValue: 100, minValue: 5, enableSelected: false),
                param(name: paramName(period: 2), defaultValue: 20, currentValue: 20, color: "#846CFF", selected: true, maxValue: 100, minValue: 5, enableSelected: false)
            ]
        }
        
        if fillObject["DKX"] == nil {
            fillObject["DKX"] = [
                param(name: paramName(period: 1), defaultValue: 10, currentValue: 10, color: "#C43484", selected: true, maxValue: 250, minValue: 2, enableSelected: false),
            ]
        }
        
        if fillObject["SKDJ"] == nil {
            fillObject["SKDJ"] = [
                param(name: "短周期", defaultValue: 9, currentValue: 9, color: "#FF6825", selected: true, maxValue: 90, minValue: 2, enableSelected: false),
                param(name: "长周期", defaultValue: 3, currentValue: 3, color: "#FBCA00", selected: true, maxValue: 30, minValue: 2, enableSelected: false),
            ]
        }
        
        if fillObject["ROC"] == nil {
            fillObject["ROC"] = [
                param(name: "短周期", defaultValue: 12, currentValue: 12, color: "#C43484", selected: true, maxValue: 120, minValue: 2, enableSelected: false),
                param(name: "长周期", defaultValue: 6, currentValue: 6, color: "#846CFF", selected: true, maxValue: 60, minValue: 2, enableSelected: false),
            ]
        }
        
        if fillObject["PCNT"] == nil {
            fillObject["PCNT"] = [
                param(name: paramName(period: 1), defaultValue: 5, currentValue: 5, color: "#C43484", selected: true, maxValue: 250, minValue: 2, enableSelected: false),
            ]
        }
        
        if fillObject["WAD"] == nil {
            fillObject["WAD"] = [
                param(name: paramName(period: 1), defaultValue: 30, currentValue:30, color: "#C43484", selected: true, maxValue: 120, minValue: 2, enableSelected: false),
            ]
        }
        
        if fillObject["XS"] == nil {
            fillObject["XS"] = [
                param(name: paramName(period: 1), defaultValue: 13, currentValue:13, color: "#FF6825", selected: true, maxValue: 120, minValue: 2, enableSelected: false),
            ]
        }
        
        if fillObject["BIAS"] == nil {
            fillObject["BIAS"] = [
                param(name: paramName(period: 1), defaultValue: 6, currentValue: 6, color: "#E32B65", selected: true, maxValue: 250, minValue: 2, enableSelected: false),
                param(name: paramName(period: 2), defaultValue: 12, currentValue: 12, color: "#846CFF", selected: true, maxValue: 250, minValue: 2, enableSelected: false),
                param(name: paramName(period: 3), defaultValue: 24, currentValue: 24, color: "#8F3C0A", selected: true, maxValue: 250, minValue: 2, enableSelected: false),
                
            ]
        }
        
        if fillObject["UDL"] == nil {
            fillObject["UDL"] = [
                param(name: paramName(period: 1), defaultValue: 3, currentValue: 3, color: "#FF6825", selected: true, maxValue: 20, minValue: 2, enableSelected: false),
                param(name: paramName(period: 2), defaultValue: 5, currentValue: 5, color: "#447EFF", selected: true, maxValue: 30, minValue: 2, enableSelected: false),
                param(name: paramName(period: 3), defaultValue: 10, currentValue: 10, color: "#FBCA00", selected: true, maxValue: 60, minValue: 2, enableSelected: false),
                param(name: paramName(period: 4), defaultValue: 20, currentValue: 20, color: "#2F97DA", selected: true, maxValue: 120, minValue: 2, enableSelected: false),
                param(name: paramName(period: 5), defaultValue: 6, currentValue: 6, color: "#19B6B5", selected: true, maxValue: 10, minValue: 2, enableSelected: false),
            ]
        }
        
        if fillObject["VRSI"] == nil {
            fillObject["VRSI"] = [
                param(name: paramName(period: 1), defaultValue: 6, currentValue: 6, color: "#FF6825", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                param(name: paramName(period: 2), defaultValue: 12, currentValue: 12, color: "#28A697", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                param(name: paramName(period: 3), defaultValue: 24, currentValue: 24, color: "#E32B65", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
            ]
        }
        
        if fillObject["JAX"] == nil {
            fillObject["JAX"] = [
                param(name: paramName(period: 1), defaultValue: 30, currentValue:30, color: "#C43484", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
            ]
        }
        
        if fillObject["XT"] == nil {
            fillObject["XT"] = [
                param(name: paramName(period: 1), defaultValue: 10, currentValue:10, color: "#C43484", selected: true, maxValue: 30, minValue: 3, enableSelected: false),
            ]
        }
        
        if fillObject["MIKE"] == nil {
            fillObject["MIKE"] = [
                param(name: paramName(period: 1), defaultValue: 10, currentValue:10, color: mainColorArray[0], selected: true, maxValue: 120, minValue: 2, enableSelected: false),
            ]
        }
        
        if fillObject["ENE"] == nil {
            fillObject["ENE"] = [
                param(name: paramName(period: 1), defaultValue: 25, currentValue: 25, color: mainColorArray[0], selected: true, maxValue: 120, minValue: 2, enableSelected: false),
//                param(name: paramName(period: 2), defaultValue: 6, currentValue:6, color: mainColorArray[1] selected: true, maxValue: 120, minValue: 2, enableSelected: false),
                param(name: paramName(period: 3), defaultValue: 6, currentValue:6, color: mainColorArray[2], selected: true, maxValue: 120, minValue: 2, enableSelected: false),
                
            ]
        }
        
        if fillObject["PBX"] == nil {
            fillObject["PBX"] = [
                param(name: paramName(period: 1), defaultValue: 4, currentValue: 4, color: mainColorArray[0], selected: true, maxValue: 10, minValue: 3, enableSelected: false),
                param(name: paramName(period: 2), defaultValue: 6, currentValue: 6, color: mainColorArray[1], selected: true, maxValue: 20, minValue: 3, enableSelected: false),
                param(name: paramName(period: 3), defaultValue: 9, currentValue: 9, color: mainColorArray[2], selected: true, maxValue: 30, minValue: 3, enableSelected: false),
                param(name: paramName(period: 4), defaultValue: 13, currentValue: 13, color: mainColorArray[3], selected: true, maxValue: 40, minValue: 3, enableSelected: false),
                param(name: paramName(period: 5), defaultValue: 18, currentValue: 18, color: mainColorArray[4], selected: true, maxValue: 50, minValue: 3, enableSelected: false),
                param(name: paramName(period: 6), defaultValue: 24, currentValue: 24, color: mainColorArray[5], selected: true, maxValue: 60, minValue: 3, enableSelected: false),
            ]
        }
        
        if fillObject["VMA"] == nil {
            fillObject["VMA"] = [
                param(name: paramName(period: 1), defaultValue: 6, currentValue: 6, color: mainColorArray[0], selected: true, maxValue: 500, minValue: 2, enableSelected: false),
                param(name: paramName(period: 2), defaultValue: 12, currentValue: 12, color: mainColorArray[1], selected: true, maxValue: 500, minValue: 2, enableSelected: false),
                param(name: paramName(period: 3), defaultValue: 30, currentValue: 30, color: mainColorArray[2], selected: true, maxValue: 500, minValue: 2, enableSelected: false),
                param(name: paramName(period: 4), defaultValue: 72, currentValue: 72, color: mainColorArray[3], selected: true, maxValue: 500, minValue: 2, enableSelected: false),
                param(name: paramName(period: 5), defaultValue: 144, currentValue: 144, color: mainColorArray[4], selected: true, maxValue: 500, minValue: 2, enableSelected: false),
            ]
        }
        
        if fillObject["LMA"] == nil {
            fillObject["LMA"] = [
                param(name: paramName(period: 1), defaultValue: 6, currentValue: 6, color: mainColorArray[0], selected: true, maxValue: 500, minValue: 2, enableSelected: false),
                param(name: paramName(period: 2), defaultValue: 12, currentValue: 12, color: mainColorArray[1], selected: true, maxValue: 500, minValue: 2, enableSelected: false),
                param(name: paramName(period: 3), defaultValue: 30, currentValue: 30, color: mainColorArray[2], selected: true, maxValue: 500, minValue: 2, enableSelected: false),
                param(name: paramName(period: 4), defaultValue: 72, currentValue: 72, color: mainColorArray[3], selected: true, maxValue: 500, minValue: 2, enableSelected: false),
                param(name: paramName(period: 5), defaultValue: 144, currentValue: 144, color: mainColorArray[4], selected: true, maxValue: 500, minValue: 2, enableSelected: false),
            ]
        }
        
        if fillObject["HMA"] == nil {
            fillObject["HMA"] = [
                param(name: paramName(period: 1), defaultValue: 6, currentValue: 6, color: mainColorArray[0], selected: true, maxValue: 500, minValue: 2, enableSelected: false),
                param(name: paramName(period: 2), defaultValue: 12, currentValue: 12, color: mainColorArray[1], selected: true, maxValue: 500, minValue: 2, enableSelected: false),
                param(name: paramName(period: 3), defaultValue: 30, currentValue: 30, color: mainColorArray[2], selected: true, maxValue: 500, minValue: 2, enableSelected: false),
                param(name: paramName(period: 4), defaultValue: 72, currentValue: 72, color: mainColorArray[3], selected: true, maxValue: 500, minValue: 2, enableSelected: false),
                param(name: paramName(period: 5), defaultValue: 144, currentValue: 144, color: mainColorArray[4], selected: true, maxValue: 500, minValue: 2, enableSelected: false),
            ]
        }
        
        if fillObject["BBI"] == nil {
            fillObject["BBI"] = [
                param(name: paramName(period: 1), defaultValue: 3, currentValue: 3, color: mainColorArray[0], selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                param(name: paramName(period: 2), defaultValue: 6, currentValue: 6, color: mainColorArray[1], selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                param(name: paramName(period: 3), defaultValue: 12, currentValue: 12, color: mainColorArray[2], selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                param(name: paramName(period: 4), defaultValue: 24, currentValue: 24, color: mainColorArray[3], selected: true, maxValue: 100, minValue: 2, enableSelected: false),
            ]
        }
        
        if fillObject["BBIBOLL"] == nil {
            fillObject["BBIBOLL"] = [
                param(name: paramName(period: 1), defaultValue: 11, currentValue: 11, color: mainColorArray[0], selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                param(name: paramName(period: 2), defaultValue: 6, currentValue: 6, color: mainColorArray[1], selected: true, maxValue: 200, minValue: 2, enableSelected: false),
            ]
        }
        
        if fillObject["ALLIGAT"] == nil {
            fillObject["ALLIGAT"] = []
        }
        
        if fillObject["成交量"] == nil {
            fillObject["成交量"] = []
        }
        
        if fillObject["SAR"] == nil {
            fillObject["SAR"] = [
                param(name: "周期", defaultValue: 4, currentValue:4, color: "common", selected: true, maxValue: 100, minValue: 1, enableSelected: false),
                param(name: "MINAF", defaultValue: 2, currentValue: 2, color: "common", selected: true, maxValue: 100, minValue: 0, enableSelected: false),
                param(name: "MAXAF", defaultValue: 20, currentValue: 20, color: "common", selected: true, maxValue: 100, minValue: 0, enableSelected: false),

            ]
        }
        
        if fillObject["SKDJ"] != nil {
            var temp = fillObject["SKDJ"];
            let containLineTech = temp?.last?["name"] as? String
            if containLineTech != "下参考线" {
                temp?.append(contentsOf:
                                [
                                    param(name: "上参考线", defaultValue: 80, currentValue: 80, color: "#7e829c", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                                    param(name: "中参考线", defaultValue: 50, currentValue: 50, color: "#7e829c", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                                    param(name: "下参考线", defaultValue: 20, currentValue: 20, color: "#7e829c", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                                ])
                fillObject["SKDJ"] = temp;
            }
        }
        
        if fillObject["KDJ"] != nil {
            var temp = fillObject["KDJ"];
            let containLineTech = temp?.last?["name"] as? String
            if containLineTech != "下参考线" {
                temp?.append(contentsOf:
                                [
                                    param(name: "上参考线", defaultValue: 80, currentValue: 80, color: "#7e829c", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                                    param(name: "中参考线", defaultValue: 50, currentValue: 50, color: "#7e829c", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                                    param(name: "下参考线", defaultValue: 20, currentValue: 20, color: "#7e829c", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                                ])
                fillObject["KDJ"] = temp;
            }
        }
        
        if fillObject["RSI"] != nil {
            var temp = fillObject["RSI"];
            let containLineTech = temp?.last?["name"] as? String
            if containLineTech != "下参考线" {
                temp?.append(contentsOf:
                                [
                                    param(name: "上参考线", defaultValue: 80, currentValue: 80, color: "#7e829c", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                                    param(name: "中参考线", defaultValue: 50, currentValue: 50, color: "#7e829c", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                                    param(name: "下参考线", defaultValue: 20, currentValue: 20, color: "#7e829c", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                                ])
                fillObject["RSI"] = temp;
            }
        }
        
        if fillObject["MTM"] == nil {
            fillObject["MTM"] = [
                param(name: "计算周期", defaultValue: 12, currentValue: 12, color: "#FBCA00", selected: true, maxValue: 120, minValue: 2, enableSelected: false),
                param(name: "移动平均周期", defaultValue: 6, currentValue: 6, color: "#61B21C", selected: true, maxValue: 60, minValue: 2, enableSelected: false),
            ]
        }
        
        if fillObject["ADTM"] == nil {
            fillObject["ADTM"] = [
                param(name: "计算周期", defaultValue: 23, currentValue: 23, color: "#FF6825", selected: true, maxValue: 100, minValue: 1, enableSelected: false),
                param(name: "移动平均周期", defaultValue: 8, currentValue: 8, color: "#846CFF", selected: true, maxValue: 100, minValue: 1, enableSelected: false),
            ]
        }
        
        if fillObject["CR"] == nil {
            fillObject["CR"] = [
                param(name: "计算周期", defaultValue: 23, currentValue: 23, color: "#D53EEA", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                param(name: paramName(period: 1), defaultValue: 5, currentValue: 5, color: "#FBCA00", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                param(name: paramName(period: 2), defaultValue: 10, currentValue: 10, color: "#FF6825", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
                param(name: paramName(period: 3), defaultValue: 30, currentValue: 30, color: "#447EFF", selected: true, maxValue: 100, minValue: 2, enableSelected: false),
            ]
        }
        
        if fillObject["WVAD"] == nil {
            fillObject["WVAD"] = []
        }
        
        return fillObject
    }
    
    class func modifyParameters(_ fillObject: inout [String: [[String: Any]]]) -> [String: [[String: Any]]] {
        //会重复添加，删除重复的部分
        if fillObject["SKDJ"] != nil {
            var temp = fillObject["SKDJ"]!
            if temp.count > 5 {
                temp = Array(temp.prefix(5))
                fillObject["SKDJ"] = temp;
            }
        }
        
        if fillObject["KDJ"] != nil {
            var temp = fillObject["KDJ"]!
            if temp.count > 6 {
                temp = Array(temp.prefix(6))
                fillObject["KDJ"] = temp;
            }
        }
        
        if fillObject["RSI"] != nil {
            var temp = fillObject["RSI"]!
            if temp.count > 6 {
                temp = Array(temp.prefix(6))
                fillObject["RSI"] = temp;
            }
        }
        
        return fillObject
    }
}
