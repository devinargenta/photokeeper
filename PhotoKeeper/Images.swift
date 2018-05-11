//
//  Structs.swift
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
    // var images = [Image]()
    let IMAGE_KEY_CONST = "storedImages"

    func getStore() -> [Data] {
        return UserDefaults.standard.array(forKey: IMAGE_KEY_CONST) as? [Data] ?? []
    }
    
    func getImages() -> [Image] {
        let savedImages = getStore()
        return savedImages.compactMap{ (item: Data) -> Image in
            return try! JSONDecoder().decode(Image.self, from: item )
        }
    }
    func saveToStore(image: Image) -> Void {
        if let encoded = try? JSONEncoder().encode(image) {
            var savedImages = getStore()
            savedImages.insert(encoded, at: 0)
            UserDefaults.standard.set(savedImages, forKey: IMAGE_KEY_CONST)
        }
    }
}
