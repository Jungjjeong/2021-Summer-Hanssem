//
//  SizeMeasurementView.swift
//  ARKitProject
//
//  Created by JungJiyoung on 2021/08/03.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import ARKit
import UIKit


class SizeMeasurementView : UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    
    
    override func viewDidLoad() { // view initialized
        super.viewDidLoad()

        Setting.registerDefaults()
        
        sceneView.automaticallyUpdatesLighting = true
        sceneView.autoenablesDefaultLighting = true
    }

    override func viewDidAppear(_ animated: Bool) { // view 보여진 후, animation appear
        super.viewDidAppear(animated)

        UIApplication.shared.isIdleTimerDisabled = true // 일정 시간 지나면 꺼지는 타이머가 설정 되지 않았는가 -> true
        // 계속해서 contents를 표시해야 하는 mapping app 같은 경우, 유후 카메라를 끈다.
        restartPlaneDetection() // 뷰가 나타날때마다 plane detection을 수행한다.
    }

    override func viewWillDisappear(_ animated: Bool) { // view 사라지기 전
        super.viewWillDisappear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
    }
    
    func restartPlaneDetection() {
        // configure session
        if let worldSessionConfig = sessionConfig as? ARWorldTrackingConfiguration { // ARWorldTrackingConfiguration 의 sessionConfig로 다운캐스팅
            worldSessionConfig.planeDetection = .horizontal // 수평 planeDetection
            session.run(worldSessionConfig, options: [.resetTracking, .removeExistingAnchors]) // 전에 존재하던 anchor 제거, tracking 초기화
        }
    }
}
