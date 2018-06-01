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
    
//    
    func testAddImageToStore() {
        let photo = PhotoObject(value: ["fileName": "help", "title": "me", "desc": "now"])
        store.addPhotoToStore(photo: photo)
        // image is in there
        XCTAssertTrue(store.photos.contains(where: {
           $0.fileName == photo.fileName
        }))
        
        // nothing weird in there
        XCTAssertFalse(store.photos.contains(where: {
            $0.fileName == "oh good lord im not in there"
        }))

    }
    
    func testImageCount() {
        let p1 =  PhotoObject(value: ["fileName": "help again", "title": "me", "description": "now"])
        store.addPhotoToStore(photo: p1)
        XCTAssertTrue(store.photos.count == 1)
        let p2 =  PhotoObject(value: ["fileName2": "help again", "title": "me", "description": "now"])
        store.addPhotoToStore(photo: p2)
        XCTAssertTrue(store.photos.count == 2)
    }

    func testStoredImages() {
        let p1 = PhotoObject(value: ["fileName": "help again", "title": "me", "description": "now"])
        store.addPhotoToStore(photo: p1)
        let first = store.photos.first!
        XCTAssertTrue(first.description == p1.description)
    }

    func testRemoveItemFromStore() {
        let p1 = PhotoObject(value: ["fileName": "help again", "title": "me", "description": "now"])
        store.addPhotoToStore(photo: p1)
        XCTAssertTrue(store.photos.count == 1)
        XCTAssertTrue(store.photos.contains(where: {
            $0.fileName == p1.fileName
        }))

        let p2 = PhotoObject(value: ["fileName2": "help again", "title": "me", "description": "now"])
        let p3 = PhotoObject(value: ["fileName3": "help again", "title": "me", "description": "now"])
        store.addPhotoToStore(photo: p2)
        store.addPhotoToStore(photo: p3)
        XCTAssertTrue(store.photos.count == 3)
        store.removePhotoFromStore(photo: p1)
        XCTAssertTrue(store.photos.count == 2)
        // p1 no longer exists hell ya
        XCTAssertFalse(store.photos.contains(p1))
    }

//
    func testSingleStore() {
        // add an image to the first store
        let p1 = PhotoObject(value: ["fileName": "help again", "title": "me", "description": "now"])
        store.addPhotoToStore(photo: p1)

        let store1 = PhotoStore.shared
        let store2 = PhotoStore.shared

        XCTAssertTrue(store1.photos.count == 1)
        XCTAssertTrue(store2.photos.count == 1)

    }
//
    func testClearCache() {
        let p1 = PhotoObject(value: ["fileName": "help again", "title": "me", "description": "now"])
        store.addPhotoToStore(photo: p1)
        XCTAssertTrue(store.photos.count == 1)

        // clear
        store.clearCache()

        XCTAssertTrue(store.photos.count == 0)

    }
    
}
