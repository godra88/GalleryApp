//
//  DataFetching.swift
//  GalleryApp
//
//  Created by Ivan Fabri on 01/03/2023.
//

import Foundation
import UIKit

public protocol DataFetching {
    typealias GalleryResultBlock = ([Photo]?, Error?) -> Void
    typealias ImageResultBlock = (UIImage?, Error?) -> Void
    func fetchGallery(isFirstTimeLoad: Bool, completion: @escaping GalleryResultBlock)
    func fetchImage(urlString: String, completion: @escaping ImageResultBlock)
}
