//
//  ShooterARVC.swift
//  Shooter_AR
//
//  Created by PaulmaX on 8.03.23.
//  Copyright © 2023 Rayan Slim. All rights reserved.
//

import ARKit

class ShooterARVC: UIViewController {

    @IBOutlet weak var arSceneView: ARSCNView!
    @IBOutlet weak var instructionLabel: UILabel!
    
    @IBAction func shootButtonTapped(_ sender: UIButton) {
        modelProvider?.shooterSetup()
    }
    
    private var config = ARWorldTrackingConfiguration()
    
    private var modelProvider: ARModelEggProvider?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arSceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        arSceneView.automaticallyUpdatesLighting = true
        arSceneView.addGestureRecognizer(gesture())
        arSceneView.session.run(config)
    }
    
    private func gesture() -> UITapGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(tapHandle))
    }
    
    @objc private func tapHandle(sender: UITapGestureRecognizer) {
        guard let sceneView = sender.view as? ARSCNView else { return }
        modelProvider = ARModelEggProvider(sceneView: sceneView)
        instructionLabel.isHidden = true
    }
}
