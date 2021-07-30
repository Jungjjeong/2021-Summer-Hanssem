// MARK: - Object define Node


import Foundation
import SceneKit.ModelIO
import ARKit


class VirtualObject: SCNNode{
	static let ROOT_NAME = "Virtual object root node"
	var fileExtension: String = ""
	var thumbImage: UIImage!
	var title: String = ""
	var modelName: String = ""
	var modelLoaded: Bool = false
	var id: Int!

	var viewController: MainViewController?

	override init() {
		super.init()
		self.name = VirtualObject.ROOT_NAME
	}

    init(modelName: String, fileExtension : String, thumbImageFilename: String, title: String) {
		super.init()
		self.id = VirtualObjectsManager.shared.generateUid()
		self.name = VirtualObject.ROOT_NAME
		self.modelName = modelName
		self.fileExtension = fileExtension
		self.thumbImage = UIImage(named: thumbImageFilename)
		self.title = title
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:)가 구현되지 않았습니다.")
	}

    // MARK: - 3D model load function
	func loadModel() {
        print("VirtualObject - loadModel function")
		guard let virtualObjectScene = SCNScene(named: "\(modelName).\(fileExtension)", inDirectory: "Models.scnassets/\(modelName)") else {
            print("모델을 찾지 못해 return.")
			return
		}
        
        let wrapperNode = SCNNode()

//        for child in virtualObjectScene.rootNode.childNodes {
//            print("in")
////            child.geometry?.firstMaterial?.lightingModel = .physicallyBased
//            child.movabilityHint = .movable
//            print(self.modelName)
//
//            let scale = 0.01
//            child.scale = SCNVector3(scale, scale, scale)
//            wrapperNode.addChildNode(child)
//        }
        if let material = virtualObjectScene.rootNode.geometry?.firstMaterial {
            material.ambient.contents = UIColor.white
            material.lightingModel = .physicallyBased
        }
        
//        virtualObjectScene.rootNode.geometry?.firstMaterial?.lightingModel = .physicallyBased
//        print(virtualObjectScene.rootNode.geometry?.firstMaterial)
//        virtualObjectScene.rootNode.movabilityHint = .movable
        
        let scale = 0.01
        virtualObjectScene.rootNode.scale = SCNVector3(scale, scale, scale)
        wrapperNode.addChildNode(virtualObjectScene.rootNode)
//        wrapperNode.light = SCNLight()
//        wrapperNode.light?.type = .directional
//        wrapperNode.light?.intensity = 500
        
        self.addChildNode(wrapperNode)
        print("--------------------------\(self)") // Virtual object root node
        modelLoaded = true
    }
    
    
    
    
    // MARK: - Model unload function
	func unloadModel() {
		for child in self.childNodes {
			child.removeFromParentNode()
		}
        print("unloadModel func")
		modelLoaded = false
	}

	func translateBasedOnScreenPos(_ pos: CGPoint, instantly: Bool, infinitePlane: Bool) {
		guard let controller = viewController else {
			return
		}
		let result = controller.worldPositionFromScreenPosition(pos, objectPos: self.position, infinitePlane: infinitePlane)
		controller.moveVirtualObjectToPosition(result.position, instantly, !result.hitAPlane)
	}
}

extension VirtualObject {

	static func isNodePartOfVirtualObject(_ node: SCNNode) -> Bool {
		if node.name == VirtualObject.ROOT_NAME {
            print("VirtualObject - isnodepartOfVirtualObject")
			return true
		}

		if node.parent != nil {
            print("VirtualObeject - is Not nodepartofVirtualObject")
			return isNodePartOfVirtualObject(node.parent!)
		}

		return false
	}
}

// MARK: - Protocols for Virtual Objects

protocol ReactsToScale {
	func reactToScale()
}

extension SCNNode {

	func reactsToScale() -> ReactsToScale? {
		if let canReact = self as? ReactsToScale {
			return canReact
		}

		if parent != nil {
			return parent!.reactsToScale()
		}

		return nil
	}
}
