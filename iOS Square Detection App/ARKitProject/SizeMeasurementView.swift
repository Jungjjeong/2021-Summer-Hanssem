//
//  SizeMeasurementView.swift
//  ARKitProject
//
//  Created by JungJiyoung on 2021/08/03.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import ARKit
import UIKit

// MARK: - Size Measurement

class SizeMeasurementView : UIViewController, ARSCNViewDelegate {
    @IBOutlet var sceneView: ARSCNView!
    
    var doteNodes = [SCNNode]()
    var textNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    // MARK: - Touch Began

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if doteNodes.count >= 2 {
            for dot in doteNodes{
                dot.removeFromParentNode()
            }
            doteNodes = [SCNNode]()
        }
        
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            
            let results = sceneView.raycastQuery(from: touchLocation, allowing: ARRaycastQuery.Target.estimatedPlane, alignment: .any)
            
            if let hitRes = results {
                let rayCast = sceneView.session.raycast(hitRes)
                
                guard let ray = rayCast.first else { return }
                addDot(at : ray)
            }
        }
    }
    
    
    
    // MARK: - Add dot

    func addDot(at hitResult: ARRaycastResult) {
        let sphereScene = SCNSphere(radius: 0.01)
        
        let material = SCNMaterial()
        
        material.diffuse.contents = UIColor.white
        sphereScene.materials = [material]
        
        let node = SCNNode()
        
        node.position = SCNVector3(
            hitResult.worldTransform.columns.3.x,
            hitResult.worldTransform.columns.3.y + sphereScene.boundingSphere.radius,
            hitResult.worldTransform.columns.3.z
        )
        
        node.geometry = sphereScene
        
        sceneView.scene.rootNode.addChildNode(node)
        
        doteNodes.append(node)
        
        if doteNodes.count >= 2{
            sceneView.scene.rootNode.addChildNode(lineBetweenNodes(positionA: doteNodes[0].position, positionB: doteNodes[1].position, inScene: self.sceneView.scene))
            calculate()
        }
    }
    
    
    // MARK: - Draw lines
    
    func lineBetweenNodes(positionA: SCNVector3, positionB: SCNVector3, inScene: SCNScene) -> SCNNode {
        let vector = SCNVector3(positionA.x - positionB.x, positionA.y - positionB.y, positionA.z - positionB.z)
        let distance = sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z)
        let midPosition = SCNVector3 (x:(positionA.x + positionB.x) / 2, y:(positionA.y + positionB.y) / 2, z:(positionA.z + positionB.z) / 2)

        let lineGeometry = SCNCylinder()
        lineGeometry.radius = 0.0025
        lineGeometry.height = CGFloat(distance)
        lineGeometry.radialSegmentCount = 5
        lineGeometry.firstMaterial!.diffuse.contents = UIColor.white

        let lineNode = SCNNode(geometry: lineGeometry)
        lineNode.position = midPosition
        lineNode.look (at: positionB, up: inScene.rootNode.worldUp, localFront: lineNode.worldUp)
        return lineNode
    }
    
    
    
    // MARK: - Calculate distance

    func calculate() {
        let start = doteNodes[0]
        let end = doteNodes[1]
        
        print(start.position)
        print(end.position)
        
        let distance = sqrt(pow(start.position.x-end.position.x, 2) +
                                pow(start.position.y-end.position.y, 2) +
                                pow(start.position.z-end.position.z, 2))
        
        
        updateText(text: "\(round(abs(distance)*100)) cm", atPosition: start.position)
    }
    
    
    
    
    // MARK: - update TextNode

    func updateText(text: String, atPosition position: SCNVector3){
        textNode.removeFromParentNode()
        
        let textGeometry = SCNText(string: text, extrusionDepth: 0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.white
//        textGeometry.containerFrame = CGRect(x: Double(position.x), y: Double(position.y), width: 5, height: 5)
        
        textNode = SCNNode(geometry: textGeometry)
        textNode.position = SCNVector3(position.x, position.y + 0.01, position.z)
        
        textNode.scale = SCNVector3(0.0025, 0.0025, 0.0025)
        
        
        
        let minVec = textNode.boundingBox.min
        let maxVec = textNode.boundingBox.max
        let bound = SCNVector3Make(maxVec.x - minVec.x,
                                   maxVec.y - minVec.y,
                                   maxVec.z - minVec.z);

        let plane = SCNPlane(width: CGFloat(bound.x + 1),
                            height: CGFloat(bound.y + 1))
        plane.cornerRadius = 0.2
        plane.firstMaterial?.diffuse.contents = UIColor.black.withAlphaComponent(0.9)

        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3(CGFloat( minVec.x) + CGFloat(bound.x) / 2 ,
                                        CGFloat( minVec.y) + CGFloat(bound.y) / 2,CGFloat(minVec.z - 0.01))

        textNode.addChildNode(planeNode)
        planeNode.name = "text"
        
        sceneView.scene.rootNode.addChildNode(textNode)
    }
}