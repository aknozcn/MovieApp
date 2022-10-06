//
//  FirebaseAnalyticsManager.swift
//  MovieApp
//
//  Created by Akin on 5.10.2022.
//

import FirebaseAnalytics

final class FirebaseAnalyticsManager {

    func logMovieDetail(movieDetail: MovieDetailResponse?) {
        if let movieDetail = movieDetail {
            Analytics.logEvent("MovieDetail", parameters: [
                "id": movieDetail.id,
                "title": movieDetail.title,
                "releaseDate": movieDetail.releaseDate,
                "imdbId": movieDetail.imdbId ?? "",
                "voteCount": movieDetail.voteCount,
                "voteAverage": movieDetail.voteAverage
                ])
        }
    }
}
