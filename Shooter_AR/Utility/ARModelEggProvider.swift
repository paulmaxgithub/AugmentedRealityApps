//
//  ARModelEggProvider.swift
//  Shooter_AR
//
//  Created by PaulmaX on 8.03.23.
//  Copyright © 2023 Rayan Slim. All rights reserved.
//

import ARKit

fileprivate func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

fileprivate enum BitmaskCategory: Int {
    case bullet = 1, target
}

final class ARModelEggProvider: NSObject {
    
    private var sceneView: ARSCNView
    
    private let F: Float = 50
    
    init(sceneView: ARSCNView) {
        self.sceneView = sceneView
        super.init()
        addEggTargets()
    }
    
    private func addEggTargets() {
        eggTargetSetup(x: 5, y: 0, z: -40)
        eggTargetSetup(x: 0, y: 0, z: -40)
        eggTargetSetup(x: -5, y: 0, z: -40)
    }
    
    private func eggTargetSetup(x: Float, y: Float, z: Float) {
        if let eggScene = SCNScene(named: "SceneKitAsset.scnassets/egg.scn") {
            if let eggNode = eggScene.rootNode.childNode(withName: "egg", recursively: false) {
                eggNode.position = SCNVector3(x, y, z)
                eggNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: eggNode))
                eggNode.physicsBody?.categoryBitMask = BitmaskCategory.target.rawValue
                eggNode.physicsBody?.contactTestBitMask = BitmaskCategory.bullet.rawValue
                sceneView.scene.physicsWorld.contactDelegate = self
                sceneView.scene.rootNode.addChildNode(eggNode)
            } else {
                print("Error with getting node!")
                return
            }
        } else {
            print("Error with getting scene!")
            return
        }
    }
    
    public func shooterSetup() {
        guard let pointOfView = sceneView.pointOfView else { return }
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        let position = orientation + location
        
        let bulletNode = SCNNode(geometry: SCNSphere(radius: 0.1))
        bulletNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        bulletNode.position = position
        
        let body = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: bulletNode))
        body.isAffectedByGravity = false
        bulletNode.physicsBody = body
        bulletNode.physicsBody?.categoryBitMask = BitmaskCategory.bullet.rawValue
        bulletNode.physicsBody?.contactTestBitMask = BitmaskCategory.target.rawValue
        
        let direction = SCNVector3(orientation.x * F, orientation.y * F, orientation.z * F)
        bulletNode.physicsBody?.applyForce(direction, asImpulse: true)
        sceneView.scene.rootNode.addChildNode(bulletNode)
    }
}

extension ARModelEggProvider: SCNPhysicsContactDelegate {
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        var targetNode = SCNNode()
        var bulletNode = SCNNode()
        let sparkNode  = SCNNode()
        
        let isTargetNode = contact.nodeA.physicsBody?.categoryBitMask == BitmaskCategory.target.rawValue
        targetNode = isTargetNode ? contact.nodeA : contact.nodeB
        bulletNode = !isTargetNode ? contact.nodeA : contact.nodeB
        bulletNode.removeFromParentNode()
        
//        guard let spark = SCNParticleSystem(
//            named: "SceneKitAsset.scnassets/Spark.sks", inDirectory: nil) else { return }
//        spark.loops = false
//        spark.particleLifeSpan = 4
//        spark.emitterShape = targetNode.geometry
//
//        sparkNode.addParticleSystem(spark)
//        sparkNode.position = contact.contactPoint
//        sceneView.scene.rootNode.addChildNode(sparkNode)
        
        // ⚙️ until a solution is found how to use the .sks file, use this code ⚙️
        // ⚠️ waiting for approach from stack overflow ⚠️
        let particleSystem = SCNParticleSystem()
        particleSystem.birthRate = 100
        particleSystem.particleSize = 0.3
        particleSystem.particleColor = .red
        particleSystem.loops = false
        particleSystem.particleLifeSpan = 2
        particleSystem.emitterShape = targetNode.geometry

        sparkNode.addParticleSystem(particleSystem)
        sparkNode.position = contact.contactPoint
        sceneView.scene.rootNode.addChildNode(sparkNode)
        
        targetNode.removeFromParentNode()
    }
}
