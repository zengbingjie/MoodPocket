//
//  TrackingViewController.swift
//  MoodPocket
//
//  Created by 曾冰洁 on 2017/12/9.
//  Copyright © 2017年 曾冰洁. All rights reserved.
//

import UIKit

class TrackingViewController: UIViewController, MyLineChartDelegate{
    
    var lineChart = MyLineChart()
    var timeLabel = UILabel(frame: CGRect(x:16, y:130, width:UIScreen.main.bounds.size.width, height:30))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var views: [String: AnyObject] = [:]
        
        timeLabel.text = lineChart.getTimeLabelText()
        
        self.view.addSubview(timeLabel)
        views["timeLabel"] = timeLabel
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[timeLabel]-|", options: [], metrics: nil, views: views))
        
        // data arrays
        let data: [CGFloat] = [100, 20, 25, 35, 75, 80, 90]
        
        // simple line with custom x axis labels
        lineChart.addLine(data)
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.delegate = self
        self.view.addSubview(lineChart)
        views["chart"] = lineChart
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[chart]-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[timeLabel]-8-[chart(==250)]", options: [], metrics: nil, views: views))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Action
    
    @IBAction func lastRange(_ sender: UIButton) {
        lineChart.lastRange()
        timeLabel.text = lineChart.getTimeLabelText()
    }
    
    @IBAction func nextRange(_ sender: UIButton) {
        lineChart.nextRange()
        timeLabel.text = lineChart.getTimeLabelText()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    /**
     * Line chart delegate method.
     */
    func didSelectDataPoint(_ x: CGFloat, yValues: Array<CGFloat>) {
        timeLabel.text = "x: \(x)     y: \(yValues)"
    }
    
    
    
    /**
     * Redraw chart on device rotation.
     */
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
            lineChart.setNeedsDisplay()
    }
    



}
