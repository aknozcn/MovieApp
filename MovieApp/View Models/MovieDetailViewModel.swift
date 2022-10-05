//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by Akin on 5.10.2022.
//

import UIKit

protocol MovieDetailViewModelDelegate: AnyObject {
    func didFetched()
    func didFetchedSimilarMovies()
}

class MovieDetailViewModel {

    //MARK: - Variables
    private let apiManager: APIManager
    private var movieDetailResponse: MovieDetailResponse?
    private var similarMoviesResponse: [SimilarMovieDetail]?
    
    //MARK: - Delegate
    weak var delegate: MovieDetailViewModelDelegate?

    // MARK: - Properties
    var movieDetail: MovieDetailResponse? {
         movieDetailResponse
    }
    
    var similarMovies: [SimilarMovieDetail] {
         similarMoviesResponse ?? []
    }

    // MARK: - Initializers
    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }

    // MARK: - Methods
    func getMovieDetail(movieId: Int) {
        apiManager.getMovieDetail(movieId: movieId) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                self.movieDetailResponse = result
                self.delegate?.didFetched()
            case .failure(let error):
                print("MovieDetailViewModel getMovieDetail \(error)")
            }
        }
    }

    func getSimilarMovies(movieId: Int) {
        apiManager.getSimilarMovies(movieId: movieId) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                self.similarMoviesResponse = result.results
                self.delegate?.didFetchedSimilarMovies()
            case .failure(let error):
                print("MovieDetailViewModel getSimilarMovies \(error)")
            }
        }
    }
}
