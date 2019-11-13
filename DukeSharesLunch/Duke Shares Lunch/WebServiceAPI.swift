//
//  WebServiceAPI.swift
//  Duke Shares Lunch
//
//  Created by Chris Theodore on 11/12/19.
//  Copyright © 2019 July Boys. All rights reserved.
//

import Foundation

class WebServiceAPI{
    
    
    
    public static let shared = WebServiceAPI()
    private init() {}
    private let urlSession = URLSession.shared
    private let baseURL = URL(string: "http://35.194.58.92/")!
    private let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidG9kb191c2VyIn0.IWnJCBgXAYfPGA-zB4JPlcAGfDYkwTwCTmQM-boguV8"
    private let jsonDecoder: JSONDecoder = {
       let jsonDecoder = JSONDecoder()
       jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "yyyy-mm-dd"
       jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
       return jsonDecoder
    }()
    // Enum Endpoint
    enum Endpoint: String, CaseIterable {
        
        case nowPlaying = "activerestaurants"
        case upcoming
        case popular
        case topRated = "top_rated"
    }
    
    public enum APIServiceError: Error {
        case apiError
        case invalidEndpoint
        case invalidResponse
        case noData
        case decodeError
    }
    
//    private func fetchResources<T: Decodable>(url: URL, completion: @escaping (Result<T, APIServiceError>) -> Void) {
//        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
//            completion(.failure(.invalidEndpoint))
//            return
//        }
//        let queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
//        urlComponents.queryItems = queryItems
//        guard let url = urlComponents.url else {
//            completion(.failure(.invalidEndpoint))
//            return
//        }
//
//        urlSession.dataTask(with: url) { (result) in
//            switch result {
//                case .success(let (response, data)):
//                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
//                        completion(.failure(.invalidResponse))
//                        return
//                    }
//                    do {
//                        let values = try self.jsonDecoder.decode(T.self, from: data)
//                        completion(.success(values))
//                    } catch {
//                        completion(.failure(.decodeError))
//                    }
//                case .failure(let error):
//                    completion(.failure(.apiError))
//                }
//         }.resume()
//    }
//    public func fetchMovies(from endpoint: Endpoint, result: @escaping (Result<MoviesResponse, APIServiceError>) -> Void) {
//        let movieURL = baseURL
//            .appendingPathComponent(endpoint.rawValue)
//        fetchResources(url: movieURL, completion: result)
//    }
//
//    public func fetchMovie(movieId: Int, result: @escaping (Result<Movie, APIServiceError>) -> Void) {
//
//        let movieURL = baseURL
//           .appendingPathComponent("movie")
//           .appendingPathComponent(String(movieId))
//        fetchResources(url: movieURL, completion: result)
//    }
//    public func getLocationSellers(result: @escaping (Result<Location, APIServiceError>) -> Void) {
//
//        let movieURL = baseURL
//           .appendingPathComponent("movie")
//           .appendingPathComponent(String(movieId))
//        fetchResources(url: movieURL, completion: result)
//    }
}
