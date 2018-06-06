//
//  PhotoViewController.swift
//  PhotoKeeper
//
//  Created by Devin Argenta on 5/4/18.
//  Copyright © 2018 Devin Argenta. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    let store = PhotoStore.shared
    weak var photo: PhotoObject? {
        didSet {
            guard let photo = photo else { return }
            let photoPath = store.getPathForPhoto(photo)
            title = photo.title
            let imageView = UIImageView()
            imageView.frame = view.bounds
            imageView.contentMode = .scaleAspectFill
            imageView.image = UIImage(contentsOfFile: photoPath)
            imageView.clipsToBounds = true
            view.addSubview(imageView)
            // set image in image view
            buildMetaDataView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deletePhoto))

        buildMetaDataView()
    }

    @objc func deletePhoto() {
        let dialogMessage =
            UIAlertController(title: "Confirm",
                message: "Are you sure you want to delete this photo?",
                preferredStyle: .alert)

        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { _ -> Void in
            self.store.removePhotoFromStore(photo: self.photo!)
            self.navigationController?.popViewController(animated: true)
        })

        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ -> Void in
            print("Cancel button tapped")
        }

        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)

        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)

    }

    func buildMetaDataView() {
        let photoTitle = photo?.title
        let photoDesc = photo?.desc

        let tl = UILabel(frame: CGRect(x: 20, y: view.frame.width + 40, width: view.frame.width - 40, height: 40))
        tl.textColor = .white
        tl.text = photoTitle

        tl.font = tl.font.withSize(48)
        tl.numberOfLines = 0
        tl.sizeToFit()
        tl.backgroundColor = .red
        view.addSubview(tl)

        let dl = UILabel(frame:
            CGRect(x: 20, y: tl.frame.origin.y + tl.frame.size.height + 20, width: view.frame.width - 40, height: 120))
        dl.text = photoDesc
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
