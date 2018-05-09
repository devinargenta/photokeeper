//
//  PhotoGridViewController.swift
//  PhotoKeeper
//
//  Created by Devin Argenta on 5/3/18.
//  Copyright © 2018 Devin Argenta. All rights reserved.
//

import UIKit


struct Trash {
    var title: String?
    var description: String?
    var image: UIImage?
}


class PhotoGridViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let reuseIdentifier = "PhotoCell"
    var data = [ImageObject]()
    var backup = [Trash]()
    let black = UIColor(hue: 0.5278, saturation: 0.9, brightness: 0.23, alpha: 1.0)
    var topBarHeight: CGFloat = 0
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundColor = .white
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(showComposer))
        
        let navBar = navigationController?.navigationBar
        navBar?.barTintColor = .white
        navBar?.isTranslucent = false
        navBar?.tintColor = black
        navBar?.titleTextAttributes =  [NSAttributedStringKey.foregroundColor: black]
        
        
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    @objc func showComposer(){
        let cvc = CameraViewController()
        let nvc = UINavigationController(rootViewController: cvc)
        present(nvc, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = data[indexPath.row]
        let pvc = PhotoViewController()
        let imageName = data[indexPath.row].fileName
        let imagePath = documentsDirectory.appendingPathComponent("\(imageName)")
        pvc.image = UIImage(contentsOfFile: imagePath.path)
        pvc.imageTitle = item.title
        pvc.imageDescription = item.description
        navigationController?.pushViewController(pvc, animated: true)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        return data.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = black
        let imageName = data[indexPath.row].fileName
        print(imageName)
        let imagePath = documentsDirectory.appendingPathComponent("\(imageName)")
        print(imagePath)

        if FileManager.default.fileExists(atPath: imagePath.path) {
            print("hey")
            let image = UIImage(contentsOfFile: imagePath.path)
            let iv = UIImageView(image: image)
            iv.contentMode = .scaleAspectFill
            cell.clipsToBounds = true
            iv.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
        
           // iv.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            cell.backgroundView = iv
           // cell.contentView.addSubview(iv)
        }
 
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let sq = (view.frame.width - 60) / 3
        return CGSize(width: sq, height: sq)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let storedImages = UserDefaults.standard.array(forKey: "storedImages") {
            data = [ImageObject]()
            for item in storedImages {
                if let image = try? JSONDecoder().decode(ImageObject.self, from: item as! Data) {
                    data.insert(image, at: 0)
                }
            }
        }

        collectionView?.reloadData()
        
    }

}
