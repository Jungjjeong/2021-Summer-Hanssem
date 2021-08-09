// MARK: - Object define Node


import Foundation
import SceneKit.ModelIO
import ARKit


class VirtualObject: SCNNode, URLSessionDownloadDelegate{
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
        print("---------------------Start loadModel function")
//        print("VirtualObject - loadModel function")

//        if modelName != "Hanssem_chair03"{
        downloadSceneTask(type: true)
        
        let downloadedScenePath = getDocumentsDirectory().appendingPathComponent("\(modelName).usdz")
        
        let asset = MDLAsset(url: downloadedScenePath)
        asset.loadTextures()
        
        let object = asset.object(at: 0)
        
        let node = SCNNode.init(mdlObject: object)
        if modelName == "Teapot" || modelName == "AirForce" || modelName == "fender_stratocaster" {
            node.scale = SCNVector3(0.01, 0.01, 0.01)
        }
        
        if modelName == "hanssemchair01" {
            node.scale = SCNVector3(0.001, 0.001, 0.001)
        }
        
        // MARK: - Light & Shadow Node
        
//        let shadowPlane = SCNPlane(width: 5000, height: 5000)
//
//        let material = SCNMaterial()
//        material.isDoubleSided = false
//        material.lightingModel = .shadowOnly // Requires SCNLight shadowMode = .forward and
//        // light가 .omni거나 .spot이면 검은색으로 변하는 이슈 발생
//
//        shadowPlane.materials = [material]
//
//        let shadowPlaneNode = SCNNode(geometry: shadowPlane)
//        shadowPlaneNode.name = modelName
//        shadowPlaneNode.eulerAngles.x = -.pi / 2
//        shadowPlaneNode.castsShadow = false
//
//        self.addChildNode(shadowPlaneNode)
//
//        let light = SCNLight()
//        light.type = .directional
//        light.castsShadow = true
//        light.shadowRadius = 20
//        light.shadowSampleCount = 64
//
//        light.shadowColor = UIColor(white: 0, alpha: 0.5)
//        light.shadowMode = .forward
//        light.maximumShadowDistance = 11000
////        let constraint = SCNLookAtConstraint(target: self)
////
////        guard let lightEstimate = MainViewController.sceneView.session.currentFrame?.lightEstimate else {
////            return
////        }
//
//        // light node
//        let lightNode = SCNNode()
//        lightNode.light = light
////        lightNode.light?.intensity = lightEstimate.ambientIntensity
////        lightNode.light?.temperature = lightEstimate.ambientColorTemperature
////            lightNode.position = SCNVector3(object.position.x + 10, object.position.y + 30, object.position.z + 30)
//        lightNode.eulerAngles = SCNVector3(45.0,0,0)
////        lightNode.constraints = [constraint]
//        self.addChildNode(lightNode)
        
        
        
        
        
        self.addChildNode(node)
        
        downloadSceneTask(type: false)
        print("finish \(modelName) downloadTask func")
        
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
    
    
    // MARK: - download from URL
    func downloadSceneTask(type : Bool) {
        if type == true {
            print("start downloadscenetask function")
            let url : URL
            switch modelName
            {
            case "Teapot":
                print("Teapot")
                url = URL(string: "https://developer.apple.com/augmented-reality/quick-look/models/teapot/teapot.usdz")!
            case "AirForce":
                print("AirForce")
                url = URL(string: "https://devimages-cdn.apple.com/ar/photogrammetry/AirForce.usdz")!
            case "fender_stratocaster":
                print("fender_stratocaster")
                url = URL(string: "https://developer.apple.com/augmented-reality/quick-look/models/stratocaster/fender_stratocaster.usdz")!
            case "moa_rose" :
                print("moa_rose")
                url = URL(string: "https://github.com/Jungjjeong/2021-Summer-Hanssem/raw/main/models/moa_rose.usdz")!
            case "hanssemchair01" :
                print("hanssemchair01")
                url = URL(string: "https://github.com/Jungjjeong/2021-Summer-Hanssem/raw/main/models/hanssemchair01.usdz")!
            default:
                print("Default")
                url = URL(string: "https://developer.apple.com/augmented-reality/quick-look/models/teapot/teapot.usdz")!
            }
            
            
            //2. Create The Download Session
            print("create the download session")
            let downloadSession = URLSession(configuration: URLSession.shared.configuration, delegate: self, delegateQueue: nil)
            
            
            //3. Create The Download Task & Run It
            print("create the download task & run it")

            let downloadTask = downloadSession.downloadTask(with: url)
            downloadTask.resume()
        }
        else{
            print("Cancel")
        }
    }
    
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        //1. Create The Filename
        let fileURL = getDocumentsDirectory().appendingPathComponent("\(modelName).usdz")
        
        //2. Copy It To The Documents Directory
        do {
            try FileManager.default.copyItem(at: location, to: fileURL)
            
            print("Successfuly Saved File \(fileURL)")
            loadModel()
        } catch {
            
            print("Error Saving: \(error)")
        }
    }
    
    
    
    func getDocumentsDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}


// MARK: - Extension

extension VirtualObject {

	static func isNodePartOfVirtualObject(_ node: SCNNode) -> Bool {
		if node.name == VirtualObject.ROOT_NAME {
//            print("VirtualObject - isnodepartOfVirtualObject")
			return true
		}

		if node.parent != nil {
//            print("VirtualObeject - is Not nodepartofVirtualObject")
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
