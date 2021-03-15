//
//  MoviesGenre.swift
//  MovieApp
//
//  Created by sh3ll on 5.03.2021.
//

import Foundation


struct MoviesGenre: Codable {
    let genres: [Genre]
}

struct Genre: Codable {
    let id: Int
    let name: String
}
