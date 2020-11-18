//
//  TrailerViewController.swift
//  Flixster
//
//  Created by Scott on 9/30/20.
//

import UIKit
import WebKit

class TrailerViewController: UIViewController, WKUIDelegate {
    
    // MARK: - Properties
    
    var webView: WKWebView!
    
    var movie: Movie!
    
    var trailers: [Video]!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchMovieTrailers()
    }
    
    // MARK: - Public Functions
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    // MARK: - Private API
    
    private func fetchMovieTrailers() {
        
        let selectedMovie = movie.id!
        let trailerURL = URL(string: "https://api.themoviedb.org/3/movie/\(selectedMovie)/videos?api_key=e440db23eb1672865e458926c722caff&language=en-US")
        
        if let url = trailerURL {
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                print(String.init(data: data!, encoding: .ascii) ?? "no data")
                if let result = try? JSONDecoder().decode(Videos.self, from: data!) {
                    print("RESULTS: \(result.results)")

                    // Get the key's value [Flixster.Video(key: Optional("value"))]
                    self.trailers = result.results
                    let key = self.trailers[0]
                    print("KEY: \(key)")
                    print("The KEY: \(key.key!)")
                    
                    // Set key's value to put in Url
                    let keys = key.key!
                    print("DEBUG key: \(keys)")
                    
                    // Set Url to YouTube
                    let myURL = URL(string: "https://www.youtube.com/watch?v=\(keys)")
                    print("URL: \(myURL!)")
                    let myRequest = URLRequest(url: myURL!)
                    
                    // load the Url to the webView
                    DispatchQueue.main.async {
                        self.webView.load(myRequest)
                    }
                }
            })
            task.resume()
        }
    }
    
    
}

// MARK: - MODEL

struct Videos: Codable {
    var results: [Video]
}

struct Video: Codable {
    var key: String?
}
