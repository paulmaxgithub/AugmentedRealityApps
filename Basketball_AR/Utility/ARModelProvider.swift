//
//  ARModelProvider.swift
//  Basketball_AR
//
//  Created by PaulmaX on 7.03.23.
//  Copyright © 2023 Rayan Slim. All rights reserved.
//

import ARKit

fileprivate func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

final class ARModelProvider {
    
    static let present = ARModelProvider()
    
    private let forcePower: Float = 10
    
    public func addBasketPlace(by raycastResult: ARRaycastResult, in sceneView: ARSCNView) {
        let transform = raycastResult.worldTransform
        let x_Position = transform.columns.3.x
        let y_Position = transform.columns.3.y
        let z_Position = transform.columns.3.z
        let basketScene = SCNScene(named: "SceneKitAssets.scnassets/BasketScene.scn")
        if let basketNode = basketScene?.rootNode.childNode(withName: "Basket", recursively: false) {
            basketNode.position = SCNVector3(x_Position, y_Position, z_Position)
            
            let SCNPhysicsShapeOptions: [SCNPhysicsShape.Option : Any] = [
                SCNPhysicsShape.Option.keepAsCompound: true,
                SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.concavePolyhedron
            ]
            
            let shape = SCNPhysicsShape(node: basketNode, options: SCNPhysicsShapeOptions)
            basketNode.physicsBody = SCNPhysicsBody(type: .static, shape: shape)
            sceneView.scene.rootNode.addChildNode(basketNode)
        }
    }
    
    public func addBall(in sceneView: ARSCNView) {
        guard let pointOfView = sceneView.pointOfView else { return }
        let transform = pointOfView.transform
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        let position = location + orientation
        
        let ball = SCNNode(geometry: SCNSphere(radius: 0.3))
        ball.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "Ball")
        ball.position = position
        
        let body = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: ball))
        ball.physicsBody = body
        let scnVectorWithPower = SCNVector3(orientation.x * forcePower, orientation.y * forcePower, orientation.z * forcePower)
        ball.physicsBody?.applyForce(scnVectorWithPower, asImpulse: true)
        
        sceneView.scene.rootNode.addChildNode(ball)
    }
}
