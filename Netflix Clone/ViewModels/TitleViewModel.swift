//
//  TitleViewModel.swift
//  Netflix Clone
//
//  Created by oeng hokleng on 20/3/23.
//

import Foundation


struct TitleViewModel {
    
    let titleName: String
    let poster_path: String
    
    
    var poster_urlString: String {
        return "https://image.tmdb.org/t/p/w500\(poster_path)"
    }
}
