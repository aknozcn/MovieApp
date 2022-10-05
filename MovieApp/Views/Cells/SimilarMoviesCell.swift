//
//  SimilarMoviesCell.swift
//  MovieApp
//
//  Created by Akin on 5.10.2022.
//

import UIKit
import Kingfisher

class SimilarMoviesCell: UICollectionViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    // MARK: - Initializers
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Methods
    func configure(movie: SimilarMovieDetail) {
        movieImageView.layer.cornerRadius = 8
        movieTitleLabel.text = movie.title
        let size = movieImageView.frame.size
        let resizeProcessor = ResizingImageProcessor(referenceSize: size, mode: .aspectFit)
        if let imagePath = movie.posterPath {
            let url = URL(string: Environment.imageURL + imagePath)
            movieImageView.kf.setImage(with: url, options: [.backgroundDecode, .processor(resizeProcessor), .scaleFactor(UIScreen.main.scale), .cacheOriginalImage])
        }
    }
}
