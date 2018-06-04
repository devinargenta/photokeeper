//
//  PhotoGridViewController.swift
//  PhotoKeeper
//
//  Created by Devin Argenta on 5/3/18.
//  Copyright © 2018 Devin Argenta. All rights reserved.
//

import UIKit
import RealmSwift

class PhotoGridViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var store = PhotoStore.shared
    var photos: Results<PhotoObject>!
    var topBarHeight: CGFloat = 0

    let reuseIdentifier = "PhotoCell"
    let black = UIColor(hue: 0.5278, saturation: 0.9, brightness: 0.23, alpha: 1.0)
    let INSET: CGFloat = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        collectionView?.backgroundColor = .white
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    func setupNav() {
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(showCameraViewController))
        let navBar = navigationController?.navigationBar
        navBar?.barTintColor = .white
        navBar?.isTranslucent = false
        navBar?.tintColor = black
        navBar?.titleTextAttributes =  [NSAttributedStringKey.foregroundColor: black]
    }

    @objc func showCameraViewController(){
        let cvc = CameraViewController()
        let nvc = UINavigationController(rootViewController: cvc)
        present(nvc, animated: true, completion: nil)
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        let pvc = PhotoViewController()
        pvc.photo = photo
        navigationController?.pushViewController(pvc, animated: true)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        let photo = photos[indexPath.row]
        let photoPath = store.getPathForPhoto(photo)
        if FileManager.default.fileExists(atPath: photoPath) {
            let image = UIImage(contentsOfFile: photoPath)
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            cell.clipsToBounds = true
            imageView.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
            cell.backgroundView = imageView
        }

        /* hacky remove all the title content things idfk..... */

        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }

        if photo.title != "" {
            let metaicon = UIImageView(frame: CGRect(x: 20, y: 20, width: 20, height: 20))
            metaicon.backgroundColor = .white
            cell.contentView.addSubview(metaicon)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        // UH LOL... width of thing, 4 gaps ( outer insets + 2 between the items )  dimageViewided by 3 items
        let size = (view.frame.width - (INSET * 4)) / 3
        return CGSize(width: size, height: size)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return INSET
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return INSET
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: INSET, left: INSET, bottom: INSET, right: INSET)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photos = store.photos.sorted(byKeyPath: "dateAdded", ascending: false)
        collectionView?.reloadData()
    }

}
