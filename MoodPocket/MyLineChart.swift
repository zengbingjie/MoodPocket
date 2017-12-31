//
//  MyLineChart.swift
//  MoodPocket
//
//  Created by 曾冰洁 on 2017/12/10.
//  Copyright © 2017年 曾冰洁. All rights reserved.
//

import UIKit
import QuartzCore

// MARK: Delegate Method
public protocol MyLineChartDelegate {
    func didSelectDataPoint(_ x: CGFloat, yValues: [CGFloat])
}

class MyLineChart: UIView {
    
    let weekdayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var xLabels: [String] = []
    var startDate = Date().minusDays(days: 6)
    var endDate = Date()

    fileprivate var panGestureRecognizer: UIPanGestureRecognizer!
    
    // my methods
    
    func refreshLineChartData() {
        clear()
        addLine(getAverageMoodData())
        for (lineIndex, _) in dataStore.enumerated() {
            drawLine(lineIndex)
            drawDataDots(lineIndex)
        }
    }
    
    private func getAverageMood(ofSelectedDate date: Date) -> Int {
        var averageMood = 0
        var count = 0
        for diary in diaries {
            if (diary.date.toString() == date.toString()){
                averageMood += diary.mood
                count += 1
            }
        }
        if count==0 {
            return -1
        } else {
            return Int(averageMood/count)
        }
    }
    
    func getAverageMoodData() -> [CGFloat] {
        var resultData: [CGFloat] = []
        var d = self.startDate
        while (true){
            if d.toString() == self.endDate.toString(){
                if d > Date() {
                    resultData.append(CGFloat(arc4random_uniform(101)))
                } else {
                    resultData.append(CGFloat(getAverageMood(ofSelectedDate: d)))
                }
                break
            } else {
                if d > Date() {
                    resultData.append(CGFloat(arc4random_uniform(101)))
                } else {
                    resultData.append(CGFloat(getAverageMood(ofSelectedDate: d)))
                }
                d = d.plusDays(days: 1)
            }
        }
        return resultData
    }
    
    func getTimeLabelText() -> String {
        var rtnStr = ""
        if startDate.getYear()==endDate.getYear(){
            rtnStr = monthNames[startDate.getMonth()-1] + String(startDate.getDay()) + " - " + monthNames[endDate.getMonth()-1] + String(endDate.getDay()) + ", " + String(endDate.getYear())
        } else {
            rtnStr = monthNames[startDate.getMonth()-1] + String(startDate.getDay()) + ", " + String(startDate.getYear()) + " - " + monthNames[endDate.getMonth()-1] + String(endDate.getDay()) + ", " + String(endDate.getYear())
        }
        if endDate>Date(){
            rtnStr += "(Future)"
        }
        return rtnStr
    }
    
    func lastRange(){
        startDate = startDate.minusDays(days: 8)
        endDate = endDate.minusDays(days: 8)
        clear()
        // remove all labels
        for view: AnyObject in self.subviews {
            view.removeFromSuperview()
        }
        addLine(getAverageMoodData())
        self.drawingHeight = self.bounds.height - (2 * y.axis.inset)
        self.drawingWidth = self.bounds.width - (2 * x.axis.inset)
        drawXLabels()
        for (lineIndex, _) in dataStore.enumerated() {
            drawLine(lineIndex)
            drawDataDots(lineIndex)
        }
    }
    
    func nextRange(){
        startDate = startDate.plusDays(days: 8)
        endDate = endDate.plusDays(days: 8)
        clear()
        // remove all labels
        for view: AnyObject in self.subviews {
            view.removeFromSuperview()
        }
        addLine(getAverageMoodData())
        self.drawingHeight = self.bounds.height - (2 * y.axis.inset)
        self.drawingWidth = self.bounds.width - (2 * x.axis.inset)
        drawXLabels()
        for (lineIndex, _) in dataStore.enumerated() {
            drawLine(lineIndex)
            drawDataDots(lineIndex)
        }
    }
    
    fileprivate func updateXLabels() {
        if xLabels.isEmpty {
            for index in 0...6 {
                xLabels.append(weekdayNames[(index + startDate.getWeekdayIndex())%7])
            }
        } else {
            for index in 0...6 {
                xLabels[index] = weekdayNames[(index + startDate.getWeekdayIndex())%7]
            }
        }
        self.x.labels = xLabels
    }
    
