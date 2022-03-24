//
//  SettingsCell.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 3/21/22.
//

import UIKit

class SettingsCell: UITableViewCell {
    static let identifier = "SettingsCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String) {

        textLabel?.text = text
        textLabel?.textColor = .black
        imageView?.image = UIImage(named: "list")?.withRenderingMode(.alwaysTemplate)
        accessoryType = .disclosureIndicator
    }
    
}


