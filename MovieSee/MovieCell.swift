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
    
    func configureCell(movie:Movie) {
        imageView.image = movie.poster
        titleLabel.text = movie.title
        titleLabel.sizeToFit()
        layer.cornerRadius = 4
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 2, height: 4)
        layer.shadowRadius = 1
        layer.shadowPath = UIBezierPath(rect: contentView.bounds).cgPath
        layer.shadowColor = UIColor.black.cgColor
        layer.shouldRasterize = true
    }
    
}
