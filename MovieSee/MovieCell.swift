//
//  MovieCell.swift
//  MovieSee
//
//  Created by Christopher Webb-Orenstein on 11/4/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    static let reuseIdentifier = "MovieCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func configureCell() {
        titleLabel.sizeToFit()
    }
}
