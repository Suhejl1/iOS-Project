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
    
    }
    
    // Field
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
                                   completionHandler: {data, response, error in
                   
                                    guard let data = data, error == nil else {
                                        return
                                    }
                                    
                                    //Convert - using codable
                                    var result: MovieResult?
                                    do {
                                        result = try JSONDecoder().decode(MovieResult.self, from: data)
                                    }
                                    catch {
                                        
                                    }
                                    
                                    guard let finalResult = result else {
                                        return
                                    }
                                    
                                    //print("\(finalResult.Search.first?.Title)")
                                    
                                    self.movies.removeAll()
                                    
                                    //Update movies array
                                    let newMovies = finalResult.Search
                                    self.movies.append(contentsOf: newMovies)
                                    
                                    //Refresh our tables
                                    DispatchQueue.main.async {
                                        self.table.reloadData()
                                    }
                                    
        }).resume()
        
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
        
        // Get the selected movie
        let selectedMovie = movies[indexPath.row]
        
        // Assuming the index of the third tab is 2
        self.tabBarController?.selectedIndex = 2
        
        // Get the reference to the tabBarController
        if let tabBarController = self.tabBarController {
            // Loop through the view controllers to find ThirdViewController
            for viewController in tabBarController.viewControllers ?? [] {
                if let navController = viewController as? UINavigationController,
                    let thirdVC = navController.topViewController as? ThirdViewController {
                    
                    // Add the selected movie to the liked movies list in ThirdViewController
                    thirdVC.addLikedMovie(selectedMovie)
                }
            }
        }
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








