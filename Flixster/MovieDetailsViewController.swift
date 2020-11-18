//
//  MovieDetailsViewController.swift
//  Flixster
//
//  Created by Scott on 9/29/20.
//

import UIKit
import AlamofireImage

class MovieDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    var movie: Movie!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateView()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let trailerViewController = segue.destination as! TrailerViewController
        trailerViewController.movie = movie
    }
    
    // MARK: - Private Functions
    private func updateView() {
        titleLabel.text = movie.title
        titleLabel.sizeToFit()
        synopsisLabel.text = movie.overview
        synopsisLabel.sizeToFit()
        
        let baseUrl = "https://image.tmdb.org/t/p/w780"
        let posterPath = movie.poster_path!
        let posterUrl = URL(string: baseUrl + posterPath)
        posterView.af.setImage(withURL: posterUrl!)
        
        let backdropPath = movie.backdrop_path!
        let backdropUrl = URL(string: baseUrl + backdropPath)
        backdropView.af.setImage(withURL: backdropUrl!)
    }

}
