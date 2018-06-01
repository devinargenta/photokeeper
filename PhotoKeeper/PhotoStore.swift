//
//  ImageStore.swift
//  PhotoKeeper
//
//  Created by Devin Argenta on 5/8/18.
//  Copyright © 2018 Devin Argenta. All rights reserved.
//

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
    init(){
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

    public func removePhotoFromStore(photo: PhotoObject) -> Void {
        try! realm.write {
            realm.delete(photo)
        }
        
    }

    public func addPhotoToStore(photo: PhotoObject) -> Void {
        try! realm.write {
            realm.add(photo)
        }
    }
}