    fileprivate class func lightenUIColor(_ color: UIColor) -> UIColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: b * 1.5, alpha: a)
    }
    
    struct Grid {
        var count: CGFloat = 4
        // #eeeeee
        var color: UIColor = COLORS[3]
    }
    
    struct Axis {
        // #607d8b
        var color: UIColor = UIColor(red: 96/255.0, green: 125/255.0, blue: 139/255.0, alpha: 1)
        var inset: CGFloat = 15
    }
    
    struct Coordinate {
        var labels: [String] = []
        var grid: Grid = Grid()
        var axis: Axis = Axis()
        fileprivate var linear: MyLinearScale!
        fileprivate var scale: ((CGFloat) -> CGFloat)!
        fileprivate var invert: ((CGFloat) -> CGFloat)!
        fileprivate var ticks: (CGFloat, CGFloat, CGFloat)!
    }
    
    public struct Animation {
        var enabled: Bool = false
        var duration: CFTimeInterval = 1
    }
    
    public struct Dots {
        public var color: UIColor = UIColor.white
        public var innerRadius: CGFloat = 8
        public var outerRadius: CGFloat = 12
        public var innerRadiusHighlighted: CGFloat = 8
        public var outerRadiusHighlighted: CGFloat = 12
    }
    
    open var animation: Animation = Animation()
    open var dots: Dots = Dots()
    open var lineWidth: CGFloat = 2
    
    open var x: Coordinate = Coordinate()
    open var y: Coordinate = Coordinate()
    
    fileprivate var drawingHeight: CGFloat = 0 {
        didSet {
            let max = CGFloat(100)
            let min = CGFloat(0)
            y.linear = MyLinearScale(domain: [min, max], range: [0, drawingHeight])
            y.scale = y.linear.scale()
            y.ticks = y.linear.ticks(Int(y.grid.count))
        }
    }
    fileprivate var drawingWidth: CGFloat = 0 {
        didSet {
            let data = dataStore[0]
            x.linear = MyLinearScale(domain: [0.0, CGFloat(data.count - 1)], range: [0, drawingWidth])
            x.scale = x.linear.scale()
            x.invert = x.linear.invert()
            x.ticks = x.linear.ticks(Int(x.grid.count))
        }
    }
    
    open var delegate: MyLineChartDelegate?
    
    fileprivate var dataStore: [[CGFloat]] = []
    fileprivate var dotsDataStore: [[DotCALayer]] = []
    fileprivate var lineLayerStore: [CAShapeLayer] = []
    
    fileprivate var removeAll: Bool = false
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func draw(_ rect: CGRect) {
        if removeAll {
            let context = UIGraphicsGetCurrentContext()
            context?.clear(rect)
            return
        }
        
        self.drawingHeight = self.bounds.height - (2 * y.axis.inset)
        self.drawingWidth = self.bounds.width - (2 * x.axis.inset)
        
        // remove all labels
        for view: AnyObject in self.subviews {
            view.removeFromSuperview()
        }
        
        // remove all lines on device rotation
        for lineLayer in lineLayerStore {
            lineLayer.removeFromSuperlayer()
        }
        lineLayerStore.removeAll()
        
        // remove all dots on device rotation
        for dotsData in dotsDataStore {
            for dot in dotsData {
                dot.removeFromSuperlayer()
            }
        }
        dotsDataStore.removeAll()
        
        drawGrid()
        
        drawXLabels()
        
        // draw lines
        for (lineIndex, _) in dataStore.enumerated() {
            drawLine(lineIndex)
            // draw dots
            drawDataDots(lineIndex)
        }
        
    }
    
    fileprivate func getYValuesForXValue(_ x: Int) -> [CGFloat] {
        var result: [CGFloat] = []
        for lineData in dataStore {
            if x < 0 {
                result.append(lineData[0])
            } else if x > lineData.count - 1 {
                result.append(lineData[lineData.count - 1])
            } else {
                result.append(lineData[x])
            }
        }
        return result
    }
    
    fileprivate func handleTouchEvents(_ touches: NSSet!, event: UIEvent) {
        //print(event)
        if (self.dataStore.isEmpty) {
            return
        }
        let point: AnyObject! = touches.anyObject() as AnyObject!
        let xTouchValue = point.location(in: self).x
        let yTouchValue = point.location(in: self).y
        let xInverted = self.x.invert(xTouchValue - x.axis.inset)
        let xRounded = Int(round(Double(xInverted)))
        let yDatas: [CGFloat] = getYValuesForXValue(xRounded)
        let yActualValue = self.bounds.height - self.y.scale(yDatas[0]) - y.axis.inset - dots.outerRadius/2
        if fabsf(Float(yTouchValue-yActualValue))<10{
            highlightDataPoints(xRounded)
            delegate?.didSelectDataPoint(CGFloat(xRounded), yValues: yDatas)
        }
    }

    // Listen on touch end event.
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouchEvents(touches as NSSet!, event: event!)
    }

    //Listen on touch move event
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouchEvents(touches as NSSet!, event: event!)
    }
    
    public func highlightDataPoints(_ index: Int) {
        for (_, dotsData) in dotsDataStore.enumerated() {
            // make all dots white again
            for dot in dotsData {
                dot.backgroundColor = dots.color.cgColor
            }
            // highlight current data point
            var dot: DotCALayer
            if index < 0 {
                dot = dotsData[0]
            } else if index > dotsData.count - 1 {
                dot = dotsData[dotsData.count - 1]
            } else {
                dot = dotsData[index]
            }
            dot.backgroundColor = MyLineChart.lightenUIColor(COLORS[0]).cgColor
        }
    }
    
    public func drawDataDots(_ lineIndex: Int) {
        var dotLayers: [DotCALayer] = []
        var data = self.dataStore[lineIndex]
        
        for index in 0..<data.count {
            let xValue = self.x.scale(CGFloat(index)) + x.axis.inset - dots.outerRadius/2
            var yValue: CGFloat!
            if data[index] < 0{
                yValue = self.bounds.height - self.y.scale(50) - y.axis.inset - dots.outerRadius/2
            } else {
                yValue = self.bounds.height - self.y.scale(data[index]) - y.axis.inset - dots.outerRadius/2
            }
            // draw custom layer with another layer in the center
            let dotLayer = DotCALayer()
            
            if startDate.plusDays(days: index)>Date(){
                // 未来显示粉色
                dotLayer.dotInnerColor = COLORS[2]
            } else if data[index] < 0 {
                // 没有记录，显示灰色
                dotLayer.dotInnerColor = COLORS[6]
                
            } else {
                // 其他情况看心情值显示颜色
                if (data[index] < 33){
                    dotLayer.dotInnerColor = COLORS[4]
                } else if (data[index] < 66){
                    dotLayer.dotInnerColor = COLORS[1]
                } else {
                    dotLayer.dotInnerColor = COLORS[5]
                }
            }
            dotLayer.innerRadius = dots.innerRadius
            dotLayer.backgroundColor = dots.color.cgColor
            dotLayer.cornerRadius = dots.outerRadius / 2
            dotLayer.frame = CGRect(x: xValue, y: yValue, width: dots.outerRadius, height: dots.outerRadius)
            self.layer.addSublayer(dotLayer)
            dotLayers.append(dotLayer)

            if animation.enabled {
                let anim = CABasicAnimation(keyPath: "opacity")
                anim.duration = animation.duration
                anim.fromValue = 0
                anim.toValue = 1
                dotLayer.add(anim, forKey: "opacity")
            }
            
        }
        dotsDataStore.append(dotLayers)
    }

    public func drawLine(_ lineIndex: Int) {
        
        var data = self.dataStore[lineIndex]
        let path = UIBezierPath()
        
        var xValue = self.x.scale(0) + x.axis.inset
        var yValue = self.bounds.height - self.y.scale(data[0]<0 ? 50 : data[0]) - y.axis.inset
        path.move(to: CGPoint(x: xValue, y: yValue))
       
        for index in 1..<data.count {
            xValue = self.x.scale(CGFloat(index)) + x.axis.inset
            yValue = self.bounds.height - self.y.scale(data[index]<0 ? 50 : data[index]) - y.axis.inset
            path.addLine(to: CGPoint(x: xValue, y: yValue))
        }
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        layer.path = path.cgPath
        layer.strokeColor = COLORS[0].cgColor
        layer.fillColor = nil
        layer.lineWidth = lineWidth
        self.layer.addSublayer(layer)
        
        // animate line drawing
        if animation.enabled {
            let anim = CABasicAnimation(keyPath: "strokeEnd")
            anim.duration = animation.duration
            anim.fromValue = 0
            anim.toValue = 1
            layer.add(anim, forKey: "strokeEnd")
        }
        
        // add line layer to store
        lineLayerStore.append(layer)
    }
    
    public func drawYGrid() {
        self.y.grid.color.setStroke()
        let path = UIBezierPath()
        let x1: CGFloat = x.axis.inset
        let x2: CGFloat = self.bounds.width - x.axis.inset
        var y1: CGFloat
        let (start, stop, step) = self.y.ticks
        for i in stride(from: start, through: stop, by: step){
            y1 = self.bounds.height - self.y.scale(i) - y.axis.inset
            path.move(to: CGPoint(x: x1, y: y1))
            path.addLine(to: CGPoint(x: x2, y: y1))
        }
        path.stroke()
    }

    public func drawGrid() {
        drawYGrid()
    }
    
    func drawXLabels() {
        updateXLabels()
        let xAxisData = self.dataStore[0]
        let y = self.bounds.height - x.axis.inset
        let (_, _, step) = x.linear.ticks(xAxisData.count)
        let width = x.scale(step)+1
        var text: String
        for (index, _) in xAxisData.enumerated() {
            let xValue = self.x.scale(CGFloat(index)) + x.axis.inset - (width / 2)
            let label = UILabel(frame: CGRect(x: xValue, y: y, width: width, height: x.axis.inset))
            label.backgroundColor = COLORS[0]
            label.textColor = UIColor.white
            label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption2)
            label.textAlignment = .center
            if (x.labels.count != 0) {
                text = x.labels[index]
            } else {
                text = String(index)
            }
            label.text = text
            self.addSubview(label)
        }
    }

    open func addLine(_ data: [CGFloat]) {
        self.dataStore.append(data)
        self.setNeedsDisplay()
    }
    
    open func clearAll() {
        self.removeAll = true
        clear()
        self.setNeedsDisplay()
        self.removeAll = false
    }
    
    //Remove charts, areas and labels but keep axis and grid.
    open func clear() {
        // clear data
        dataStore.removeAll()
        self.setNeedsDisplay()
    }
}

