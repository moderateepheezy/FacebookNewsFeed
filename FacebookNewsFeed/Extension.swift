//
//  Extension.swift
//  FacebookNewsFeed
//
//  Created by SimpuMind on 11/2/16.
//  Copyright © 2016 SimpuMind. All rights reserved.
//

import UIKit


extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...){
        var viewsDictionary = [String: UIView]()
        for(index, view) in views.enumerated(){
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options:
            NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

extension UIColor{
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        return UIColor(red: red/225, green: green/225, blue: blue/225, alpha: 1)
    }
}
