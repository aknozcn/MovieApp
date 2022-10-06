//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Akin on 4.10.2022.
//

import UIKit
import Kingfisher

class MovieDetailViewController: UIViewController, Storyboardable {

    //MARK: - IBOutlets
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieDescriptionTextView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!

    //MARK: - Variables
    private let viewModel = MovieDetailViewModel(apiManager: APIManager())
    var movieId = 0

    // MARK: - Initializers
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    // MARK: - Setup
    private func setup() {
        let nib = UINib(nibName: "SimilarMoviesCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "similarCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        viewModel.delegate = self
        Loading.shared.show(inView: view)
        viewModel.getMovieDetail(movieId: movieId)
        viewModel.getSimilarMovies(movieId: movieId)
    }

    // MARK: - Actions
    @IBAction func imdbPageButtonClicked(_ sender: UIButton) {

        let url = Environment.imdbURL + (viewModel.movieDetail?.imdbId ?? "")
        let vc = IMDBViewController.instantiate(storyboardName: .imdbScreen)
        vc.imdbUrl = url
        navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - UICollectionViewDelegate
extension MovieDetailViewController: UICollectionViewDelegate { }

// MARK: - UICollectionViewDataSource
extension MovieDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        viewModel.similarMovies.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "similarCell", for: indexPath) as? SimilarMoviesCell else { return UICollectionViewCell() }
        let movie = viewModel.similarMovies[indexPath.row]
        cell.configure(movie: movie)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        CGSize(width: 140, height: 135)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let cellWidth: CGFloat = 140.0
        let numberOfCells = floor(collectionView.frame.size.width / cellWidth)
        let edgeInsets = (collectionView.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)

        return UIEdgeInsets(top: 15, left: edgeInsets, bottom: 0, right: edgeInsets)
    }
}

// MARK: - MovieDetailViewModelDelegate
extension MovieDetailViewController: MovieDetailViewModelDelegate {

    func didFetched() {
        movieTitleLabel.text = viewModel.movieDetail?.title
        movieDescriptionTextView.text = viewModel.movieDetail?.overview ?? ""
        movieImageView.layer.cornerRadius = 8
        movieImageView.kf.setImage(with: URL(string: Environment.imageURL + (viewModel.movieDetail?.backdropPath ?? "")))
        Loading.shared.hide()

        FirebaseAnalyticsManager.init().logMovieDetail(movieDetail: viewModel.movieDetail)
    }

    func didFetchedSimilarMovies() {
        collectionView.reloadData()
    }
}
