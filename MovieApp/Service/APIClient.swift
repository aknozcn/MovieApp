//
//  APIClient.swift
//  MovieApp
//
//  Created by sh3ll on 3.03.2021.
//

import Foundation

fileprivate struct APIConstants {
    
    private static let baseURL = URL(string: "https://api.themoviedb.org/3")!
    private static let apiKey = "1df44ae9de2b132ba512603ea5eca8ca"

    static let baseURLComponentsWithKeys: URLComponents = {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)

        urlComponents?.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]

        return urlComponents!
    }()
}

class APIClient {
    
    static func getMovies(of type: MovieFilterPath, completion: @escaping (_ moviesResult: MoviesResult) -> Void) {
        var urlComponents = APIConstants.baseURLComponentsWithKeys
        urlComponents.path += "/movie/\(type.rawValue)"

        let sem = DispatchSemaphore.init(value: 0)

        guard let url = urlComponents.url else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            defer { sem.signal() }
            guard let data = data, error == nil else { return }

            do {
                let movie = try JSONDecoder().decode(MoviesResult.self, from: data)

                Logger.LogIt("Movie Count: \(movie.results.count)", LogType.succcess)

                completion(movie)
                
            } catch {
                Logger.LogIt("getMovies: \(error.localizedDescription)", LogType.error)
            }

        }
        task.resume()
        sem.wait()
    }

    static func getMoviesGenre(completion: @escaping(_ genreResult: MoviesGenre) -> Void) {

        var urlComponents = APIConstants.baseURLComponentsWithKeys
        urlComponents.path += "/genre/movie/list"

        let sem = DispatchSemaphore.init(value: 0)

        guard let url = urlComponents.url else { return }
        print("\(url)")
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            defer { sem.signal() }

            do {
                let genre = try JSONDecoder().decode(MoviesGenre.self, from: data!)

                Logger.LogIt("Genre Count: \(genre.genres.count)", LogType.succcess)
                completion(genre)
            }
            catch {
                
                Logger.LogIt("getMoviesGenre: \(error.localizedDescription)", LogType.error)
            }
        }

        task.resume()

        sem.wait()
    }
    
    static func getMoviesVideo(movieId: Int, completion: @escaping (_ videoResult: MoviesVideoResult) -> Void) {
        var urlComponents = APIConstants.baseURLComponentsWithKeys
        urlComponents.path += "/movie/\(movieId)/videos"

        let sem = DispatchSemaphore.init(value: 0)

        guard let url = urlComponents.url else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            defer { sem.signal() }
            guard let data = data, error == nil else { return }

            do {
                let video = try JSONDecoder().decode(MoviesVideoResult.self, from: data)

                Logger.LogIt("Movie Video Count: \(video.results.count)", LogType.succcess)

                completion(video)
                
            } catch {
                Logger.LogIt("getMoviesVideo: \(error.localizedDescription)", LogType.error)
            }

        }
        task.resume()
        sem.wait()
    }
}
