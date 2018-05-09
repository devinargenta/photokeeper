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
    var imageTitle: String?
    var imageDescription: String?

    override func viewDidLoad() {
        super.viewDidLoad()
       //
        title = imageTitle
        view.backgroundColor = .black
        if image != nil {
            let imageView = UIImageView(image: image)
            view.clipsToBounds = true
            imageView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.width)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.center.x = view.center.x
            view.addSubview(imageView)
        } else {
            view.backgroundColor = UIColor(hue: 0.5722, saturation: 0.73, brightness: 0.82, alpha: 1.0) /* #388ed1 */
        }
        // Do any additional setup after loading the view.
        
        let tl = UILabel(frame: CGRect(x: 40, y: view.frame.width + 40, width: view.frame.width - 40, height: 40))
        tl.textColor = .white
        tl.text = imageTitle

        tl.font = tl.font.withSize(48)
        tl.numberOfLines = 0
        tl.sizeToFit()
        tl.backgroundColor = .red
        view.addSubview(tl)
        
        let dl = UILabel(frame: CGRect(x: 40, y: tl.frame.origin.y + tl.frame.size.height + 20, width: view.frame.width, height: 120))
        dl.text = imageDescription
        dl.numberOfLines = 0
        dl.backgroundColor = .blue
        dl.font = dl.font.withSize(20)
        dl.sizeToFit()
        dl.textColor = .white

        view.addSubview(dl)
        
        // kill me
        
        
        
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
