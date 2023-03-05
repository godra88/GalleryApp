//
//  DataService.swift
//  GalleryApp
//
//  Created by Ivan Fabri on 01/03/2023.
//

import Foundation
import UIKit

public class DataService: BaseDataService, DataFetching {
    public static let shared = DataService()
    private var currentAlbum = 1
}

extension DataService {
    public func fetchGallery(isFirstTimeLoad: Bool, completion: @escaping GalleryResultBlock) {
        if isFirstTimeLoad {
            currentAlbum = 1
        } else {
            currentAlbum += 1
        }
        guard let dataUrl = URL(string: App.baseUrl + "/albums/\(currentAlbum)/photos") else {
            completion(nil, FetchError.badUrl)
            return }
        self.requestAPI(url: dataUrl) { data, error in
            guard let data = data else {
                completion(nil, FetchError.downloadDataError)
                return
            }
            self.parseGallery(data: data) { result, error in
                completion(result, error)
            }
        }
    }
    private func parseGallery(data: Data, completion: @escaping GalleryResultBlock) {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode([Photo]?.self, from: data)
            completion(result, nil)
        } catch {
            completion(nil, FetchError.invalidData)
        }
    }
    
    public func fetchImage(urlString: String, completion: @escaping ImageResultBlock) {
        guard let dataUrl = URL(string: urlString) else {
            completion(nil, FetchError.badUrl)
            return }
        self.requestAPI(url: dataUrl) { data, error in
            guard let data = data else {
                completion(nil, FetchError.downloadImageDataError)
                return
            }
            completion(UIImage(data: data), nil)
        }
    }
}
