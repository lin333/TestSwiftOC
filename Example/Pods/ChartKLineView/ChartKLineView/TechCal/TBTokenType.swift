
//
//  TBTokenType.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/11/19.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import Foundation

public enum TBIndexType: String {
    case MA     = "MA"
    case EMA    = "EMA"
    case SAR    = "SAR"
    case BBI    = "BBI"
    case HMA    = "HMA"
    case LMA    = "LMA"
    case VMA    = "VMA"
    case BBIBOLL = "BBIBOLL"
    case ALLIGAT="ALLIGAT"
    case PBX    = "PBX"
    case ENE    = "ENE"
    case MIKE   = "MIKE"
    case XT     = "XT"
    case JAX    = "JAX"
    case VOLUME = "成交量"
    case MACD   = "MACD"
    case BOLL   = "BOLL"
    case KDJ    = "KDJ"
    case RSI    = "RSI"
    case OBV    = "OBV"
    case DMI    = "DMI"
    case WR     = "WR"
    case EMV    = "EMV"
    case DMA    = "DMA"
    case ARBR   = "ARBR"
    case CODE   = "CODE"
    case MACDKDJ = "MACDKDJ"
    case VR     = "VR"
    case TPXH   = "TPXH"
    case CCI = "CCI"
    case MFI = "MFI"
    case ATR = "ATR"
    case TRIX = "TRIX"
    case BIAS = "BIAS"
    case DKX = "DKX"
    case PCNT = "PCNT"
    case ROC = "ROC"
    case SKDJ = "SKDJ"
    case UDL = "UDL"
    case VRSI = "VRSI"
    case WAD = "WAD"
    case XS = "XS"
    case NONE   = "NONE"
    case ZigZag = "ZigZag"
    case MTM = "MTM"
    case ADTM = "ADTM"
    case CR = "CR"
    case WVAD = "WVAD"

    private static var _name: String = ""
    public static var name: String {
        get {
            return _name
        }
        
        set {
            _name = newValue
        }
    }
    
    public static func getType(type: TBIndexType) -> String {
        switch type {
        case .MA:     return "MA"
        case .EMA:    return "EMA"
        case .SAR:    return "SAR"
        case .VOLUME: return "成交量"
        case .MACD:   return "MACD"
        case .BOLL:   return "BOLL"
        case .KDJ:    return "KDJ"
        case .RSI:    return "RSI"
        case .OBV:    return "OBV"
        case .DMI:    return "DMI"
        case .WR:     return "WR"
        case .EMV:    return "EMV"
        case .DMA:    return "DMA"
        case .ARBR:   return "ARBR"
        case .NONE:   return "NONE"
        case .CODE:   return "CODE"
        case .MACDKDJ: return "MACDKDJ"
        case .VR:     return "VR"
        case .TPXH:   return "TPXH"
        case .ZigZag: return "ZigZag"
        case .CCI:
            return "CCI"
        case .MFI:
            return "MFI"
        case .ATR:
            return "ATR"
        case .TRIX:
            return "TRIX"
        case .BIAS:
            return "BIAS"
        case .DKX:
            return "DKX"
        case .PCNT:
            return "PCNT"
        case .ROC:
            return "ROC"
        case .SKDJ:
            return "SKDJ"
        case .UDL:
            return "UDL"
        case .VRSI:
            return "VRSI"
        case .WAD:
            return "WAD"
        case .XS:
            return "XS"
        case .BBI:
            return "BBI"
        case .HMA:
            return "HMA"
        case .LMA:
            return "LMA"
        case .VMA:
            return "VMA"
        case .BBIBOLL:
            return "BBIBOLL"
        case .ALLIGAT:
            return "ALLIGAT"
        case .PBX:
            return "PBX"
        case .ENE:
            return "ENE"
        case .MIKE:
            return "MIKE"
        case .XT:
            return "XT"
        case .JAX:
            return "JAX"
        case .MTM:
            return "MTM"
        case .ADTM:
            return "ADTM"
        case .CR:
            return "CR"
        case .WVAD:
            return "WVAD"
        }
        
    }
}

protocol ITBDecoration {
    var name: String {get set}
    
}

public enum TBDecoration: String {
    
    case COLORSTICK = "COLORSTICK"
    case CIRCLEDOT = "CIRCLEDOT"
    case BROKENLINE = "BROKENLINE"
    
    static func getDecoration(str: String) -> TBDecoration {
        switch str {
        case "COLORSTICK":
            return .COLORSTICK
        case "CIRCLEDOT":
            return .CIRCLEDOT
        case "BROKENLINE":
            return .BROKENLINE
        default:
            return .CIRCLEDOT
      
        }
    }
    
//    private var _name : String
//    public var name: String {
//        get {
//            return _name
//        }
//
//        set {
//            _name = name
//        }
//    }
}

public enum TBTokenType {
    case SMA 
    case NEW_ASSIGN 
    case ASSIGN 
    case HIGH 
    case LOW 
    case CLOSE 
    case REF 
    case OPEN 
    case NUMBER 
    case COLON //冒号
    case SEMICOLON //分号
    case IF
    case OP
    case ABS
    case SPACE
    case SUM
    case LP //(
    case RP //)
    case VAR
    case MAX
    case MIN
    case COM   //
    case EQ
    case AND
    case OR
    case NULL
    case GT
    case LT
    case MA
    case VOL
    case LTE
    case GTE
    case EMA
    case COLORSTICK  //柱形图
    case HHV  //一段时间内最高值
    case LLV
    case TAB
    case STD
    case SAR
    case CIRCLEDOT  //一段时间内最低值
    case AVEDEV  //平均绝对偏差
    case DMA
    case ZigZag
}

open class TBToken: NSObject {
    open var kind: TBTokenType = .SMA
    open var beginLine: Int = Int(0)
    open var endLine: Int = Int(0)
    open var beginColumn: Int = Int(0)
    open var endColumn: Int = Int(0)
    open var image: String?
    open var next: TBToken?
    open var specialToken: TBToken?
    
    public init(initKind: TBTokenType, initBeginLine: Int, initEndLine: Int, initBeginColumn: Int, initEndColumn: Int, initImage: String, initNext: TBToken?, initSpecialToken: TBToken?) {
        super.init()
        self.kind = initKind
        self.beginLine = initBeginLine
        self.endLine = initEndLine
        self.beginColumn = initBeginColumn
        self.endColumn = initEndColumn
        self.image = initImage
        self.next = initNext
        self.specialToken = initSpecialToken
        
    }
    
}






