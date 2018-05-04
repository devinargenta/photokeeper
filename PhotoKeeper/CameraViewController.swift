//
//  CameraViewController.swift
//  PhotoKeeper
//
//  Created by Devin Argenta on 5/3/18.
//  Copyright © 2018 Devin Argenta. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationController?.navigationBar.barStyle = .blackTranslucent
        navigationController?.navigationBar.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(cancel))
        
    
        // build the little clicker
        let snappyBoi = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))

        snappyBoi.center = view.center
        snappyBoi.center.y = view.frame.height - (snappyBoi.bounds.size.height * 1.5)
        snappyBoi.layer.cornerRadius = 0.5 * snappyBoi.bounds.size.width
        snappyBoi.clipsToBounds = true
        snappyBoi.backgroundColor = .white
        snappyBoi.addTarget(self, action: #selector(takePhoto), for: UIControlEvents.touchUpInside)
        view.addSubview(snappyBoi)
        // Do any additional setup after loading the view.
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func takePhoto() {
        // take a  photo
        
        // display the next stuff
        
        // hide the photo the
        
       // let captionViewController =
        
    }

}
