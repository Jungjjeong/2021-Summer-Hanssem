// MARK: - Object define Node


import Foundation
import SceneKit.ModelIO
import ARKit
import RealityKit


class VirtualObject: SCNNode {
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

	init(modelName: String, fileExtension: String, thumbImageFilename: String, title: String) {
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
		guard let virtualObjectScene = SCNScene(named: "\(modelName).\(fileExtension)",
												inDirectory: "Models.scnassets/\(modelName)") else {
            print("모델을 찾지 못해 return.")
			return
		}
        let wrapperNode = SCNNode()
//
//        let url = URL(fileURLWithPath: "https://developer.apple.com/augmented-reality/quick-look/models/teapot/teapot.usdz")
//        if let virtualObjectScene = try? SCNScene(url: url, options: [.checkConsistency: true]){
//            print("불러왔따")
//            for child in virtualObjectScene.rootNode.childNodes {
//                wrapperNode.addChildNode(child)
//                print("Add child")
//            }
//            print("loadModel func")
//            self.addChildNode(wrapperNode)
//        } else {
//            print("Error loading")
//            return
//        }
//        modelLoaded = true
        
        for child in virtualObjectScene.rootNode.childNodes {
            print("in")
            child.geometry?.firstMaterial?.lightingModel = .physicallyBased
            child.movabilityHint = .movable
            print(self.modelName)
            if self.modelName == "teapot" { // usdz file scale format
                let scale = 0.005
                child.scale = SCNVector3(scale, scale, scale)
//                child.f
            }
            else if self.modelName == "746525_close" {
                let scale = 0.01
                child.scale = SCNVector3(scale, scale, scale)
            }
            wrapperNode.addChildNode(child)
        }
        self.addChildNode(wrapperNode)
        print(self) // Virtual object root node
        modelLoaded = true
        
    }
        
    
        
    // MARK: - 3D usdz file load function

    func usdzFileLoad() {
        print("virtualObejct - download function")
        let url = URL(string: "https://developer.apple.com/augmented-reality/quick-look/models/teapot/teapot.usdz")
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsUrl.appendingPathComponent(url!.lastPathComponent)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let downloadTask = session.downloadTask(with: request, completionHandler: {
            (location:URL?, response:URLResponse?, error:Error?) -> Void in
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: destinationUrl.path) {
                try! fileManager.removeItem(atPath: destinationUrl.path)
            }
            try! fileManager.moveItem(atPath: location!.path, toPath: destinationUrl.path)
            DispatchQueue.main.async {
                do {
                    let object = try Entity.load(contentsOf: destinationUrl) // It is work
                    print(object)
                    for child in object.children {
                        print(child)
                    }
                }
                catch {
                    print("Fail load entity: \(error.localizedDescription)")
                }
            }
        })
        downloadTask.resume()
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
