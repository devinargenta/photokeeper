//
//  Structs.swift
//  PhotoKeeper
//
//  Created by Devin Argenta on 5/8/18.
//  Copyright © 2018 Devin Argenta. All rights reserved.
//

import Foundation

struct ImageObject: Codable {
    var fileName: String // idk if this works
    var title: String!
    var description: String!
}

class Images {
    var images = [ImageObject]()
    func setImages(newImages: [Data]) -> Void {
        self.images = newImages.compactMap{ (item: Any) -> ImageObject in
            return try! JSONDecoder().decode(ImageObject.self, from: item as! Data)
        }
    }
}
