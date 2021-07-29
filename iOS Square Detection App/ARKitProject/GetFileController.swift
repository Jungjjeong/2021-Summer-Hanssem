//
//  GetFileController.swift
//  ARKitProject
//
//  Created by JungJiyoung on 2021/07/29.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import UIKit
import ARKit
import SceneKit.ModelIO


// MARK: - 3D usdz file load function

class GetFileController : UIViewController, URLSessionDownloadDelegate, ARSCNViewDelegate {
    @IBOutlet weak var scnView: ARSCNView!
    var scnScene: SCNScene!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        scnView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,ARSCNDebugOptions.showWorldOrigin]
        scnView.delegate = self
        scnView.session.run(config)
        
        
        downloadSceneTask()
    }
    
    
    
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
    
    func loadModel(){
        
        //1. Get The Path Of The Downloaded File
        let downloadedScenePath = getDocumentsDirectory().appendingPathComponent("teapot.usdz")
        
        self.scnView.autoenablesDefaultLighting = true
//        self.scnView.showsStatistics = true
//        self.scnView.backgroundColor = UIColor.blue
        let asset = MDLAsset(url: downloadedScenePath)
        asset.loadTextures()
//        let scene = SCNScene(mdlAsset: asset)
//        self.scnView.scene = scene
//        self.scnView.allowsCameraControl = true
        let object = asset.object(at: 0)
        print(object)
        
        let node = SCNNode.init(mdlObject: object)
        print(node)
        node.position = SCNVector3(0, 0, -0.2)
        node.scale = SCNVector3(0.01, 0.01, 0.01)
        
        let scene = SCNScene()
        scene.rootNode.addChildNode(node)
        scnView.scene = scene
    }
}
