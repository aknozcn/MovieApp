//
//  IMDBViewController.swift
//  MovieApp
//
//  Created by Akin on 5.10.2022.
//

import UIKit
import WebKit

class IMDBViewController: UIViewController, Storyboardable {

    //MARK: - IBOutlets
    @IBOutlet weak var webView: WKWebView!
    
    //MARK: - Variables
    var imdbUrl = ""
    
    // MARK: - Initializers
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    // MARK: - Setup
    private func setup(){
        webView.navigationDelegate = self
        webView.load(URLRequest(url: URL(string: imdbUrl)!))
    }
}

// MARK: - WKNavigationDelegate
extension IMDBViewController: WKNavigationDelegate {
  
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        Loading.shared.show(inView: view)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        Loading.shared.hide()
    }
}
