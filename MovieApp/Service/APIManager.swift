//
//  APIManager.swift
//  MovieApp
//
//  Created by Akin on 4.10.2022.
//

import Moya

class APIManager {

    var provider = MoyaProvider<APIRequest>(plugins: [NetworkLoggerPlugin()])

    func getMovies(page: Int, completion: @escaping (Result<MoviesResponse, Error>) -> ()) {
        request(target: .getMovie(page: page), completion: completion)
    }
    func getMovieDetail(movieId: Int, completion: @escaping (Result<MovieDetailResponse, Error>) -> ()) {
        request(target: .getMovieDetail(movieId: movieId), completion: completion)
    }
    func getSimilarMovies(movieId: Int, completion: @escaping (Result<SimilarMoviesResponse, Error>) -> ()) {
        request(target: .getSimilarMovies(movieId: movieId), completion: completion)
    }
    func getSearchMovie(page: Int, query: String, completion: @escaping (Result<MoviesResponse, Error>) -> ()) {
        request(target: .getSearchMovie(page: page, query: query), completion: completion)
    }

    private func request<T: Decodable>(target: APIRequest, completion: @escaping(Result<T, Error>) -> ()) {

        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
