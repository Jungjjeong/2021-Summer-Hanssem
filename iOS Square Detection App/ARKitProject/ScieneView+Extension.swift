// MARK: - View setting


import ARKit
import Foundation


extension ARSCNView {
	func setUp(viewController: MainViewController, session: ARSession) {
		delegate = viewController
		self.session = session
		antialiasingMode = .multisampling4X // view의 장면을 rendering하는데 필요한 antialiasingMode
        autoenablesDefaultLighting = true
		automaticallyUpdatesLighting = true
		preferredFramesPerSecond = 60 // view가 장면을 rendering하는데 사용하는 애니메이션 frame rate(second)
		contentScaleFactor = 1.3 // content의 축적 비율
//		if let camera = pointOfView?.camera {
//			camera.wantsHDR = true
//			camera.wantsExposureAdaptation = true
//			camera.exposureOffset = 0
//			camera.minimumExposure = 0
//		}
	}

//	func enableEnvironmentMapWithIntensity(_ intensity: CGFloat) {
//		if scene.lightingEnvironment.contents == nil {
//			if let environmentMap = UIImage(named: "Models.scnassets/sharedImages/environment_blur.exr") {
//                //UIImage(named: "Models.scnassets/sharedImages/environment_blur.exr")
//                scene.lightingEnvironment.contents.
//                print("환경 텍스쳐 추가")
//                // lightingEnvironment : scene의 contents를 둘러싼 환경을 묘사하는 큐브 맵 텍스쳐로 고급 조명 효과에 사용된다.
//			}
//		}
//		scene.lightingEnvironment.intensity = intensity
//	}
}
