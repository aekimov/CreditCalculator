//
//  UITableViewCell+Extension.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 3/21/22.
//

import UIKit

extension UITableViewCell {

    func configure(text: String, detailText: String? = nil, imageName: String? = nil, cellType: CellType) {
        textLabel?.text = text
        detailTextLabel?.text = detailText
        
        textLabel?.font = .systemFont(ofSize: 16)
        detailTextLabel?.font = .systemFont(ofSize: 14)
        
        accessoryType = .disclosureIndicator

        if let imageName = imageName {
            imageView?.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        }
        
        switch cellType {
        
        case .detailCell:
            textLabel?.textColor = .gray
            detailTextLabel?.textColor = .gray
            preservesSuperviewLayoutMargins = false
            separatorInset = .init(top: 0, left: 12, bottom: 0, right: 12)
            layoutMargins = .zero
        case .settingsCell:
            textLabel?.textColor = .black
        }
    }
}
