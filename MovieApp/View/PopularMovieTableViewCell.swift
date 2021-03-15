//
//  TableViewCell.swift
//  MovieApp
//
//  Created by sh3ll on 28.02.2021.
//

import UIKit
import Kingfisher

class PopularMovieTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var genresByMovies: [Int: String] = [:]
    var popularMoviesResult: MoviesResult?
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
        return popularMoviesResult!.results.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        cellDelegate?.movieTitle = self.popularMoviesResult!.results[indexPath.row].title
        cellDelegate?.movieImage = String("https://image.tmdb.org/t/p/w500\(self.popularMoviesResult!.results[indexPath.row].posterPath)")
        cellDelegate?.movieOverview = self.popularMoviesResult?.results[indexPath.row].overview
        cellDelegate?.movieVoteCount = self.popularMoviesResult?.results[indexPath.row].voteCount
        self.cellDelegate?.movieGenre = self.genresByMovies[self.popularMoviesResult!.results[indexPath.row].id]
        
        perform(#selector(goToVC))
    }

    @IBAction func goToVC() {
        cellDelegate?.launchVC()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection1Cell", for: indexPath) as! PopularMovieCollectionViewCell
        DispatchQueue.main.async {
            let url = URL(string: "https://image.tmdb.org/t/p/w500/\(self.popularMoviesResult!.results[indexPath.row].posterPath)")
            cell.imageView.kf.setImage(with: url)
            cell.imageView.contentMode = .scaleToFill
            cell.imageView.layer.cornerRadius = 15
            cell.labelMovieTitle.text = self.popularMoviesResult!.results[indexPath.row].title
            cell.labelMovieVoteAverage.text = String(self.popularMoviesResult!.results[indexPath.row].voteAverage)
        }
        
        return cell
    }
}
