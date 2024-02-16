//
//  ViewController.swift
//  iOS-Project
//
//  Created by MacBook on 2/13/24.
//  Copyright © 2024 MacBook. All rights reserved.
//

import UIKit
import SafariServices

// UI
// Network request
// tap a cell to see info about the movies
// custom cell

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, MovieTableViewCellDelgate {
    
    @IBOutlet var table: UITableView!
    @IBOutlet var field: UITextField!
    
    var thirdViewController: ThirdViewController?
    
    var movies = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(MovieTableViewCell.nib(), forCellReuseIdentifier: MovieTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        field.delegate = self
        
        if let thirdVC = storyboard?.instantiateViewController(withIdentifier: "ThirdViewController") as? ThirdViewController {
            thirdViewController = thirdVC
        }
        
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTapGesture.numberOfTapsRequired = 2
        table.addGestureRecognizer(doubleTapGesture)
    
    }
    @objc func doubleTapped(on indexPath: IndexPath) {
        
            let url = "https://www.imdb.com/title/\(movies[indexPath.row].imdbID)/"
            let vc = SFSafariViewController(url: URL(string: url)!)
            present(vc, animated: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchMovies()
        return true
    }
    
    func searchMovies() {
        field.resignFirstResponder()
        
        guard let text = field.text, !text.isEmpty else {
            return
        }
        
        let query = text.replacingOccurrences(of: " ", with: "%20")
        
        URLSession.shared.dataTask(with: URL(string: "https://www.omdbapi.com/?apikey=d1f47913&s=\(query)&type=movie")!,
                                   completionHandler: { data, response, error in
                                    
                                    guard let data = data, error == nil else {
                                        // Handle error
                                        print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                                        return
                                    }
                                    
                                    var result: MovieResult?
                                    do {
                                        result = try JSONDecoder().decode(MovieResult.self, from: data)
                                    } catch {
                                        // Handle JSON decoding error
                                        print("Error decoding JSON: \(error.localizedDescription)")
                                    }
                                    
                                    guard let finalResult = result else {
                                        // Show alert if there are no search results
                                        DispatchQueue.main.async {
                                            self.showNoResultsAlert()
                                        }
                                        return
                                    }
                                    
                                    self.movies.removeAll()
                                    
                                    let newMovies = finalResult.Search
                                    self.movies.append(contentsOf: newMovies)
                                    
                                    DispatchQueue.main.async {
                                        self.table.reloadData()
                                    }
                                    
        }).resume()
    }
    
    func showNoResultsAlert() {
        let alert = UIAlertController(title: "No Results", message: "Your search returned no results.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    func didTapLikeButton(for cell: MovieTableViewCell) {
        guard let indexPath = table.indexPath(for: cell) else {
            return
        }
        
        let likedMovie = movies[indexPath.row]
        thirdViewController?.addLikedMovie(likedMovie)
        
        
    }
    
    // Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        cell.delgate = self
        
        cell.configure(with: movies[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedMovie = movies[indexPath.row]
        
        self.tabBarController?.selectedIndex = 2
        
        if let tabBarController = self.tabBarController {
            for viewController in tabBarController.viewControllers ?? [] {
                if let navController = viewController as? UINavigationController,
                    let thirdVC = navController.topViewController as? ThirdViewController {
                    
                    thirdVC.addLikedMovie(selectedMovie)
                }
            }
        }
        
        doubleTapped(on: indexPath)
    }


}

struct MovieResult: Codable {
    let Search: [Movie]
}

struct Movie: Codable {
    let Title: String
    let Year: String
    let imdbID: String
    let _Type: String
    let Poster: String
    
    private enum CodingKeys: String, CodingKey {
        case Title, Year, imdbID, _Type = "Type", Poster
    }
}








