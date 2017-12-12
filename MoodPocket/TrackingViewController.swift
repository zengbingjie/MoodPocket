//
//  TrackingViewController.swift
//  MoodPocket
//
//  Created by 曾冰洁 on 2017/12/9.
//  Copyright © 2017年 曾冰洁. All rights reserved.
//

import UIKit

class TrackingViewController: UIViewController, MyLineChartDelegate{
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var lineChart: MyLineChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        timeLabel.text = lineChart.getTimeLabelText()
        setupUILayout()
        // load data
        let data: [CGFloat] = [100, 20, 25, 35, 75, 80, 90]
        lineChart.addLine(data)
        lineChart.delegate = self
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
    
    // MARK: Actions
    
    @IBAction func swipeGestureRecognized(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .right{
            lineChart.lastRange()
            timeLabel.text = lineChart.getTimeLabelText()
        } else if sender.direction == .left {
            lineChart.nextRange()
            timeLabel.text = lineChart.getTimeLabelText()
        } else {
            // do nothing
        }
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
        // TODO: update table view cell
    }
    
    
    
    /**
     * Redraw chart on device rotation.
     */
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
            lineChart.setNeedsDisplay()
    }
    
    // MARK: Private Methods

    private func setupUILayout() {
        var views: [String: AnyObject] = [:]
        views["timeLabel"] = timeLabel
        // simple line with custom x axis labels
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        views["chart"] = lineChart
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[chart]-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[timeLabel]-8-[chart(==250)]", options: [], metrics: nil, views: views))
    }

}
