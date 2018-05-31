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

        title = imageTitle
        view.backgroundColor = .black
    
    
        let iv = UIImageView()
        view.clipsToBounds = true
        iv.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        iv.contentMode = .scaleAspectFill
        iv.image = image
        iv.clipsToBounds = true
        view.addSubview(iv)
        
        let tl = UILabel(frame: CGRect(x: 20, y: view.frame.width + 40, width: view.frame.width - 40, height: 40))
        tl.textColor = .white
        tl.text = imageTitle

        tl.font = tl.font.withSize(48)
        tl.numberOfLines = 0
        tl.sizeToFit()
        tl.backgroundColor = .red
        view.addSubview(tl)
        
        let dl = UILabel(frame: CGRect(x: 20, y: tl.frame.origin.y + tl.frame.size.height + 20, width: view.frame.width - 40, height: 120))
        dl.text = imageDescription
        dl.numberOfLines = 0
        dl.backgroundColor = .blue
        dl.font = dl.font.withSize(20)
        dl.sizeToFit()
        dl.textColor = .white

        view.addSubview(dl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
