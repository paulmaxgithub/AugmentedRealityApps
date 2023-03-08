//
//  BasketballARVC.swift
//  Basketball_AR
//
//  Created by PaulmaX on 7.03.23.
//  Copyright © 2023 Rayan Slim. All rights reserved.
//

import ARKit
import TimerStep

class BasketballARVC: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var detectionLabel: UILabel!
    
    private var config = ARWorldTrackingConfiguration()
    
    private var timer = TimerStep(0.05).seconds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config.planeDetection = .horizontal
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        sceneView.automaticallyUpdatesLighting = true
        sceneView.addGestureRecognizer(gesture())
        sceneView.session.run(config)
        sceneView.delegate = self
    }
    
    private func gesture() -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandle))
        tap.cancelsTouchesInView = false
        return tap
    }
    
    @objc private func tapHandle(sender: UITapGestureRecognizer) {
        detectionLabel.isHidden = true
        guard let sceneView = sender.view as? ARSCNView else { return }
        let touchLocation = sender.location(in: sceneView)
        
        guard let raycastQuery = sceneView.raycastQuery(from: touchLocation, allowing: .existingPlaneGeometry, alignment: .horizontal) else { return }
        let raycastResults = sceneView.session.raycast(raycastQuery)
        if let raycastResult = raycastResults.first {
            ///ADD MODEL BY AR MODEL PROVIDER CLASS
            ARModelProvider.present.addBasketPlace(by: raycastResult, in: sceneView)
        }
    }
    
    //MARK: - TOUCHES SETUP TO SHOOT THE BALL
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = touches.first?.view as? ARSCNView else { return }
        if ARModelProvider.present.basketIsAdded {
            timer.perform {
                ARModelProvider.present.forcePower += 1.0
                return .continue
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let sceneView = touches.first?.view as? ARSCNView else { return }
        if ARModelProvider.present.basketIsAdded {
            timer.stop()
            ARModelProvider.present.addBall(in: sceneView)
        }
    }
}
