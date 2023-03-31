//
//  CompareChartDataProvider.swift
//  TBCharts
//
//  Created by JustLee on 2020/11/3.
//

import UIKit

@objc
public protocol CompareChartDataProvider: BarLineScatterCandleBubbleChartDataProvider
{
    var compareData: LineChartData? { get }
}
