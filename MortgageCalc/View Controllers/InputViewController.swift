//
//  InputViewController.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 1/18/22.
//


import UIKit

protocol InputViewControllerDelegate: AnyObject {
    func didTapCalculateButton(_ controller: InputViewController)
    func didTapSaveButton(_ controller: InputViewController)
}

class InputViewController: UIViewController {
    
    weak var delegate: InputViewControllerDelegate?
    let viewModel: InputViewModel
    
    init(viewModel: InputViewModel) {
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
        
        titleTextField.text = viewModel.titleString
        zeroDateTextField.text = viewModel.zeroDateString
        amountTextField.text = viewModel.amountString
        rateTextField.text = viewModel.rateString
        periodTextField.text = viewModel.periodString
        
        monthlyPaymentLabel.text = viewModel.monthlyPaymentString
        totalAmountLabel.text = viewModel.totalString
        interestAmountLabel.text = viewModel.interestString
        slider.setValue(viewModel.sliderValue, animated: true)
        
        if viewModel.isFormValid {
            showPaymentScheduleButton.isEnabled = true
            showPaymentScheduleButton.setTitleColor(.myBlue, for: .normal)
            saveButton.isEnabled = true
            saveButton.backgroundColor = .myBlue
        } else {
            showPaymentScheduleButton.isEnabled = false
            showPaymentScheduleButton.setTitleColor(.myBlue.withAlphaComponent(0.5), for: .normal)
            saveButton.isEnabled = false
            saveButton.backgroundColor = .myBlue.withAlphaComponent(0.5)
        }
    }
    
    private let scrollView: UIScrollView = {
        return UIScrollView()
    }()
    
    private let containerViewCreditAmount: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .fillColor
        return view
    }()
    
    private let containerViewPeriod: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .fillColor
        return view
    }()
    
    private let containerViewRate: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .fillColor
        return view
    }()
    
    private let containerViewDate: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .fillColor
        return view
    }()
    
    private let containerViewResults: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.fillColor.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    private var slider: UISlider = {
        let view = UISlider()
        view.minimumValue = 0
        view.maximumValue = 10_000_000
        view.tintColor = .myBlue
        view.addTarget(self, action: #selector(handleSlider(_:)), for: .valueChanged)
        return view
    }()

    private let monthlyPaymentDescriptionLabel: UILabel = {
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

    private let monthlyPaymentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.textColor = .black
        label.text = "0"
        return label
    }()
    
    private let showPaymentScheduleButton: UIButton = {
        let button = UIButton(type: .system)
        let title = Localized.showPaymentSchedule
        button.setTitle(title, for: .normal)
        button.setTitleColor(.myBlue, for: .normal)
        button.addTarget(self, action: #selector(showPaymentsTableView), for: .touchUpInside)
        return button
    }()
    
    @objc private func showPaymentsTableView() {
        viewModel.recalculate()
        delegate?.didTapCalculateButton(self)
    }
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Localized.save, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.tintColor = .white
        button.backgroundColor = .myBlue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleSaveButton() {
        viewModel.saveCredit()
        delegate?.didTapSaveButton(self)
    }
    
    private let containerViewTitle: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .fillColor
        return view
    }()
    
    private let titleTextField: UITextField = {
        let tf = UITextField()
        tf.addTarget(self, action: #selector(titleChanged(_:)), for: .editingChanged)
        tf.text = "Credit"
        return tf
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Localized.titleLabel
        return label
    }()
    
    private let amountTextField: UITextField = {
        let tf = UITextField()
        tf.keyboardType = .numberPad
        tf.addTarget(self, action: #selector(amountChanged(_:)), for: .editingChanged)
        return tf
    }()
    
    private let creditAmountLabel: UILabel = {
        let label = UILabel()
        label.text = Localized.amountLabel
        return label
    }()
    
    private let periodTextField: UITextField = {
        let tf = UITextField()
        tf.keyboardType = .numberPad
        tf.addTarget(self, action: #selector(periodChanged(_:)), for: .editingChanged)
        return tf
    }()
    
    private let periodLabel: UILabel = {
        let label = UILabel()
        label.text = Localized.periodLabel
        return label
    }()
    
    private let rateTextField: UITextField = {
        let tf = UITextField()
        tf.keyboardType = .decimalPad
        tf.addTarget(self, action: #selector(rateChanged(_:)), for: .editingChanged)
        return tf
    }()
    
    private let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = Localized.rateLabel
        return label
    }()
    
    private let zeroDateTextField: UITextField = {
        let tf = UITextField()
        return tf
    }()
        
    private let zeroDateLabel: UILabel = {
        let label = UILabel()
        label.text = Localized.dateLabel
        return label
    }()
    
    private let zeroDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        
        if #available(iOS 13.4, *) { datePicker.preferredDatePickerStyle = .wheels }
        
        datePicker.addTarget(self, action: #selector(dateDidChange(_:)), for: .valueChanged)
        return datePicker
    }()

    @objc private func backgroundTap(gesture : UITapGestureRecognizer) {
        [titleTextField, zeroDateTextField, amountTextField, periodTextField, rateTextField].forEach {
            $0.resignFirstResponder()
        }
    }
    
    private var activeTextField = UITextField()
    private let nextButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(toolbarButtonAction))
    private let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(toolbarButtonAction))
    private let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    private let toolbar: UIToolbar = {
        let tb = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 45))
        tb.barStyle = .default
        tb.sizeToFit()
        return tb
    }()
}

//MARK:- UITextField Delegate

extension InputViewController: UITextFieldDelegate {
    
