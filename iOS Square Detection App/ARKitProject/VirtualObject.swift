// MARK: - Object define Node


import Foundation
import SceneKit.ModelIO
import ARKit
import RealityKit


class VirtualObject: SCNNode, URLSessionDelegate {
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
//		guard let virtualObjectScene = SCNScene(named: "\(modelName).\(fileExtension)",
//												inDirectory: "Models.scnassets/\(modelName)") else {
//            print("모델을 찾지 못해 return.")
//			return
//		}
        
        downloadSceneTask()
        
        
        let downloadedScenePath = getDocumentsDirectory().appendingPathComponent("teapot.usdz")
        
        let asset = MDLAsset(url: downloadedScenePath)
        asset.loadTextures()
//        let scene = SCNScene(mdlAsset: asset)
        
        let object = asset.object(at: 0)
        print(object)

        
        let node = SCNNode.init(mdlObject: object)

        let wrapperNode = SCNNode.init(mdlObject: object)
        print(node)
        let scale = 0.01
        wrapperNode.scale = SCNVector3(scale, scale, scale)
//        for child in scene.rootNode.childNodes {
//            print("in")
//            child.geometry?.firstMaterial?.lightingModel = .physicallyBased
//            child.movabilityHint = .movable
//            print(self.modelName)
//
//        }
        self.addChildNode(wrapperNode)
        print(self) // Virtual object root node
        modelLoaded = true
        
        
    }
    
    // MARK: - usdz file download

    func downloadSceneTask(){
        
        //1. Get The URL Of The SCN File
        guard let url = URL(string: "https://developer.apple.com/augmented-reality/quick-look/models/teapot/teapot.usdz") else {
            return
        }
        
        //2. Create The Download Session
        let downloadSession = URLSession(configuration: URLSession.shared.configuration, delegate: self, delegateQueue: nil)
        
        //3. Create The Download Task & Run It
        let downloadTask = downloadSession.downloadTask(with: url)
        downloadTask.resume()
    }
        
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        //1. Create The Filename
        let fileURL = getDocumentsDirectory().appendingPathComponent("teapot.usdz")
        
        //2. Copy It To The Documents Directory
        do {
            try FileManager.default.copyItem(at: location, to: fileURL)
            
            print("Successfuly Saved File \(fileURL)")
            
            //3. Load The Model
            loadModel()
            
        } catch {
            
            print("Error Saving: \(error)")
            loadModel()
        }
        
    }
    
    func getDocumentsDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
        
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
