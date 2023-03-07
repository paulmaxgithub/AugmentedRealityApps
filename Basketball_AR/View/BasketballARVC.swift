//
//  BasketballARVC.swift
//  Basketball_AR
//
//  Created by PaulmaX on 7.03.23.
//  Copyright © 2023 Rayan Slim. All rights reserved.
//

import ARKit

class BasketballARVC: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var detectionLabel: UILabel!
    
    private var config = ARWorldTrackingConfiguration()
    
    private var basketIsAdded: Bool {
        return sceneView.scene.rootNode.childNode(withName: "Basket", recursively: false) != nil
    }
    
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
        return UITapGestureRecognizer(target: self, action: #selector(tapHandle))
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
    
    //MARK: - TOUCHES
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let sceneView = touches.first?.view as? ARSCNView else { return }
        if basketIsAdded {
            ARModelProvider.present.addBall(in: sceneView)
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
