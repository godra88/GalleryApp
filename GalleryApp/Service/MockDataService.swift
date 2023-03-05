//
//  MockDataService.swift
//  GalleryApp
//
//  Created by Ivan Fabri on 04/03/2023.
//

import Foundation
import UIKit

public class MockDataService: BaseDataService, DataFetching {
    public static let shared = MockDataService()
}

extension MockDataService {
    public func fetchGallery(isFirstTimeLoad: Bool, completion: @escaping GalleryResultBlock) {
        let data = [Photo(albumId: 1, id: 1, title: "Title1", url: "", thumbnailUrl: "", image: nil),
                    Photo(albumId: 1, id: 2, title: "Title2", url: "", thumbnailUrl: "", image: nil),
                    Photo(albumId: 1, id: 3, title: "Title3", url: "", thumbnailUrl: "", image: nil),
                    Photo(albumId: 1, id: 4, title: "Title4", url: "", thumbnailUrl: "", image: nil),
                    Photo(albumId: 1, id: 5, title: "Title5", url: "", thumbnailUrl: "", image: nil),
                    Photo(albumId: 1, id: 6, title: "Title6", url: "", thumbnailUrl: "", image: nil),
                    Photo(albumId: 1, id: 7, title: "Title7", url: "", thumbnailUrl: "", image: nil),
        ]
        completion(data, nil)
    }
    
    public func fetchImage(urlString: String, completion: @escaping ImageResultBlock) {
        let image = UIImage(systemName: "photo")
        completion(image, nil)
    }
}
