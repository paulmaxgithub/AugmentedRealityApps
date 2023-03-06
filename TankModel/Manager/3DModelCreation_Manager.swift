//
//  3DModelCreation_Manager.swift
//  TankModel_ARKit
//
//  Created by PaulmaX on 6.03.23.
//  Copyright © 2023 Rayan Slim. All rights reserved.
//

import ARKit

fileprivate func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

final class Model_3D_CreationManager {
    
    static let create = Model_3D_CreationManager()
    
    public var vehicle = SCNPhysicsVehicle()
    
    //MARK: - MODEL CREATION
    public func concreteNode(planeAnchor: ARPlaneAnchor) -> SCNNode {
        let concreteNode = SCNNode(geometry: SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(CGFloat(planeAnchor.extent.z))))
        concreteNode.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "concrete.png")
        concreteNode.geometry?.firstMaterial?.isDoubleSided = true
        concreteNode.position = SCNVector3(planeAnchor.center.x,planeAnchor.center.y,planeAnchor.center.z)
        concreteNode.eulerAngles = SCNVector3(90.degreesToRadians, 0, 0)
        let staticBody = SCNPhysicsBody.static()
        concreteNode.physicsBody = staticBody
        return concreteNode
    }
    
    public func tankModel(on sceneView: ARSCNView) {
        //Orientation
        guard let pointOfView = sceneView.pointOfView else { return }
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        let currentPositionOfCamera = orientation + location
        
        //Tank Model
        let tankScene = SCNScene(named: "TANK.scn")
        guard let tankFrameNode =
                tankScene?.rootNode.childNode(withName: "Tank_FRAME", recursively: false) else { return }
        
        //Weels
        guard let frontLeftWheel =
                tankFrameNode.childNode(withName: "leftFrontWheelParent", recursively: false) else { return }
        guard let frontRightWheel =
                tankFrameNode.childNode(withName: "rightFrontWheelParent", recursively: false) else { return }
        guard let rearLeftWheel =
                tankFrameNode.childNode(withName: "leftRearWheelParent", recursively: false) else { return }
        guard let rearRightWheel =
                tankFrameNode.childNode(withName: "rightRearWheelParent", recursively: false) else { return }
        let V_frontLeftWheel = SCNPhysicsVehicleWheel(node: frontLeftWheel)
        let V_frontRightWheel = SCNPhysicsVehicleWheel(node: frontRightWheel)
        let V_rearLeftWheel = SCNPhysicsVehicleWheel(node: rearLeftWheel)
        let V_rearRightWheel = SCNPhysicsVehicleWheel(node: rearRightWheel)
        
        tankFrameNode.position = currentPositionOfCamera
        
        let body = SCNPhysicsBody(type: .dynamic,
                                  shape: SCNPhysicsShape(node: tankFrameNode,
                                                         options: [SCNPhysicsShape.Option.keepAsCompound : true]))
        body.mass = 1.5
        tankFrameNode.physicsBody = body
        
        //Motion
        guard let tankPhysicsBody = tankFrameNode.physicsBody else { return }
        vehicle = SCNPhysicsVehicle(chassisBody: tankPhysicsBody,
                                    wheels: [V_frontLeftWheel, V_frontRightWheel, V_rearLeftWheel, V_rearRightWheel])
        
        sceneView.scene.physicsWorld.addBehavior(vehicle)
        sceneView.scene.rootNode.addChildNode(tankFrameNode)
    }
}
