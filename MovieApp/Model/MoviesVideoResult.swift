//
//  MoviesVideoResult.swift
//  MovieApp
//
//  Created by sh3ll on 13.03.2021.
//

import Foundation

struct MoviesVideoResult: Codable {
    let id: Int
    let results: [MoviesVideoDetail]
}
