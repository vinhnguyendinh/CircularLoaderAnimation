//
//  ViewController.swift
//  CircleAnimation
//
//  Created by Vinh Nguyen on 6/22/18.
//  Copyright © 2018 Vinh Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let circleLayer = CAShapeLayer()

    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "100%"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    fileprivate func drawCircleBackground(_ circlePath: UIBezierPath, _ centerPoint: CGPoint) {
        let circleBackgroundLayer = CAShapeLayer()
        
        circleBackgroundLayer.path = circlePath.cgPath
        circleBackgroundLayer.strokeColor = UIColor.lightGray.cgColor
        circleBackgroundLayer.lineWidth = 10
        circleBackgroundLayer.position = centerPoint
        circleBackgroundLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        circleBackgroundLayer.fillColor = UIColor.clear.cgColor
        
        self.view.layer.addSublayer(circleBackgroundLayer)
    }
    
    fileprivate func drawCircleAnimation(_ circlePath: UIBezierPath, _ centerPoint: CGPoint) {
        circleLayer.path = circlePath.cgPath
        circleLayer.strokeColor = UIColor.red.cgColor
        circleLayer.lineWidth = 10
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeEnd = 0
        circleLayer.lineCap = kCALineCapRound
        circleLayer.position = centerPoint
        circleLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        
        self.view.layer.addSublayer(circleLayer)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let centerPoint = view.center
        let circlePath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        
        drawCircleBackground(circlePath, centerPoint)
        
        drawCircleAnimation(circlePath, centerPoint)
        
        self.percentageLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        self.view.addSubview(percentageLabel)
    }
    
    fileprivate func animateCircle() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fromValue = 0
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.isRemovedOnCompletion = false
        basicAnimation.fillMode = kCAFillModeForwards
        
        circleLayer.add(basicAnimation, forKey: "circleAnimation")
    }
    
    let urlString = "http://cdn.baogiaothong.vn/files/nhung.nguyen/2017/01/19/ngoc_trinh-2_gvua-1128.jpg"
    
    fileprivate func downloadFile() {
        percentageLabel.text = "0%"
        circleLayer.strokeEnd = 0
        
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        guard let url = URL(string: urlString) else {
            return
        }
        let dataTask = urlSession.downloadTask(with: url)
        dataTask.resume()
    }
    
    @objc private func handleTap() {
//        animateCircle()
        downloadFile()
    }
}

extension ViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        DispatchQueue.main.async {
            self.circleLayer.strokeEnd = percentage
            self.percentageLabel.text = "\(Int(percentage*100))%"
        }
    }
}

