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

class SizeMeasurementView : UIViewController, ARSessionDelegate {
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var addBtn : UIButton!
    var screenCenter: CGPoint?
    let session = ARSession() // ar scene의 고유 런타임 인스턴스 관리


    
    var doteNodes = [SCNNode]()
    var textNode = SCNNode()
    var lineNode = SCNNode()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.session.delegate = self
        sceneView.autoenablesDefaultLighting = true
        print("SizeMeasurementView")
        setupFocusSquare()
        setupARView()
//        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let configuration = ARWorldTrackingConfiguration()
//        configuration.planeDetection = [.horizontal, .vertical]
//        sceneView.session.run(configuration)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = true 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
        session.pause() // session 멈춘다.
        let configuration = ARWorldTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
    }
    
    
    func setupARView() {
        self.addCoaching()
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        sceneView.session.run(configuration)
        
        DispatchQueue.main.async {
            self.screenCenter = self.sceneView.bounds.mid // center setting
        }
    }
    
    // MARK: - Focus Square
    var focusSquare: FocusSquare?

    func setupFocusSquare() {
        focusSquare?.isHidden = true // 레이어가 숨겨지는지 여부 -> hide
        focusSquare?.removeFromParentNode()
        focusSquare = FocusSquare()
        print("setupFocusSquare")
        sceneView.scene.rootNode.addChildNode(focusSquare!) // 장면 위 Node에 focusSquare 붙인다.
    }

    func updateFocusSquare() {
        guard let screenCenter = screenCenter else { return } // nil이면 return, nil이 아닐 시 screenCenter 할당
        focusSquare?.unhide()
        let (worldPos, planeAnchor, _) = MainViewController().worldPositionFromScreenPosition(screenCenter, objectPos: focusSquare?.position)
        // position: SCNVector3?,planeAnchor: ARPlaneAnchor?,hitAPlane: Bool 반환
        
        print(worldPos)
        if let worldPos = worldPos {
            focusSquare?.update(for: worldPos, planeAnchor: planeAnchor, camera: self.session.currentFrame?.camera) // 해당 값으로 focusSquare 업데이트
        }
    }


    
    
    // MARK: - addButton Click
    
    @IBAction func addAnchor(_ button : UIButton) {
        
        if doteNodes.count >= 2 {
            for dot in doteNodes{
                dot.removeFromParentNode()
            }
            textNode.removeFromParentNode()
            lineNode.removeFromParentNode()
            textNode = SCNNode()
            lineNode = SCNNode()
            doteNodes = [SCNNode]()
        }
        // 클릭하면 화면 중앙의 앵커가 저장 -> addDot로 연결
        ExistPlanes()
    }
    
    func ExistPlanes() {
        let results = sceneView.raycastQuery(from: view.center, allowing: ARRaycastQuery.Target.estimatedPlane, alignment: .any)
        
        if let hisRes = results {
            let rayCast = sceneView.session.raycast(hisRes)
            
            guard let ray = rayCast.first else { return }
            addDot(at: ray)
        }
    }

    
    // MARK: - Add focus image

    
    
    
    
    
    // MARK: - Add dot

    func addDot(at hitResult: ARRaycastResult) {
        let sphereScene = SCNSphere(radius: 0.007)
        
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

        lineNode = SCNNode(geometry: lineGeometry)
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
        
        let midPosition = SCNVector3 (x:(start.position.x + end.position.x) / 2, y:(start.position.y + end.position.y) / 2, z:(start.position.z + end.position.z) / 2)

        updateText(text: "\(round(abs(distance)*10000)/100) cm", atPosition: midPosition)
    }
    
    
    
    
    // MARK: - update TextNode

    func updateText(text: String, atPosition position: SCNVector3){
        let textGeometry = SCNText(string: text, extrusionDepth: 0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.black
        
        textNode = SCNNode(geometry: textGeometry)
        textNode.position = SCNVector3(position.x - 0.01, position.y + 0.002, position.z)
        
        textNode.scale = SCNVector3(0.0018, 0.0018, 0.0018)
        
        
        let minVec = textNode.boundingBox.min
        let maxVec = textNode.boundingBox.max
        let bound = SCNVector3Make(maxVec.x - minVec.x,
                                   maxVec.y - minVec.y,
                                   maxVec.z - minVec.z);

        let plane = SCNPlane(width: CGFloat(bound.x + 3.5),
                             height: CGFloat(bound.y + 3.5))
        plane.cornerRadius = 3.5
        plane.firstMaterial?.diffuse.contents = UIColor.white

        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3(CGFloat( minVec.x) + CGFloat(bound.x) / 2 ,
                                        CGFloat( minVec.y) + CGFloat(bound.y) / 2 ,
                                        CGFloat( minVec.z - 0.01))

        textNode.addChildNode(planeNode)
        planeNode.name = "text"
        
        sceneView.scene.rootNode.addChildNode(textNode)
        print("text")
    }
    
    
    
    // MARK: - initialize Button

    @IBOutlet weak var trashBtn : UIButton!
    
    @IBAction func initialize (_ button: UIButton) {
        for dot in doteNodes{
            dot.removeFromParentNode()
        }
        textNode.removeFromParentNode()
        lineNode.removeFromParentNode()
        textNode = SCNNode()
        lineNode = SCNNode()
        doteNodes = [SCNNode]()
    }
    
}


    // MARK: - Coaching overlay view


extension SizeMeasurementView : ARCoachingOverlayViewDelegate {
    func addCoaching() {
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.delegate = self
        coachingOverlay.session = sceneView.session
        coachingOverlay.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        sceneView.addSubview(coachingOverlay)
        
        NSLayoutConstraint.activate([
            coachingOverlay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coachingOverlay.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            coachingOverlay.widthAnchor.constraint(equalTo: view.widthAnchor),
            coachingOverlay.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        coachingOverlay.activatesAutomatically = true
        coachingOverlay.goal = .horizontalPlane
    }
}

extension SizeMeasurementView : ARSCNViewDelegate {
    // MARK: - ARSCNViewDelegate

    private func renderer(_ renderer: SCNRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            print("renderer")
            self.updateFocusSquare()
        }
    }
}