    @objc private func toolbarButtonAction() {
        
        switch activeTextField {
        case titleTextField:
            amountTextField.becomeFirstResponder()
        case amountTextField:
            periodTextField.becomeFirstResponder()
        case periodTextField:
            rateTextField.becomeFirstResponder()
        case rateTextField:
            rateTextField.resignFirstResponder()
        default:
            activeTextField.resignFirstResponder()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        
        switch activeTextField {
        case titleTextField, amountTextField, periodTextField:
            toolbar.items = [flexibleSpace, nextButton]
        case rateTextField:
            toolbar.items = [flexibleSpace, doneButton]
        default:
            print("Other TextField")
            toolbar.items = [flexibleSpace, doneButton]
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = textField
        
        switch activeTextField {
        case rateTextField:
            viewModel.verifyAfterResignResponder(textField.text ?? "")
            updateUI()
        default: break
        }
    }
}

//MARK:- ViewModel methods

private extension InputViewController {
    
    @objc private func dateDidChange(_ datePicker: UIDatePicker) {
        viewModel.date = datePicker.date
        updateUI()
    }
    
    @objc func handleSlider(_ slider: UISlider) {
        let step: Float = 50000
        let currentValue = round(slider.value / step) * step
        viewModel.verifyAmount(String(currentValue))
        updateUI()
    }
    
    @objc func amountChanged(_ textField: UITextField) {
        viewModel.verifyAmount(textField.text ?? "0")
        updateUI()
    }
    
    @objc func periodChanged(_ textField: UITextField) {
        viewModel.verifyPeriod(textField.text ?? "0")
        updateUI()
    }
    
    @objc func rateChanged(_ textField: UITextField) {
        viewModel.verifyRate(textField.text ?? "0")
        updateUI()
    }
    
    @objc func titleChanged(_ textField: UITextField) {
        viewModel.verifyTitle(textField.text ?? "Credit")
        updateUI()
    }
}

//MARK:- UI Configuration

private extension InputViewController {
    
    private func configureUI() {
        title = Localized.calculation
        
        dateDidChange(zeroDatePicker) // по умолчанию показывать дату при запуске
        titleChanged(titleTextField)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTap(gesture:)))
        view.addGestureRecognizer(gestureRecognizer)
        view.backgroundColor = .white
        
        zeroDateTextField.inputView = zeroDatePicker

        [titleTextField, amountTextField, periodTextField, rateTextField, zeroDateTextField].forEach {
            $0.borderStyle = .none
            $0.placeholder = "0"
            $0.font = UIFont.systemFont(ofSize: 24)
            $0.backgroundColor = .clear
            $0.textColor = .black
            $0.tintColor = .gray.withAlphaComponent(0.7)
            $0.contentVerticalAlignment = .bottom
            $0.inputAccessoryView = toolbar
            $0.delegate = self
        }

        titleTextField.placeholder = Localized.titlePlaceholder
        
        [titleLabel, creditAmountLabel, periodLabel, percentageLabel, zeroDateLabel, monthlyPaymentDescriptionLabel, monthlyPaymentLabel, totalLabel, totalAmountLabel, interestLabel, interestAmountLabel].forEach {
            $0.font = .systemFont(ofSize: 16)
            $0.textColor = .gray
        }
        
        view.addSubview(scrollView)

        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        [containerViewTitle, containerViewCreditAmount, slider, containerViewPeriod, containerViewRate, containerViewDate, containerViewResults, showPaymentScheduleButton, saveButton].forEach {
            scrollView.addSubview($0)
        }
        
        containerViewTitle.anchor(top: scrollView.contentLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        containerViewTitle.addLabelTextField(label: titleLabel, textField: titleTextField)
        
        containerViewCreditAmount.anchor(top: containerViewTitle.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        containerViewCreditAmount.addLabelTextField(label: creditAmountLabel, textField: amountTextField)
        
        slider.anchor(top: containerViewCreditAmount.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        
        containerViewPeriod.anchor(top: slider.bottomAnchor, left: view.leftAnchor, bottom: nil, right: containerViewRate.leftAnchor, paddingTop: 12, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        containerViewPeriod.addLabelTextField(label: periodLabel, textField: periodTextField)

        containerViewRate.anchor(top: slider.bottomAnchor, left: containerViewPeriod.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        containerViewRate.addLabelTextField(label: percentageLabel, textField: rateTextField)
        
        containerViewDate.anchor(top: containerViewPeriod.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        containerViewDate.addLabelTextField(label: zeroDateLabel, textField: zeroDateTextField)
        
        let resultsStack = UIStackView(type: .vertical, alignment: .fill, distribution: .fill, spacing: 10, paddings: .init(top: 10, left: 10, bottom: 10, right: 10))
        
        containerViewResults.anchor(top: containerViewDate.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        
        containerViewResults.addSubview(resultsStack)
        resultsStack.fillSuperview()
        
        let labels = [monthlyPaymentDescriptionLabel, monthlyPaymentLabel, totalLabel, totalAmountLabel, interestLabel, interestAmountLabel]
        
        for index in stride(from: 0, to: labels.count, by: 2) {
            let sv = UIStackView(type: .horizontal, alignment: .fill, distribution: .equalSpacing, spacing: 0)
            [labels[index], labels[index + 1]].forEach { sv.addArrangedSubview($0) }
            resultsStack.addArrangedSubview(sv)
        }
        resultsStack.addArrangedSubview(showPaymentScheduleButton)
        
        saveButton.anchor(top: showPaymentScheduleButton.bottomAnchor, left: view.leftAnchor, bottom: scrollView.contentLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 24, paddingBottom: 16, paddingRight: 24, width: 0, height: 52)
    }
}
