//
//  DistanceViewController.swift
//  ARKitProject
//
//  Created by JungJiyoung on 2021/07/26.
//  Copyright © 2021 Apple. All rights reserved.
//
// 거리 재는 ARRuler 구현 예정

import ARKit
import UIKit
import RealityKit


class DistanceViewController : UIViewController {
    @IBOutlet var arview: ARView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arview.session.delegate = self
        
//        showModel()
        overlayCoachingView()
        setupARView()
        
        arview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:))))
    }
    
//    func showModel() {
//        let anchorEntity = AnchorEntity(plane: .horizontal, minimumBounds: [0.2, 0.2])
//
//        print("-------------------------------spinner activate-------------------------------")
//        let spinner = UIActivityIndicatorView()
//        spinner.center = usdzButton.center
//        spinner.bounds.size = CGSize(width: usdzButton.bounds.width - 5, height: usdzButton.bounds.height - 5)
//        usdzButton.setImage(#imageLiteral(resourceName: "buttonring"), for: [])
//        arview.addSubview(spinner)
//        spinner.startAnimating()
//
//
//
//        print("-------------------------------download function-------------------------------")
//        let url = URL(string: "https://developer.apple.com/augmented-reality/quick-look/models/teapot/teapot.usdz")
//        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let destinationUrl = documentsUrl.appendingPathComponent(url!.lastPathComponent)
//        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
//        var request = URLRequest(url: url!)
//        request.httpMethod = "GET"
//
//
//
//        let downloadTask = session.downloadTask(with: request, completionHandler: {
//            (location:URL?, response:URLResponse?, error:Error?) -> Void in
//            let fileManager = FileManager.default
//            if fileManager.fileExists(atPath: destinationUrl.path) {
//                try! fileManager.removeItem(atPath: destinationUrl.path)
//            }
//            try! fileManager.moveItem(atPath: location!.path, toPath: destinationUrl.path)
//            DispatchQueue.main.async {
//                do {
//                    let entity = try Entity.load(contentsOf: destinationUrl) // It is work
//                    entity.setParent(anchorEntity)
//
//                    self.arview.scene.addAnchor(anchorEntity)
//
//                    print("-------------------------------spinner deactivate-------------------------------")
//                    spinner.removeFromSuperview()
//                    self.usdzButton.setImage(#imageLiteral(resourceName: "add"), for: [])
//                    self.usdzButton.setImage(#imageLiteral(resourceName: "addPressed"), for: [.highlighted])
//                }
//                catch {
//                    print("Fail load entity: \(error.localizedDescription)")
//                }
//            }
//        })
//
//
//        print("-------------------------------downloadTask resume-------------------------------")
//        downloadTask.resume()
//
////
////        let entity = try! Entity.loadModel(named: "TEAPOT")
////        entity.setParent(anchorEntity)
////
////        arview.scene.addAnchor(anchorEntity)
//    }
    
    @IBOutlet weak var usdzButton: UIButton!


    @IBAction func usdzFileLoad(_ button: UIButton) {
        
        print("-------------------------------spinner activate-------------------------------")
        let spinner = UIActivityIndicatorView()
        spinner.center = usdzButton.center
        spinner.bounds.size = CGSize(width: usdzButton.bounds.width - 5, height: usdzButton.bounds.height - 5)
        usdzButton.setImage(#imageLiteral(resourceName: "buttonring"), for: [])
        arview.addSubview(spinner)
        spinner.startAnimating()
        
        
        
        print("-------------------------------download function-------------------------------")
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
                    object.name = "TEAPOT"
                    let anchor = AnchorEntity(plane: .horizontal, minimumBounds:[0.2,0.2])
                    anchor.addChild(object)
                    self.arview.scene.addAnchor(anchor)
                    
                    print("-------------------------------spinner deactivate-------------------------------")
                    spinner.removeFromSuperview()
                    self.usdzButton.setImage(#imageLiteral(resourceName: "add"), for: [])
                    self.usdzButton.setImage(#imageLiteral(resourceName: "addPressed"), for: [.highlighted])
                }
                catch {
                    print("Fail load entity: \(error.localizedDescription)")
                }
            }
        })
        
        
        print("-------------------------------downloadTask resume-------------------------------")
        downloadTask.resume()
        
    }
    
    func overlayCoachingView() {
        let coachingView = ARCoachingOverlayView(frame: CGRect(x: 0,y:0, width: arview.frame.width, height: arview.frame.height))
        
        coachingView.session = arview.session
        coachingView.activatesAutomatically = true
        coachingView.goal = .horizontalPlane
        
        view.addSubview(coachingView)
    }
    
    
    func setupARView() {
        arview.automaticallyConfigureSession = false
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        arview.session.run(configuration)
    }
    
    
    @objc
    func handleTap(recognizer: UITapGestureRecognizer){
        let location = recognizer.location(in: arview)
        
        let results = arview.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal)
        
        if let firstResult = results.first {
            let anchor = ARAnchor(name: "TEAPOT", transform: firstResult.worldTransform)
            arview.session.add(anchor : anchor)
        } else {
            print("Object placement failed - couldn't find surface.")
        }
    }
    
    func placeObject(named entityName: String, for anchor : ARAnchor) {
        print("-------------------------------spinner activate-------------------------------")
        let spinner = UIActivityIndicatorView()
        spinner.center = usdzButton.center
        spinner.bounds.size = CGSize(width: usdzButton.bounds.width - 5, height: usdzButton.bounds.height - 5)
        usdzButton.setImage(#imageLiteral(resourceName: "buttonring"), for: [])
        arview.addSubview(spinner)
        spinner.startAnimating()
        
        
        
        print("-------------------------------download function-------------------------------")
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
                    let entity = try ModelEntity.load(contentsOf: destinationUrl) // It is work
                    
                    entity.generateCollisionShapes(recursive: true)
//                    self.arview.installGestures([.rotation, .translation], for: entity)
                    
                    let anchorEntity = AnchorEntity(anchor: anchor)
                    anchorEntity.addChild(entity)
                    self.arview.scene.addAnchor(anchorEntity)
                    
                    print("-------------------------------spinner deactivate-------------------------------")
                    spinner.removeFromSuperview()
                    self.usdzButton.setImage(#imageLiteral(resourceName: "add"), for: [])
                    self.usdzButton.setImage(#imageLiteral(resourceName: "addPressed"), for: [.highlighted])
                }
                catch {
                    print("Fail load entity: \(error.localizedDescription)")
                }
            }
        })
        
        
        print("-------------------------------downloadTask resume-------------------------------")
        downloadTask.resume()
        
//
//        let entity = try! ModelEntity.loadModel(named: entityName)
//
//        entity.generateCollisionShapes(recursive: true)
//        arview.installGestures([.rotation, .translation], for: entity)
//
//        let anchorEntity = AnchorEntity(anchor : anchor)
//        anchorEntity.addChild(entity)
//        arview.scene.addAnchor(anchorEntity)
    }
}

extension DistanceViewController: ARSessionDelegate {
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if let anchorName = anchor.name, anchorName == "TEAPOT" {
                placeObject(named: anchorName, for: anchor)
            }
        }
    }
}
