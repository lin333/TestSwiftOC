//
//  Category.swift
//  TBKLineChartView
//
//  Created by luopengfei on 2017/12/28.
//  Copyright © 2017年 luopengfei. All rights reserved.
//

import Foundation
import UIKit
/*
 在给一个对象添加关联对象时有五种关联策略可供选择：
 
 关联策略                               等价属性                                                说明
 OBJC_ASSOCIATION_ASSIGN              @property (assign) or @property (unsafe_unretained)    弱引用关联对象
 OBJC_ASSOCIATION_RETAIN_NONATOMIC    @property (strong, nonatomic)                          强引用关联对象，且为非原子操作
 OBJC_ASSOCIATION_COPY_NONATOMIC      @property (copy, nonatomic)                            复制关联对象，且为非原子操作
 OBJC_ASSOCIATION_RETAIN              @property (strong, atomic)                             强引用关联对象，且为原子操作
 OBJC_ASSOCIATION_COPY                @property (copy, atomic)                               复制关联对象，且为原子操作
 
 
 OBJC_ASSOCIATION_ASSIGN: 所指向的对象在 ViewPortHandler 出现后就被释放了，但是 OBJC_ASSOCIATION_ASSIGN 仍然有值，还是保存的原对象的地址。如果之后再使用 OBJC_ASSOCIATION_ASSIGN 就会造成 Crash ，所以我们在关联对象时使用OBJC_ASSOCIATION_RETAIN_NONATOMIC；使用 OBJC_ASSOCIATION_RETAIN_NONATOMIC 的关联策略，这可以保证我们持有关联对象；
 
 from: http://blog.leichunfeng.com/blog/2015/06/26/objective-c-associated-objects-implementation-principle/
 */

extension ViewPortHandler {
     /// MOD:LPF
    /// MARK- ChartViewPortHandler category 新增两个属性：
    /// lineType:绘制类型，为TBLineType 枚举
    /// drawMarket市场类型，为TBChartMarketType 枚举
    
    private struct ViewPortHandlerKeys {
        static var landScape: String = "landScape"
        static var preClose: String = "preClose"
        static var drawMarket: String = "StockDrawType"
        static var lineType: String = "lineType"
        static var isIndex: String = "isIndex"
        static var shouldLocalFormat: String = "shouldLocalFormat"
        static var contractModel: String = "contractModel"
        static var maxScale: String = "maxScale"
    }
    
//    @objc open var contractModel: TBFuturesContractModel? {
//        get {
//            guard let value = objc_getAssociatedObject(self, &ViewPortHandlerKeys.contractModel) else {
//                return nil
//            }
//            return (value as! TBFuturesContractModel)
//        }
//
//        set {
//            objc_setAssociatedObject(self, &ViewPortHandlerKeys.contractModel, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//
//
//    }
    
