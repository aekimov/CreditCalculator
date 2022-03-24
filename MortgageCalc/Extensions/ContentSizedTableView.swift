//
//  ContentSizedTableView.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 1/27/22.
//

import UIKit

final class ContentSizedTableView: UITableView {
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
