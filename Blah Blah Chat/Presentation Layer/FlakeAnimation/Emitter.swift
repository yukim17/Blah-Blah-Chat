//
//  Emitter.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 22.04.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//
import UIKit

class Emitter {
    
    private weak var superView: UIView?
    private var emitter = CAEmitterLayer()
    
    private var longPressRecognizer = UILongPressGestureRecognizer()
    
    init(view: UIView) {
        superView = view
        longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(performLongPressAnimations))
        superView?.addGestureRecognizer(longPressRecognizer)
    }
    
    private func generateEmitterCells() {
        superView?.endEditing(true)
        
        emitter.emitterPosition = longPressRecognizer.location(in: superView)
        emitter.emitterShape = CAEmitterLayerEmitterShape.circle
        emitter.emitterSize = CGSize(width: 30, height: 30)
        
        let cell = CAEmitterCell()
        
        cell.contents = UIImage(named: "icons8-mess")?.cgImage
        cell.birthRate = 8
        cell.lifetime = 3
        cell.velocity = CGFloat(55)
        cell.contentsScale = 2
        cell.velocityRange = 10
        cell.yAcceleration = -70.0
        cell.xAcceleration = -10
        cell.emissionRange = .pi / 6
        
        emitter.emitterCells = [cell]
        superView?.layer.addSublayer(emitter)
    }
    
    @objc private func performLongPressAnimations(_ sender: UILongPressGestureRecognizer) {
        switch longPressRecognizer.state {
        case .began:
            generateEmitterCells()
        case .ended:
            emitter.removeFromSuperlayer()
        case .changed:
            emitter.emitterPosition = sender.location(in: superView)
        default:
            break
        }
    }
    
}
