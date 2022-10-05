//
//  MoviesCell.swift
//  MovieApp
//
//  Created by Akin on 4.10.2022.
//

import UIKit
import Kingfisher

class MoviesCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieReleaseDateLabel: UILabel!
    
    // MARK: - Initializers
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Methods
    func configure(movie: MoviesDetail) {
        movieImageView.layer.cornerRadius = 12
        movieTitleLabel.text = movie.title
        movieReleaseDateLabel.text = movie.releaseDate
        let size = movieImageView.frame.size
        let resizeProcessor = ResizingImageProcessor(referenceSize: size, mode: .aspectFit)
        if let imagePath = movie.posterPath {
            let url = URL(string: Environment.imageURL + imagePath)
            movieImageView.kf.setImage(with: url, options: [.backgroundDecode, .processor(resizeProcessor), .scaleFactor(UIScreen.main.scale), .cacheOriginalImage])
        }
    }
}
