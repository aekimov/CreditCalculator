//
//  DetailViewController.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 1/20/22.
//

import UIKit

enum CellType {
    case detailCell
    case settingsCell
}

protocol DetailViewControllerDelegate: AnyObject {
    func didTapDeleteButton(_ controller: DetailViewController)
    func didTapEditButton(_ controller: DetailViewController)
    func didTapShowScheduleButton(_ controller: DetailViewController, section: Int)
    func didTapAddPayment(_ controller: DetailViewController, section: Int)
    func didTapEditPayment(_ controller: DetailViewController, section: Int, selectedEarlyPayment: EarlyPaymentModel)
}

class DetailViewController: UIViewController {
    
    weak var delegate: DetailViewControllerDelegate?
    let viewModel: DetailViewModel
    private var isFirstInitiated: Bool
    private let identifier = "detailCell"
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        self.isFirstInitiated = true
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }

    func updateUI() {
        title = viewModel.titleString
        calculatedMonthlyPaymentLabel.text = viewModel.monthlyPaymentString
        totalAmountLabel.text = viewModel.totalString
        interestAmountLabel.text = viewModel.interestString
        endDateLabel.text = viewModel.endDateString
        
        rateLabel.text = viewModel.rateString
        remainderLabel.text = viewModel.remainderString
        progressBar.setProgress(viewModel.progressBarValue, animated: true)
        totalPaidLabel.text = viewModel.totalPaidString
        amountLabel.text = viewModel.amountString
        
        if !viewModel.updatedCredit.advancePayments.isEmpty {
            addAdvancePaymentButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            addAdvancePaymentButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        }
    }
    
    func callback(creditModel: CreditModel) {
        viewModel.callbackModel(creditModel: creditModel)
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFirstInitiated {
            isFirstInitiated = false
            viewModel.fetchData() // only on init update data from the VM without recalculating the calculator
        } else {
            viewModel.updateAndFetchData() //completely update the data on every viewWillAppear except the first time on init
        }
        updateUI()
        tableView.reloadData()
    }

    private let progressBar: UIProgressView = {
        let bar = UIProgressView()
        bar.progressTintColor = .myBlue
        return bar
    }()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let topContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let remainderLabel: UILabel = {
        let label = UILabel()
        label.text = "Balance"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let totalPaidLabel: UILabel = {
        let label = UILabel()
        label.text = "Paid"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.text = "Total amount"
        return label
    }()

    private let containerViewResults: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        return view
    }()

    private let monthlyPaymentLabel: UILabel = {
        let label = UILabel()
        label.text = Localized.monthlyPayment
        return label
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.text = Localized.totalLabel
        return label
    }()
    
    private let interestLabel: UILabel = {
        let label = UILabel()
        label.text = Localized.interest
        return label
    }()
    
    private let totalAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        return label
    }()
    
    private let interestAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        return label
    }()

    private let calculatedMonthlyPaymentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.textColor = .black
        label.text = "0"
        return label
    }()
    
    private let creditAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "Amount"
        return label
    }()

    private let rateLabel: UILabel = {
        let label = UILabel()
        label.text = "Rate, %"
        return label
    }()

    private let endDateDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = Localized.creditUntil
        return label
    }()
    
    private let endDateLabel: UILabel = {
        let label = UILabel()
        label.text = "12.12.2020"
        return label
    }()
    
    private let showPaymentScheduleButton: UIButton = {
        let button = UIButton(type: .system)
        let title = Localized.showPaymentSchedule
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(showPaymentsTableView), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.tintColor = .myBlue
        button.backgroundColor = .white
        return button
    }()
    
    @objc private func showPaymentsTableView() {
        delegate?.didTapShowScheduleButton(self, section: viewModel.section)
    }
    
    private let addAdvancePaymentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Localized.addAdvancePayment, for: .normal)
        button.addTarget(self, action: #selector(addAdvancePayment), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.tintColor = .white
        button.backgroundColor = .myBlue
        button.layer.cornerRadius = 10
        return button
    }()
    
    @objc private func addAdvancePayment() {
        delegate?.didTapAddPayment(self, section:  viewModel.section)
    }
    
    private let tableView: ContentSizedTableView = {
        let tableView = ContentSizedTableView()
        return tableView
    }()
    
    private func configureTableView() {
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 10
        tableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        tableView.clipsToBounds = true
        tableView.register(DetailCell.self, forCellReuseIdentifier: DetailCell.identifier)
        tableView.separatorStyle = .singleLine
        tableView.isScrollEnabled = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.reloadData()
    }
}

