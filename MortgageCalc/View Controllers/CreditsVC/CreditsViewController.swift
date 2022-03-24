//
//  CreditsViewController.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 1/18/22.
//

import UIKit


protocol CreditsViewControllerDelegate: AnyObject {
    func didTapAddCreditButton(_ controller: CreditsViewController)
    func showCredit(_ controller: CreditsViewController, section: Int)
    func didTapSettingsButton(_ controller: CreditsViewController)
}

class CreditsViewController: UIViewController {
   
    weak var delegate: CreditsViewControllerDelegate?
    private(set) var viewModel: CreditsViewModel
    
    init(viewModel: CreditsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if viewModel.hasChanged {
            viewModel.fetchData()
            configureUI()
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
        configureNavBar()
    }
        
    private func configureNavBar() {
        title = Localized.credits
        let image = UIImage(named: "settings")?.withRenderingMode(.alwaysTemplate)
        let settingsButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(tapSettingsButton))
        navigationItem.rightBarButtonItems = [settingsButton]
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    private let addCreditButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Localized.addCredit, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.tintColor = .white
        button.backgroundColor = .myBlue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleAddCreditButton), for: .touchUpInside)
        return button
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let onboardingImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "placeholder")?.withRenderingMode(.alwaysOriginal)
        return view
    }()
    
    private let onboardingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.text = Localized.nothingAdded
        return label
    }()
    
    private let onboardingAddLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        label.text = Localized.addFirstCredit
        return label
    }()

    @objc private func handleAddCreditButton() {
        delegate?.didTapAddCreditButton(self)
        tableView.reloadData()
    }

    @objc private func tapSettingsButton() {
        delegate?.didTapSettingsButton(self)
    }

    private func configureTableView() {
        tableView.backgroundColor = .clear
        tableView.register(CreditTableViewCell.self, forCellReuseIdentifier: CreditTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    private func configureUI() {
                
        view.backgroundColor = .bgColor
        
        let scale = onboardingImage.intrinsicContentSize.height / onboardingImage.intrinsicContentSize.width

        if !viewModel.credits.isEmpty {
            
            [onboardingImage, onboardingLabel, onboardingAddLabel, containerView].forEach {
                $0.deactivateConstraints()
                $0.removeFromSuperview()
            }
            
            [tableView, addCreditButton].forEach {
                view.addSubview($0)
                $0.centerAnchors(x: view.centerXAnchor, y: nil)
            }
            
            tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: addCreditButton.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, width: 0, height: 0)
            
            addCreditButton.anchor(top: nil, left: tableView.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: tableView.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 44, paddingRight: 8, width: 0, height: 50)
        } else {
            [tableView].forEach {
                $0.deactivateConstraints()
                $0.removeFromSuperview()
            }
            
            view.addSubview(containerView)
            
            containerView.centerAnchors(x: view.centerXAnchor, y: view.centerYAnchor)
            containerView.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            
            [onboardingImage, onboardingLabel, onboardingAddLabel].forEach { containerView.addSubview($0) }
            
            onboardingImage.centerAnchors(x: view.centerXAnchor, y: nil)
            onboardingImage.anchor(top: containerView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 48, height: (view.frame.width - 48) * scale)
            onboardingLabel.anchor(top: onboardingImage.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
            onboardingAddLabel.anchor(top: onboardingLabel.bottomAnchor, left: view.leftAnchor, bottom: containerView.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
            
            view.addSubview(addCreditButton)

            addCreditButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 24, paddingBottom: 44, paddingRight: 24, width: 0, height: 50)
        }
    }
}

extension CreditsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { return viewModel.credits.count }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CreditTableViewCell.identifier, for: indexPath) as! CreditTableViewCell
        
        let model = viewModel.getModelForCell(indexPath.section)
        cell.configure(model: model)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.showCredit(self, section: indexPath.section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
}

