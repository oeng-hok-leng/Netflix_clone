//
//  YoutubeSearchResponse.swift
//  Netflix Clone
//
//  Created by oeng hokleng on 21/3/23.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
    
    struct IdVideoElement: Codable {
        let kind: String
        let videoId: String
    }
}

