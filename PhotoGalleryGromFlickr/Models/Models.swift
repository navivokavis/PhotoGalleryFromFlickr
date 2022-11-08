//
//  Models.swift
//  FlickrPhotoGallery
//
//  Created by Navi Vokavis on 4.11.22.
//

import UIKit

class PhotosCollectionViewModel {
    var id: String
    var secret: String
    var server: String
    
    init(
        id: String,
        secret: String,
        server: String
    ) {
        self.id = id
        self.secret = secret
        self.server = server
    }
}

struct APIResponse: Codable {
    var photos: PageInfo
}

struct PageInfo: Codable {
    var photo : [PhotoInfo]
}

struct PhotoInfo: Codable {
    var id: String
    var secret: String
    var server: String
}

