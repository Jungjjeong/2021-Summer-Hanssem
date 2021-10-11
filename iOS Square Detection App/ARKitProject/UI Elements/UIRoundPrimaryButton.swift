//
// MARK: - Button design
//  ARKitProject
//
//  Created by JungJiyoung on 2021/07/19.
//  Copyright © 2021 Apple. All rights reserved.
//


import Foundation
import UIKit

class UIRoundPrimaryButton: UIButton{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.layer.cornerRadius = 10.0;
        self.backgroundColor = UIColor(red: 0.5529, green: 0, blue: 0.6392, alpha: 1.0)
        self.tintColor = UIColor.white
    }
}
