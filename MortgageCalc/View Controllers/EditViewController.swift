//
//  EditCreditViewController.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 1/20/22.
//


import UIKit

protocol EditViewControllerDelegate: AnyObject {
    func didTapSaveButton(_ controller: EditViewController)
}

class EditViewController: UIViewController {
    
    weak var delegate: EditViewControllerDelegate?
    let viewModel: EditViewModel
    
    init(viewModel: EditViewModel) {
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
        zeroDatePicker.date = viewModel.zeroDateDouble.toDate
        titleTextField.text = viewModel.titleString
        zeroDateTextField.text = viewModel.zeroDateString
        amountTextField.text = viewModel.amountString
        rateTextField.text = viewModel.rateString
        periodTextField.text = viewModel.periodString
        slider.setValue(viewModel.sliderValue, animated: true)
        
        if viewModel.isFormValid {
            self.saveButton.isEnabled = true
            self.saveButton.backgroundColor = .myBlue
        } else {
            self.saveButton.isEnabled = false
            self.saveButton.backgroundColor = .myBlue.withAlphaComponent(0.5)
        }
    }
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        return sv
    }()
    
    private let containerViewCreditAmount: UIView = {
        let view = UIView()
        view.backgroundColor = .fillColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let containerViewPeriod: UIView = {
        let view = UIView()
        view.backgroundColor = .fillColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let containerViewRate: UIView = {
        let view = UIView()
        view.backgroundColor = .fillColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let containerViewDate: UIView = {
        let view = UIView()
        view.backgroundColor = .fillColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let containerViewResults: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
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
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Localized.save, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.tintColor = .white
        button.backgroundColor = .myBlue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(saveChangesButton), for: .touchUpInside)
        return button
    }()
    
    @objc private func saveChangesButton() {
        viewModel.updateModel()
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
        tf.text = "My Credit"
        tf.addTarget(self, action: #selector(titleChanged(_:)), for: .editingChanged)
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
    
    private let amountLabel: UILabel = {
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
    
    private let rateLabel: UILabel = {
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

    @objc private func backgroundTap(gesture: UITapGestureRecognizer) {
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

extension EditViewController: UITextFieldDelegate {
    
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

//MARK:- Update ViewModel and UI

private extension EditViewController {
    
    @objc func dateDidChange(_ datePicker: UIDatePicker) {
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

extension EditViewController {
    
    private func configureUI() {
        title = Localized.calculation
        view.backgroundColor = .white

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTap(gesture:)))
        view.addGestureRecognizer(gestureRecognizer)

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
        
        [titleLabel, amountLabel, periodLabel, rateLabel, zeroDateLabel].forEach {
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.textColor = .gray
        }
        
        view.addSubview(scrollView)
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        [containerViewTitle, containerViewCreditAmount, slider, containerViewPeriod, containerViewRate, containerViewDate, containerViewResults, saveButton].forEach {
            scrollView.addSubview($0)
        }
        
        containerViewTitle.anchor(top: scrollView.contentLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        containerViewTitle.addLabelTextField(label: titleLabel, textField: titleTextField)

        containerViewCreditAmount.anchor(top: containerViewTitle.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        containerViewCreditAmount.addLabelTextField(label: amountLabel, textField: amountTextField)
        
        slider.anchor(top: containerViewCreditAmount.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        
        containerViewPeriod.anchor(top: slider.bottomAnchor, left: view.leftAnchor, bottom: nil, right: containerViewRate.leftAnchor, paddingTop: 12, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        containerViewPeriod.addLabelTextField(label: periodLabel, textField: periodTextField)

        
        containerViewRate.anchor(top: slider.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        containerViewRate.addLabelTextField(label: rateLabel, textField: rateTextField)
        
        
        containerViewDate.anchor(top: containerViewPeriod.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        containerViewDate.addLabelTextField(label: zeroDateLabel, textField: zeroDateTextField)
        
        saveButton.anchor(top: containerViewDate.bottomAnchor, left: view.leftAnchor, bottom: scrollView.contentLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 52)
    }
}
