//
//  PDChartAxesComponent.swift
//  PDChart
//
//  Created by Pandara on 14-7-11.
//  Copyright (c) 2014年 Pandara. All rights reserved.
//

import UIKit

class PDChartAxesComponentDataItem: NSObject {
    //required
    var targetView: UIView!
    
    var featureH: CGFloat!
    var featureW: CGFloat!
    
    var xMax: CGFloat!
    var xInterval: CGFloat!
    var yMax: CGFloat!
    var yInterval: CGFloat!
    
    var xAxesDegreeTexts: [String]?
    var yAxesDegreeTexts: [String]?
    
    //optional default
    var showAxes: Bool = true
    
    var showXDegree: Bool = true
    var showYDegree: Bool = true
    
    var axesColor: UIColor = UIColor(red: 80.0 / 255, green: 80.0 / 255, blue: 80.0 / 255, alpha: 1.0)//坐标轴颜色
    var axesTipColor: UIColor = UIColor(red: 80.0 / 255, green: 80.0 / 255, blue: 80.0 / 255, alpha: 1.0)//坐标轴刻度值颜色
    
    var xAxesLeftMargin: CGFloat = 40                   //坐标系左边margin
    var xAxesRightMargin: CGFloat = 40                  //坐标系右边margin
    var yAxesBottomMargin: CGFloat = 40                 //坐标系下面margin
    var yAxesTopMargin: CGFloat = 40                    //坐标系上方marign
    
    var axesWidth: CGFloat = 1.0     //坐标轴的粗细
    
    var arrowHeight: CGFloat = 5.0
    var arrowWidth: CGFloat = 5.0
    var arrowBodyLength: CGFloat = 10.0
    
    var degreeLength: CGFloat = 5.0             //坐标轴刻度直线的长度
    var degreeTipFontSize: CGFloat = 10.0
    var degreeTipMarginHorizon: CGFloat = 5.0
    var degreeTipMarginVertical: CGFloat = 5.0
    
    override init() {
        
    }
}

class PDChartAxesComponent: NSObject {
    
    var dataItem: PDChartAxesComponentDataItem!
    
    init(dataItem: PDChartAxesComponentDataItem) {
        self.dataItem = dataItem
    }
    
    func getYAxesHeight() -> CGFloat {//heigth between 0~yMax
        var basePoint: CGPoint = self.getBasePoint()
        var yAxesHeight = basePoint.y - dataItem.arrowHeight - dataItem.yAxesTopMargin - dataItem.arrowBodyLength
        return yAxesHeight
    }
    
    func getXAxesWidth() -> CGFloat {//width between 0~xMax
        var basePoint: CGPoint = self.getBasePoint()
        var xAxesWidth = dataItem.featureW - basePoint.x - dataItem.arrowHeight - dataItem.xAxesRightMargin - dataItem.arrowBodyLength
        return xAxesWidth
    }
    
    func getBasePoint() -> CGPoint {
        
        var neededAxesWidth: CGFloat!
        if dataItem.showAxes {
            neededAxesWidth = CGFloat(dataItem.axesWidth)
        } else {
            neededAxesWidth = 0
        }
        
        var basePoint: CGPoint = CGPoint(x: dataItem.xAxesLeftMargin + neededAxesWidth / 2.0, y: dataItem.featureH - (dataItem.yAxesBottomMargin + neededAxesWidth / 2.0))
        return basePoint
    }
    
    func getXDegreeInterval() -> CGFloat {
        var xAxesWidth: CGFloat = self.getXAxesWidth()
        var xDegreeInterval: CGFloat = dataItem.xInterval / dataItem.xMax * xAxesWidth
        return xDegreeInterval
    }
    
    func getYDegreeInterval() -> CGFloat {
        var yAxesHeight: CGFloat = self.getYAxesHeight()
        var yDegreeInterval: CGFloat = dataItem.yInterval / dataItem.yMax * yAxesHeight
        return yDegreeInterval
    }
    
    func getAxesDegreeTipLabel(tipText: String, center: CGPoint, size: CGSize, fontSize: CGFloat, textAlignment: NSTextAlignment, textColor: UIColor) -> UILabel {
        var label: UILabel = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        label.text = tipText
        label.center = center
        label.textAlignment = textAlignment
        label.textColor = textColor
        label.backgroundColor = UIColor.clearColor()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFontOfSize(fontSize)
        return label
    }
    
