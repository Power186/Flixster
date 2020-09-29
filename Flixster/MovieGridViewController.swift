//
//  MovieGridViewController.swift
//  Flixster
//
//  Created by Scott on 9/29/20.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Configure collectionView layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2) / 3
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)

        let DomainURL = "https://api.themoviedb.org/3/movie/297762/similar?api_key=e440db23eb1672865e458926c722caff&language=en-US&page=1"

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
                        
                        print(self.movies)
                        
                        // Reload data
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                        
                    }
                })
                task.resume()
            }
        }

        fetch()
        
    }
    
    // CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        let movie = movies[indexPath.item]
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie.poster_path!
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af.setImage(withURL: posterUrl!)
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
