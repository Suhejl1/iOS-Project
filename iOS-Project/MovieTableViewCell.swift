//
//  MovieTableViewCell.swift
//  iOS-Project
//
//  Created by MacBook on 2/13/24.
//  Copyright © 2024 MacBook. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var movieYearLabel: UILabel!
    @IBOutlet var moviePosterImageView: UIImageView!
    @IBOutlet var likeMovie: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    weak var delgate: MovieTableViewCellDelgate?
    
    static let identifier = "MovieTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MovieTableViewCell", bundle: nil)
    }
    
    func configure(with model: Movie) {
        self.movieTitleLabel.text = model.Title
        self.movieYearLabel.text = model.Year
        let url = model.Poster
        if let data = try? Data(contentsOf: URL(string: url)!) {
                self.moviePosterImageView.image = UIImage(data: data)
        }
    }
    
    @IBAction func likeButtonPressed(_ sender: UIButton){
        delgate?.didTapLikeButton(for: self)
    }
    
    
}

protocol MovieTableViewCellDelgate: AnyObject {
    func didTapLikeButton(for cell: MovieTableViewCell)
}
