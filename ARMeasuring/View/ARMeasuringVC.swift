//
//  ARMeasuringVC.swift
//  ARMeasuring
//
//  Created by PaulmaX on 6.03.23.
//

import ARKit

class ARMeasuringVC: UIViewController {
    
    @IBOutlet weak var arSceneView:     ARSCNView!
    @IBOutlet weak var distanceLabel:   UILabel!
    @IBOutlet weak var x_label:         UILabel!
    @IBOutlet weak var y_label:         UILabel!
    @IBOutlet weak var z_label:         UILabel!
    
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        
    }
    
    private let config = ARWorldTrackingConfiguration()
    
    public var nodeForStartingPosition: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arSceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        arSceneView.session.run(config)
        arSceneView.addGestureRecognizer(gestureSetup())
        arSceneView.delegate = self
    }
    
    private func gestureSetup() -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        return tap
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        guard let sceneView = sender.view as? ARSCNView else { return }
        guard let currentFrame = sceneView.session.currentFrame else { return }
        
        if nodeForStartingPosition != nil {
            nodeForStartingPosition?.removeFromParentNode()
            nodeForStartingPosition = nil
            return
        }
        
        let camera = currentFrame.camera
        let transform = camera.transform
        var translationMatrix = matrix_identity_float4x4
        translationMatrix.columns.3.z = -0.3
        let modifiedMatrix = simd_mul(transform, translationMatrix)
        let sphere = SCNNode(geometry: SCNSphere(radius: 0.005))
        sphere.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
        sphere.simdTransform = modifiedMatrix
        
        arSceneView.scene.rootNode.addChildNode(sphere)
        nodeForStartingPosition = sphere
    }
}
