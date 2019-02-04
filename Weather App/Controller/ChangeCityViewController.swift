//
//  ChangeCityViewController.swift
//  Weather App
//
//  Created by Thobio on 04/02/19.
//  Copyright © 2019 Zerone Consulting. All rights reserved.
//

import UIKit

class ChangeCityViewController: UIViewController {

    @IBOutlet var locationText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func getLocationButton(_ sender: Any) {
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
