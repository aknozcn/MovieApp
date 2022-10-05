//
//  Loading.swift
//  MovieApp
//
//  Created by Akin on 5.10.2022.
//

import UIKit

class Loading {
    
    public static let shared = Loading()
    
    private var containerView = UIView()
    private var loadingView = UIView()
    private var activityIndicator = UIActivityIndicatorView()
    
    func show(inView view: UIView) {
        containerView.frame = view.bounds
        containerView.backgroundColor = .white
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
        loadingView.center = containerView.center
        loadingView.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        activityIndicator.style = .large
        activityIndicator.center = CGPoint(x: loadingView.bounds.width / 2, y: loadingView.bounds.height / 2)
        loadingView.addSubview(activityIndicator)
        containerView.addSubview(loadingView)
        view.addSubview(containerView)
        activityIndicator.startAnimating()
    }
    
    func hide() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.containerView.removeFromSuperview()
        }
    }
}
