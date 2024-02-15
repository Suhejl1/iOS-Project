//
//  ThirdViewController.swift
//  iOS-Project
//
//  Created by MacBook on 2/15/24.
//  Copyright © 2024 MacBook. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var likedMovies = [Movie]() // Assuming you have a Movie model
    
    weak var delegateViewController: ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieTableViewCell.nib(), forCellReuseIdentifier: MovieTableViewCell.identifier)
        
        // Additional setup code for your tableView, if needed
        // ...
    }
    
    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        
        // Configure the cell with liked movie data
        let likedMovie = likedMovies[indexPath.row]
        cell.configure(with: likedMovie)
        // Set the movie image using your UIImageView in the LikedMoviesTableViewCell
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    // Implement UITableViewDelegate methods if needed
    
    // ...
    
    // MARK: - Custom Method to Add Liked Movie
    
    func addLikedMovie(_ likedMovie: Movie) {
        likedMovies.append(likedMovie)
        
        guard let tableView = tableView else {
            print("ErrorL tblView")
            return
        }
        
        if isViewLoaded && (view.window != nil) {
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
        
    }
    

}

