//
//  GetMoviesTrendingResponse.swift
//  Netflix Clone
//
//  Created by oeng hokleng on 17/3/23.
//

import Foundation

struct GetTitlesTrendingResponse: Codable {
    let results: [Title]
}

struct Title: Codable {
    let id: Int
    let media_type: String?
    let original_title: String?
    let overview : String
    let poster_path: String?
    let popularity: Double
    let release_date: String?
    let vote_count: Int
    let vote_average: Double
}
