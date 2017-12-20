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
    
    public func setupUILayout() {
        lastRangeChart.addPanGestureRecognizer(target: self, action: #selector(self.toggleCurrentView(_:)))
        currentRangeChart.addPanGestureRecognizer(target: self, action: #selector(self.toggleCurrentView(_:)))
        nextRangeChart.addPanGestureRecognizer(target: self, action: #selector(self.toggleCurrentView(_:)))
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
    
    public func getTimeLabelText() -> String {
        return currentRangeChart.getTimeLabelText()
    }
    
    // TODO:
    public func loadData() {
        let data: [CGFloat] = [100, 20, 25, 35, 75, 80, 90]
        lastRangeChart.addLine(data)
        currentRangeChart.addLine(data)
        nextRangeChart.addLine(data)
    }
    
    public func resetUILayout() {
        lastRangeChart.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width-40, height: 250)
        currentRangeChart.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width-40, height: 250)
        nextRangeChart.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width-40, height: 250)
        lastRangeChart.center.x = -UIScreen.main.bounds.size.width * 0.5
        currentRangeChart.center.x = UIScreen.main.bounds.size.width * 0.5
        nextRangeChart.center.x = UIScreen.main.bounds.size.width * 1.5
    }
    
    @objc func toggleCurrentView(_ pan: UIPanGestureRecognizer) {
        
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
            resetUILayout()
            lastRangeChart.nextRange()
            currentRangeChart.nextRange()
            nextRangeChart.nextRange()
        }
    }
    
    fileprivate func lastViewDidShow(_ finished: Bool) {
        if finished {
            resetUILayout()
            lastRangeChart.lastRange()
            currentRangeChart.lastRange()
            nextRangeChart.lastRange()
        }
    }

}
