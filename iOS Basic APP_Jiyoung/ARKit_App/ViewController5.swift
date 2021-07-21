//
//  일반 배치 모드
//
import UIKit
import RealityKit
// 기본 arkit 통합, 물리적 요소 기반의 랜더링, 변형, 애니메이션, ar 개발 프래임워크
import ARKit
// iOS 기기의 카메라와 움직임들을 어플 또는 게임 내에서 증강 현실을 구현하기 위해 통합하는 프레임워크

class ViewController5: UIViewController {

    @IBOutlet weak var arView: ARView! // realitykit
    // IBOutlet : 값에 접근하기위한 변수
    // weak -> 뷰를 삭제할 경우 메모리에서 해제
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        arView.session.delegate = self
        print("ViewController5")
        setupARView()
        
        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:))))
        // UITapGestureRecognizer : single tap or multi tap gesture
    }
    
    //MARK: Setup Methods
    func setupARView() {
        arView.automaticallyConfigureSession = false
        self.addCoaching() // add CoachingOverlay View
        let configuration = ARWorldTrackingConfiguration()
        // ARWorldTrackingConfiguration -> arConfiguration을 상속받는 서브 클래스 중 하나
        // arkit 기본 제공, 실제 세계의 사용자의 위치를 인식하고 가상 콘텐츠를 배치할 좌표 공간과 일치시키는 역할 .
        // 기기의 움직임을 3개의 회전각 (roll, pitch, yaw)와 3개의 변환각 (x, y, z)을 통해 추적
        
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        arView.session.run(configuration)
    }
    
    //MARK: Object Placement
    @objc
    func handleTap(recognizer: UITapGestureRecognizer) {
        // Tap시 콜백함수
        let locatoin = recognizer.location(in: arView) // tap location
        
        let results = arView.raycast(from: locatoin, allowing: .estimatedPlane, alignment: .horizontal)
        // location(View의 로컬 좌표계)에서부터 광선을 투사하고, 반환 결과(카메라에서 가까운 -> 먼 것 순으로 정렬된 레이케스트 결과 목록)를 result에 저장
        // allowing : 광선이 종료되는 시점
        // alignmnet : 정렬
        
        if let firstResult = results.first {
            // results.first의 값을 firstResult에 할당할 수 있으면
            let anchor = ARAnchor(name: "chair_swan", transform: firstResult.worldTransform)
            // anchor 생성
            arView.session.add(anchor: anchor)
            // arview에 anchor을 session을 통해서 얹기
        } else {
            print("Object placement failed -couldn't find surface.")
        }
    }
    
    func placeObject(named entityName: String, for anchor: ARAnchor) {
        let entity = try! ModelEntity.loadModel(named: entityName)
        // ModelEntity -> realitykit이 랜더링하고 선택적으로 시뮬레이션하는 물리적 개체
        // string: entityName 의 모델을 로드 시도 -> 성공 시 entity 에 할당
        
        entity.generateCollisionShapes(recursive: true)
        // Collision components가 있는 엔티티의 Collision을 감지하여 shapes를 만든다.
        arView.installGestures([.rotation,.translation], for: entity)
        // entity에 rotation과 translation이 동시에 인식될 수 있게 구성
        
        let anchorEntity = AnchorEntity(anchor: anchor) // AnchorEntity -> ar session에서 가상 contents를 실제 개체에 연결하는 anchor
        anchorEntity.addChild(entity) //AnchorEntity 위에 entity 배치
        arView.scene.addAnchor(anchorEntity) // arview에 anchorentity를 배치
    }
}

extension ViewController5: ARSessionDelegate {
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) { // ARSession - ar 경험을 만들기 위해 필수적인 데이터와 로직을 처리하기 위한 세션
        for anchor in anchors {
            if let anchorName = anchor.name, anchorName == "chair_swan" { // anchor name 지정해서 불러오기
                placeObject(named: anchorName, for: anchor)
            }
        }
    }
}

extension ViewController5: ARCoachingOverlayViewDelegate { // coachingOverlayView
    func addCoaching() {
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.delegate = self
        coachingOverlay.session = arView.session
        coachingOverlay.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        arView.addSubview(coachingOverlay)
        
        NSLayoutConstraint.activate([
            coachingOverlay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coachingOverlay.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            coachingOverlay.widthAnchor.constraint(equalTo: view.widthAnchor),
            coachingOverlay.heightAnchor.constraint(equalTo: view.heightAnchor)
            ])
        
        coachingOverlay.activatesAutomatically = true
        coachingOverlay.goal = .horizontalPlane
    }
    
//    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
//        <#code#>// Ready to add entities next?
//    }
}
