//
//  HeaderView.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 12/1/21.
//

import UIKit

class HeaderView: UICollectionReusableView {
    
    static let identifier = "HeaderCollectionReusableView"
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22)
        label.text = ""
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    func configure(for section: Int, years: [String]) {
        backgroundColor = .bgColor
        addSubview(label)
        label.centerAnchors(x: centerXAnchor, y: centerYAnchor)
        label.text = years[section]
    }
}
