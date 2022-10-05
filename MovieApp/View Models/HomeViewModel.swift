//
//  HomeViewModel.swift
//  MovieApp
//
//  Created by Akin on 4.10.2022.
//

import UIKit

protocol HomeViewModelDelegate: AnyObject {
    func didFetchMovies()
}

class HomeViewModel {

    //MARK: - Variables
    private let apiManager: APIManager
    private var moviesResponse: [MoviesDetail]?
    private var searchMovieResponse: [MoviesDetail]?
    private var currentPage = 0
    private var totalPage = 0

    //MARK: - Delegate
    weak var delegate: HomeViewModelDelegate?

    // MARK: - Properties
    var moviesPage: Int {
        get {
            return currentPage
        }
        set {
            currentPage = newValue
        }
    }

    var getMovie: [MoviesDetail] {
        moviesResponse ?? []
    }

    var getSearchMovie: [MoviesDetail] {
        searchMovieResponse ?? []
    }

    var newMovieData: Bool {
        currentPage < totalPage
    }

    // MARK: - Initializers
    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }

    // MARK: - Methods
    func clearResponse() {
        moviesResponse?.removeAll()
        searchMovieResponse?.removeAll()
    }

    func setDefaultCurrentPage() {
        currentPage = 0
    }

    func getMovies() {

        let nextPage = currentPage + 1
        apiManager.getMovies(page: nextPage) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let movies):
                self.currentPage = movies.page
                self.totalPage = movies.totalPages
                if self.moviesResponse == nil {
                    self.moviesResponse = movies.results
                } else {
                    self.moviesResponse?.append(contentsOf: movies.results)
                }
                self.delegate?.didFetchMovies()
            case .failure(let error):
                print("HomeViewModel getMovies: \(error)")
            }
        }
    }

    func getSearchMovie(movieTitle: String) {
        
        apiManager.getSearchMovie(page: currentPage, query: movieTitle) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let movies):
                self.currentPage = movies.page
                self.totalPage = movies.totalPages
                if self.searchMovieResponse == nil {
                    self.searchMovieResponse = movies.results
                } else {
                    self.searchMovieResponse?.append(contentsOf: movies.results)
                }
                self.delegate?.didFetchMovies()
            case .failure(let error):
                print("HomeViewModel getMovies \(error)")
            }
            self.delegate?.didFetchMovies()
        }
    }
}