    func getXAxesDegreeTipLabel(tipText: String, center: CGPoint, size: CGSize, fontSize: CGFloat) -> UILabel {
        return self.getAxesDegreeTipLabel(tipText, center: center, size: size, fontSize: fontSize, textAlignment: NSTextAlignment.Center, textColor: dataItem.axesTipColor)
    }
    
    func getYAxesDegreeTipLabel(tipText: String, center: CGPoint, size: CGSize, fontSize: CGFloat) -> UILabel {
        return self.getAxesDegreeTipLabel(tipText, center: center, size: size, fontSize: fontSize, textAlignment: NSTextAlignment.Right, textColor: dataItem.axesTipColor)
    }
    
    func strokeAxes(context: CGContextRef?) {
        var xAxesWidth: CGFloat = self.getXAxesWidth()
        var yAxesHeight: CGFloat = self.getYAxesHeight()
        var basePoint: CGPoint = self.getBasePoint()
        
        
        if dataItem.showAxes {
            CGContextSetStrokeColorWithColor(context, dataItem.axesColor.CGColor)
            CGContextSetFillColorWithColor(context, dataItem.axesColor.CGColor)
            
            var axesPath: UIBezierPath = UIBezierPath()
            axesPath.lineWidth = dataItem.axesWidth
            axesPath.lineCapStyle = kCGLineCapRound
            axesPath.lineJoinStyle = kCGLineJoinRound
            
            //x axes--------------------------------------
            axesPath.moveToPoint(CGPoint(x: basePoint.x, y: basePoint.y))
            axesPath.addLineToPoint(CGPoint(x: basePoint.x + xAxesWidth, y: basePoint.y))
            
            //degrees in x axes
            var xDegreeNum: Int = Int((dataItem.xMax - (dataItem.xMax % dataItem.xInterval)) / dataItem.xInterval)
            var xDegreeInterval: CGFloat = self.getXDegreeInterval()

            if dataItem.showXDegree {
                for var i = 0; i < xDegreeNum; i++ {
                    var degreeX: CGFloat = basePoint.x + xDegreeInterval * CGFloat(i + 1)
                    axesPath.moveToPoint(CGPoint(x: degreeX, y: basePoint.y))
                    axesPath.addLineToPoint(CGPoint(x: degreeX, y: basePoint.y - dataItem.degreeLength))
                }
            }
            
            //x axes arrow
            //arrow body
            axesPath.moveToPoint(CGPoint(x: basePoint.x + xAxesWidth, y: basePoint.y))
            axesPath.addLineToPoint(CGPoint(x: basePoint.x + xAxesWidth + dataItem.arrowBodyLength, y: basePoint.y))
            //arrow head
            var arrowPath: UIBezierPath = UIBezierPath()
            arrowPath.lineWidth = dataItem.axesWidth
            arrowPath.lineCapStyle = kCGLineCapRound
            arrowPath.lineJoinStyle = kCGLineJoinRound
            
            var xArrowTopPoint: CGPoint = CGPoint(x: basePoint.x + xAxesWidth + dataItem.arrowBodyLength + dataItem.arrowHeight, y: basePoint.y)
            arrowPath.moveToPoint(xArrowTopPoint)
            arrowPath.addLineToPoint(CGPoint(x: basePoint.x + xAxesWidth + dataItem.arrowBodyLength, y: basePoint.y - dataItem.arrowWidth / 2))
            arrowPath.addLineToPoint(CGPoint(x: basePoint.x + xAxesWidth + dataItem.arrowBodyLength, y: basePoint.y + dataItem.arrowWidth / 2))
            arrowPath.addLineToPoint(xArrowTopPoint)
            
            //y axes--------------------------------------
            axesPath.moveToPoint(CGPoint(x: basePoint.x, y: basePoint.y))
            axesPath.addLineToPoint(CGPoint(x: basePoint.x, y: basePoint.y - yAxesHeight))
            
            //degrees in y axes
            var yDegreesNum: Int = Int((dataItem.yMax - (dataItem.yMax % dataItem.yInterval)) / dataItem.yInterval)
            var yDegreeInterval: CGFloat = self.getYDegreeInterval()
            if dataItem.showYDegree {
                for var i = 0; i < yDegreesNum; i++ {
                    var degreeY: CGFloat = basePoint.y - yDegreeInterval * CGFloat(i + 1)
                    axesPath.moveToPoint(CGPoint(x: basePoint.x, y: degreeY))
                    axesPath.addLineToPoint(CGPoint(x: basePoint.x +  dataItem.degreeLength, y: degreeY))
                }
            }
            
            //y axes arrow
            //arrow body
            axesPath.moveToPoint(CGPoint(x: basePoint.x, y: basePoint.y - yAxesHeight))
            axesPath.addLineToPoint(CGPoint(x: basePoint.x, y: basePoint.y - yAxesHeight - dataItem.arrowBodyLength))
            //arrow head
            var yArrowTopPoint: CGPoint = CGPoint(x: basePoint.x, y: basePoint.y - yAxesHeight - dataItem.arrowBodyLength - dataItem.arrowHeight)
            arrowPath.moveToPoint(yArrowTopPoint)
            arrowPath.addLineToPoint(CGPoint(x: basePoint.x - dataItem.arrowWidth / 2, y: basePoint.y - yAxesHeight - dataItem.arrowBodyLength))
            arrowPath.addLineToPoint(CGPoint(x: basePoint.x + dataItem.arrowWidth / 2, y: basePoint.y - yAxesHeight - dataItem.arrowBodyLength))
            arrowPath.addLineToPoint(yArrowTopPoint)
            
            axesPath.stroke()
            arrowPath.stroke()
            
            //axes tips------------------------------------
            //func getXAxesDegreeTipLabel(tipText: String, frame: CGRect, fontSize: CGFloat) -> UILabel {
            if (dataItem.xAxesDegreeTexts != nil) {
                for var i = 0; i < dataItem.xAxesDegreeTexts!.count; i++ {
                    var size: CGSize = CGSize(width: xDegreeInterval - dataItem.degreeTipMarginHorizon * 2, height: dataItem.degreeTipFontSize)
                    var center: CGPoint = CGPoint(x: basePoint.x + xDegreeInterval * CGFloat(i + 1), y: basePoint.y + dataItem.degreeTipMarginVertical + size.height / 2)
                    var label: UILabel = self.getXAxesDegreeTipLabel(dataItem.xAxesDegreeTexts![i], center: center, size: size, fontSize: dataItem.degreeTipFontSize)
                    dataItem.targetView.addSubview(label)
                }
            } else {
                for var i = 0; i < xDegreeNum; i++ {
                    var size: CGSize = CGSize(width: xDegreeInterval - dataItem.degreeTipMarginHorizon * 2, height: dataItem.degreeTipFontSize)
                    var center: CGPoint = CGPoint(x: basePoint.x + xDegreeInterval * CGFloat(i + 1), y: basePoint.y + dataItem.degreeTipMarginVertical + size.height / 2)
                    var label: UILabel = self.getXAxesDegreeTipLabel("\(CGFloat(i + 1) * dataItem.xInterval)", center: center, size: size, fontSize: dataItem.degreeTipFontSize)
                    dataItem.targetView.addSubview(label)
                }
            }
            
            if (dataItem.yAxesDegreeTexts != nil) {
                for var i = 0; i < dataItem.yAxesDegreeTexts!.count; i++ {
                    var size: CGSize = CGSize(width: dataItem.xAxesLeftMargin - dataItem.degreeTipMarginHorizon * 2, height: dataItem.degreeTipFontSize)
                    var center: CGPoint = CGPoint(x: dataItem.xAxesLeftMargin / 2, y: basePoint.y - yDegreeInterval * CGFloat(i + 1))
                    var label: UILabel = self.getYAxesDegreeTipLabel(dataItem.yAxesDegreeTexts![i], center: center, size: size, fontSize: dataItem.degreeTipFontSize)
                    dataItem.targetView.addSubview(label)
                }
            } else {
                for var i = 0; i < yDegreesNum; i++ {
                    var size: CGSize = CGSize(width: dataItem.xAxesLeftMargin - dataItem.degreeTipMarginHorizon * 2, height: dataItem.degreeTipFontSize)
                    var center: CGPoint = CGPoint(x: dataItem.xAxesLeftMargin / 2, y: basePoint.y - yDegreeInterval * CGFloat(i + 1))
                    var label: UILabel = self.getYAxesDegreeTipLabel("\(CGFloat(i + 1) * dataItem.yInterval)", center: center, size: size, fontSize: dataItem.degreeTipFontSize)
                    dataItem.targetView.addSubview(label)
                }
            }
        }

    }
}





















