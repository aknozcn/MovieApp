//
//  ViewController.swift
//  MovieApp
//
//  Created by Akin on 4.10.2022.
//

import UIKit
import Lottie

enum AnimationType: String {
    case noConnectionNetwork = "no-connection-white"
    case noData = "no-data"
}

class HomeViewController: UIViewController, Storyboardable {

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: SearchTextField!
    @IBOutlet weak var searchTextClearImageView: UIImageView!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var noDataContainerView: UIView!

    //MARK: - Variables
    private let viewModel = HomeViewModel(apiManager: APIManager())
    private var searching = false
    private var searchMovieTitle = ""
    private var timer: Timer?
    private let network = NetworkConnection()
    private var noConnectionAnimationView: AnimationView!
    private var noDataAnimationView: AnimationView!

    // MARK: - Initializers
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    // MARK: - Setup
    private func setup() {

        let gesture = UITapGestureRecognizer(target: self, action: #selector(searchTextClear))
        searchTextClearImageView.isUserInteractionEnabled = true
        searchTextClearImageView.addGestureRecognizer(gesture)
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)),
            for: .editingChanged)
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        let nib = UINib(nibName: "MoviesCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "moviesCell")
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.delegate = self

        if network.isConnectedToNetwork() {
            Loading.shared.show(inView: view)
            viewModel.getMovies()
            noDataContainerView.isHidden = true
        } else {
            noDataAnimation(type: .noConnectionNetwork)
        }
    }

    // MARK: - Methods
    func noDataAnimation(type: AnimationType) {

        if type == .noConnectionNetwork {
            searchContainerView.isHidden = true
        }
        tableView.isHidden = true
        noDataContainerView.isHidden = false
        noDataAnimationView = .init(name: type.rawValue)
        noDataAnimationView.frame = noDataContainerView.frame
        noDataAnimationView.contentMode = .scaleAspectFit
        noDataAnimationView.loopMode = .loop
        noDataAnimationView.animationSpeed = 1.0
        noDataContainerView.addSubview(noDataAnimationView)
        noDataAnimationView.translatesAutoresizingMaskIntoConstraints = false
        noDataAnimationView.centerXAnchor.constraint(equalTo: noDataContainerView.centerXAnchor).isActive = true
        noDataAnimationView.centerYAnchor.constraint(equalTo: noDataContainerView.centerYAnchor).isActive = true
        noDataAnimationView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        noDataAnimationView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        noDataAnimationView.play()
    }

    private func dismissKeyboard() {
        self.view.endEditing(true)
    }

    @objc private func searchTextClear() {
        searching = false
        searchTextField.text = ""
        searchTextClearImageView.isHidden = true
        viewModel.clearResponse()
        viewModel.setDefaultCurrentPage()
        viewModel.getMovies()
        tableView.reloadData()
        removeNoDataView()
    }

    private func setTimer(searchText: String) {
        invalidateTimer()

        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { (timer) in
            self.viewModel.clearResponse()
            self.viewModel.getSearchMovie(movieTitle: searchText)
        })
    }

    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        let textFieldCount = textField.text?.count ?? 0
        if textFieldCount >= 3 {
            searching = true
            searchTextClearImageView.isHidden = false
            setTimer(searchText: textField.text ?? "")
            searchMovieTitle = textField.text ?? ""
        } else {
            searchTextClearImageView.isHidden = true
            searching = false
            viewModel.setDefaultCurrentPage()
            viewModel.getMovies()
            tableView.reloadData()
            removeNoDataView()
        }
    }

    private func removeNoDataView() {
        tableView.isHidden = false
        noDataContainerView.isHidden = true
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = MovieDetailViewController.instantiate(storyboardName: .movieDetail)
        if searching {
            vc.movieId = viewModel.getSearchMovie[indexPath.row].id
        } else {
            vc.movieId = viewModel.getMovie[indexPath.row].id
        }

        navigationController?.pushViewController(vc, animated: true)
        dismissKeyboard()
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if searching && indexPath.row == viewModel.getSearchMovie.count - 1 && viewModel.newMovieData {
            viewModel.moviesPage += 1
            viewModel.getSearchMovie(movieTitle: searchMovieTitle)
        } else if !searching && indexPath.row == viewModel.getMovie.count - 1 && viewModel.newMovieData {
            viewModel.getMovies()
        }
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let movieCount = searching ? viewModel.getSearchMovie.count : viewModel.getMovie.count
        movieCount == 0 ? noDataAnimation(type: .noData) : removeNoDataView()
        return movieCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "moviesCell", for: indexPath) as? MoviesCell else { return UITableViewCell() }
        if searching {
            let movie = viewModel.getSearchMovie[indexPath.row]
            cell.configure(movie: movie)
        } else {
            let movie = viewModel.getMovie[indexPath.row]
            cell.configure(movie: movie)
        }

        return cell
    }
}

// MARK: - HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
    func didFetchMovies() {
        tableView.reloadData()
        Loading.shared.hide()
    }
}
