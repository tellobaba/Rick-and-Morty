//
//  Extensions.swift
//  Rick and Morty
//
//  Created by Oluwatomiwa on 06/02/2023.
//

import UIKit

extension UIView{
    func addSubviews(_ views: UIView...){
        views.forEach({
            addSubview($0)
        })
    }
}
