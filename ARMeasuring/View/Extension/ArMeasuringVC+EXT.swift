//
//  ArMeasuringVC+EXT.swift
//  ARMeasuring
//
//  Created by PaulmaX on 6.03.23.
//  Copyright © 2023 Rayan Slim. All rights reserved.
//

import ARKit

extension ARMeasuringVC: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let nodeStartingPosition = nodeForStartingPosition else { return }
        guard let pointOfView = arSceneView.pointOfView else { return }
        
        let transform = pointOfView.transform
        let location = SCNVector3(x: transform.m41, y: transform.m42, z: transform.m43)
        
        let xDistance = location.x - nodeStartingPosition.position.x
        let yDistance = location.y - nodeStartingPosition.position.y
        let zDistance = location.z - nodeStartingPosition.position.z
        DispatchQueue.main.async { [unowned self] in
            x_label.text = "X " + String(format: "%.2f", xDistance) + "m"
            y_label.text = "Y " + String(format: "%.2f", yDistance) + "m"
            z_label.text = "Z " + String(format: "%.2f", zDistance) + "m"
            
            let distance = distanceTravelled(x: xDistance, y: yDistance, z: zDistance)
            let formattedDistance = String(format: "%.2f", distance) + "m"
            distanceLabel.text = "Distance \(formattedDistance)"
        }
    }
    
    private func distanceTravelled(x: Float, y: Float, z: Float) -> Float {
        return (sqrtf(x*x + y*y + z*z))
    }
}
