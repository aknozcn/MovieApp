//
//  Storyboardable.swift
//  MovieApp
//
//  Created by Akin on 4.10.2022.
//

import UIKit

enum StoryboardNameEnum: String {
    case home = "Main"
    case movieDetail = "MovieDetail"
    case imdbScreen = "IMDBScreen"
}

protocol Storyboardable {
    
    static var storyboardIdentifier: String { get }
    static func instantiate(storyboardName: StoryboardNameEnum) -> Self
}

extension Storyboardable {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
    
    static func instantiate(storyboardName: StoryboardNameEnum) -> Self {
        guard let viewController = UIStoryboard(name: storyboardName.rawValue, bundle: nil).instantiateViewController(withIdentifier: storyboardIdentifier) as? Self else {
            fatalError("storyboard identifier : \(storyboardIdentifier)")
        }
        return viewController
    }
}
