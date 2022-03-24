//
//  CreditTableViewCell.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 1/18/22.
//

import UIKit

class CreditTableViewCell: UITableViewCell {
    
    static var identifier = "CreditTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layer.cornerRadius = 16
        backgroundColor = .white
        clipsToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "title"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let remainderLabel: UILabel = {
        let label = UILabel()
        label.text = "100000"
        return label
    }()
    
    private let periodLabel: UILabel = {
        let label = UILabel()
        label.text = "12"
        return label
    }()
    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.text = "5"
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "11.11.2011"
        return label
    }()
    
    private let progressBar: UIProgressView = {
        let bar = UIProgressView()
        return bar
    }()
    
    private let progressStartLabel: UILabel = {
        let label = UILabel()
        label.text = Localized.paid
        return label
    }()
    
    private let progressEndLabel: UILabel = {
        let label = UILabel()
        label.text = Localized.balance
        return label
    }()
    
    private let totalPaidLabel: UILabel = {
        let label = UILabel()
        label.text = "100000"
        return label
    }()

    private let creditIcon: UIImageView = {
        let image = UIImage(named: "percent")?.withRenderingMode(.alwaysTemplate)
        let view = UIImageView(image: image)
        view.tintColor = .systemGreen
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        return view
    }()
}

extension CreditTableViewCell {
    
    func configure(model: CreditCellModel) {
        
        titleLabel.text = model.title

        let paymentString = Localized.paymentOn
        dateLabel.text = "\(paymentString) \(model.nextPaymentDate) • \(model.monthlyPayment)"
        totalPaidLabel.text = model.totalPaid
        remainderLabel.text = model.remainder
        progressBar.setProgress(model.progressValue, animated: false)
        
                
        [remainderLabel, totalPaidLabel, dateLabel, progressStartLabel, progressEndLabel].forEach {
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.textColor = .gray
            addSubview($0)
        }
        
        [progressBar, titleLabel, creditIcon].forEach { addSubview($0) }
        
        creditIcon.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 48, height: 48)
        
        titleLabel.anchor(top: creditIcon.topAnchor, left: creditIcon.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        dateLabel.anchor(top: nil, left: creditIcon.rightAnchor, bottom: creditIcon.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        totalPaidLabel.anchor(top: creditIcon.bottomAnchor, left: creditIcon.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        remainderLabel.anchor(top: creditIcon.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
        progressBar.anchor(top: totalPaidLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)

        progressStartLabel.anchor(top: progressBar.bottomAnchor, left: progressBar.leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 4, paddingLeft: 0, paddingBottom: 12, paddingRight: 0, width: 0, height: 0)

        progressEndLabel.anchor(top: progressBar.bottomAnchor, left: nil, bottom: bottomAnchor, right: progressBar.rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 12, paddingRight: 0, width: 0, height: 0)
    }
}
