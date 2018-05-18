//
//  ImageStore.swift
//  PhotoKeeper
//
//  Created by Devin Argenta on 5/8/18.
//  Copyright © 2018 Devin Argenta. All rights reserved.
//

import Foundation

// toog eneric // refactor??
struct Photo: Codable {
    var fileName: String // idk if this works
    var title: String?
    var description: String?
    var dateAdded: Date
    init(fileName: String, title: String? = nil, description: String? = nil) {
        self.fileName = fileName
        self.title = title
        self.description = description
        self.dateAdded = Date()
    }
}

class PhotoStore {
    // singleton
    static let shared = PhotoStore()
    
    private let IMAGE_KEY_CONST = "storedImages"
    private let defaults = UserDefaults.standard
    private func getStore() -> [Data] {
        return defaults.array(forKey: IMAGE_KEY_CONST) as? [Data] ?? []
    }

    // no set
    public var images: [Photo] {
        let savedImages = getStore()
        return savedImages.compactMap{ (item: Data) -> Photo? in
            if let item =  try? JSONDecoder().decode(Photo.self, from: item ) {
                return item
            }
            return nil
        }
    }
    
    public func clearCache() {
        defaults.removeObject(forKey: IMAGE_KEY_CONST)
        defaults.synchronize()
    }
    
    /*
        this is potentailly fucky
 
    */
    public func removeImageFromStore(image: Photo) -> Void {
        var savedImages = getStore()
        if let i = images.index(where: {
            image.fileName == $0.fileName
        }) {
            savedImages.remove(at: i)
            defaults.set(savedImages, forKey: IMAGE_KEY_CONST)
        }
    }
    public func addImageToStore(image: Photo) -> Void {
        if let encoded = try? JSONEncoder().encode(image) {
            var savedImages = getStore()
            savedImages.insert(encoded, at: 0)
            defaults.set(savedImages, forKey: IMAGE_KEY_CONST)
        }
    }
}
