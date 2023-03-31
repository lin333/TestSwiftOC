//
//  CustomDrawChartDataProvider.swift
//  TBMixedChartView
//
//  Created by JustLee on 2020/3/20.
//  Copyright © 2020 luopengfei. All rights reserved.
//

import Foundation

@objc
public protocol CustomDrawChartDataProvider: BarLineScatterCandleBubbleChartDataProvider
{
    var customDrawData: CustomDrawChartData? { get }
}
