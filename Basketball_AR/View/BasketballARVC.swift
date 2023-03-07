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
            addBasketPlace(by: raycastResult)
        }
    }
    
    private func addBasketPlace(by raycastResult: ARRaycastResult) {
        let transform = raycastResult.worldTransform
        let x_Position = transform.columns.3.x
        let y_Position = transform.columns.3.y
        let z_Position = transform.columns.3.z
        let basketScene = SCNScene(named: "SceneKitAssets.scnassets/BasketScene.scn")
        if let basketNode = basketScene?.rootNode.childNode(withName: "Basket", recursively: false) {
            basketNode.position = SCNVector3(x_Position, y_Position, z_Position)
            sceneView.scene.rootNode.addChildNode(basketNode)
        }
    }
}