    @objc open var maxScale: Int {
        get {
            guard let value = objc_getAssociatedObject(self, &ViewPortHandlerKeys.maxScale) as? Int else { return 3 }
            return value
        }
        set {
            objc_setAssociatedObject(self, &ViewPortHandlerKeys.maxScale, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc open var landScapeMode: LandScapeMode {
        get {
            guard let value = objc_getAssociatedObject(self, &ViewPortHandlerKeys.landScape) as? LandScapeMode else {
                return .Portrait
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &ViewPortHandlerKeys.landScape, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc open var preClose: Float {
        get {
            guard let value = objc_getAssociatedObject(self, &ViewPortHandlerKeys.preClose) as? Float else {
                return Float(0)
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &ViewPortHandlerKeys.preClose, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc open var drawMarket: StockDrawType {
        get {
            guard let value = objc_getAssociatedObject(self, &ViewPortHandlerKeys.drawMarket) as? StockDrawType else {
                return .US
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &ViewPortHandlerKeys.drawMarket, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc open var lineType: LineType {
        get {
            guard let value = objc_getAssociatedObject(self, &ViewPortHandlerKeys.lineType) as? LineType else {
                return .RealTime1Day
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &ViewPortHandlerKeys.lineType, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc open var isIndex: Bool {
        get {
            guard let value = objc_getAssociatedObject(self, &ViewPortHandlerKeys.isIndex) as? Bool else {
                return false
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &ViewPortHandlerKeys.isIndex, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc open var shouldLocalFormat: Bool {
        get {
            guard let value = objc_getAssociatedObject(self, &ViewPortHandlerKeys.shouldLocalFormat) as? Bool else {
                return false
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &ViewPortHandlerKeys.shouldLocalFormat, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

}

/// 为ChartLimitLine 添加新的属性drawLineEnable
/// 是否绘制ChartLimitLine line
///
extension ChartLimitLine {
    
    ///- 在私有嵌套 struct 中使用 static var，这样会生成我们所需的关联对象键，但不会污染整个命名空间。
    private struct ChartLimitLineKeys {
        static var drawLineEnable: String = "drawLineEnable"
    }
    
    
    /// objc_get/setAssociatedObject()来填充其 get 和 set
    @objc open var drawLineEnable: Bool {
        get {
            guard let value = objc_getAssociatedObject(self, &ChartLimitLineKeys.drawLineEnable) as? Bool else {
                return false
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &ChartLimitLineKeys.drawLineEnable, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
}

// extension UIView {
    
//     public func getRight() -> CGFloat {
//         return self.frame.origin.x + self.frame.size.width
//     }
    
//     public func getLeft() -> CGFloat {
//         return self.frame.origin.x
//     }
    
//     public func getWidth() -> CGFloat {
//         return self.frame.size.width
//     }
    
//     public func getHeight() -> CGFloat {
//         return self.frame.size.height
//     }
// }


extension ChartDataEntry {
    
    private struct ChartDataEntryExtraKeys {
        ///这里的key和TBKLineItem的值一致
        static let volume     = "volume"
        static let action     = "action"
        static let buy        = "buy"
        static let sell       = "sell"
        static let warning    = "warning"
        static let timestamp  = "time"
        static let tradeMark  = "tradeMark"
        static let actionType = "actionType"
        static let actionDes  = "actionDes"
        static let magicPoint = "magicPoint"
    }
    
    private func extraValue(forKey key: String) -> Any? {
        guard let dataMap = data as? [String: Any] else {
            return nil
        }
        return dataMap[key]
    }
    
    private func setExtraValue(_ value: Any?, forKey key: String) {
        var dataMap = data as? [String: Any]
        if dataMap == nil {
            dataMap = [String: Any]()
        }
        dataMap?[key] = value
        data = dataMap
    }
    
    @objc open var buy: Bool {
        get {
            guard let value = extraValue(forKey: ChartDataEntryExtraKeys.buy) as? Bool else {
                return false
            }
            return value
        }
        set {
            setExtraValue(newValue, forKey: ChartDataEntryExtraKeys.buy)
        }
    }
    
    @objc open var sell: Bool {
        get {
            guard let value = extraValue(forKey: ChartDataEntryExtraKeys.sell) as? Bool else {
                return false
            }
            return value
        }
        set {
            setExtraValue(newValue, forKey: ChartDataEntryExtraKeys.sell)
        }
    }
    
    @objc open var warning: Double {
        get {
            guard let value = extraValue(forKey: ChartDataEntryExtraKeys.warning) as? Double  else {
                return Double.nan
            }
            return value
        }
        set {
            setExtraValue(newValue, forKey: ChartDataEntryExtraKeys.warning)
        }
    }
    
    
    @objc open var volume: Double {
        get {
            guard let value = extraValue(forKey: ChartDataEntryExtraKeys.volume) as? Double else {
                return 0.0
            }
            return value
        }
        set {
            setExtraValue(newValue, forKey: ChartDataEntryExtraKeys.volume)
        }
    }
    
    @objc open var action: Bool {
        get {
            guard let value = extraValue(forKey: ChartDataEntryExtraKeys.action) as? Bool  else {
                return false
            }
            return value
        }
        set {
            setExtraValue(newValue, forKey: ChartDataEntryExtraKeys.action)
        }
    }
    
    @objc open var timestamp: Double {
        get {
            guard let value = extraValue(forKey: ChartDataEntryExtraKeys.timestamp) as? Double  else {
                return 0.0
            }
            return value
        }
        set {
            setExtraValue(newValue, forKey: ChartDataEntryExtraKeys.timestamp)
        }
    }
    
    @objc open var tradeMark: String? {
        get {
            guard let value = extraValue(forKey: ChartDataEntryExtraKeys.tradeMark) as? String  else {
                return nil
            }
            return value
        }
        set {
            setExtraValue(newValue, forKey: ChartDataEntryExtraKeys.tradeMark)
        }
    }
    
    @objc open var actionType: Int {
        get {
            guard let value = extraValue(forKey: ChartDataEntryExtraKeys.actionType) as? Int  else {
                return 0
            }
            return value
        }
        set {
            setExtraValue(newValue, forKey: ChartDataEntryExtraKeys.actionType)
        }
    }
    
    @objc open var actionDes: String? {
        get {
            guard let value = extraValue(forKey: ChartDataEntryExtraKeys.actionDes) as? String  else {
                return nil
            }
            return value
        }
        set {
            setExtraValue(newValue, forKey: ChartDataEntryExtraKeys.actionDes)
        }
    }
    
    @objc open var magicPoint: Int {
        get {
            guard let value = extraValue(forKey: ChartDataEntryExtraKeys.magicPoint) as? Int  else {
                return 0
            }
            return value
        }
        set {
            setExtraValue(newValue, forKey: ChartDataEntryExtraKeys.magicPoint)
        }
    }
}

extension CandleChartDataSet {
    
    private struct CandleChartDataSetKeys {
        static var drawJump: String = "drawJump"
        static var drawAction: String = "drawAction"
    }
    
    
    /// objc_get/setAssociatedObject()来填充其 get 和 set
    @objc open var drawJump: Bool {
        get {
            guard let value = objc_getAssociatedObject(self, &CandleChartDataSetKeys.drawJump) as? Bool  else {
                return false
            }
            return value
        }
        
        set {
            objc_setAssociatedObject(self, &CandleChartDataSetKeys.drawJump, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc open var drawAction : Bool {
        get {
            guard let value = objc_getAssociatedObject(self, &CandleChartDataSetKeys.drawAction) as? Bool  else {
                return false
            }
            return value
        }
        
        set {
            objc_setAssociatedObject(self, &CandleChartDataSetKeys.drawAction, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension YAxis {
    private struct YAxisKeys {
        static var numberFormatter: String = "numberFormatter"
        static var showOnlyMinMaxEnabled : String = "showOnlyMinMaxEnabled"
    }
    
    @objc open var numberFormatter : NumberFormatter {
        get {
            guard let value = objc_getAssociatedObject(self,&YAxisKeys.numberFormatter) as? NumberFormatter else {
                return NumberFormatter()
            }
            return value
        }
        
        set {
            self.valueFormatter = DefaultAxisValueFormatter(formatter: newValue)
            objc_setAssociatedObject(self, &YAxisKeys.numberFormatter, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    @objc open var showOnlyMinMaxEnabled: Bool  {
        get {
            guard let value = objc_getAssociatedObject(self, &YAxisKeys.showOnlyMinMaxEnabled) as? Bool else {
                return false
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &YAxisKeys.showOnlyMinMaxEnabled, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    
    
}

extension ChartDataSet {
    private struct ChartDataSetKeys {
        static var numberFormatter: String = "numberFormatter"
        static var dataSetCountDiff: String = "dataSetCountDiff"
    }
    
    @objc open var numberFormatter : NumberFormatter {
        get {
            guard let value = objc_getAssociatedObject(self,&ChartDataSetKeys.numberFormatter) as? NumberFormatter else {
                return NumberFormatter()
            }
            return value
        }
        
        set {
            self.valueFormatter = DefaultValueFormatter(formatter: newValue)
            objc_setAssociatedObject(self, &ChartDataSetKeys.numberFormatter, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// MOD:LPF 主要用来解决dateSetcount 不一致情况，当dataSet count 不一致时，start end所获取位置亦不正确，利用dataSetCountDiff 来判断dateSetcount 差异
    @objc open var dataSetCountDiff: Double {
        get {
            guard let value = objc_getAssociatedObject(self,&ChartDataSetKeys.dataSetCountDiff) as? Double else {
                return Double(0)
            }
            return value
        }
        
        set {
            objc_setAssociatedObject(self, &ChartDataSetKeys.dataSetCountDiff, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension XAxis {
    private struct XAxisKeys {
        static var xAxisValues: String = "xAxisValues"
    }
    
    @objc open var xAxisValues: [String] {
        get {
            guard let value = objc_getAssociatedObject(self,&XAxisKeys.xAxisValues) as? [String] else {
                return [String]()
            }
            return value
        }
        
        set(newValue) {
            objc_setAssociatedObject(self, &XAxisKeys.xAxisValues, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
    }
}


extension BarLineChartViewBase {
    private struct BarLineChartViewBaseKeys {
        static var isDrawContinue: String = "isDrawContinue"
    }
    
    @objc open var isDrawContinue: Bool {
        get {
            guard let value = objc_getAssociatedObject(self,&BarLineChartViewBaseKeys.isDrawContinue) as? Bool else {
                return true
            }
            return value
        }
        
        set {
            
            objc_setAssociatedObject(self, &BarLineChartViewBaseKeys.isDrawContinue, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
   
}

extension UIFont {
    @objc public class func tb_numberFont(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "DINPro", size: ofSize) ?? UIFont.systemFont(ofSize:ofSize)
    }
}

extension UIView {
    
    public func getRight() -> CGFloat {
        return self.frame.origin.x + self.frame.size.width
    }
    
    public func getLeft() -> CGFloat {
        return self.frame.origin.x
    }
    
    public func getWidth() -> CGFloat {
        return self.frame.size.width
    }
    
    public func getHeight() -> CGFloat {
        return self.frame.size.height
    }
}
