//
//  APICaller.swift
//  FlickrPhotoGallery
//
//  Created by Navi Vokavis on 4.11.22.
//

import Foundation

class APICaller {
        //prepair for reuese loader
    func request(completion: @escaping (Result<APIResponse, Error>) -> Void) {
        guard let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.interestingness.getList&api_key=\(apiKey)&per_page=10000&format=json&nojsoncallback=1") else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("ERROR : \(error)")
                    completion(.failure(error))
                }
                guard let data = data else { return }
                print("DATA: \(data)")
                
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("RESULT : \(result)")
                    completion(.success(result))
                } catch {
                    print("ERROR : \(error)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    
    
    func searchByWord(string: String, completion: @escaping (Result<APIResponse, Error>) -> Void) {
        guard let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&per_page=10000&text=\(string)&sort=popular&format=json&nojsoncallback=1") else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("ERROR : \(error)")
                    completion(.failure(error))
                }
                guard let data = data else { return }
                print("DATA: \(data)")
                
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("RESULT : \(result)")
                    completion(.success(result))
                } catch {
                    print("ERROR : \(error)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    
}

