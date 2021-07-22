//
//  Sofa.swift
//  ARKitProject
//
//  Created by JungJiyoung on 2021/07/22.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation

class Sofa: VirtualObject {

    override init() {
        super.init(modelName: "746525_close", fileExtension: "usdz", thumbImageFilename: "vase", title: "Sofa")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
