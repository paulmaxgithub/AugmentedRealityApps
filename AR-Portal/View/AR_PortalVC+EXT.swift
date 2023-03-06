//
//  AR_PortalVC+EXT.swift
//  AR-Portal
//
//  Created by PaulmaX on 6.03.23.
//  Copyright © 2023 Rayan Slim. All rights reserved.
//

import ARKit

extension AR_PortalVC: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [unowned self] in
            detectionInfoLabel.isHidden = false
        }
    }
}
