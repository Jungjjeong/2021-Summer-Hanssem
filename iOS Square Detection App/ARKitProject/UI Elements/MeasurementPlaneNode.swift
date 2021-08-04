//
//  MeasurementPlaneNode.swift
//  ARKitProject
//
//  Created by JungJiyoung on 2021/08/04.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import ARKit

class MeasurementPlaneNode : SCNNode {
    var mGeometry : SCNBox?
    var mAnchor : ARPlaneAnchor?
    
    init(mAnchor : ARPlaneAnchor) {
        super.init()
        
        
        let wid = CGFloat(mAnchor.extent.x)
        let len = CGFloat(mAnchor.extent.z)
        let planeHeight = 0.01 as CGFloat
        self.mGeometry = SCNBox(width: wid, height: planeHeight, length: len, chamferRadius: 0)
        
        let material = SCNMaterial()
        let image = UIImage(named: "focus.png")
        material.diffuse.contents = image
        
        let transmat = SCNMaterial()
        transmat.diffuse.contents = UIColor.white.withAlphaComponent(0.0)
        self.mGeometry?.materials = [transmat, transmat, transmat, transmat, material, transmat]
        
        
        let mNode = SCNNode(geometry: self.mGeometry)
        mNode.position = SCNVector3(0, -planeHeight/2.0, 0)
        
        self.addChildNode(mNode)
    }
    
    func updateWith(_ mAnchor: ARPlaneAnchor) {
        self.mGeometry?.width = CGFloat(mAnchor.extent.x)
        self.mGeometry?.length = CGFloat(mAnchor.extent.z)
        self.position = SCNVector3(mAnchor.center.x, 0, mAnchor.center.z)
    }
    
    
    func setTextureScale() {
        let width = self.mGeometry?.width
        let length = self.mGeometry?.length
        
        
        let material = self.mGeometry?.materials[4]
        material?.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(width!), Float(length!), 1);
        material?.diffuse.wrapS = .repeat
        material?.diffuse.wrapT = .repeat
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) 가 구현되지 않았습니다. ")
    }
    
}
