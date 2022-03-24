//
//  PaymentsViewController.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 11/29/21.
//

import UIKit

class PaymentsViewController: UIViewController {
    
    let viewModel: PaymentsViewModel

    init(viewModel: PaymentsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 4
        
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.backgroundColor = .fillColor
        return collection
    }()
    
    private var newWidthConstaint: CGFloat = 0
    private var firstColumnWidth: CGFloat = 0
    private var otherColumnWidth: CGFloat = 0
    
    private func configureCollectionView() {

        collectionView.allowsMultipleSelection = false
        collectionView.delaysContentTouches = false
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.identifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        firstColumnWidth = (view.frame.width * 0.1).rounded(.down)
        otherColumnWidth = ((view.frame.width - firstColumnWidth) / 4).rounded(.down)
        newWidthConstaint =  firstColumnWidth + 4 * otherColumnWidth

        configureCollectionView()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchData()
        collectionView.reloadData()
    }

    private let headerTitles = [Localized.date, Localized.payment, Localized.interest, Localized.principal, Localized.balance]
        
    private func configureUI() {
        view.backgroundColor = .white
        title = Localized.paymentSchedule
        
        let stackView = UIStackView(type: .horizontal, alignment: .fill, distribution: .fill)
        
        [stackView, collectionView].forEach {
            view.addSubview($0)
            $0.centerAnchors(x: view.centerXAnchor, y: nil)
        }

        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: newWidthConstaint, height: 40)

        for index in 0...4 {
            let label = UILabel()
            label.text = headerTitles[index]
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 14, weight: .semibold)
            label.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
                         width: index == 0 ? firstColumnWidth : otherColumnWidth,
                         height: 0)
            stackView.addArrangedSubview(label)
        }
        
        collectionView.anchor(top: stackView.bottomAnchor, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: newWidthConstaint, height: 0)
    }
}

//MARK: - CollectionView Delegates

extension PaymentsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(for: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.identifier, for: indexPath) as? CollectionCell else { return UICollectionViewCell() }
        let text = viewModel.fetchText(for: indexPath.item, in: indexPath.section)
        cell.configure(text: text)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier, for: indexPath) as! HeaderView
        header.configure(for: indexPath.section, years: viewModel.yearsForHeader)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: viewModel.firstColumnSequence.contains(indexPath.item) ? firstColumnWidth : otherColumnWidth,
                      height: 50)
    }
}

