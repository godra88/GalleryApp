//
//  BaseDataService.swift
//  GalleryApp
//
//  Created by Ivan Fabri on 01/03/2023.
//

import Foundation

enum FetchError: Error {
    case invalidData
    case downloadDataError
    case downloadImageDataError
    case badUrl
}

public class BaseDataService {
    func requestAPI(url: URL, completion: @escaping (Data?, Error?) -> Void) {
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-type")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200,
                      let data = data else {
                    completion(nil, error)
                    return
                }
                completion(data, nil)
            }
        }.resume()
    }
}
