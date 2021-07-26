// MARK: - ARCamera를 사용했을 시, 품질이 좋지 않은 경우 -> return


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
