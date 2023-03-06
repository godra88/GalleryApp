//
//  GalleryControllerTests.swift
//  GalleryAppTests
//
//  Created by Ivan Fabri on 04/03/2023.
//

import XCTest
@testable import GalleryApp

final class GalleryControllerTests: XCTestCase {
    var galleryController: GalleryViewController?
    
    override func setUp() {
        galleryController = GalleryViewController(dataService: MockDataService.shared)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPhotoCount() async throws {
        await galleryController?.fetchData(isFirstTimeLoad: true)
        
        let photoCount = await galleryController?.photoCount
        XCTAssertEqual(photoCount, 7)
    }
    
    func testAlbumCount() async throws {
        await galleryController?.fetchData(isFirstTimeLoad: true)
        
        let albumCount = await galleryController?.albums.count
        XCTAssertEqual(albumCount, 7)
    }
    
    func testFetchImageNotNill() async throws {
        await galleryController?.fetchData(isFirstTimeLoad: true)
        let imageData = await galleryController?.albums.first?.image
        XCTAssertNotNil(imageData)
    }
}
