//
//  PDBarChart.swift
//  PDChart
//
//  Created by Pandara on 14-7-11.
//  Copyright (c) 2014年 Pandara. All rights reserved.
//

import UIKit
import QuartzCore

class PDBarChartDataItem {
    //optional
    var axesColor: UIColor = UIColor(red: 80.0 / 255, green: 80.0 / 255, blue: 80.0 / 255, alpha: 1.0)              //坐标轴颜色
    var axesTipColor: UIColor = UIColor(red: 80.0 / 255, green: 80.0 / 255, blue: 80.0 / 255, alpha: 1.0)                                                                                                        //坐标轴刻度值颜色
    var chartLayerColor: UIColor = UIColor(red: 61.0 / 255, green: 189.0 / 255, blue: 100.0 / 255, alpha: 1.0)    //折线的颜色
    
    var barBgColor: UIColor = UIColor(red: 234.0 / 255, green: 234.0 / 255, blue: 234.0 / 255, alpha: 1.0)
    var barColor: UIColor = UIColor(red: 69.0 / 255, green: 189.0 / 255, blue: 100.0 / 255, alpha: 1.0)//69 189 100
    
    var showAxes: Bool = true
    var axesWidth: CGFloat = 1.0
    
    var barMargin: CGFloat = 4.0
    var barWidth: CGFloat!
    
    var barCornerRadius: CGFloat = 0
    
    //require
    var xMax: CGFloat!
    var xInterval: CGFloat!
    
    var yMax: CGFloat!
    var yInterval: CGFloat!
    
    var xAxesDegreeTexts: [String]?
    var yAxesDegreeTexts: [String]?
    
    var barPointArray: [CGPoint]?
    
    init() {
        
    }
}

class PDBarChart: PDChart {

    var axesComponent: PDChartAxesComponent!
    var dataItem: PDBarChartDataItem!
    
    //property
    var barBgArray: [UIView] = []
    var barLayerArray: [CAShapeLayer] = []
    
    init(frame: CGRect, dataItem: PDBarChartDataItem) {
        super.init(frame: frame)
        self.dataItem = dataItem
        
        var axesDataItem: PDChartAxesComponentDataItem = PDChartAxesComponentDataItem()
        axesDataItem.arrowBodyLength += 10
        axesDataItem.targetView = self
        axesDataItem.featureH = getFeatureHeight()
        axesDataItem.featureW = getFeatureWidth()
        axesDataItem.xMax = dataItem.xMax
        axesDataItem.xInterval = dataItem.xInterval
        axesDataItem.yMax = dataItem.yMax
        axesDataItem.yInterval = dataItem.yInterval
        axesDataItem.xAxesDegreeTexts = dataItem.xAxesDegreeTexts
        axesDataItem.showXDegree = false
        axesDataItem.axesWidth = dataItem.axesWidth
        
        self.axesComponent = PDChartAxesComponent(dataItem: axesDataItem)
        
        //bar width
        var xDegreeInterval = self.axesComponent.getXDegreeInterval()
        self.dataItem.barWidth = xDegreeInterval - dataItem.barMargin * 2
        
        self.addBarBackgroundView()
    }

    func getFeatureWidth() -> CGFloat {
        return CGFloat(self.frame.size.width)
    }
    
    func getFeatureHeight() -> CGFloat {
        return CGFloat(self.frame.size.height)
    }
    
    func getBarView(frame: CGRect) -> UIView {
        var barView: UIView = UIView(frame: frame)
        barView.backgroundColor = self.dataItem.barBgColor
        barView.clipsToBounds = true
        barView.layer.cornerRadius = self.dataItem.barCornerRadius
        return barView
    }
    
    func getBarShapeLayer(layerFrame: CGRect, barHeight: CGFloat) -> CAShapeLayer {
        var shapeLayer: CAShapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.whiteColor().CGColor
        shapeLayer.strokeColor = self.dataItem.barColor.CGColor
        shapeLayer.lineWidth = self.dataItem.barWidth
        shapeLayer.strokeStart = 0.0
        shapeLayer.strokeEnd = 1.0
        shapeLayer.frame = layerFrame
        
        var barPath: UIBezierPath = UIBezierPath()
        barPath.moveToPoint(CGPointMake(self.dataItem.barWidth / 2, layerFrame.size.height))
        barPath.addLineToPoint(CGPointMake(self.dataItem.barWidth / 2, layerFrame.size.height - barHeight))
        barPath.stroke()
        
        shapeLayer.path = barPath.CGPath
        
        return shapeLayer
    }
    
    func getBarAnimation() -> CABasicAnimation {
        CATransaction.begin()
        
        var pathAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 1.0
        pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pathAnimation.fromValue = 0.0
        pathAnimation.toValue = 1.0
        
        CATransaction.setCompletionBlock({
            () -> Void in
            return
        })
        
        CATransaction.commit()
        
        return pathAnimation
    }
    
    func addBarBackgroundView() {
        var xDegreeInterval: CGFloat = self.axesComponent.getXDegreeInterval()
        var basePoint: CGPoint = self.axesComponent.getBasePoint()
        var xAxesWidth: CGFloat = self.axesComponent.getXAxesWidth()
        var yAxesHeight: CGFloat = self.axesComponent.getYAxesHeight()
        
        for var i = 0; i < self.dataItem.barPointArray!.count; i++ {
            var point: CGPoint = self.dataItem.barPointArray![i]
            
            var bvw: CGFloat = self.dataItem.barWidth
            var bvh: CGFloat = yAxesHeight
            var bvx: CGFloat = basePoint.x + xDegreeInterval / 2 + self.dataItem.barMargin + (self.dataItem.barWidth + self.dataItem.barMargin * 2) * CGFloat(i)
            var bvy: CGFloat = basePoint.y - bvh - self.dataItem.axesWidth / 2
            
            var barView: UIView = self.getBarView(CGRectMake(bvx, bvy, bvw, bvh))
            self.barBgArray.append(barView)
            self.addSubview(barView)
        }
    }
    
    override func strokeChart()  {
        if !self.dataItem.barPointArray {
            return
        }
        
        UIGraphicsBeginImageContext(self.frame.size)
        
        var yAxesHeight: CGFloat = self.axesComponent.getYAxesHeight()
        
        for var i = 0; i < self.dataItem.barPointArray!.count; i++ {
            var point: CGPoint = self.dataItem.barPointArray![i]
            var barView: UIView = self.barBgArray[i]
            
            //barShape
            var barShapeLayer: CAShapeLayer = self.getBarShapeLayer(CGRectMake(0, 0, barView.frame.size.width, barView.frame.size.height), barHeight: point.y / self.dataItem.yMax * yAxesHeight)
            barShapeLayer.addAnimation(self.getBarAnimation(), forKey: "barAnimation")
            self.barLayerArray.append(barShapeLayer)
            barView.layer.addSublayer(barShapeLayer)
        }
        
        UIGraphicsEndImageContext()
    }

    override func drawRect(rect: CGRect)
    {
        super.drawRect(rect)
        
        var context: CGContextRef = UIGraphicsGetCurrentContext()
        axesComponent.strokeAxes(context)
    }

}







































