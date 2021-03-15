//
//  MovieDetailVC.swift
//  MovieApp
//
//  Created by sh3ll on 7.03.2021.
//

import UIKit


class MovieDetailVC: UIViewController {
    
    var movieTitle: String?
    var movieImage: String?
    var movieGenre: String?
    var movieOverview: String?
    var movieVoteCount: Int?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelMovieTitle: UILabel!
    @IBOutlet weak var labelMovieGenre: UILabel!
    @IBOutlet weak var textViewOverview: UITextView!
    @IBOutlet weak var labelMovieVoteCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelMovieTitle.text = movieTitle
        labelMovieGenre.text = movieGenre
        textViewOverview.text = movieOverview
        labelMovieVoteCount.text = "⭐️ \(movieVoteCount!) Vote"

        if let data = URL(string: movieImage!) {
            imageView.kf.setImage(with: data)
        }

    }
}
