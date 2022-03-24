//
//  AdvancePaymentsViewController.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 12/18/21.
//

import UIKit

enum PaymentType {
    case decreasePeriod
    case decreasePayment
}

enum OverpaymentGoal { //целевой тип предварительного платежа, либо для оценки превариательного платежа, либо с занесением в таблицу
    case completedPayment
    case preliminaryPayment
}

protocol AddPaymentViewControllerDelegate: AnyObject {
    func AddPaymentDidTapButton(_ controller: AddPaymentViewController)
}

class AddPaymentViewController: UIViewController {
   
    weak var delegate: AddPaymentViewControllerDelegate?
    private(set) var viewModel: AddPaymentViewModel
    
    init(viewModel: AddPaymentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        updateUI()
    }

    private func updateUI() {
        datePicker.date = viewModel.dateDouble.toDate
        dateTextField.text = viewModel.dateString
        amountTextField.text = viewModel.amountString
        segmentedControl.selectedSegmentIndex = viewModel.selectedSegment
        descriptionLabel.attributedText = viewModel.description
        
        if viewModel.isFormValid {
            self.addAdvancePaymentButton.isEnabled = true
            self.addAdvancePaymentButton.backgroundColor = .myBlue
        } else {
            self.addAdvancePaymentButton.isEnabled = false
            self.addAdvancePaymentButton.backgroundColor = .myBlue.withAlphaComponent(0.5)
        }
    }
    
    private let amountTextField: UITextField = {
        let tf = UITextField()
        tf.keyboardType = .numberPad
        tf.placeholder = "0"
        tf.addTarget(self, action: #selector(amountChanged(_:)), for: .editingChanged)
        return tf
    }()

    private let addAdvancePaymentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Localized.addAdvancePayment, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.tintColor = .white
        button.backgroundColor = .myBlue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleAddPayment), for: .touchUpInside)
        return button
    }()

    private let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: [Localized.reducePeriod, Localized.reducePayment])
        sc.addTarget(self, action: #selector(handleSelector(_:)), for: .valueChanged)
        sc.selectedSegmentIndex = 0
        return sc
    }()

    private let dateTextField: UITextField = {
        let tf = UITextField()
        return tf
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Payment info"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.date = Date()
        
        if #available(iOS 13.4, *) { datePicker.preferredDatePickerStyle = .wheels }
        
        datePicker.addTarget(self, action: #selector(dateDidChange(_:)), for: .valueChanged)
        return datePicker
    }()

    private let containerPayment: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .fillColor
        return view
    }()
    
    private let paymentLabel: UILabel = {
        let label = UILabel()
        label.text = Localized.amountLabel
        return label
    }()
    
    private let containerDate: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .fillColor
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = Localized.dateLabel
        return label
    }()
    
    private let containerResults: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .myGreen.withAlphaComponent(0.2)
        return view
    }()
    
    private func configureUI() {

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTap(_:)))
        view.addGestureRecognizer(gestureRecognizer)

        view.backgroundColor = .white
        title = Localized.advancePayment
        dateTextField.inputView = datePicker
        dateTextField.text = Date().toDouble.formatDate()

        [amountTextField, dateTextField].forEach {
            $0.borderStyle = .none
            $0.placeholder = "0"
            $0.font = .systemFont(ofSize: 24)
            $0.backgroundColor = .clear
            $0.textColor = .black
            $0.tintColor = .gray.withAlphaComponent(0.7)
            $0.contentVerticalAlignment = .bottom
        }

        [addAdvancePaymentButton, segmentedControl, containerResults, containerPayment, containerDate].forEach {
            view.addSubview($0)
            $0.centerAnchors(x: view.centerXAnchor, y: nil)
        }
        
        [paymentLabel, dateLabel].forEach {
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.textColor = .gray
        }
        
        containerPayment.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        containerPayment.addLabelTextField(label: paymentLabel, textField: amountTextField)
        
        containerDate.anchor(top: containerPayment.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        containerDate.addLabelTextField(label: dateLabel, textField: dateTextField)
        
        segmentedControl.anchor(top: containerDate.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 40)
        
        containerResults.anchor(top: segmentedControl.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        containerResults.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        containerResults.addSubview(descriptionLabel)
        
        descriptionLabel.fillSuperview(padding: .init(top: 12, left: 12, bottom: 12, right: 12))
               
        addAdvancePaymentButton.anchor(top:  nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 24, paddingBottom: 44, paddingRight: 24, width: 0, height: 50)
    }
}

//MARK: - Update ViewModel and UI

private extension AddPaymentViewController {

    @objc func handleAddPayment() {

        if !viewModel.isAllowableDate(date: datePicker.date) {
            showAlert(title: Localized.invalidDate, message: Localized.selectedDateSchedule, actionTitle: "Ok")
            return
        }
        
        viewModel.recalculate(overpaymentGoal: .completedPayment)
        navigationController?.popViewController(animated: true)
    }

    @objc func handleSelector(_ segmentControl: UISegmentedControl) {
        viewModel.selectedSegment = segmentControl.selectedSegmentIndex
        updateUI()
    }

    @objc func dateDidChange(_ datePicker: UIDatePicker) {
        viewModel.date = datePicker.date
        updateUI()
    }

    @objc func amountChanged(_ textField: UITextField) {
        viewModel.verifyAmount(textField.text ?? "0")
        updateUI()
    }
    
    @objc func backgroundTap(_ gesture: UITapGestureRecognizer) {
        [amountTextField, dateTextField].forEach {
            $0.resignFirstResponder()
        }
    }
}
