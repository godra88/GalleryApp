//
//  Photo.swift
//  GalleryApp
//
//  Created by Ivan Fabri on 02/03/2023.
//

import Foundation
import UIKit

public class Photo: Codable {
    public let albumId: Int?
    public let id: Int?
    public let title: String?
    public let url: String?
    public let thumbnailUrl: String?
    public let image: Data?
    
    init(albumId: Int?, id: Int?, title: String?, url: String?, thumbnailUrl: String?, image: UIImage?) {
        self.albumId = albumId
        self.id = id
        self.title = title
        self.url = url
        self.thumbnailUrl = thumbnailUrl
        self.image = image?.pngData()
    }
}
