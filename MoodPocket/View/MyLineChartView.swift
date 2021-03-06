//
//  MyLineChartView.swift
//  MoodPocket
//
//  Created by 曾冰洁 on 2017/12/19.
//  Copyright © 2017年 曾冰洁. All rights reserved.
//

import UIKit

class MyLineChartView: UIView {
    
    var lastRangeChart = MyLineChart()
    var currentRangeChart = MyLineChart()
    var nextRangeChart = MyLineChart()
    
    fileprivate var selectedDate = Date()
    
    fileprivate var panGestureStartLocation: CGFloat!
    
    func refreshXLabels() {
        currentRangeChart.refreshXLabels()
    }
    
    func refreshLineChartData() {
        lastRangeChart.refreshLineChartData()
        currentRangeChart.refreshLineChartData()
        nextRangeChart.refreshLineChartData()
    }
    
    func setupUILayout() {
        self.addSubview(lastRangeChart)
        self.addSubview(currentRangeChart)
        self.addSubview(nextRangeChart)
        lastRangeChart.translatesAutoresizingMaskIntoConstraints = false
        currentRangeChart.translatesAutoresizingMaskIntoConstraints = false
        nextRangeChart.translatesAutoresizingMaskIntoConstraints = false
        lastRangeChart.frame = CGRect(x: 0, y: 0, width: self.bounds.width-40, height: 250)
        currentRangeChart.frame = CGRect(x: 0, y: 0, width: self.bounds.width-40, height: 250)
        nextRangeChart.frame = CGRect(x: 0, y: 0, width: self.bounds.width-40, height: 250)
        lastRangeChart.lastRange()
        nextRangeChart.nextRange()
        resetUILayout()
    }
    
    func getTimeLabelText() -> String {
        return currentRangeChart.getTimeLabelText()
    }
    
    func loadData() {
        lastRangeChart.addLine(lastRangeChart.getAverageMoodData())
        currentRangeChart.addLine(currentRangeChart.getAverageMoodData())
        nextRangeChart.addLine(nextRangeChart.getAverageMoodData())
    }
    
    func resetUILayout() {
        lastRangeChart.frame = CGRect(x: 0, y: 0, width: WIDTH-40, height: 250)
        currentRangeChart.frame = CGRect(x: 0, y: 0, width: WIDTH-40, height: 250)
        nextRangeChart.frame = CGRect(x: 0, y: 0, width: WIDTH-40, height: 250)
        lastRangeChart.center.x = -WIDTH * 0.5
        currentRangeChart.center.x = WIDTH * 0.5
        nextRangeChart.center.x = WIDTH * 1.5
    }
    
    func toggleCurrentView(_ pan: UIPanGestureRecognizer) {
        
        switch pan.state {
            
        case .began:
            self.panGestureStartLocation = pan.location(in: self).x
            
        case .changed:
            let changeInX = pan.location(in: self).x - self.panGestureStartLocation
            
            //if (currentRangeChart.center.x + changeInX <= self.bounds.size.width * 0.5) {
                
                lastRangeChart.center.x += changeInX
                currentRangeChart.center.x += changeInX
                nextRangeChart.center.x += changeInX
            //}
            
            self.panGestureStartLocation = pan.location(in: self).x
            
        case .ended:
            if self.currentRangeChart.center.x < (self.bounds.size.width * 0.5) - 50 {
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.currentRangeChart.center.x = -self.bounds.size.width * 0.5
                    self.nextRangeChart.center.x = self.bounds.size.width * 0.5
                }, completion: self.nextViewDidShow)
            }
            else if self.currentRangeChart.center.x > (self.bounds.size.width * 0.5) + 50 {
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.currentRangeChart.center.x = self.bounds.size.width * 1.5
                    self.lastRangeChart.center.x = self.bounds.size.width * 0.5
                }, completion: self.lastViewDidShow)
            }
            else {
                
                UIView.animate(withDuration: 0.15, animations: {
                    self.resetUILayout()
                })
            }
            
        default:
            break
        }
    }
    
    fileprivate func nextViewDidShow(_ finished: Bool) {
        if finished {
            lastRangeChart.nextRange()
            currentRangeChart.nextRange()
            nextRangeChart.nextRange()
            resetUILayout()
            for view: AnyObject in (self.superview?.subviews)! {
                if view.isKind(of: UILabel.self){
                    (view as! UILabel).text = currentRangeChart.getTimeLabelText()
                    break
                }
            }
        }
    }
    
    fileprivate func lastViewDidShow(_ finished: Bool) {
        if finished {
            lastRangeChart.lastRange()
            currentRangeChart.lastRange()
            nextRangeChart.lastRange()
            resetUILayout()
            for view: AnyObject in (self.superview?.subviews)! {
                if view.isKind(of: UILabel.self){
                    (view as! UILabel).text = currentRangeChart.getTimeLabelText()
                    break
                }
            }
        }
    }
    
    

}
