//
//  TankModelScene_VC+EXT.swift
//  TankModel
//
//  Created by PaulmaX on 4.03.23.
//  Copyright © 2023 Rayan Slim. All rights reserved.
//

import ARKit

extension MainTankFieldScene_VC: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        let concreteNode = Model_3D_CreationManager.create.concreteNode(planeAnchor: planeAnchor)
        node.addChildNode(concreteNode)
        //        print("new flat surface detected, new ARPlaneAnchor added")
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        //        print("updating floor's anchor...")
        
        node.enumerateChildNodes { (childNode, _) in childNode.removeFromParentNode() }
        
        let concreteNode = Model_3D_CreationManager.create.concreteNode(planeAnchor: planeAnchor)
        node.addChildNode(concreteNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard let _ = anchor as? ARPlaneAnchor else { return }
        node.enumerateChildNodes { (childNode, _) in childNode.removeFromParentNode() }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: TimeInterval) {
        
        let vehicle = Model_3D_CreationManager.create.vehicle
        
        cancellable = Accelerometer_Manager.run.orientation.sink(receiveValue: { [unowned self] _orientation in
            //USE IF MODEL CONTAINS WHEELS 🚜
            vehicle.setSteeringAngle(-_orientation, forWheelAt: 2)
            vehicle.setSteeringAngle(-_orientation, forWheelAt: 3)
            
            var engineForce: CGFloat = 0, breakingForce: CGFloat = 0
            switch touchedFingersCount {
            case 1:     engineForce = 7
            case 2:     engineForce = -7
            case 3:     breakingForce = 100
            default:    return
            }
            
            vehicle.applyEngineForce(engineForce, forWheelAt: 0)
            vehicle.applyEngineForce(engineForce, forWheelAt: 1)
            vehicle.applyBrakingForce(breakingForce, forWheelAt: 0)
            vehicle.applyBrakingForce(breakingForce, forWheelAt: 1)
        })
    }
}