class DotCALayer: CALayer {
    
    var innerRadius: CGFloat = 8
    var dotInnerColor = UIColor.black
    
    override init() {
        super.init()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        let inset = self.bounds.size.width - innerRadius
        let innerDotLayer = CALayer()
        innerDotLayer.frame = self.bounds.insetBy(dx: inset/2, dy: inset/2)
        innerDotLayer.backgroundColor = dotInnerColor.cgColor
        innerDotLayer.cornerRadius = innerRadius / 2
        self.addSublayer(innerDotLayer)
    }
    
}

open class MyLinearScale {
    
    var domain: [CGFloat]
    var range: [CGFloat]
    
    public init(domain: [CGFloat] = [0, 1], range: [CGFloat] = [0, 1]) {
        self.domain = domain
        self.range = range
    }
    
    open func scale() -> (_ x: CGFloat) -> CGFloat {
        return bilinear(domain, range: range, uninterpolate: uninterpolate, interpolate: interpolate)
    }
    
    open func invert() -> (_ x: CGFloat) -> CGFloat {
        return bilinear(range, range: domain, uninterpolate: uninterpolate, interpolate: interpolate)
    }
    
    open func ticks(_ m: Int) -> (CGFloat, CGFloat, CGFloat) {
        return scale_linearTicks(domain, m: m)
    }
    
