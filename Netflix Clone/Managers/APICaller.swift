//
//  APICaller.swift
//  Netflix Clone
//
//  Created by oeng hokleng on 17/3/23.
//

import Foundation

struct Constants {
    /// Movie API
    /// go to https://www.themoviedb.org/ and register for get api key
    /// Link: https://developers.themoviedb.org/3/getting-started/introduction for docs
    static let API_KEY = ""
    static let baseURL = "https://api.themoviedb.org"
    
    
    /// Youtube Api Ket
    /// go to https://console.cloud.google.com/ to get api key
    static let YoutubeAPI_KEY = ""
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3"
    
    enum APIError: Error {
        case failToFetchData
        case failToConvertData
    }
    
}

class APICaller {
    static let shared = APICaller()
    
    
    
    /// GET : Trending Movies
    /// - Parameter completion: call back
    public func getTrendingMovies(completion: @escaping (Result<[Title],Error>) -> Void) {
        let urlString = "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)"
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError.badURL as! Error))
            return
        }
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, _ , error in
            guard let data = data , error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(GetTitlesTrendingResponse.self, from: data)
                completion(.success(result.results))
            }
            catch {
                print("Error Fetch Data from api : \(error.localizedDescription)")
                
                completion(.failure(Constants.APIError.failToConvertData))
            }
            
        }
        task.resume()
    }
    
    /// GET : Trending TV
    /// - Parameter completion: call back
    public func getTrendingTVs(completion: @escaping (Result<[Title],Error>) -> Void) {
        let urlString = "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)"
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError.badURL as! Error))
            return
        }
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, _ , error in
            guard let data = data , error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(GetTitlesTrendingResponse.self, from: data)
                completion(.success(result.results))
            }
            catch {
                print("Error Fetch Data from api : \(error.localizedDescription)")
                
                completion(.failure(Constants.APIError.failToConvertData))
            }
            
        }
        task.resume()
    }
    
    /// GET : Up Coming Movies
    /// - Parameter completion: call back
    public func getUpComingMovies(completion: @escaping (Result<[Title],Error>) -> Void) {
        let urlString = "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)"
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError.badURL as! Error))
            return
        }
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, _ , error in
            guard let data = data , error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(GetTitlesTrendingResponse.self, from: data)
                completion(.success(result.results))
            }
            catch {
                print("Error Fetch Data from api : \(error.localizedDescription)")
                
                completion(.failure(Constants.APIError.failToConvertData))
            }
            
        }
        task.resume()
    }
    
    
    /// GET : Popular Movies
    /// - Parameter completion: call back
    public func getPopularMovies(completion: @escaping (Result<[Title],Error>) -> Void) {
        let urlString = "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)"
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError.badURL as! Error))
            return
        }
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, _ , error in
            guard let data = data , error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(GetTitlesTrendingResponse.self, from: data)
                completion(.success(result.results))
            }
            catch {
                print("Error Fetch Data from api : \(error.localizedDescription)")
                
                completion(.failure(Constants.APIError.failToConvertData))
            }
            
        }
        task.resume()
    }
    
    /// GET : Top Rate Movies
    /// - Parameter completion: call back
    public func getTopRateMovies(completion: @escaping (Result<[Title],Error>) -> Void) {
        let urlString = "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)"
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError.badURL as! Error))
            return
        }
        let request = URLRequest(url: url)
        
       
        
        let task = URLSession.shared.dataTask(with: request) { data, _ , error in
            guard let data = data , error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(GetTitlesTrendingResponse.self, from: data)
                completion(.success(result.results))
            }
            catch {
                print("Error Fetch Data from api : \(error.localizedDescription)")
                
                completion(.failure(Constants.APIError.failToConvertData))
            }
            
        }
        task.resume()
    }
    
    /// GET : Discover Movies
    /// - Parameter completion: call back
    public func getDiscoverMovies(completion: @escaping (Result<[Title],Error>) -> Void) {
         
        let urlString = "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate"
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError.badURL as! Error))
            return
        }
        let request = URLRequest(url: url)
        
       
        
        let task = URLSession.shared.dataTask(with: request) { data, _ , error in
            guard let data = data , error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(GetTitlesTrendingResponse.self, from: data)
                completion(.success(result.results))
            }
            catch {
                print("Error Fetch Data from api : \(error.localizedDescription)")
                
                completion(.failure(Constants.APIError.failToConvertData))
            }
            
        }
        task.resume()
        
    }
    
    func search(with query: String, completion: @escaping (Result<[Title],Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return 
        }
        
        let urlString = "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)"
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError.badURL as! Error))
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _ , error in
            guard let data = data , error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(GetTitlesTrendingResponse.self, from: data)
                completion(.success(result.results))
            }
            catch {
                print("Error Fetch Data from api : \(error.localizedDescription)")
                
                completion(.failure(Constants.APIError.failToConvertData))
            }
            
        }
        task.resume()
        
    }
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement,Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        let urlString = "\(Constants.YoutubeBaseURL)/search?q=\(query)&key=\(Constants.YoutubeAPI_KEY)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError.badURL as! Error))
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _ , error in
            guard let data = data , error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                completion(.success(result.items[0]))
            }
            catch {
                print("Error Fetch Data from api : \(error.localizedDescription)")
                
                completion(.failure(Constants.APIError.failToConvertData))
            }
            
        }
        task.resume()
        
    }
    
    
    
    
}
