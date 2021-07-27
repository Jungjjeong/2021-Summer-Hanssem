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
    @IBOutlet weak var usdzButton: UIButton!

    @IBAction func usdzFileLoad(_ button: UIButton) {
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
                    let anchor = AnchorEntity(world: [0,0,0])
                    anchor.addChild(object)
                    self.arview.scene.addAnchor(anchor)
                }
                catch {
                    print("Fail load entity: \(error.localizedDescription)")
                }
            }
        })
        downloadTask.resume()
    }
    
    
}
