//
//  ViewController.swift
//  iOS-Project
//
//  Created by MacBook on 2/13/24.
//  Copyright © 2024 MacBook. All rights reserved.
//

import UIKit

// UI
// Network request
// tap a cell to see info about the movies
// custom cell

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    @IBOutlet var field: UITextField!
    
    var movies = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        field.delegate = self
    
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
        
        URLSession.shared.dataTask(with: URL(string: "https://www.omdbapi.com/?apikey=d1f47913&s=fast%20and&type=movie")!,
                                   completionHandler: {data, response, error in
                   
                                    guard let data = data, error == nil else {
                                        return
                                    }
                                    
                                    //Convert - using codable
                                    
                                    //Update movies array
                                    
                                    //Refresh our tables
                                    
        }).resume()
        
    }
    
    // Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Show movie details
    }

}


struct Movie {
    
}








