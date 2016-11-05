//
//  UIView+Extension.swift
//  MovieSee
//
//  Created by Christopher Webb-Orenstein on 11/4/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

struct Padding {
    let top: CGFloat
    let bottom: CGFloat
    let leading: CGFloat
    let trailing: CGFloat
}

extension UIView {
    
    func constrainEdges(to view: UIView) {
        leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func constrainEdges(to view: UIView, padding: Padding) {
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding.leading).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor, constant: -padding.trailing).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: padding.top).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding.bottom).isActive = true
    }
}
