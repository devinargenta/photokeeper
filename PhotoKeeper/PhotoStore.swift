//
//  ImageStore.swift
//  PhotoKeeper
//
//  Created by Devin Argenta on 5/8/18.
//  Copyright © 2018 Devin Argenta. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

// :Object is a realm class to overwrite
class PhotoObject: Object {
    @objc dynamic var fileName: String = "" // idk if this works
    @objc dynamic var title: String?
    @objc dynamic var desc: String?
    @objc dynamic var dateAdded: Date = Date()
}

class PhotoStore {
    // singleton
    static let shared = PhotoStore()
    let realm = try! Realm()
    init() {
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "help")
    }

    public var photos: Results<PhotoObject> {
          return realm.objects(PhotoObject.self)
    }

    public func clearCache() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    /*
     idk about this
     */
    public func getUIImageFromPhoto(photo: PhotoObject) -> UIImage {
        let image = UIImage()
        let imagePath = getPathForPhoto(photo)
        if FileManager.default.fileExists(atPath: imagePath) {
            if let image = UIImage(contentsOfFile: imagePath) {
                return image
            }
        }
        return image
    }

    public func getPathForPhoto(_ photo: PhotoObject) -> String {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imagePath = documentsDirectory.appendingPathComponent("\(photo.fileName)")
        return imagePath.path
    }

    public func removePhotoFromStore(photo: PhotoObject) -> Void {
        let imagePath = getPathForPhoto(photo)
        try! realm.write {
            realm.delete(photo)
        }
        if FileManager.default.fileExists(atPath: imagePath) {
                try! FileManager.default.removeItem(atPath: imagePath)
        }
    }

    public func addPhotoToStore(photo: PhotoObject) -> Void {
        try! realm.write {
            realm.add(photo)
        }
    }
}
