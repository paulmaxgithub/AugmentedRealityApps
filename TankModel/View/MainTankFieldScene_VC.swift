//
//  MainTankFieldScene_VC.swift
//  Floor is lava
//
//  Created by Rayan Slim on 2017-08-16.
//  Copyright © 2017 Rayan Slim. All rights reserved.
//

import ARKit
import Combine

class MainTankFieldScene_VC: UIViewController {
    
    @IBOutlet weak var sceneView:       ARSCNView!
    @IBOutlet weak var addCarButton:    UIButton!
    
    @IBAction func addTankButtonTapped(_ sender: UIButton) {
        Model_3D_CreationManager.create.tankModel(on: sceneView)
    }
    
    public var touchedFingersCount: Int = 0
    
    //MARK: - ARKIT
    let configuration   = ARWorldTrackingConfiguration()
    
    //MARK: - COREMOTION (start accelerometer by init)
    var accelerometer = Accelerometer_Manager.run
    
    //MARK: - COMBINE
    var cancellable: Cancellable? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration.planeDetection = .horizontal
        
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        sceneView.session.run(configuration)
        sceneView.delegate = self
        sceneView.showsStatistics = true
    }
    
    //MARK: - TOUCHES
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = touches.first else { return }
        touchedFingersCount += touches.count
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchedFingersCount = 0
    }
}
