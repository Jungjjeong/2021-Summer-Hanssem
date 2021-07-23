// MARK: - ARcamera를 통한 위치 추적 품질 및 품질이 좋지 않을 시 그 원인(case)


import Foundation
import ARKit

extension ARCamera.TrackingState {
	var presentationString: String {
		switch self {
        case .notAvailable:
            return "TRACKING UNAVAILABLE"
        case .normal:
            return "TRACKING NORMAL"
        case .limited(let reason):
            switch reason {
            case .excessiveMotion:
                return "TRACKING LIMITED\nToo much camera movement"
            case .insufficientFeatures:
                return "TRACKING LIMITED\nNot enough surface detail"
            case .initializing:
                return "INITIALIZING"
            case .relocalizing:
                return "INITIALIZING"
            }
        }
	}
}
