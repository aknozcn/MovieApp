//
//  SecondTableViewCell.swift
//  MovieApp
//
//  Created by sh3ll on 1.03.2021.
//

import UIKit
import Kingfisher

class MovieTrailerTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    

    var movieVideos = [(id: Int, name: String, key: String)]()

    var cellDelegate: TrailerPopupShowing? = nil

    override func awakeFromNib() {
        super.awakeFromNib()

        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieVideos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        

        cellDelegate?.showPopup(videoId: movieVideos[indexPath.row].key)
        
        print("test")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection2Cell", for: indexPath) as! MovieTrailerCollectionViewCell
        let url = URL(string: "https://img.youtube.com/vi/\(movieVideos[indexPath.row].key)/maxresdefault.jpg")
        cell.imageView.kf.setImage(with: url)
        cell.movieName.text =  movieVideos[indexPath.row].name
        cell.imageView.layer.cornerRadius = 15
        cell.imageView.contentMode = .scaleToFill
        return cell
    }
}
