//
//  ViewController.swift
//  CircleAnimation
//
//  Created by Vinh Nguyen on 6/22/18.
//  Copyright © 2018 Vinh Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var circleLayer: CAShapeLayer!
    var trackerLayer: CAShapeLayer!
    var shimmerLayer: CAShapeLayer!

    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        return label
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        
        let centerPoint = view.center
        let circlePath = UIBezierPath(arcCenter: .zero, radius: 120, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        shapeLayer.path = circlePath.cgPath
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.lineWidth = 20
        shapeLayer.position = centerPoint
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        
        return shapeLayer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        shimmerLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: UIColor(red: 255/255, green: 138/255, blue: 128/255, alpha: 0.8))
        view.layer.addSublayer(shimmerLayer)
        animationForShimmerLayer()
        
        trackerLayer = createCircleShapeLayer(strokeColor: UIColor(red: 255/255, green: 205/255, blue: 210/255, alpha: 1), fillColor: .clear)
        view.layer.addSublayer(trackerLayer)
        
        circleLayer = createCircleShapeLayer(strokeColor: UIColor(red: 213/255, green: 0/255, blue: 0/255, alpha: 1), fillColor: .black)
        circleLayer.strokeEnd = 0
        self.view.layer.addSublayer(circleLayer)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        self.percentageLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        self.view.addSubview(percentageLabel)
        
        setupNotification()
    }
    
    @objc fileprivate func handleWhenAppActive() {
        animationForShimmerLayer()
    }
    
    fileprivate func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleWhenAppActive), name: .UIApplicationDidBecomeActive, object: nil)
    }
    
    fileprivate func animationForShimmerLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.4
        animation.duration = 1.2
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        shimmerLayer.add(animation, forKey: "shimmerAnimation")
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
    
    @objc private func handleTap() {
//        animateCircle()
        downloadFile()
    }
    
    let urlString = "http://cdn.baogiaothong.vn/files/nhung.nguyen/2017/01/19/ngoc_trinh-2_gvua-1128.jpg"
    fileprivate func downloadFile() {
        percentageLabel.text = "Start"
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

