//
//  ThirdTableViewCell.swift
//  MovieApp
//
//  Created by sh3ll on 1.03.2021.
//

import UIKit
import Kingfisher

class TopRatedMovieTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!

    var topRatedMoviesResult: MoviesResult?
    var moviesGenreResult: MoviesGenre?
    var genresByMovies: [Int: String] = [:]
    var cellDelegate: DetailDataSending? = nil


    override func awakeFromNib() {
        super.awakeFromNib()

        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return topRatedMoviesResult!.results.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        cellDelegate?.movieTitle = self.topRatedMoviesResult!.results[indexPath.row].title
        cellDelegate?.movieImage = String("https://image.tmdb.org/t/p/w500\(self.topRatedMoviesResult!.results[indexPath.row].posterPath)")
        cellDelegate?.movieOverview = self.topRatedMoviesResult?.results[indexPath.row].overview
        cellDelegate?.movieVoteCount = self.topRatedMoviesResult?.results[indexPath.row].voteCount
        self.cellDelegate?.movieGenre = self.genresByMovies[self.topRatedMoviesResult!.results[indexPath.row].id]
        
        perform(#selector(goToVC))
    }

    @IBAction func goToVC() {
        cellDelegate?.launchVC()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection3Cell", for: indexPath) as! TopRatedMovieCollectionViewCell
        let url = URL(string: "https://image.tmdb.org/t/p/w500/\(self.topRatedMoviesResult!.results[indexPath.row].posterPath)")
        cell.imageView.kf.setImage(with: url)
        cell.imageView.contentMode = .scaleToFill
        cell.imageView.layer.cornerRadius = 15
        cell.movieName.text = self.topRatedMoviesResult?.results[indexPath.row].title
        return cell
    }



}
