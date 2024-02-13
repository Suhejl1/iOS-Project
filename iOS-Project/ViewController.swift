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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        field.delegate = self
    
    }
    




}



