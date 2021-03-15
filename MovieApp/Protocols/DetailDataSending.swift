//
//  DataSending.swift
//  MovieApp
//
//  Created by sh3ll on 12.03.2021.
//

import Foundation

protocol DetailDataSending  {
    
    var movieTitle: String? { get set}
    var movieImage: String? { get set }
    var movieOverview: String? {get set}
    var movieGenre: String? {get set}
    var movieVoteCount: Int? {get set}
    
    func launchVC()
}

