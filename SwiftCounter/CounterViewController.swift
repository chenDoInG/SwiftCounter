//
//  CounterViewController.swift
//  SwiftCounter
//
//  Created by chenDoInG on 15/11/19.
//  Copyright © 2015年 chenDoInG. All rights reserved.
//

import UIKit

class CounterViewController:UIViewController {
    
    var timeLabel:UILabel?
    var timeButtons:[UIButton]?
    var startStopButton:UIButton?
    var clearButton:UIButton?
    
    let timeButtonInfos = [("1分",60),("3分",180),("5分",300),("秒",1)]
    
    var remainingSeconds: Int = 0 {
        willSet(newSeconds) {
            let mins = newSeconds/60
            let seconds = newSeconds%60
            self.timeLabel!.text = String(format:"%02d:%02d",mins,seconds)
        }
    }
    
    var isCounting: Bool = false {
        willSet(newValue) {
            if newValue {
                timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimer:", userInfo: nil, repeats: true)
            } else {
                timer?.invalidate()
                timer = nil
            }
            setSettingButtonsEnabled(!newValue)
        }
    }
    
    var timer:NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
       
        setupTimeLabel()
        setupTimeButton()
        setupActionButtons()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        timeLabel!.frame = CGRectMake(10, 40, self.view.bounds.size.width-20, 120)
        
        let gap = ( self.view.bounds.size.width - 10*2 - (CGFloat(timeButtons!.count) * 64) ) / CGFloat(timeButtons!.count - 1)
        for (index, button) in timeButtons!.enumerate() {
            let buttonLeft = 10 + (64 + gap) * CGFloat(index)
            button.frame = CGRectMake(buttonLeft, self.view.bounds.size.height-120, 64, 44)
        }
        
        startStopButton!.frame = CGRectMake(10, self.view.bounds.size.height-60, self.view.bounds.size.width-20-100, 44)
        clearButton!.frame = CGRectMake(10+self.view.bounds.size.width-20-100+20, self.view.bounds.size.height-60, 80, 44)
    }
    
    func setupTimeLabel(){
        timeLabel = UILabel()
        timeLabel!.text = "00:00"
        timeLabel!.textColor = UIColor.whiteColor()
        timeLabel!.font = UIFont(name: "时间", size: 80)
        timeLabel!.backgroundColor = UIColor.blackColor()
        timeLabel!.textAlignment = NSTextAlignment.Center
    
        self.view.addSubview(timeLabel!)
    }
    
    func setupTimeButton(){
        var buttons = [UIButton]()
        for(index,(title,_)) in timeButtonInfos.enumerate(){
            let button:UIButton = UIButton()
            button.tag = index
            button.setTitle("\(title)", forState: UIControlState.Normal)
            button.backgroundColor = UIColor.orangeColor()
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
            button.addTarget(self, action: "timeButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
            
            buttons.insert(button,atIndex: index)
            self.view.addSubview(button)
        }
        timeButtons = buttons
    }
    
    func setupActionButtons() {
        
        //create start/stop button
        startStopButton = UIButton()
        startStopButton!.backgroundColor = UIColor.redColor()
        startStopButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        startStopButton!.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        startStopButton!.setTitle("启动/停止", forState: UIControlState.Normal)
        startStopButton!.addTarget(self, action: "startStopButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(startStopButton!)
        
        clearButton = UIButton()
        clearButton!.backgroundColor = UIColor.redColor()
        clearButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        clearButton!.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        clearButton!.setTitle("复位", forState: UIControlState.Normal)
        clearButton!.addTarget(self, action: "clearButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(clearButton!)
        
    }
    
    
    ///Actions & Callbacks
    func startStopButtonTapped(sender: UIButton) {
        isCounting = !isCounting

    }
    
    func clearButtonTapped(sender: UIButton) {
        remainingSeconds = 0
    }
    
    func timeButtonTapped(sender: UIButton) {
        let (_,seconds) = timeButtonInfos[sender.tag]
        remainingSeconds += seconds
    }
    
    func updateTimer(timer: NSTimer) {
        remainingSeconds -= 1
        
        if remainingSeconds <= 0 {
            self.isCounting = false
            self.timeLabel?.text = "00:00"
            self.remainingSeconds = 0
        }
    }
    
    func setSettingButtonsEnabled(enabled: Bool) {
        for button in self.timeButtons! {
            button.enabled = enabled
            button.alpha = enabled ? 1.0 : 0.3
        }
        clearButton!.enabled = enabled
        clearButton!.alpha = enabled ? 1.0 : 0.3
    }
}