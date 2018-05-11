//
//  ImageStore.swift
//  PhotoKeeper
//
//  Created by Devin Argenta on 5/8/18.
//  Copyright © 2018 Devin Argenta. All rights reserved.
//

import Foundation

struct Image: Codable {
    var fileName: String // idk if this works
    var title: String!
    var description: String!
}

class ImageStore {
    // singleton
    static let shared = ImageStore()
    
    private let IMAGE_KEY_CONST = "storedImages"
    private let defaults = UserDefaults.standard
    private func getStore() -> [Data] {
        return defaults.array(forKey: IMAGE_KEY_CONST) as? [Data] ?? []
    }

    // no set
    public var images: [Image] {
        let savedImages = getStore()
        return savedImages.compactMap{ (item: Data) -> Image in
            return try! JSONDecoder().decode(Image.self, from: item )
        }
    }
    
    public func clearCache() {
        defaults.removeObject(forKey: IMAGE_KEY_CONST)
        defaults.synchronize()
    }
    
    /*
        this is potentailly fucky
 
    */
    public func removeImageFromStore(image: Image) -> Void {
        var savedImages = getStore()
        if let i = images.index(where: {
            image.fileName == $0.fileName
        }) {
            savedImages.remove(at: i)
            defaults.set(savedImages, forKey: IMAGE_KEY_CONST)
        }
    }
    public func addImageToStore(image: Image) -> Void {
        if let encoded = try? JSONEncoder().encode(image) {
            var savedImages = getStore()
            savedImages.insert(encoded, at: 0)
            defaults.set(savedImages, forKey: IMAGE_KEY_CONST)
        }
    }
}
