//
//  ViewController.swift
//  MSession
//
//  Created by Vitor Mesquita on 03/07/2018.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let session = SessionManager<User>(sessionDataStore: SessionDataStore())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

