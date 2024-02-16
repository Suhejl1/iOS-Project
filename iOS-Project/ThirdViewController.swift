//
//  ThirdViewController.swift
//  iOS-Project
//
//  Created by MacBook on 2/15/24.
//  Copyright © 2024 MacBook. All rights reserved.
//

import UIKit
import SafariServices
import SQLite3

class ThirdViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var removeBtn: UIButton!
    
    var likedMovies = [Movie]() 
    
    weak var delegateViewController: ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieTableViewCell.nib(), forCellReuseIdentifier: MovieTableViewCell.identifier)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        
        let likedMovie = likedMovies[indexPath.row]
        cell.configure(with: likedMovie)
        
        return cell
    }
    
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
    
    @IBAction func removeButtonPressed(_ sender: UIButton) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            likedMovies.remove(at: selectedIndexPath.row)
            tableView.reloadData()
        }
    }
    

}

