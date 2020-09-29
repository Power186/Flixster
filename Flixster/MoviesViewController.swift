//
//  MoviesViewController.swift
//  Flixster
//
//  Created by Scott on 9/22/20.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var movies = [Movie]()
    
    @IBOutlet weak var moviesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        
        // Do any additional setup after loading the view.
        
        let DomainURL = "https://api.themoviedb.org/3/movie/now_playing?api_key=e440db23eb1672865e458926c722caff"

        func fetch() {
            let urlString = DomainURL
            
            if let url = URL.init(string: urlString) {
                let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    print(String.init(data: data!, encoding: .ascii) ?? "no data")
                    if let result = try? JSONDecoder().decode(Movies.self, from: data!) {
                        print(result.results)
                        
                        // Update movies array
                        let newMovies = result.results
                        self.movies.append(contentsOf: newMovies)
                        
                        // Reload data
                        DispatchQueue.main.async {
                            self.moviesTableView.reloadData()
                        }
                        
                    }
                })
                task.resume()
            }
        }

        fetch()
    }
    
    // Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let movie = movies[indexPath.row]
        let title = movie.title!
        let synopsis = movie.overview!
        
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie.poster_path!
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af.setImage(withURL: posterUrl!)
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Find the selected movie
        let cell = sender as! UITableViewCell
        let indexPath = moviesTableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        
        // Pass the selected movie to the details view controller
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
        
        moviesTableView.deselectRow(at: indexPath, animated: true)
    }
   
}

// MARK: - Model
struct Movies: Codable {
    var results: [Movie]
}

struct Movie: Codable {
    let title: String?
    let overview: String?
    let poster_path: String?
    let backdrop_path: String?
}
