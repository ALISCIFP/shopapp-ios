//
//  ErrorView.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 11/2/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import ShopApp_Gateway

protocol ErrorViewDelegate: class {
    func viewDidTapTryAgain(_ view: ErrorView)
}

class ErrorView: UIView {
    @IBOutlet private weak var errorTextLabel: UILabel!
    @IBOutlet private weak var errorImageView: UIImageView!
    @IBOutlet private weak var tryAgainButton: GrayButton!
    
    weak var delegate: ErrorViewDelegate?
    
    var isNetworkError: Bool = false {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - View lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    // MARK: - Setup
    
    private func commonInit() {
        loadFromNib()
    }
    
    private func updateUI() {
        errorImageView.isHidden = !isNetworkError
        errorTextLabel.text = isNetworkError ? "Error.NoConnection".localizable : "Error.Unknown".localizable
        tryAgainButton.setTitle("Button.TryAgain".localizable.uppercased(), for: .normal)
    }
    
    // MARK: - Actions
    
    @IBAction private func tryAgainButtonDidTap(_ sender: UIButton) {
        delegate?.viewDidTapTryAgain(self)
    }
}
