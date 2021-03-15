//
//  ViewController.swift
//  MovieApp
//
//  Created by sh3ll on 1.03.2021.
//

import UIKit

class MoviesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var imageViewSlider: UIImageView!
    @IBOutlet weak var tableView: UITableView!

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
        }

        APIClient.getMovies(of: .nowPlaying) { moviesResult in
            self.nowPlayingMoviesResult = moviesResult
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

        tableView.delegate = self
        tableView.dataSource = self

        imageViewSlider.contentMode = .scaleToFill
        imageViewSlider.layer.cornerRadius = 15

        imageViewSlider.image = UIImage(named: "stranger")
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! TableViewCell
            cell.popularMoviesResult = self.popularMoviesResult
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! SecondTableViewCell

            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! ThirdTableViewCell
            cell.topRatedMoviesResult = self.topRatedMoviesResult

            cell.genresByMovies = self.genresByMovies
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! TableViewCell
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch indexPath.section {
        case 0:
            return 250
        case 1:
            return 180
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

