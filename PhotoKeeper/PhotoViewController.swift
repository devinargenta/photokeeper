//
//  PhotoViewController.swift
//  PhotoKeeper
//
//  Created by Devin Argenta on 5/4/18.
//  Copyright © 2018 Devin Argenta. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    var image: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hue: 0.5722, saturation: 0.73, brightness: 0.82, alpha: 1.0) /* #388ed1 */
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
