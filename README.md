# PDChart - Chart lib for iOS in Swift
---
A simple and beautiful chart lib for iOS, developed in Swift，refering to [PNChart](https://github.com/kevinzhow/PNChart/)
![PDChartDemo][1]

## Requirements

PDChart works on iOS 8.0 and later version. It depends on the following Apple frameworks, which should already be included with most Xcode templates:

* Foundation.framework
* UIKit.framework
* CoreGraphics.framework
* QuartzCore.framework

You will need LLVM 3.0 or later in order to build PNChart.




## Usage

### Copy the PDChart folder to your project


```swift
//for lineChart

var dataItem: PDLineChartDataItem = PDLineChartDataItem()
dataItem.xMax = 7.0
dataItem.xInterval = 1.0
dataItem.yMax = 100.0
dataItem.yInterval = 10.0
dataItem.pointArray = [CGPoint(x: 1.0, y: 95.0), CGPoint(x: 2.0, y: 25.0), CGPoint(x: 3.0, y: 30.0), CGPoint(x: 4.0, y:50.0), CGPoint(x: 5.0, y: 55.0), CGPoint(x: 6.0, y: 60.0), CGPoint(x: 7.0, y: 90.0)]
dataItem.xAxesDegreeTexts = ["周日", "一", "二", "三", "四", "五", "周六"]
dataItem.yAxesDegreeTexts = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]
        
var lineChart: PDLineChart = PDLineChart(frame: CGRectMake(0, 100, 320, 320), dataItem: dataItem)

self.view.addSubview(lineChart)
lineChart.strokeChart()

```

```swift
//for barChart

var dataItem: PDBarChartDataItem = PDBarChartDataItem()
dataItem.xMax = 7.0
dataItem.xInterval = 1.0
dataItem.yMax = 100.0
dataItem.yInterval = 10.0
dataItem.barPointArray = [CGPoint(x: 1.0, y: 95.0), CGPoint(x: 2.0, y: 25.0), CGPoint(x: 3.0, y: 30.0), CGPoint(x: 4.0, y:50.0), CGPoint(x: 5.0, y: 55.0), CGPoint(x: 6.0, y: 60.0), CGPoint(x: 7.0, y: 90.0)]
dataItem.xAxesDegreeTexts = ["周日", "一", "二", "三", "四", "五", "周六"]
dataItem.yAxesDegreeTexts = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]
        
var barChart: PDBarChart = PDBarChart(frame: CGRectMake(0, 100, 320, 320), dataItem: dataItem)

self.view.addSubview(barChart)
barChart.addSubview(barChart)

```

```swift
//for pieChart

var dataItem: PDPieChartDataItem = PDPieChartDataItem()
dataItem.pieWidth = 80
dataItem.pieMargin = 50
dataItem.dataArray = [PieDataItem(description: "first pie", color: lightGreen, percentage: 0.3),
                      PieDataItem(description: nil, color: middleGreen, percentage: 0.1),
                      PieDataItem(description: "third pie", color: deepGreen, percentage: 0.6)]
var pieChart: PDPieChart = PDPieChart(frame: CGRectMake(0, 100, 320, 320), dataItem: dataItem)
```

## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).

## SpecialThanks
[@kevinzhow](https://github.com/kevinzhow/PNChart/)  PNChart


  [1]: https://github.com/PandaraWen/PDChart/blob/master/readme_resource/PDChartDemo.gif