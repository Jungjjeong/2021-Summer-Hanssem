//
//  Teapot.swift
//  ARKitProject
//
//  Created by JungJiyoung on 2021/07/22.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import SceneKit


class Teapot: VirtualObject{

    override init() {
        super.init(modelName: "teapot", thumbImageFilename: "vase", title: "Teapot")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    func reactToScale() {
//        // Update the size of the flame
//        let entity = SCNScene(named: self.modelName)
//        entity.
//    }
}