//MARK:- NavigationBar Button Actions

private extension DetailViewController {
    
    @objc func deleteCreditButton() {
        delegate?.didTapDeleteButton(self)
    }
    
    @objc func editCreditButton() {
        delegate?.didTapEditButton(self)
    }
}

//MARK:- UI Configuration

private extension DetailViewController {
    
    private func configureUI() {
        
        let image = UIImage(named: "edit")?.withRenderingMode(.alwaysTemplate)
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteCreditButton))
        let editButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(editCreditButton))
        navigationItem.rightBarButtonItems = [deleteButton, editButton]
        view.backgroundColor = .bgColor
        
        [creditAmountLabel, rateLabel, amountLabel, monthlyPaymentLabel, calculatedMonthlyPaymentLabel, totalLabel, totalAmountLabel, interestLabel, interestAmountLabel, endDateLabel, endDateDescriptionLabel].forEach {
            $0.font = .systemFont(ofSize: 16)
            $0.textColor = .gray
        }
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.centerAnchors(x: view.centerXAnchor, y: nil)
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 0)
        
        contentView.centerAnchors(x: scrollView.centerXAnchor, y: nil)

        contentView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 0)

        [topContainerView, addAdvancePaymentButton, containerViewResults, showPaymentScheduleButton, tableView].forEach {
            contentView.addSubview($0)
        }
        
        topContainerView.anchor(top: contentView.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        
        [rateLabel, remainderLabel, progressBar, totalPaidLabel, amountLabel].forEach { topContainerView.addSubview($0) }
                
        rateLabel.anchor(top: topContainerView.topAnchor, left: topContainerView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        remainderLabel.anchor(top: rateLabel.bottomAnchor, left: topContainerView.leftAnchor, bottom: nil, right: topContainerView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        progressBar.anchor(top: remainderLabel.bottomAnchor, left: topContainerView.leftAnchor, bottom: nil, right: topContainerView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
        
        totalPaidLabel.anchor(top: progressBar.bottomAnchor, left: topContainerView.leftAnchor, bottom: nil, right: topContainerView.rightAnchor, paddingTop: 12, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        amountLabel.anchor(top: totalPaidLabel.bottomAnchor, left: topContainerView.leftAnchor, bottom: topContainerView.bottomAnchor, right: topContainerView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        containerViewResults.anchor(top: amountLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        
        let resultsStack = UIStackView(type: .vertical, alignment: .fill, distribution: .fill, spacing: 10, paddings: .init(top: 16, left: 10, bottom: 10, right: 10))
        
        containerViewResults.addSubview(resultsStack)
        
        resultsStack.fillSuperview()
        
        let labels = [monthlyPaymentLabel, calculatedMonthlyPaymentLabel, totalLabel, totalAmountLabel, interestLabel, interestAmountLabel, endDateDescriptionLabel, endDateLabel]
        
        for index in stride(from: 0, to: labels.count, by: 2) {
            let sv = UIStackView(type: .horizontal, alignment: .fill, distribution: .equalSpacing, spacing: 0)
            [labels[index], labels[index + 1]].forEach { sv.addArrangedSubview($0) }
            resultsStack.addArrangedSubview(sv)
        }
        resultsStack.addArrangedSubview(showPaymentScheduleButton)
        
        addAdvancePaymentButton.anchor(top: containerViewResults.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 52)

        tableView.centerAnchors(x: view.centerXAnchor, y: nil)
        tableView.anchor(top: addAdvancePaymentButton.bottomAnchor, left: nil, bottom: scrollView.contentLayoutGuide.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 16, paddingRight: 0, width: view.frame.width - 48, height: 0)
    }
}

//MARK:- TableView's Delegates

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return viewModel.numberOfRows }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailCell.identifier, for: indexPath) as! DetailCell
        
        let earlyPaymentModel = viewModel.earlyPayments[indexPath.row]
        
        let amount = earlyPaymentModel.amount.asStringLocale.applyMask()
        let dateString = earlyPaymentModel.date.formatDate()

        let type = earlyPaymentModel.type ? Localized.reducePeriod : Localized.reducePayment
        
        cell.configure(text: dateString, detailText: "\(amount) • \(type)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let earlyPayment = viewModel.earlyPayments[indexPath.row]
        delegate?.didTapEditPayment(self, section: viewModel.section, selectedEarlyPayment: earlyPayment)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let earlyPayment = viewModel.earlyPayments[indexPath.row]
            viewModel.deleteEarlyPayment(earlyPayment: earlyPayment)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            updateUI()
        }
    }
}
