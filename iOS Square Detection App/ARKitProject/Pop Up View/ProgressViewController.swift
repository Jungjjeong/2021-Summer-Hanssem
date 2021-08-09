//
//  ProgressViewController.swift
//  ARKitProject
//
//  Created by JungJiyoung on 2021/08/09.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController {
    
    @IBOutlet weak var cancleBtn : UIButton!
    @IBOutlet var popUpView: UIView!
    
    @IBAction func cancle(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        popUpView.layer.cornerRadius = 15
        popUpView.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