    open func scale_linearTicks(_ domain: [CGFloat], m: Int) -> (CGFloat, CGFloat, CGFloat) {
        return scale_linearTickRange(domain, m: m)
    }
    
    open func scale_linearTickRange(_ domain: [CGFloat], m: Int) -> (CGFloat, CGFloat, CGFloat) {
        var extent = scaleExtent(domain)
        let span = extent[1] - extent[0]
        var step = CGFloat(pow(10, floor(log(Double(span) / Double(m)) / M_LN10)))
        let err = CGFloat(m) / span * step
        
        // Filter ticks to get closer to the desired count.
        if (err <= 0.15) {
            step *= 10
        } else if (err <= 0.35) {
            step *= 5
        } else if (err <= 0.75) {
            step *= 2
        }
        
        // Round start and stop values to step interval.
        let start = ceil(extent[0] / step) * step
        let stop = floor(extent[1] / step) * step + step * 0.5 // inclusive
        
        return (start, stop, step)
    }
    
    open func scaleExtent(_ domain: [CGFloat]) -> [CGFloat] {
        let start = domain[0]
        let stop = domain[domain.count - 1]
        return start < stop ? [start, stop] : [stop, start]
    }
    
    open func interpolate(_ a: CGFloat, b: CGFloat) -> (_ c: CGFloat) -> CGFloat {
        var diff = b - a
        func f(_ c: CGFloat) -> CGFloat {
            return (a + diff) * c
        }
        return f
    }
    
    open func uninterpolate(_ a: CGFloat, b: CGFloat) -> (_ c: CGFloat) -> CGFloat {
        var diff = b - a
        var re = diff != 0 ? 1 / diff : 0
        func f(_ c: CGFloat) -> CGFloat {
            return (c - a) * re
        }
        return f
    }
    
    open func bilinear(_ domain: [CGFloat], range: [CGFloat], uninterpolate: (_ a: CGFloat, _ b: CGFloat) -> (_ c: CGFloat) -> CGFloat, interpolate: (_ a: CGFloat, _ b: CGFloat) -> (_ c: CGFloat) -> CGFloat) -> (_ c: CGFloat) -> CGFloat {
        var u: (_ c: CGFloat) -> CGFloat = uninterpolate(domain[0], domain[1])
        var i: (_ c: CGFloat) -> CGFloat = interpolate(range[0], range[1])
        func f(_ d: CGFloat) -> CGFloat {
            return i(u(d))
        }
        return f
    }
    
}

