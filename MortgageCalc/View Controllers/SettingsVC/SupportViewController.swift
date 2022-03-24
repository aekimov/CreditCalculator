//
//  SupportViewController.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 3/21/22.
//

import UIKit

final class SupportViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private let addCreditButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .clear
        button.setBackgroundImage(UIImage(named: "telegram"), for: .normal)
        button.addTarget(self, action: #selector(handleLink), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleLink() {
        if let url = URL(string: "https://t.me/creditcalc") {
            UIApplication.shared.open(url)
        }
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .fillColor
        return view
    }()

    private let telegramLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Telegram"
        return label
    }()
    
    private let reportLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        label.text = Localized.reportText
        label.numberOfLines = 0
        return label
    }()

    private func configureUI() {
        navigationItem.title = Localized.support
        view.backgroundColor = .white
        
        let stackView = UIStackView(type: .vertical, alignment: .fill, distribution: .fill, spacing: 12, paddings: .init(top: 10, left: 10, bottom: 10, right: 10))
        view.addSubview(stackView)
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        
        [reportLabel, containerView, addCreditButton].forEach { stackView.addArrangedSubview($0) }
        
        let stack = UIStackView(type: .vertical, alignment: .center, distribution: .fill, spacing: 4, paddings: .init(top: 12, left: 8, bottom: 12, right: 8))
        
        containerView.addSubview(stack)
        stack.fillSuperview()
        
        [addCreditButton, telegramLabel].forEach { stack.addArrangedSubview($0) }
        addCreditButton.setSizeConstraints(width: 44, height: 44)
    }
}

