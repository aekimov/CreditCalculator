//
//  DetailCell.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 3/4/22.
//

import UIKit

class DetailCell: UITableViewCell {
    static let identifier = "TableCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String, detailText: String) {

        textLabel?.font = .systemFont(ofSize: 16)
        textLabel?.textColor = .gray
        detailTextLabel?.font = .systemFont(ofSize: 14)
        detailTextLabel?.textColor = .gray
        
        textLabel?.text = text
        detailTextLabel?.text = detailText
        accessoryType = .disclosureIndicator
        preservesSuperviewLayoutMargins = false
        separatorInset = .init(top: 0, left: 12, bottom: 0, right: 12)
        layoutMargins = .zero
    }
    
}

