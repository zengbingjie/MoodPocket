//
//  TrackingViewController.swift
//  MoodPocket
//
//  Created by 曾冰洁 on 2017/12/9.
//  Copyright © 2017年 曾冰洁. All rights reserved.
//

import UIKit

class TrackingViewController: UIViewController, MyLineChartDelegate {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var lineChartView: MyLineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupUILayout()
        self.lineChartView.setupUILayout()
        lineChartView.loadData()
        timeLabel.text = lineChartView.getTimeLabelText()
        lineChartView.lastRangeChart.delegate = self
        lineChartView.currentRangeChart.delegate = self
        lineChartView.nextRangeChart.delegate = self
        lineChartView.lastRangeChart.lastRange()
        lineChartView.nextRangeChart.nextRange()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        // TODO: do something
        timeLabel.text = "x: \(x)     y: \(yValues)"
    }
    
    /**
     * Redraw chart on device rotation.
     */
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        lineChartView.currentRangeChart.setNeedsDisplay()
        lineChartView.lastRangeChart.setNeedsDisplay()
        lineChartView.nextRangeChart.setNeedsDisplay()
        lineChartView.resetUILayout()
    }
    
    // MARK: Private Methods

    private func setupUILayout() {
        // simple line with custom x axis labels
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        lineChartView.frame = CGRect(x: 0, y: timeLabel.frame.maxY+8, width: UIScreen.main.bounds.size.width, height: 250)
    }
    
    fileprivate func lastViewDidShow(_ finished: Bool) {
        if finished {
            
            lineChartView.lastRangeChart.lastRange()
            lineChartView.currentRangeChart.lastRange()
            lineChartView.nextRangeChart.lastRange()
            lineChartView.resetUILayout()
            timeLabel.text = lineChartView.currentRangeChart.getTimeLabelText()
        }
    }
    
    fileprivate func nextViewDidShow(_ finished: Bool) {
        if finished {
            
            lineChartView.lastRangeChart.nextRange()
            lineChartView.currentRangeChart.nextRange()
            lineChartView.nextRangeChart.nextRange()
            lineChartView.resetUILayout()
            timeLabel.text = lineChartView.currentRangeChart.getTimeLabelText()
        }
    }
    
    // MARK: Actions

    @IBAction func lastRangeButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, animations: {
            self.lineChartView.currentRangeChart.center.x = self.lineChartView.bounds.size.width * 1.5
            self.lineChartView.lastRangeChart.center.x = self.lineChartView.bounds.size.width * 0.5
        }, completion: self.lastViewDidShow)
    }
    
    @IBAction func nextRangeButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, animations: {
            self.lineChartView.currentRangeChart.center.x = -self.lineChartView.bounds.size.width * 0.5
            self.lineChartView.nextRangeChart.center.x = self.lineChartView.bounds.size.width * 0.5
        }, completion: self.nextViewDidShow)
    }
    
    @IBAction func dragLineChartView(_ sender: UIPanGestureRecognizer) {
        lineChartView.toggleCurrentView(sender)
    }
    
}
