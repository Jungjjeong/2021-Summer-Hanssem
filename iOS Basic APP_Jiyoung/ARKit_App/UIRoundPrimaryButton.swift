//
//  UIRoundPrimaryButton.swift
//  ARKit_App
//
//  Created by JungJiyoung on 2021/07/15.
//

import Foundation
import UIKit

class UIRoundPrimaryButton: UIButton{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.layer.cornerRadius = 20.0;
        self.backgroundColor = UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        self.tintColor = UIColor.white
    }
}
