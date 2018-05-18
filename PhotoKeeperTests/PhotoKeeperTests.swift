//
//  PhotoKeeperTests.swift
//  PhotoKeeperTests
//
//  Created by Devin Argenta on 5/3/18.
//  Copyright © 2018 Devin Argenta. All rights reserved.
//

import XCTest
@testable import PhotoKeeper

class PhotoKeeperTests: XCTestCase {
    var store: PhotoStore!
    override func setUp() {

        super.setUp()
        store = PhotoStore.shared
        store.clearCache()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        store.clearCache()
        super.tearDown()
        
    }
    
    
    func testAddImageToStore() {
        let image = Photo(fileName: "help", title: "me", description: "now")
        store.addImageToStore(image: image)
        
        // image is in there
        XCTAssertTrue(store.images.contains(where: {
           $0.fileName == image.fileName
        }))
        
        // nothing weird in there
        XCTAssertFalse(store.images.contains(where: {
            $0.fileName == "oh good lord im not in there"
        }))

    }
    
    func testImageCount() {
        let image = Photo(fileName: "help", title: "me", description: "now")
        store.addImageToStore(image: image)
        XCTAssertTrue(store.images.count == 1)
        store.addImageToStore(image: image)
        XCTAssertTrue(store.images.count == 2)
    }
    
    func testStoredImages() {
        let image = Photo(fileName: "help", title: "me", description: "now")
        store.addImageToStore(image: image)
        
        var images = store.images
        XCTAssertTrue(images[0].fileName == image.fileName)
        XCTAssertTrue(images[0].title == image.title)
        XCTAssertTrue(images[0].description == image.description)
    }
    
    func testRemoveItemFromStore() {
        let image = Photo(fileName: "help", title: "me", description: "now")
        store.addImageToStore(image: image)
        XCTAssertTrue(store.images.count == 1)
        XCTAssertTrue(store.images.contains(where: {
            $0.fileName == image.fileName
        }))
        
        let image2 = Photo(fileName: "help again", title: "me", description: "now")
        let image3 = Photo(fileName: "help again", title: "me", description: "now")
        store.addImageToStore(image: image2)
        store.addImageToStore(image: image3)
        XCTAssertTrue(store.images.count == 3)
        store.removeImageFromStore(image: image)
        XCTAssertTrue(store.images.count == 2)
        XCTAssertFalse(store.images.contains(where: {
            $0.fileName == image.fileName
        }))
    }

    
    func testSingleStore() {
        // add an image to the first store
        let image = Photo(fileName: "help", title: "me", description: "now")
        store.addImageToStore(image: image)
        
        let store1 = PhotoStore.shared
        let store2 = PhotoStore.shared
        
        XCTAssertTrue(store1.images.count == 1)
        XCTAssertTrue(store2.images.count == 1)

    }
    
    func testClearCache() {
        let image = Photo(fileName: "help", title: "me", description: "now")
        store.addImageToStore(image: image)
        XCTAssertTrue(store.images.count == 1)
        
        // clear
        store.clearCache()
        
        XCTAssertTrue(store.images.count == 0)
        
    }
    
}
