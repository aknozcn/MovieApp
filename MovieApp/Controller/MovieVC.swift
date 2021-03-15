//
//  MovieVC.swift
//  MovieApp
//
//  Created by sh3ll on 1.03.2021.
//

import UIKit
import FFPopup
import youtube_ios_player_helper

class MovieVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var imageViewSlider: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet var viewMovieTrailer: UIView!
    @IBOutlet var playerView: YTPlayerView!

    var movieTitle: String?
    var movieImage: String?
    var movieOverview: String?
    var movieGenre: String?
    var movieVoteCount: Int?

    var movieIdForVideos = [Int]()
    var randomMovieId = [Int]()

    private var movieVideos = [(id: Int, name: String, key: String)]()


    private var moviesGenreResult: MoviesGenre?
    private var popularMoviesResult: MoviesResult?
    private var nowPlayingMoviesResult: MoviesResult?
    private var topRatedMoviesResult: MoviesResult?
    private var genresByMovies: [Int: String] = [:]


    override func viewDidLoad() {
        super.viewDidLoad()



        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")

        APIClient.getMoviesGenre { (genreResult) in
            self.moviesGenreResult = genreResult
        }

        APIClient.getMovies(of: .popular) { moviesResult in
            self.popularMoviesResult = moviesResult

            for movie in moviesResult.results {
                var genreNames: [String] = []

                for genreId in movie.genreIDS {
                    if let genre = self.moviesGenreResult?.genres.first(where: { (g) -> Bool in return g.id == genreId }) {
                        genreNames.append(genre.name)
                    }
                }
                self.movieIdForVideos.append(movie.id)
                self.genresByMovies[movie.id] = genreNames.joined(separator: ", ")
            }
        }

        /*APIClient.getMovies(of: .nowPlaying) { moviesResult in
            self.nowPlayingMoviesResult = moviesResult
        }*/
        randomMovieId.removeAll()
        while randomMovieId.count != 5 {
            let randomId = movieIdForVideos.randomElement()!
            if !randomMovieId.contains(randomId) {
                randomMovieId.append(randomId)
                print("random id: \(randomMovieId)")

            } else { Logger.LogIt("Already exits", LogType.warning) }
        }


        for index in 0..<randomMovieId.count {

            APIClient.getMoviesVideo(movieId: randomMovieId[index]) { videoResult in

                for video in videoResult.results {

                    if video.type == "Trailer" {
                        self.movieVideos.append((id: videoResult.id, name: video.name, key: video.key))
                        Logger.LogIt("video key: \(video.key)", LogType.succcess)
                    }

                }
            }
        }

        APIClient.getMovies(of: .topRated) { moviesResult in

            for movie in moviesResult.results {
                var genreNames: [String] = []

                for genreId in movie.genreIDS {
                    if let genre = self.moviesGenreResult?.genres.first(where: { (g) -> Bool in return g.id == genreId }) {
                        genreNames.append(genre.name)
                    }
                }

                self.genresByMovies[movie.id] = genreNames.joined(separator: ", ")
            }

            self.topRatedMoviesResult = moviesResult
        }


        for index in 0..<movieVideos.count {

            print("array test: \(movieVideos[index])")

        }

        for index in 0..<movieVideos.count {

            print("https://www.youtube.com/watch?v=\(movieVideos[index].key)")
        }

        tableView.delegate = self
        tableView.dataSource = self
        imageViewSlider.contentMode = .scaleToFill
        imageViewSlider.layer.cornerRadius = 15
        imageViewSlider.image = UIImage(named: "1")

        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            self.testTimer()
        }
    }



    func testTimer() {

        switch pageControl.currentPage {
        case 0:
            imageViewSlider.image = UIImage(named: "2")
            UIView.transition(with: imageViewSlider, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
            pageControl.currentPage += 1
        case 1:
            imageViewSlider.image = UIImage(named: "3")
            UIView.transition(with: imageViewSlider, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
            pageControl.currentPage += 1
        case 2:
            imageViewSlider.image = UIImage(named: "1")
            UIView.transition(with: imageViewSlider, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
            pageControl.currentPage = 0
        default:
            pageControl.currentPage = 0
        }
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {

        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! PopularMovieTableViewCell
            cell.cellDelegate = self
            cell.genresByMovies = self.genresByMovies
            cell.popularMoviesResult = self.popularMoviesResult
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! MovieTrailerTableViewCell
            cell.movieVideos = self.movieVideos
            cell.cellDelegate = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! TopRatedMovieTableViewCell
            cell.cellDelegate = self
            cell.genresByMovies = self.genresByMovies
            cell.topRatedMoviesResult = self.topRatedMoviesResult
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! PopularMovieTableViewCell
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch indexPath.section {
        case 0:
            return 250
        case 1:
            return 200
        case 2:
            return 250
        default:
            return 10
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        switch section {
        case 0:
            return "MOST POPULAR MOVIES"
        case 1:
            return "TRAILERS"
        case 2:
            return "TOP RATED"
        default:
            return "default"
        }
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.white
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.black
    }
}

extension MovieVC: DetailDataSending {

    func launchVC() {

        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SecondViewController") as! MovieDetailVC
        vc.movieTitle = self.movieTitle
        vc.movieImage = self.movieImage
        vc.movieGenre = self.movieGenre
        vc.movieOverview = self.movieOverview
        vc.movieVoteCount = self.movieVoteCount
        self.present(vc, animated: true, completion: nil)
    }
}


extension MovieVC: TrailerPopupShowing {

    func showPopup(videoId: String) {
        let popup = FFPopup(contetnView: self.viewMovieTrailer, showType: .bounceIn, dismissType: .shrinkOut, maskType: .dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
        let layout = FFPopupLayout(horizontal: .center, vertical: .center)
        popup.show(layout: layout)

        playerView.load(withVideoId: "\(videoId)")
    }

}
