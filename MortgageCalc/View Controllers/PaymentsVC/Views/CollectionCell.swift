//
//  CollectionCell.swift
//  BankApp
//
//  Created by Artem Ekimov on 11/29/21.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    
    static let identifier = "CollectionCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor =  .white //.orange.withAlphaComponent(0.2)
        addSubview(label)
        label.fillSuperview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.textColor = .black
        label.text = "12345"
        label.textAlignment = .center
        label.sizeToFit()
        label.numberOfLines = 0
        return label
    }()
    
    func configure(text: String) {
        label.text = text
    }
}

