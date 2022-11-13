//
//  NewViewController.swift
//  PhotoGalleryGromFlickr
//
//  Created by Navi Vokavis on 11.11.22.
//


//MARK: - this controller not avaliable in this App. Just for test CAReplicatorLayer


import UIKit

class NewViewController: UIViewController {
    
    var backgroundLayer = CALayer()
    var firstReplicatorLayer = CAReplicatorLayer()
    var firstSourceLayer = CALayer()
    var secondReplicatorLayer = CAReplicatorLayer()
    var secondSourceLayer = CALayer()
    var thirdReplicatorLayer = CAReplicatorLayer()
    var thirdSourceLayer = CALayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer.addSublayer(backgroundLayer)

        backgroundLayer.backgroundColor = .init(gray: 0, alpha: 0.3)
        backgroundLayer.frame = self.view.bounds
        
        startAnimation(replicatorLayer: firstReplicatorLayer, sourceLayer: firstSourceLayer, beginTime: 0.3, delay: 0.5, replicates: 3, anchorY: 0)
        startAnimation(replicatorLayer: secondReplicatorLayer, sourceLayer: secondSourceLayer, beginTime: 0.6, delay: 0.5, replicates: 3, anchorY: 1.3)
        startAnimation(replicatorLayer: thirdReplicatorLayer, sourceLayer: thirdSourceLayer, beginTime: 0.9, delay: 0.5, replicates: 3, anchorY: 2.6)


    }
    

    func startAnimation(replicatorLayer: CAReplicatorLayer, sourceLayer: CALayer, beginTime: CFTimeInterval, delay: CFTimeInterval, replicates: Int, anchorY: Double) {
        
        self.view.layer.addSublayer(replicatorLayer)
        replicatorLayer.instanceCount = replicates
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(20, 0, 0)

        replicatorLayer.instanceDelay = delay
        replicatorLayer.frame = self.view.bounds
        replicatorLayer.position = self.view.center
        replicatorLayer.addSublayer(sourceLayer)
        
        sourceLayer.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        sourceLayer.backgroundColor = UIColor.black.cgColor
        sourceLayer.position.x = self.view.center.x - 23.8
        sourceLayer.position.y = self.view.center.y + 23.8
        sourceLayer.anchorPoint = CGPoint(x: 0, y: anchorY)
        
        sourceLayer.opacity = 0
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0
        opacityAnimation.beginTime = beginTime
        opacityAnimation.duration = Double(replicates) * delay
        opacityAnimation.repeatCount = Float.infinity
        
        sourceLayer.add(opacityAnimation, forKey: nil)
        
    }

}
