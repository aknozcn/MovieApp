//
//  APIRequest.swift
//  MovieApp
//
//  Created by Akin on 4.10.2022.
//

import Moya

enum APIRequest {
    case getMovie(page: Int)
    case getMovieDetail(movieId: Int)
    case getSimilarMovies(movieId: Int)
    case getSearchMovie(page: Int, query: String)
}

extension APIRequest: TargetType {

    var baseURL: URL {
        guard let url = Environment.apiURL else { fatalError() }
        return url
    }

    var path: String {
        switch self {
        case .getMovie:
            return "movie/upcoming"
        case .getMovieDetail(let movieId):
            return "movie/\(movieId)"
        case .getSimilarMovies(let movieId):
            return "movie/\(movieId)/similar"
        case .getSearchMovie:
            return "search/movie"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .getMovie(let page):
            let params = ["page": page, "api_key": Environment.apiKey] as [String: Any]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getMovieDetail:
            let params = ["api_key": Environment.apiKey] as [String: Any]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getSimilarMovies:
            let params = ["api_key": Environment.apiKey] as [String: Any]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getSearchMovie(let page, let query):
            let params = ["page": page, "query": query, "api_key": Environment.apiKey] as [String: Any]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
