//
//  AR_PortalVC.swift
//  AR-Portal
//
//  Created by PaulmaX on 6.03.23.
//  Copyright © 2023 Rayan Slim. All rights reserved.
//

import ARKit

class AR_PortalVC: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var detectionInfoLabel: UILabel!
    
    private let config = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config.planeDetection = .horizontal
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        sceneView.addGestureRecognizer(gesture())
        sceneView.session.run(config)
        sceneView.delegate = self
    }
    
    private func gesture() -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        detectionInfoLabel.isHidden = true
        return tap
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        guard let sceneView = sender.view as? ARSCNView else { return }
        let touchLocation = sender.location(in: sceneView)
        
        guard let raycastQuery = sceneView
                .raycastQuery(from: touchLocation, allowing: .existingPlaneGeometry, alignment: .horizontal) else { return }
        
        let raycastResults = sceneView.session.raycast(raycastQuery)
        if let raycastResult = raycastResults.first {
            addPortal(by: raycastResult)
        }
    }
    
    private func addPortal(by raycastResult: ARRaycastResult) {
        let transform = raycastResult.worldTransform
        let plane_X_position = transform.columns.3.x
        let plane_Y_position = transform.columns.3.y
        let plane_Z_position = transform.columns.3.z
        
        let portalScene = SCNScene(named: "SceneKitAssetCatalog.scnassets/Portal.scn")
        if let portalNode = portalScene?.rootNode.childNode(withName: "Portal", recursively: false) {
            portalNode.position = SCNVector3(plane_X_position, plane_Y_position, plane_Z_position)
            sceneView.scene.rootNode.addChildNode(portalNode)
            addPlane(nodeName: "roof", portal: portalNode, image: "top")
            addPlane(nodeName: "plane", portal: portalNode, image: "bottom")
            addPlane(nodeName: "backWall", portal: portalNode, image: "back")
            addPlane(nodeName: "wallSideA", portal: portalNode, image: "sideA")
            addPlane(nodeName: "wallSideB", portal: portalNode, image: "sideB")
            addPlane(nodeName: "sideDoorA", portal: portalNode, image: "sideDoorA")
            addPlane(nodeName: "sideDoorB", portal: portalNode, image: "sideDoorB")
        }
    }
    
    private func addPlane(nodeName: String, portal: SCNNode, image: String) {
        guard let child = portal.childNode(withName: nodeName, recursively: true) else { return }
        let currentName = "SceneKitAssetCatalog.scnassets/\(image).png"
        child.geometry?.firstMaterial?.diffuse.contents = UIImage(named: currentName)
//        child.geometry?.firstMaterial?.isDoubleSided = false
    }
}
