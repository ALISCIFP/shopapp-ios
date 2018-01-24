//
//  ArticleDetailsViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/26/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class ArticleDetailsViewController: BaseViewController<ArticleDetailsViewModel> {
    @IBOutlet private weak var articleImageView: UIImageView!
    @IBOutlet private weak var articleTitleLabel: UILabel!
    @IBOutlet private weak var authorNameLabel: UILabel!
    @IBOutlet private weak var articleContentLabel: UILabel!
    
    var articleId: String!
    
    override func viewDidLoad() {
        viewModel = ArticleDetailsViewModel()
        super.viewDidLoad()

        setupViewModel()
        loadData()
    }
    
    private func setupViewModel() {
        viewModel.articleId = articleId

        errorView.delegate = self

        viewModel.data
            .subscribe(onNext: { [weak self] article in
                self?.populateViews(with: article)
            })
            .disposed(by: disposeBag)
    }
    
    private func populateViews(with article: Article) {
        articleImageView.set(image: article.image)
        articleTitleLabel.text = article.title
        authorNameLabel.text = article.author?.fullName
        articleContentLabel.text = article.content
    }

    fileprivate func loadData() {
        viewModel.loadData()
    }
}
