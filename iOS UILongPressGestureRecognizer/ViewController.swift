//
//  ViewController.swift
//  iOS UILongPressGestureRecognizer
//
//  Created by Mazegeek Mac Mini 2018 on 12/13/19.
//  Copyright © 2019 Mazegeek Mac Mini 2018. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var longPressView: UIView!
    
    var startTime: Date? = nil
    var endTime: Date? = nil
    var longPress: UILongPressGestureRecognizer? = nil
    var timer: Timer? = nil
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        if #available(iOS 13.0, *) {
            return .darkContent
        }
        
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLongPressView()
        setupProgressView()
    }
    
    private func setupLongPressView() {
        
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(_:)))
        longPress?.minimumPressDuration = 0.01
        longPressView.addGestureRecognizer(longPress!)
    }
    
    private func setupProgressView() {
        progressBar.setProgress(0, animated: false)
        progressBar.trackTintColor = .lightGray
        progressBar.tintColor = .green
    }
    
    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: false)
    }
    
    @objc private func fireTimer() {
        
        longPress?.isEnabled = false
        longPress?.isEnabled = true
        progressBar.setProgress(0, animated: false)
        
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
        }
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "NextViewController") as! NextViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func longPressAction(_ sender: UILongPressGestureRecognizer) {
        
        let animator = UIViewPropertyAnimator(duration: 2.0, curve: .linear) {
            self.progressBar.setProgress(1, animated: true)
        }
        
        if sender.state == .began {
            print("Long Press Began: ", Date())
            startTime = Date()
            animator.startAnimation()
            setupTimer()
            
        }
        if sender.state == .changed {
            print("Long Press Changed: ", Date())
        }
        if sender.state == .cancelled {
            print("Long Press Cancelled: ", Date())
        }
        
        if sender.state == .ended {
            print("Long Press Ended: ", Date())
            endTime = Date()
            
            if let startTime = startTime, let endTime = endTime {
                
                let interval = DateInterval(start: startTime, end: endTime)
                print("Invter Duration: \(interval.duration.magnitude)")
                
                if interval.duration.magnitude < 2.0 {
                    animator.stopAnimation(true)
                    print("Animation Not Complete")
                    progressBar.setProgress(0, animated: false)
                    timer?.invalidate()
                    timer = nil
                }
//                else {
//                    print("Animation Complete: \(interval.duration.magnitude)")
//                    longPress?.isEnabled = false
//                    longPress?.isEnabled = true
//                    progressBar.setProgress(0, animated: false)
//
//                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "NextViewController") as! NextViewController
//                    navigationController?.pushViewController(vc, animated: true)
//                }
            }
        }
    }


}

