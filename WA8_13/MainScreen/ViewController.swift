//
//  ViewController.swift
//  WA8_13
//
//  Created by Veronika Potter on 3/22/24.
//

import UIKit

class ViewController: UIViewController {

    let mainScreen = MainScreenView()
    
    override func loadView() {
        view = mainScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "hello, world."
        // Do any additional setup after loading the view.
    }


}

